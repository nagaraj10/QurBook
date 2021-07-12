import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/view/widgets/care_plan_card.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';

class CarePlanPage extends StatefulWidget {
  @override
  _CarePlanPageState createState() => _CarePlanPageState();
}

class _CarePlanPageState extends State<CarePlanPage> {
  List<PlanListResult> planListResult;

  Future<PlanListModel> planListModel;
  PlanWizardViewModel myPlanViewModel = new PlanWizardViewModel();

  PlanListModel myPlanListModel;

  bool isPlanChecked = false;

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
              hintText: strPlanHospitalDiet,
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
            if (!isPlanChecked) {
              _alertForUncheckPlan();
            } else {
              Provider.of<PlanWizardViewModel>(context, listen: false)
                  .changeCurrentPage(2);
            }
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
                  child: Text(variable.strNoPackages),
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
            itemBuilder: (BuildContext ctx, int i) =>
                CarePlanCard(i, planList, () {
              isPlanChecked = true;
            }),
            itemCount: planList.length,
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  child: Center(
                child: Text(variable.strNoPlans),
              )),
            ),
          );
  }

  Future<bool> _alertForUncheckPlan() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to continue without choose any plan'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<PlanWizardViewModel>(context, listen: false)
                      .changeCurrentPage(2);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
