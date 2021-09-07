import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/landing/view/widgets/video_screen.dart';
import 'package:myfhb/plan_dashboard/view/planDetailsView.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/regiment/view/regiment_screen.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:provider/provider.dart';

class DynamicLinks {
  static void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    await processDynamicLink(deepLink);

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;
        await processDynamicLink(deepLink);
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      },
    );
  }

  static Future<void> processDynamicLink(Uri deepLink) async {
    if ((PreferenceUtil.getStringValue(KEY_USERID) ?? '').isNotEmpty) {
      await PreferenceUtil.saveString(KEY_DYNAMIC_URL, '');
      if ((deepLink?.queryParameters?.length ?? 0) > 0 &&
          (deepLink?.queryParameters['module'] ?? '').isNotEmpty) {
        switch (deepLink?.queryParameters['module']) {
          case 'qurplan':
            var planWizardViewModel =
                Provider.of<PlanWizardViewModel>(Get.context, listen: false);
            int currentPage;
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
                  planWizardViewModel?.dynamicLinkTabIndex = 1;
                } else {
                  planWizardViewModel?.dynamicLinkTabIndex = 0;
                }
              }

              if ((deepLink?.queryParameters['provider'] ?? '').isNotEmpty) {
                planWizardViewModel?.dynamicLinkSearchText =
                    deepLink?.queryParameters['provider'];
              }

              if ((deepLink?.queryParameters['plan'] ?? '').isNotEmpty) {
                planWizardViewModel?.dynamicLinkSearchText =
                    deepLink?.queryParameters['plan'];
              }

              if ((deepLink?.queryParameters['diseaseCondition'] ?? '')
                  .isNotEmpty) {
                planWizardViewModel?.selectedTag =
                    deepLink?.queryParameters['diseaseCondition'];
              }

              planWizardViewModel.isDynamicLink = true;
              planWizardViewModel?.dynamicLinkPage = currentPage ?? 0;
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
          case 'family':
            Get.offAllNamed(
              rt_UserAccounts,
              arguments: UserAccountsArguments(
                selectedIndex: 1,
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
