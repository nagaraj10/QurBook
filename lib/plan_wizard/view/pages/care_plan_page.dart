import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/view/widgets/Rounded_CheckBox.dart';
import 'package:myfhb/plan_wizard/view/widgets/care_plan_card.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:provider/provider.dart';

class CarePlanPage extends StatefulWidget {
  @override
  _CarePlanPageState createState() => _CarePlanPageState();
}

class _CarePlanPageState extends State<CarePlanPage> {
  List<PlanListResult> planListResult;

  Future<PlanListModel> planListModel;

  PlanListModel myPlanListModel;

  PlanWizardViewModel planWizardViewModel = new PlanWizardViewModel();

  bool isSearch = false;

  List<PlanListResult> planSearchList = List();

  @override
  void initState() {
    FocusManager.instance.primaryFocus.unfocus();
    planListModel = planWizardViewModel.getPlanList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchWidget(
                    onChanged: (value) {
                      if (value != '' && value.length > 2) {
                        isSearch = true;
                        onSearched(value, planListResult);
                      } else {
                        setState(() {
                          isSearch = false;
                        });
                      }
                    },
                    hintText: strPlanHospitalDiet,
                    padding: 10.0.sp,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: moreOptionsPopup(),
                ),
                SizedBox(width: 20.w)
              ],
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
            if ((Provider.of<PlanWizardViewModel>(context, listen: false)
                        ?.currentPackageId ??
                    '')
                .isEmpty) {
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

  Widget moreOptionsPopup() => PopupMenuButton(
      icon: Icon(
        Icons.filter_alt_sharp,
      ),
      color: Colors.white,
      padding: EdgeInsets.only(left: 1, right: 2),
      onSelected: (newValue) {},
      itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false,
              value: 0,
              child: Center(
                child: Text(
                  '$popUpChoiceSortLabel',
                  style: TextStyle(fontSize: 14.0.sp, color: Colors.blueGrey),
                ),
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: Text(
                '$popUpChoicePrice',
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(
                '$popUpChoiceDura',
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: Text(
                '$popUpChoiceDefault',
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
            ),
            /* PopupMenuItem(
            child: GestureDetector(child: Text('$popUpChoiceTwo'))),
        PopupMenuItem(
            child: GestureDetector(child: Text('$popUpCHoiceThree')))*/
          ]);

  onSearched(String title, List<PlanListResult> planListOld) async {
    planSearchList.clear();
    if (title != null) {
      planSearchList =
          await planWizardViewModel.filterPlanNameProvider(title, planListOld);
    }
    setState(() {});
  }

  Widget getCarePlanList() {
    planListResult = [];
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
            planListResult = snapshot?.data?.result ?? [];
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
              bottom: 50.0.h,
            ),
            itemBuilder: (BuildContext ctx, int i) => CarePlanCard(
                planList: isSearch ? planSearchList[i] : planList[i]),
            itemCount: isSearch ? planSearchList.length : planList.length,
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

  Widget listItem(BuildContext context, PlanListResult planList) {
    InkWell(
      onTap: () {
        /*Provider.of<PlanWizardViewModel>(context, listen: false)
            .changeCurrentPage(2);*/
      },
      child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400],
                blurRadius: 5.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.0.w,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 20,
                    child: CommonUtil()
                        .customImage(planList?.metadata?.icon ?? ''),
                  ),
                  SizedBox(
                    width: 20.0.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          planList.title != null
                              ? toBeginningOfSentenceCase(planList.title)
                              : '',
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          planList.providerName != null
                              ? toBeginningOfSentenceCase(planList.providerName)
                              : '',
                          style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.lightgraycolor),
                        ),
                        SizedBox(height: 8.h),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Duration: ',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                planList.packageDuration != null
                                    ? Text(
                                        planList.packageDuration + ' days',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 12.0.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(new CommonUtil()
                                                .getMyPrimaryColor())),
                                      )
                                    : Container(),
                                SizedBox(width: 20.w),
                                Text(
                                  'Fee: ',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                planList.price != null
                                    ? Visibility(
                                        visible: planList.price.isNotEmpty &&
                                            planList.price != '0',
                                        child: TextWidget(
                                            text: INR + planList.price,
                                            fontsize: 12.0.sp,
                                            fontWeight: FontWeight.w500,
                                            colors: Color(new CommonUtil()
                                                .getMyPrimaryColor())),
                                        replacement: TextWidget(
                                            text: FREE,
                                            fontsize: 12.0.sp,
                                            fontWeight: FontWeight.w500,
                                            colors: Color(new CommonUtil()
                                                .getMyPrimaryColor())),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      RoundedCheckBox(
                          isSelected: Provider.of<PlanWizardViewModel>(context)
                                  .currentPackageId ==
                              planList.packageid,
                          onTap: () {
                            Provider.of<PlanWizardViewModel>(context,
                                    listen: false)
                                .updateSingleSelection(planList.packageid);
                          }),
                      SizedBox(width: 5.w),
                    ],
                  )
                ],
              ),
              SizedBox(height: 2.h),
            ],
          )),
    );
  }

  Future<bool> _alertForUncheckPlan() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                'You’ve not chosen any care plan. Are you sure you want to continue'),
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
