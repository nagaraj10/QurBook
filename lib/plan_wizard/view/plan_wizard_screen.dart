import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:provider/provider.dart';

import '../../add_new_plan/view/AddNewPlan.dart';
import '../../add_provider_plan/view/AddProviderPlan.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart';
import '../../landing/view/landing_arguments.dart';
import '../../main.dart';
import '../../src/ui/MyRecord.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import '../view_model/plan_wizard_view_model.dart';
import 'pages/care_plan/tab_care_main.dart';
import 'pages/diet_plan/tab_diet_main.dart';
import 'pages/health_condition_page.dart';
import 'widgets/plan_navigation_widget.dart';

class PlanWizardScreen extends StatefulWidget {
  @override
  _PlanWizardScreenState createState() => _PlanWizardScreenState();
}

class _PlanWizardScreenState extends State<PlanWizardScreen> {
  String feedbackCode = "MissingCondition";
  String titleName = "Missing Health Condition";
  String hintText = "Missing condition";

  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBAAddPlansCategoryScreen);
    if (!Provider.of<PlanWizardViewModel>(context, listen: false)
        .isDynamicLink) {
      Provider.of<PlanWizardViewModel>(context, listen: false).currentPage = 0;
    } else {
      Future.delayed(const Duration(), () {
        Provider.of<PlanWizardViewModel>(context, listen: false)
            .changeCurrentPage(
          Provider.of<PlanWizardViewModel>(context, listen: false)
              .dynamicLinkPage,
        );
      });
    }
    Provider.of<PlanWizardViewModel>(context,listen: false).getMemberShip();
    Provider.of<PlanWizardViewModel>(context, listen: false).getCreditBalance();
    Provider.of<PlanWizardViewModel>(context, listen: false).fetchCartItem();
    Provider.of<PlanWizardViewModel>(context, listen: false).updateCareCount();
    Provider.of<PlanWizardViewModel>(context, listen: false).updateDietCount();
    Provider.of<PlanWizardViewModel>(context, listen: false)
        .isPlanWizardActive = true;
  }

  @override
  void deactivate() {
    Provider.of<PlanWizardViewModel>(context, listen: false)
        .isPlanWizardActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var planWizardViewModel = Provider.of<PlanWizardViewModel>(context);
    return WillPopScope(
      onWillPop: () {
        onBackPressed(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          backgroundColor: mAppThemeProvider.primaryColor,
          elevation: 0,
          title: Text(
            _getAppBarText(planWizardViewModel.currentPage)!,
            style: TextStyle(
                fontSize: (CommonUtil().isTablet ?? false)
                    ? tabFontTitle
                    : mobileFontTitle),
          ),
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 24.0.sp,
            onTap: () {
              onBackPressed(context);
            },
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 5.h),
                PlanNavigationWidget(),
                Expanded(
                  child: PageView(
                    controller:
                        planWizardViewModel.pageController ?? PageController(),
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int pageNumber) {
                      // planWizardViewModel.changeCurrentPage(pageNumber);
                    },
                    children: [
                      HealthConditionPage(),
                      TabCareMain(),
                      TabDietMain(),
                    ],
                  ),
                ),
                ((planWizardViewModel.currentPage == 1 &&
                            planWizardViewModel.currentTab == 0 &&
                            planWizardViewModel.isListEmpty) ||
                        (planWizardViewModel.currentTabDiet == 0 &&
                            planWizardViewModel.isDietListEmpty &&
                            planWizardViewModel.currentPage == 2))
                    ? Container(
                        color: mAppThemeProvider.primaryColor,
                        margin: EdgeInsets.only(
                          top: 10.0.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0.sp,
                          vertical: 5.0.sp,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  10.0.sp,
                                ),
                                child: Text(
                                  _getBottomText(
                                      planWizardViewModel.currentPage,
                                      planWizardViewModel.currentTab,
                                      planWizardViewModel.currentTabDiet)!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0.sp,
                                  ),
                                ),
                              ),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0.sp,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (planWizardViewModel.currentPage == 1 ||
                                    planWizardViewModel.currentPage == 2) {
                                  Get.to(AddProviderPlan(
                                      planWizardViewModel.selectedTag));
                                } else {
                                  AddNewPlan().addNewPlan(context, feedbackCode,
                                      titleName, hintText, (bool) {
                                    FlutterToast toast = FlutterToast();
                                    if (bool) {
                                      toast.getToast(
                                          "We've received your request and get back to you soon",
                                          Colors.green);
                                    } else {
                                      toast.getToast(
                                          "Please try again ", Colors.red);
                                    }
                                  });
                                }
                              },
                              child: Text(
                                _getBottomButtonText(
                                    planWizardViewModel.currentPage,
                                    planWizardViewModel.currentTab,
                                    planWizardViewModel.currentTabDiet)!,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _getBottomText(int currentPage, int currentTab, int currentTabDiet) {
    switch (currentPage) {
      case 0:
        return strDontCondition;
        break;
      case 1:
        return currentTab == 0 ? strDontProvider : "";
        break;
      case 2:
        return currentTabDiet == 0 ? strDontProvider : "";
        break;
    }
  }

  String? _getBottomButtonText(
      int currentPage, int currentTab, int currentTabDiet) {
    switch (currentPage) {
      case 0:
        feedbackCode = "MissingCondition";
        titleName = strDontCondition;
        hintText = strHintHealth;
        return strTellToUs;
        break;
      case 1:
        feedbackCode = "MissingCarePlan";
        titleName = strDontPlan;
        hintText = strHintCarePlan;
        return strAdd;
        break;
      case 2:
        feedbackCode = "MissingDietPlan";
        titleName = strDontDietPlan;
        hintText = strHintDietPlan;
        return strAdd;
        break;
    }
  }

  String? _getAppBarText(int currentPage) {
    switch (currentPage) {
      case 0:
        return strHealthcon;
        break;
      case 1:
        return strCarePlans;
        break;
      case 2:
        return strDietPlan;
        break;
    }
  }

  onBackPressed(BuildContext context) {
    var planWizardViewModel =
        Provider.of<PlanWizardViewModel>(context, listen: false);
    if (planWizardViewModel.currentPage == 0) {
      planWizardViewModel.isDynamicLink = false;
      planWizardViewModel.dynamicLinkSearchText = '';
      if (Navigator.canPop(context)) {
        Get.back();
      } else {
        Get.offAllNamed(
          rt_Landing,
          arguments: const LandingArguments(
            needFreshLoad: false,
          ),
        );
      }
    } else {
      var newPage = 0;
      if (planWizardViewModel.isDynamicLink) {
        planWizardViewModel.isDynamicLink = false;
        planWizardViewModel.dynamicLinkSearchText = '';
        newPage = 0;
      } else {
        newPage = planWizardViewModel.currentPage - 1;
      }
      planWizardViewModel.changeCurrentPage(newPage);
    }
  }
}
