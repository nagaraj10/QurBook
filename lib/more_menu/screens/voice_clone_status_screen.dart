import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/more_menu/screens/terms_and_conditon.dart';
import 'package:myfhb/more_menu/voice_clone_status_controller.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart';

class VoiceCloningStatus extends StatefulWidget {
  const VoiceCloningStatus();

  @override
  _MyFhbWebViewState createState() => _MyFhbWebViewState();
}

class _MyFhbWebViewState extends State<VoiceCloningStatus> {
  bool isLoading = true;
  final controller = Get.put(VoiceCloneStatusController());
  double subtitle = CommonUtil().isTablet! ? tabHeader2 : mobileHeader2;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    controller.onInit();
    //Api to get health organzation id and also the status of voice cloning
    controller.getUserHealthOrganizationId();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': ' Voice Cloning status',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: AppBarForVoiceCloning().getVoiceCloningAppBar(),
          centerTitle: false,
        ),
        body: controller.loadingData.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : controller.voiceCloneStatusModel?.result != null
                ? Stack(children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: _onButtonPressed,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: getColors()),
                            borderRadius: BorderRadius.circular(20),
                            color: getBackGroundColor(),
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 30.sp,
                                  right: 30.sp,
                                  top: 10,
                                  bottom: 10),
                              child: Text(
                                getTextBasedOnStatus(),
                                style: TextStyle(color: getColors()),
                              )),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            controller.voiceCloneStatusModel?.result
                                    ?.description ??
                                strDescStatus,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: mobileFontTitle),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                strDOS,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: subtitle,
                                    color: Colors.grey[600]),
                              ),
                              Text(
                                  changeDateFormat(
                                      CommonUtil().validString(controller
                                              .voiceCloneStatusModel
                                              ?.result
                                              ?.createdOn ??
                                          ''),
                                      isFromAppointment: false),
                                  style: TextStyle(
                                    fontSize: subtitle,
                                  )),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                strStatus,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: subtitle,
                                    color: Colors.grey[600]),
                              ),
                              Text(
                                  controller.voiceCloneStatusModel?.result
                                          ?.status ??
                                      '',
                                  style: AppBarForVoiceCloning().getTextStyle(
                                      controller.voiceCloneStatusModel?.result
                                              ?.status ??
                                          '')),
                            ]),
                        Visibility(
                          visible: (controller
                                  .voiceCloneStatusModel?.result?.status ==
                              strDecline),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 17.0.sp,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: strReason,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: mobileFontTitle,
                                          color: Colors.grey[600]),
                                    ),
                                    TextSpan(
                                        text: controller
                                                .voiceCloneStatusModel
                                                ?.result
                                                ?.additionalInfo
                                                ?.reason ??
                                            strDescStatus,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: mobileFontTitle)),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ])
                : ErrorsWidget()));
  }

  /**
   * Set text button based on the status fof voice cloning
   */
  String getTextBasedOnStatus() {
    String? status = controller.voiceCloneStatusModel?.result?.status;
    switch (status) {
      case 'Under Review':
        return 'Revoke Submission';

      case 'Being Processed':
        return 'Revoke Submission';

      case strApproved:
        return 'Assign voice to members';

      case strDeclined:
        return 'Record Again';

      default:
        return 'Revoke Submission';
    }
  }

  /**
   * Get text color based on status of voice cloning text
   */
  getColors() {
    return (controller.voiceCloneStatusModel?.result?.status == strApproved)
        ? Colors.white
        : Color(CommonUtil().getMyPrimaryColor());
  }

/**
 * Get the background color based on tatus of voice cloning text 
 */
  getBackGroundColor() {
    return (controller.voiceCloneStatusModel?.result?.status == strApproved)
        ? Color(CommonUtil().getMyPrimaryColor())
        : Colors.white;
  }

  /**
   * Button click based on the staus of the voice cloning status 
   */
  void _onButtonPressed() async {
    String statusBtn = getTextBasedOnStatus();
    if (statusBtn == 'Revoke Submission') {
      await controller.revokeSubmission();
    } else if (statusBtn == 'Record Again') {
    } else {}
  }
}
