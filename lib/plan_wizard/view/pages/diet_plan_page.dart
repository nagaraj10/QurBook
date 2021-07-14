import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/models/DietPlanModel.dart';
import 'package:myfhb/plan_wizard/view/widgets/PlansDietListView.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import 'package:provider/provider.dart';

class DietPlanPage extends StatefulWidget {
  @override
  _DietPlanPageState createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPlanPage> {
  Future<DietPlanModel> planListModel;

  DietPlanModel myPlanListModel;

  PlanWizardViewModel planWizardViewModel = new PlanWizardViewModel();

  bool isSearch = false;

  List<DietPlanResult> planSearchList = List();

  String _selectedView = popUpChoiceDefault;

  List<String> listCategories = ['Recommended Plans', 'All Plans'];

  @override
  void initState() {
    planListModel = planWizardViewModel.getDietPlanList();
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
            if ((Provider.of<PlanWizardViewModel>(context, listen: false)
                        ?.currentPackageId ??
                    '')
                .isEmpty) {
              _alertForUncheckPlan();
            } else {
              Get.to(CheckoutPage());
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
      planSearchList =
          await planWizardViewModel.filterDietSorting(popUpChoicePrice);
    } else if (filterBy == popUpChoiceDura) {
      planSearchList = await planWizardViewModel.filterDietSorting(popUpChoiceDura);
    } else if (filterBy == popUpChoiceDefault) {
      planSearchList =
          await planWizardViewModel.filterDietSorting(popUpChoiceDefault);
    } else if (filterBy == 'localSearch') {
      if (title != null) {
        planSearchList =
            await planWizardViewModel.filterPlanNameProviderDiet(title);
      }
    }
    setState(() {});
  }

  Widget getCarePlanList() {
    return new FutureBuilder<DietPlanModel>(
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
            return carePlanList(snapshot?.data?.result??[]);
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

  Widget carePlanList(List<List<DietPlanResult>> planList) {
    return (planList != null && planList.length > 0)
        ? SingleChildScrollView(
            child: Column(
              children: getDiePLansWidget(planList),
            ),
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

  List<Widget> getDiePLansWidget(List<List<DietPlanResult>> planResult) {
    var planCategories = <Widget>[];
    for (int i = 0; i < planResult.length; i++) {
      planCategories.add(PlanDietListView(
        title: toBeginningOfSentenceCase(listCategories[i]),
        planList: planResult[i],
      ));
    }

    return planCategories;
  }

  Future<bool> _alertForUncheckPlan() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                'You’ve not chosen any diet plan. Are you sure you want to continue'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.to(CheckoutPage());
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
