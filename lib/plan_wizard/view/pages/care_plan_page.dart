import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/view/widgets/care_plan_card.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:provider/provider.dart';

class CarePlanPage extends StatefulWidget {
  @override
  _CarePlanPageState createState() => _CarePlanPageState();
}

class _CarePlanPageState extends State<CarePlanPage> {
  Future<PlanListModel> planListModel;

  PlanListModel myPlanListModel;

  bool isSearch = false;

  List<PlanListResult> planSearchList = List();

  String _selectedView = popUpChoiceDefault;

  int carePlanListLength = 0;

  PlanWizardViewModel planListProvider;

  @override
  void initState() {
    planListModel = Provider.of<PlanWizardViewModel>(context, listen: false)
        .getCarePlanList();
  }

  @override
  Widget build(BuildContext context) {
    planListProvider = Provider.of<PlanWizardViewModel>(context);

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
                        onSearched(value, 'localSearch');
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
                  padding: const EdgeInsets.only(top: 10.0),
                  child: popMenuItem(),
                ),
                SizedBox(width: 20.w)
              ],
            ),
            Expanded(
              child: getCarePlanList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
          onPressed: () {
            if (carePlanListLength > 0 &&
                (planListProvider?.currentPackageId ?? '').isEmpty) {
              _alertForUncheckPlan();
            } else {
              planListProvider.changeCurrentPage(2);
            }
          },
          child: Icon(
            Icons.navigate_next,
            color: Colors.white,
            size: 26.0.sp,
          ),
        ));
  }

  onSearched(String title, String filterBy) async {
    planSearchList.clear();
    if (filterBy == popUpChoicePrice) {
      planSearchList = await planListProvider.filterSorting(popUpChoicePrice);
    } else if (filterBy == popUpChoiceDura) {
      planSearchList = await planListProvider.filterSorting(popUpChoiceDura);
    } else if (filterBy == popUpChoiceDefault) {
      planSearchList = await planListProvider.filterSorting(popUpChoiceDefault);
    } else if (filterBy == 'localSearch') {
      if (title != null) {
        planSearchList = await planListProvider.filterPlanNameProvider(title);
      }
    }
    setState(() {});
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
            carePlanListLength = snapshot?.data?.result?.length ?? 0;
            return carePlanList(snapshot?.data?.result);
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
              planList: isSearch ? planSearchList[i] : planList[i],
              onClick: () {},
            ),
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

  Widget popMenuItem() {
    return PopupMenuButton(
      icon: Icon(
        Icons.filter_alt_sharp,
      ),
      onSelected: (value) => setState(() {
        FocusManager.instance.primaryFocus.unfocus();
        _selectedView = value;
        if (value == popUpChoicePrice) {
          isSearch = true;
          onSearched(value, popUpChoicePrice);
        } else if (value == popUpChoiceDura) {
          isSearch = true;
          onSearched(value, popUpChoiceDura);
        } else if (value == popUpChoiceDefault) {
          isSearch = true;
          onSearched(value, popUpChoiceDefault);
        } else {
          isSearch = false;
        }
      }),
      itemBuilder: (_) => [
        new CheckedPopupMenuItem(
          enabled: false,
          value: popUpChoiceSortLabel,
          child: new Text(
            popUpChoiceSortLabel,
            style: TextStyle(fontSize: 14.0.sp, color: Colors.blueGrey),
          ),
        ),
        new CheckedPopupMenuItem(
          checked: _selectedView == popUpChoicePrice,
          value: popUpChoicePrice,
          child:
              new Text(popUpChoicePrice, style: TextStyle(fontSize: 16.0.sp)),
        ),
        new CheckedPopupMenuItem(
          checked: _selectedView == popUpChoiceDura,
          value: popUpChoiceDura,
          child: new Text(popUpChoiceDura, style: TextStyle(fontSize: 14.0.sp)),
        ),
        new CheckedPopupMenuItem(
          checked: _selectedView == popUpChoiceDefault,
          value: popUpChoiceDefault,
          child:
              new Text(popUpChoiceDefault, style: TextStyle(fontSize: 14.0.sp)),
        ),
      ],
    );
  }
}
