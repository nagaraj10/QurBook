import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/CommonUtil.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart';
import '../../constants/variable_constant.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/Notifications/constants/notification_constants.dart';
import '../../voice_cloning/model/voice_clone_status_arguments.dart';
import '../../voice_cloning/model/voice_cloning_choose_member_arguments.dart';
import '../../voice_cloning/view/widgets/voice_clone_family_members_list.dart';
import '../voice_clone_status_controller.dart';
import 'terms_and_conditon.dart';

class VoiceCloningStatus extends StatefulWidget {
  final VoiceCloneStatusArguments? arguments;

  const VoiceCloningStatus({
    required this.arguments,
  });

  @override
  _MyFhbWebViewState createState() => _MyFhbWebViewState();
}

class _MyFhbWebViewState extends State<VoiceCloningStatus> {
  bool isLoading = true;
  final controller = Get.put(VoiceCloneStatusController());
  double subtitle = CommonUtil().isTablet! ? tabHeader2 : mobileHeader2;

  @override
  void initState() {
    controller
      ..onInit()
      //Api to get health organzation id and also the status of voice cloning
      ..getUserHealthOrganizationId();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () {
          controller.setBackButton(
              context, widget.arguments?.fromMenu ?? false);

          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
              onPressed: () {
                controller.setBackButton(
                    context, widget.arguments?.fromMenu ?? false);
              },
            ),
            title: AppBarForVoiceCloning().getVoiceCloningAppBar(),
            centerTitle: false,
          ),
          body: controller.loadingData.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.voiceCloneStatusModel?.result != null
                  ? Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                            const SizedBox(
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
                                      style: AppBarForVoiceCloning()
                                          .getTextStyle(controller
                                                  .voiceCloneStatusModel
                                                  ?.result
                                                  ?.status ??
                                              '')),
                                ]),
                            Visibility(
                                visible: controller.voiceCloneStatusModel
                                            ?.result?.status ==
                                        strApproved &&
                                    controller.listOfFamilyMembers.length > 0,
                                child: Expanded(
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 16, 8, 8),
                                    child: VoiceCloneFamilyMembersList(
                                      isShowcaseExisting: true,
                                      familyMembers:
                                          controller.listOfFamilyMembers,
                                      onValueSelected: (value) {},
                                    ),
                                  ),
                                )),
                            Visibility(
                              visible: controller
                                      .voiceCloneStatusModel?.result?.status ==
                                  strDecline,
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
                                              '',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: mobileFontTitle)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
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
                      ],
                    )
                  : ErrorsWidget(),
        ),
      ),
    );
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
  _onButtonPressed() async {
    String statusBtn = getTextBasedOnStatus();
    if (statusBtn == 'Revoke Submission') {
      //revoke the submission of voice clone and navigate to more menu screen
      await controller.revokeSubmission(widget.arguments?.fromMenu ?? false);
    } else if (statusBtn == 'Record Again') {
      //Pop the current page and should go back to recording page
      Navigator.pushNamed(context, rt_record_submission);
    } else {
      //Navigate to assign to members
      final selectedFamilyMembers = controller.listOfFamilyMembers.value
          .map((e) => e.child?.id ?? '')
          .toList();

      Navigator.pushNamed(context, rt_VoiceCloningChooseMemberSubmit,
          arguments: VoiceCloningChooseMemberArguments(
            fromMenu: widget.arguments?.fromMenu ?? false,
            voiceCloneId: controller.voiceCloneId.value,
            selectedFamilyMembers: controller.selectedFamilyMembers,
          ));
    }
  }
}
