import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/Prescription/model/fetch_prescription_detail/prescription_detail.dart'
    as pre;
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/calldata.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/video_call/utils/wave_animation.dart';
import '../../../constants/fhb_constants.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class CallingPage extends StatefulWidget {
  final name;
  final id;
  CallMetaData callMetaData;
  dynamic isCallActualTime;
  final healthOrganizationId;
  pre.PrescriptionDetail existingAdditionalInfo = pre.PrescriptionDetail();
  User patienInfo;
  bool isFromAppointment;
  String patientPrescriptionId;
  CallingPage(
      {this.name,
      this.id,
      this.callMetaData,
      this.healthOrganizationId,
      this.existingAdditionalInfo,
      this.isCallActualTime,
      this.patienInfo,
      this.isFromAppointment,
      this.patientPrescriptionId});

  @override
  _CallingPageState createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  final myDB = FirebaseFirestore.instance;
  var name = '';
  bool callCurrentStaus = false;
  AudioPlayer audioPlayer;
  AudioCache _audioCache;
  var isDoctor;

  var regController = Get.find<QurhomeRegimenController>();

  @override
  void initState() {
    try {
      _audioCache = AudioCache();
      configAudioPlayer();
      super.initState();
      name = widget.name;
      mInitialTime = DateTime.now();
      /*var regController = Get.find<QurhomeRegimenController>();
      regController.onGoingSOSCall.value = true;*/
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    try {
      super.dispose();
      clearAudioPlayer();
      VideoCallCommonUtils.callActions.value = CallActions.CALLING;
      fbaLog(eveName: 'qurpro_screen_event', eveParams: {
        'eventTime': '${DateTime.now()}',
        'pageName': 'Calling Screen',
        'screenSessionTime':
            '${DateTime.now().difference(mInitialTime).inSeconds} secs'
      });
    } catch (e) {
      print(e);
    }
  }

  void clearAudioPlayer() async {
    try {
      _audioCache.clearAll();
      await audioPlayer.stop();
      await audioPlayer.release();
    } catch (e) {
      print(e);
    }
  }

  void configAudioPlayer() async {
    try {
//SharedPrefUtils sharedPref = new SharedPrefUtils();
      try {
        isDoctor = false; //await sharedPref.getBool('isDoctor');
      } catch (e) {}
      audioPlayer = await _audioCache.play('raw/dailer_tone.mp3');
      audioPlayer.setVolume(0.1);
      audioPlayer.playingRouteState = PlayingRoute.EARPIECE;
      VideoCallCommonUtils.isMissedCallNsSent = false;
      VideoCallCommonUtils().updateCallCurrentStatus(
          mContext: context,
          cid: widget.id,
          callMetaData: widget.callMetaData,
          healthOrganizationId: widget.healthOrganizationId,
          existingAdditionalInfo: widget.existingAdditionalInfo,
          audioPlayer: audioPlayer,
          isCallActualTime: widget.isCallActualTime,
          healthRecord: widget.callMetaData.healthRecord,
          patienInfo: widget.patienInfo,
          isFromAppointment: widget.isFromAppointment,
          isDoctor: isDoctor);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 40.0.w,
            ),
            child: ValueListenableBuilder(
              valueListenable: VideoCallCommonUtils.callActions,
              builder: (context, value, child) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 20.0.h,
                        bottom: 40.0.h,
                      ),
                      height: 150.0.h,
                      width: double.infinity,
                      child: WaveAnimation(
                        patName: name,
                      ),
                    ),
                    Visibility(
                      visible: value == CallActions.CALLING,
                      child: Text(
                        'Dialing',
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      '$name',
                      style: TextStyle(
                        fontSize: 30.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(CommonUtil().getMyPrimaryColor()),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: value == CallActions.DECLINED,
                      child: Text(
                        'Call Declined',
                        style: TextStyle(
                            fontSize: 18.0.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.red),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 50.0.h,
                      ),
                      height: 50.0.h,
                      width: 50.0.h,
                      child: IconButton(
                        icon: Icon(
                          Icons.call_end,
                          size: 24.0.sp,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          try {
                            clearAudioPlayer();
                            regController.onGoingSOSCall.value = false;
                            if (widget.callMetaData != null) {
                              VideoCallCommonUtils.isMissedCallNsSent = true;
                              VideoCallCommonUtils().createMissedCallNS(
                                  docName: /*widget.callMetaData.docName*/ regController
                                      .userName.value,
                                  patId: /*widget.callMetaData.patId*/ regController
                                      .careCoordinatorId.value,
                                  bookingId: widget.callMetaData.bookId);
                            }
                            VideoCallCommonUtils().callEnd(context, widget.id);
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
