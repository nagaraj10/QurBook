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

class PlanWizardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var planWizardViewModel = Provider.of<PlanWizardViewModel>(context);
    return Scaffold(
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
              Placeholder(
                fallbackHeight: 100.0.h,
                fallbackWidth: 1.0.sw,
              ),
              Expanded(
                child: PageView(
                  controller: planWizardViewModel.pageController,
                  scrollDirection: Axis.horizontal,
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
              Padding(
                padding: EdgeInsets.all(
                  10.0.sp,
                ),
                child: Text(
                  _getBottomText(planWizardViewModel.currentPage),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
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
}
