import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/add_new_plan/view/AddNewPlan.dart';
import 'package:myfhb/add_provider_plan/view/AddProviderPlan.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/plan_wizard/view/pages/care_plan/care_plan_page.dart';
import 'package:myfhb/plan_wizard/view/pages/diet_plan/diet_plan_page.dart';
import 'package:myfhb/plan_wizard/view/pages/diet_plan/tab_diet_main.dart';
import 'package:myfhb/plan_wizard/view/pages/health_condition_page.dart';
import 'package:myfhb/plan_wizard/view/widgets/plan_header.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'pages/care_plan/tab_care_main.dart';
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
    Provider.of<PlanWizardViewModel>(context, listen: false)?.currentPage = 0;
    Provider.of<PlanWizardViewModel>(context, listen: false)?.fetchCartItem();
    Provider.of<PlanWizardViewModel>(context, listen: false)
        ?.isPlanWizardActive = true;
  }

  @override
  void deactivate() {
    Provider.of<PlanWizardViewModel>(context, listen: false)
        ?.isPlanWizardActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var planWizardViewModel = Provider.of<PlanWizardViewModel>(context);
    return WillPopScope(
      onWillPop: () {
        if (planWizardViewModel.currentPage == 0) {
          return Future.value(true);
        } else {
          planWizardViewModel
              .changeCurrentPage(planWizardViewModel.currentPage - 1);
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          elevation: 0,
          title: Text(_getAppBarText(planWizardViewModel.currentPage)),
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 24.0.sp,
            onTap: () {
              if (planWizardViewModel.currentPage == 0) {
                Get.back();
              } else {
                planWizardViewModel
                    .changeCurrentPage(planWizardViewModel.currentPage - 1);
              }
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
                    controller: planWizardViewModel.pageController,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int pageNumber) {
                      planWizardViewModel.changeCurrentPage(pageNumber);
                    },
                    children: [
                      HealthConditionPage(),
                      TabCareMain(),
                      TabDietMain(),
                    ],
                  ),
                ),
                Container(
                  color: Color(CommonUtil().getMyPrimaryColor()),
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
                                planWizardViewModel.currentTabDiet),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0.sp,
                            ),
                          ),
                        ),
                      ),
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10.0.sp,
                          ),
                        ),
                        onPressed: () {
                          if(planWizardViewModel.currentPage==1 || planWizardViewModel.currentPage==2) {
                            Get.to(AddProviderPlan());
                          }else {
                            new AddNewPlan().addNewPlan(
                                context, feedbackCode, titleName, hintText,
                                    (bool) {
                                  FlutterToast toast = new FlutterToast();
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
                        borderSide: BorderSide(color: Colors.white),
                        color: Colors.white,
                        textColor: Colors.white,
                        child: Text(
                          _getBottomButtonText(
                              planWizardViewModel.currentPage,
                              planWizardViewModel.currentTab,
                              planWizardViewModel.currentTabDiet),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getBottomText(int currentPage, int currentTab, int currentTabDiet) {
    switch (currentPage) {
      case 0:
        return strDontCondition;
        break;
      case 1:
        return currentTab == 0 ? strDontProvider : strDontProvider;
        break;
      case 2:
        return currentTabDiet == 0 ? strDontProvider : strDontProvider;
        break;
    }
  }

  String _getBottomButtonText(
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
        return currentTab == 0 ? strAdd : strTellToUs;
        break;
      case 2:
        feedbackCode = "MissingDietPlan";
        titleName = strDontDietPlan;
        hintText = strHintDietPlan;
        return currentTabDiet == 0 ? strAdd : strTellToUs;
        break;
    }
  }

  String _getAppBarText(int currentPage) {
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
}
