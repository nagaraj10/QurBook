import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/landing/view/widgets/video_screen.dart';
import 'package:myfhb/landing/view_model/landing_view_model.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:provider/provider.dart';

import 'landing_card.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({
    @required this.refresh,
  });

  final Function(bool userChanged) refresh;

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20.0.w,
                right: 20.0.w,
                top: 10.0.h,
              ),
              child: Text(
                constants.strMyDashboard,
                style: TextStyle(
                  fontSize: 18.0.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Expanded(
              child: Consumer<LandingViewModel>(
                builder: (context, landingViewModel, child) {
                  if (landingViewModel.landingScreenStatus ==
                      LandingScreenStatus.Loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor:
                            Color(CommonUtil().getMyPrimaryColor()),
                      ),
                    );
                  } else {
                    var dashboardData = landingViewModel?.dashboardData;
                    var activePlanCount =
                        dashboardData?.activePlans?.activePlanCount ?? 0;
                    var activeDevices =
                        dashboardData?.vitalsDetails?.activeDevice ?? 0;
                    var activeDues = dashboardData?.regimenDue?.activeDues ?? 0;
                    var activeFamilyMembers =
                        dashboardData?.familyMember?.noOfFamilyMembers ?? 0;
                    var activeProviders =
                        (dashboardData?.providers?.doctor ?? 0) +
                            (dashboardData?.providers?.hospital ?? 0) +
                            (dashboardData?.providers?.lab ?? 0);
                    var availableVideos =
                        (dashboardData?.helperVideos?.length ?? 0);
                    var availableCareProvider =
                        (dashboardData?.careGiverInfo?.doctorId != null
                            ? 1
                            : 0);
                    var careProviderName =
                        (dashboardData?.careGiverInfo?.firstName ?? '') +
                            ' ' +
                            (dashboardData?.careGiverInfo?.lastName ?? '');

                    var careProvidersCount =
                        dashboardData?.careGiverList?.length ?? 0;
                    return GridView(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0.h,
                        horizontal: 10.0.w,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0.w,
                        mainAxisSpacing: 16.0.w,
                        childAspectRatio: 1.2,
                      ),
                      children: [
                        LandingCard(
                          title: constants.strYourQurplans,
                          lastStatus: '',
                          alerts: activePlanCount > 0
                              ? '${activePlanCount}${constants.strPlansActive} '
                              : constants.strNoPlansAdded,
                          icon: variable.icon_my_plan,
                          color: Color(CommonConstants.bplightColor),
                          onPressed: () async {
                            await Get.toNamed(rt_MyPlans);
                            await landingViewModel.getQurPlanDashBoard();
                          },
                          onAddPressed: activePlanCount > 0
                              ? null
                              : () async {
                                  await Get.toNamed(rt_PlanWizard);
                                  await landingViewModel.getQurPlanDashBoard();
                                },
                        ),
                        LandingCard(
                          title: constants.strYourRegimen,
                          // eventName:
                          //     dashboardData?.regimenDue?.lastEventTitle ?? '',
                          onEventPressed: () async {
                            var userId = PreferenceUtil.getStringValue(
                                constants.KEY_USERID);
                            Provider.of<RegimentViewModel>(
                              Get.context,
                              listen: false,
                            ).regimentMode = RegimentMode.Schedule;
                            // Provider.of<RegimentViewModel>(
                            //   Get.context,
                            //   listen: false,
                            // ).regimentFilter = RegimentFilter.Event;
                            Provider.of<RegimentViewModel>(
                              context,
                              listen: false,
                            ).regimentFilter = RegimentFilter.Scheduled;
                            Provider.of<RegimentViewModel>(
                              Get.context,
                              listen: false,
                            ).redirectEventId =
                                '${dashboardData?.regimenDue?.eid ?? ''}';
                            await Get.toNamed(rt_Regimen);
                            var newUserId = PreferenceUtil.getStringValue(
                                constants.KEY_USERID);
                            refresh(userId != newUserId);
                            await landingViewModel.getQurPlanDashBoard();
                          },
                          // lastStatus:
                          //     dashboardData?.regimenDue?.lastEnteredDateTime !=
                          //             null
                          //         ? CommonUtil().regimentDateFormat(
                          //             dashboardData
                          //                 ?.regimenDue?.lastEnteredDateTime,
                          //             isLanding: true,
                          //           )
                          //         : '',
                          alerts: activePlanCount > 0
                              ? (activeDues > 0
                                  ? '$activeDues${constants.strActivitiesDue}'
                                  : '')
                              : constants.strNoPlansAdded,
                          alertsColor: activePlanCount > 0
                              ? Color(CommonConstants.pulselightColor)
                              : null,
                          icon: variable.icon_my_health_regimen,
                          color: Color(CommonConstants.pulselightColor),
                          onPressed: activePlanCount > 0
                              ? () async {
                                  var userId = PreferenceUtil.getStringValue(
                                      constants.KEY_USERID);
                                  Provider.of<RegimentViewModel>(
                                    Get.context,
                                    listen: false,
                                  ).regimentMode = RegimentMode.Schedule;
                                  Provider.of<RegimentViewModel>(
                                    context,
                                    listen: false,
                                  ).regimentFilter = RegimentFilter.Scheduled;
                                  await Get.toNamed(rt_Regimen);
                                  var newUserId = PreferenceUtil.getStringValue(
                                      constants.KEY_USERID);
                                  refresh(userId != newUserId);
                                  await landingViewModel.getQurPlanDashBoard();
                                }
                              : null,
                          // onAddPressed: () async {
                          //   var userId = PreferenceUtil.getStringValue(
                          //       constants.KEY_USERID);
                          //   Provider.of<RegimentViewModel>(
                          //     Get.context,
                          //     listen: false,
                          //   ).regimentMode = RegimentMode.Schedule;
                          //   Provider.of<RegimentViewModel>(Get.context,
                          //           listen: false)
                          //       .regimentFilter = RegimentFilter.All;
                          //   await Get.toNamed(rt_Regimen);
                          //   var newUserId = PreferenceUtil.getStringValue(
                          //       constants.KEY_USERID);
                          //   refresh(userId != newUserId);
                          //   await landingViewModel.getQurPlanDashBoard();
                          // },
                          onLinkPressed: activePlanCount > 0
                              ? () async {
                                  var userId = PreferenceUtil.getStringValue(
                                      constants.KEY_USERID);
                                  Provider.of<RegimentViewModel>(
                                    Get.context,
                                    listen: false,
                                  ).regimentMode = RegimentMode.Schedule;
                                  Provider.of<RegimentViewModel>(
                                    Get.context,
                                    listen: false,
                                  ).regimentFilter = RegimentFilter.Missed;
                                  await Get.toNamed(rt_Regimen);
                                  var newUserId = PreferenceUtil.getStringValue(
                                      constants.KEY_USERID);
                                  refresh(userId != newUserId);
                                  await landingViewModel.getQurPlanDashBoard();
                                }
                              : null,
                        ),
                        LandingCard(
                          title: constants.strVitals,
                          lastStatus: '',
                          alerts: activeDevices > 0
                              ? '${activeDevices} ${constants.strVitalsDevice}'
                              : constants.strVitalsNoDevice,
                          icon: variable.icon_record_my_vitals,
                          color: Color(CommonConstants.pulselightColor),
                          onPressed: () async {
                            await Get.toNamed(rt_Devices);
                            await landingViewModel.getQurPlanDashBoard();
                          },
                          // onAddPressed: () async {
                          //   await Get.toNamed(rt_Devices);
                          //   await landingViewModel.getQurPlanDashBoard();
                          // },
                        ),
                        LandingCard(
                          title: constants.strSymptomsCheckIn,
                          eventName: dashboardData?.symptomsCheckIn?.title,
                          onEventPressed: () async {
                            var userId = PreferenceUtil.getStringValue(
                                constants.KEY_USERID);
                            Provider.of<RegimentViewModel>(
                              Get.context,
                              listen: false,
                            ).regimentMode = RegimentMode.Symptoms;
                            Provider.of<RegimentViewModel>(
                              Get.context,
                              listen: false,
                            ).regimentFilter = RegimentFilter.Event;
                            Provider.of<RegimentViewModel>(
                              Get.context,
                              listen: false,
                            ).redirectEventId =
                                '${dashboardData?.symptomsCheckIn?.eid ?? ''}';
                            await Get.toNamed(rt_Regimen);
                            var newUserId = PreferenceUtil.getStringValue(
                                constants.KEY_USERID);
                            refresh(userId != newUserId);
                            await landingViewModel.getQurPlanDashBoard();
                          },
                          lastStatus:
                              dashboardData?.symptomsCheckIn?.ack != null
                                  ? CommonUtil().regimentDateFormat(
                                      dashboardData?.symptomsCheckIn?.ack,
                                      isLanding: true,
                                    )
                                  : '',
                          alerts: activePlanCount > 0
                              ? ''
                              : constants.strNoPlansAdded,
                          icon: variable.icon_check_symptoms,
                          color: Color(CommonConstants.bplightColor),
                          onPressed: activePlanCount > 0
                              ? () async {
                                  var userId = PreferenceUtil.getStringValue(
                                      constants.KEY_USERID);
                                  Provider.of<RegimentViewModel>(
                                    Get.context,
                                    listen: false,
                                  ).regimentMode = RegimentMode.Symptoms;
                                  Provider.of<RegimentViewModel>(
                                    context,
                                    listen: false,
                                  ).regimentFilter = RegimentFilter.Scheduled;
                                  await Get.toNamed(rt_Regimen);
                                  var newUserId = PreferenceUtil.getStringValue(
                                      constants.KEY_USERID);
                                  refresh(userId != newUserId);
                                  await landingViewModel.getQurPlanDashBoard();
                                }
                              : null,
                          // onAddPressed: () async {
                          //   var userId = PreferenceUtil.getStringValue(
                          //       constants.KEY_USERID);
                          //   Provider.of<RegimentViewModel>(
                          //     Get.context,
                          //     listen: false,
                          //   ).regimentMode = RegimentMode.Symptoms;
                          //   Provider.of<RegimentViewModel>(Get.context,
                          //           listen: false)
                          //       .regimentFilter = RegimentFilter.All;
                          //   await Get.toNamed(rt_Regimen);
                          //   var newUserId = PreferenceUtil.getStringValue(
                          //       constants.KEY_USERID);
                          //   refresh(userId != newUserId);
                          //   await landingViewModel.getQurPlanDashBoard();
                          // },
                        ),
                        LandingCard(
                          title: constants.strYourFamily,
                          lastStatus: '',
                          alerts: activeFamilyMembers > 0
                              ? '$activeFamilyMembers ${constants.strFamilyActive}'
                              : constants.strNoFamily,
                          icon: variable.icon_my_family,
                          color: Color(CommonConstants.bplightColor),
                          onPressed: () async {
                            await Navigator.pushNamed(
                              Get.context,
                              rt_UserAccounts,
                              arguments: UserAccountsArguments(
                                selectedIndex: 1,
                              ),
                            );
                            await landingViewModel.getQurPlanDashBoard();
                          },
                          // onAddPressed: () async {
                          //   await Navigator.pushNamed(
                          //     Get.context,
                          //     rt_UserAccounts,
                          //     arguments: UserAccountsArguments(
                          //       selectedIndex: 1,
                          //     ),
                          //   );
                          //   await landingViewModel.getQurPlanDashBoard();
                          // },
                        ),
                        LandingCard(
                          title: constants.strYourProviders,
                          lastStatus: '',
                          alerts: activeProviders > 0
                              ? '$activeProviders ${constants.strProviderActive}'
                              : constants.strNoProvider,
                          icon: variable.icon_my_providers,
                          color: Color(CommonConstants.pulselightColor),
                          onPressed: () async {
                            await Navigator.pushNamed(
                              Get.context,
                              rt_UserAccounts,
                              arguments: UserAccountsArguments(
                                selectedIndex: 2,
                              ),
                            );
                            await landingViewModel.getQurPlanDashBoard();
                          },
                          // onAddPressed: () async {
                          //   await Navigator.pushNamed(
                          //     Get.context,
                          //     rt_UserAccounts,
                          //     arguments: UserAccountsArguments(
                          //       selectedIndex: 2,
                          //     ),
                          //   );
                          //   await landingViewModel.getQurPlanDashBoard();
                          // },
                        ),
                        LandingCard(
                          title: constants.strHowVideos,
                          lastStatus: '',
                          alerts: availableVideos > 0
                              ? '$availableVideos ${constants.strVideosAvailable}'
                              : constants.strNoVideos,
                          icon: variable.icon_how_to_use,
                          color: Color(CommonConstants.pulselightColor),
                          onPressed: () {
                            if (availableVideos > 0) {
                              Get.to(
                                VideoScreen(
                                  videoList: dashboardData?.helperVideos,
                                ),
                              );
                            }
                          },
                        ),
                        LandingCard(
                          title: constants.strChatWithUs,
                          lastStatus: '',
                          isEnabled: activePlanCount > 0,
                          // alerts: availableCareProvider > 0 &&
                          //         (careProviderName?.trim()?.isNotEmpty ??
                          //             false)
                          //     ? '$careProviderName ${constants.strChatAvailable}'
                          //     : constants.strChatNotAvailable,
                          alerts: careProvidersCount > 0
                              ? '$careProvidersCount ${constants.strCareProvidersAvailable}'
                              : constants.strChatNotAvailable,
                          icon: variable.icon_chat_dash,
                          color: Color(CommonConstants.bplightColor),
                          onPressed: () {
                            // if (availableCareProvider > 0) {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => Chat(
                            //         peerId:
                            //             dashboardData?.careGiverInfo?.doctorId,
                            //         peerAvatar: dashboardData
                            //                 ?.careGiverInfo?.profilePic ??
                            //             '',
                            //         peerName: careProviderName,
                            //         lastDate: null,
                            //         patientId: '',
                            //         patientName: '',
                            //         patientPicture: '',
                            //         isFromVideoCall: false,
                            //       ),
                            //     ),
                            //   );
                            // }
                            if (careProvidersCount > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatHomeScreen(
                                    careGiversList:
                                        dashboardData?.careGiverList ?? [],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
}
