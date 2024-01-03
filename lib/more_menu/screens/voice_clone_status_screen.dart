import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/more_menu/screens/terms_and_conditon.dart';
import 'package:myfhb/more_menu/voice_clone_status_controller.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

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
    controller.getUserHealthOrganizationId();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Terms And Condition Voice Cloning',
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
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(CommonUtil().getMyPrimaryColor()),
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 30.sp, right: 30.sp, top: 10, bottom: 10),
                            child: Text(
                              getTextBasedOnStatus(),
                              style: TextStyle(color: Colors.white),
                            )),
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
                                  CommonUtil.getDateStringFromDateTime(
                                      controller.voiceCloneStatusModel?.result
                                              ?.createdOn ??
                                          ''),
                                  style: AppBarForVoiceCloning().getTextStyle(
                                      controller.voiceCloneStatusModel?.result
                                              ?.status ??
                                          '')),
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
                      ],
                    )
                  ])
                : Center(
                    child: Text(
                    "Unable to load",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: subtitle),
                  ))));
  }

  String getTextBasedOnStatus() {
    String? status = controller.voiceCloneStatusModel?.result?.status;
    switch (status) {
      case 'Under Review':
        return 'Revoke Submission';

      case 'Being Processed':
        return 'Revoke Submission';

      case 'Approved':
        return 'Assign voice to members';

      case 'Declined':
        return 'Record Again';

      default:
        return 'Revoke Submission';
    }
  }
}
