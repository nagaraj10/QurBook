import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/plan_wizard/view/pages/health_condition_page.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

import 'widgets/plan_navigation_widget.dart';

class PlanWizardScreen extends StatelessWidget {
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
          title: const Text(strHealthcon),
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 24.0.sp,
            onTap: () => Get.back(),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                //TODO: Replace Placeholder with page number widget
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
                      HealthConditionPage(),
                      HealthConditionPage(),
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
                            _getBottomText(planWizardViewModel.currentPage),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0.sp,
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10.0.sp,
                          ),
                        ),
                        onPressed: () {},
                        color: Colors.white,
                        child: Text(
                          _getBottomButtonText(planWizardViewModel.currentPage),
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

  String _getBottomText(int currentPage) {
    switch (currentPage) {
      case 0:
        return strDontCondition;
        break;
      case 1:
        return strDontPlan;
        break;
      case 2:
        return strDontDietPlan;
        break;
    }
  }

  String _getBottomButtonText(int currentPage) {
    switch (currentPage) {
      case 0:
        return strLetsAdd;
        break;
      case 1:
        return strTellToUs;
        break;
      case 2:
        return strTellToUs;
        break;
    }
  }
}
