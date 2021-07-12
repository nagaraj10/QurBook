import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/view/widgets/care_plan_card.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class DietPlanPage extends StatefulWidget {

  @override
  _DietPlanPageState createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPlanPage> {

  List<PlanListResult> planListResult;

  Future<PlanListModel> planListModel;
  PlanWizardViewModel myPlanViewModel = new PlanWizardViewModel();

  PlanListModel myPlanListModel;

  @override
  void initState() {
    planListModel = myPlanViewModel.getPlanList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            SearchWidget(
              hintText: strSearchDietPlan,
              onChanged: (providerName) {},
            ),
            Expanded(
              child: myPlanListModel != null ?? myPlanListModel.isSuccess
                  ? carePlanList(myPlanListModel.result)
                  : getCarePlanList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
          onPressed: () {
          },
          child: Icon(
            Icons.navigate_next,
            color: Colors.white,
            size: 26.0.sp,
          ),
        ));
  }

  Widget getCarePlanList() {
    return new FutureBuilder<PlanListModel>(
      future: planListModel,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: new Center(
                child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: new CircularProgressIndicator(
                      backgroundColor:
                      Color(new CommonUtil().getMyPrimaryColor())),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          if (snapshot?.hasData &&
              snapshot?.data?.result != null &&
              snapshot?.data?.result?.length > 0) {
            return carePlanList(snapshot.data.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                      child: Text(strNoPackages),
                    )),
              ),
            );
          }
        }
      },
    );
  }

  Widget carePlanList(List<PlanListResult> planList) {
    return (planList != null && planList.length > 0)
        ? ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(
        bottom: 8.0.h,
      ),
      itemBuilder: (BuildContext ctx, int i) => CarePlanCard(i, planList,(){

      }),
      itemCount: planList.length,
    )
        : SafeArea(
      child: SizedBox(
        height: 1.sh / 1.3,
        child: Container(
            child: Center(
              child: Text(strNoPlans),
            )),
      ),
    );
  }
}
