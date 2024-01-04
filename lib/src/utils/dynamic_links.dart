
import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/chat_socket/view/ChatUserList.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/firebase_analytics_service.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/landing/view/widgets/video_screen.dart';
import 'package:myfhb/landing/view_model/landing_view_model.dart';
import 'package:myfhb/plan_dashboard/view/planDetailsView.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/regiment/view/regiment_screen.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:provider/provider.dart';

class DynamicLinks {
  static void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    await processDynamicLink(deepLink);

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      final Uri? deepLink = dynamicLinkData?.link;
      await processDynamicLink(deepLink);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  static Future<void> processDynamicLink(Uri? deepLink) async {
    if ((PreferenceUtil.getStringValue(KEY_USERID) ?? '').isNotEmpty) {
      await PreferenceUtil.saveString(KEY_DYNAMIC_URL, '');
      if ((deepLink?.queryParameters.length ?? 0) > 0 &&
          (deepLink?.queryParameters['module'] ?? '').isNotEmpty) {
        var firebase=FirebaseAnalyticsService();
        firebase.trackEvent("on_deep_link_clicked",
            {
              "user_id" : PreferenceUtil.getStringValue(KEY_USERID_MAIN),
              "type" : deepLink?.queryParameters
            }
        );
        switch (deepLink?.queryParameters['module']) {
          case 'qurplan':
            var planWizardViewModel =
                Provider.of<PlanWizardViewModel>(Get.context!, listen: false);
            int? currentPage;
            if ((deepLink?.queryParameters['packageId'] ?? '').isNotEmpty) {
              Get.offAll(
                MyPlanDetailView(
                  packageId: deepLink?.queryParameters['packageId'],
                  isFrom: strDeepLink,
                ),
              );
            } else {
              if ((deepLink?.queryParameters['planType'] ?? '').isNotEmpty) {
                if (deepLink?.queryParameters['planType'] == 'Care') {
                  currentPage = 1;
                } else if (deepLink?.queryParameters['planType'] == 'Diet') {
                  currentPage = 2;
                }
              }

              if ((deepLink?.queryParameters['freePlans'] ?? '').isNotEmpty) {
                if (deepLink?.queryParameters['freePlans'] == '1') {
                  planWizardViewModel.dynamicLinkTabIndex = 1;
                } else {
                  planWizardViewModel.dynamicLinkTabIndex = 0;
                }
              }

              if ((deepLink?.queryParameters['provider'] ?? '').isNotEmpty) {
                planWizardViewModel.dynamicLinkSearchText =
                    deepLink?.queryParameters['provider'];
              }

              if ((deepLink?.queryParameters['plan'] ?? '').isNotEmpty) {
                planWizardViewModel.dynamicLinkSearchText =
                    deepLink?.queryParameters['plan'];
              }

              if ((deepLink?.queryParameters['diseaseCondition'] ?? '')
                  .isNotEmpty) {
                planWizardViewModel.selectedTag =
                    deepLink?.queryParameters['diseaseCondition'];
              }

              planWizardViewModel.isDynamicLink = true;
              planWizardViewModel.dynamicLinkPage = currentPage ?? 0;
              Get.offAllNamed(rt_PlanWizard);
            }
            break;
          case 'devices':
            Get.offAllNamed(rt_Devices);
            break;
          case 'regimen':
            Get.offAll(
              RegimentScreen(),
            );
            break;
          case 'help_videos':
            Get.offAll(VideoScreen());
            break;
          case 'providers':
            Get.offAllNamed(
              rt_UserAccounts,
              arguments: UserAccountsArguments(
                selectedIndex: 2,
              ),
            );
            break;
          case 'family':
            Get.offAllNamed(
              rt_UserAccounts,
              arguments: UserAccountsArguments(
                selectedIndex: 1,
              ),
            );
            break;
          case 'symptoms':
            Provider.of<RegimentViewModel>(
              Get.context!,
              listen: false,
            ).regimentMode = RegimentMode.Symptoms;
            Provider.of<RegimentViewModel>(
              Get.context!,
              listen: false,
            ).regimentFilter = RegimentFilter.Scheduled;
            Get.offAllNamed(rt_Regimen);
            break;
          case 'caregivers_chat':
            var widgetsData =
                await Provider.of<LandingViewModel>(Get.context!, listen: false)
                    .getQurPlanWidgetsData(
              needNotify: true,
              includeText: qr_careGiverList,
            );
            Get.offAll(
              ChatUserList(
                isDynamicLink: true,
                careGiversList: widgetsData?.careGiverList ?? [],
              ),
            );
            break;
        }
      }
    } else {
      await PreferenceUtil.saveString(
          KEY_DYNAMIC_URL, jsonEncode(deepLink?.toString() ?? ''));
    }
  }
}
