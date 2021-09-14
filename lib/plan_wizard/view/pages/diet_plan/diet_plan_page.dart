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
import 'package:myfhb/plan_wizard/view/widgets/next_button.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

class DietPlanPage extends StatefulWidget {
  @override
  _DietPlanPageState createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPlanPage> {
  Future<DietPlanModel> planListModel;

  DietPlanModel myPlanListModel;

  PlanWizardViewModel planWizardViewModel = new PlanWizardViewModel();

  bool isSearch = false;

  List<List<DietPlanResult>> planSearchList = List();

  String _selectedView = popUpChoiceDefault;

  List<String> listCategories = ['Recommended Plans', 'All Plans'];

  int dietPlanListLength = 0;

  PlanWizardViewModel planListProvider;

  bool isSwitched = false;

  List sortType = ['Default', 'Price', 'Duration'];
  ValueNotifier<String> _selectedItem = new ValueNotifier<String>('Default');

  @override
  void initState() {
     mInitialTime = DateTime.now();
    Provider.of<PlanWizardViewModel>(context, listen: false)
        .currentPackageIdDiet = '';

    planListModel = planWizardViewModel.getDietPlanList();
  }
  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'DietPlanPage Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
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
                  child: popMenuItemNew(),
                ),
                SizedBox(width: 20.w)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Switch(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: toggleSwitch,
                  value: isSwitched,
                  activeColor: Color(new CommonUtil().getMyPrimaryColor()),
                ),
                SizedBox(width: 2.w),
                Text(
                  'VEG ONLY',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                      fontSize: 16.sp),
                ),
                SizedBox(width: 15.w),
              ],
            ),
            Expanded(
              child: getCarePlanList(),
            ),
          ],
        ),
        floatingActionButton: NextButton(
          onPressed: () {
            if (dietPlanListLength > 0 &&
                (planListProvider?.currentPackageIdDiet ?? '').isEmpty) {
              _alertForUncheckPlan();
            } else {
              Get.to(CheckoutPage());
            }
          },
        ));
  }

  onSearched(String title, String filterBy) async {
    planSearchList.clear();
    /*if (filterBy == popUpChoicePrice) {
      planSearchList =
          await planWizardViewModel.filterDietSorting(popUpChoicePrice);
    } else if (filterBy == popUpChoiceDura) {
      planSearchList =
          await planWizardViewModel.filterDietSorting(popUpChoiceDura);
    } else if (filterBy == popUpChoiceDefault) {
      planSearchList =
          await planWizardViewModel.filterDietSorting(popUpChoiceDefault);
    } else if (filterBy == 'localSearch') {
      *//*if (title != null) {
        planSearchList =
            await planWizardViewModel.filterPlanNameProviderDiet(title);
      }*//*
    }*/
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
                  child: CommonCircularIndicator(),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          int totalListCount = 0;
          totalListCount = (snapshot?.data?.result?.length ?? 0) > 0
              ? snapshot?.data?.result?.length
              : 0;
          if (totalListCount > 0) {
            totalListCount = 0;
            snapshot?.data?.result?.forEach((element) {
              totalListCount += element?.length ?? 0;
            });
          }
          if (totalListCount > 0) {
            dietPlanListLength =
                isSearch ? planSearchList.length : totalListCount ?? 0;
            return carePlanList(
                isSearch ? planSearchList : snapshot?.data?.result ?? []);
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
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.0.h),
              child: Column(
                children: getDiePLansWidget(planList),
              ),
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

  /* Widget popMenuItem() {
    return PopupMenuButton(
      icon: Icon(
        Icons.sort,
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
  } */

  Widget popMenuItemNew() {
    return new PopupMenuButton<String>(
      icon: Icon(
        Icons.sort,
      ),
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<String>> menuItems =
            new List<PopupMenuEntry<String>>.generate(
          sortType.length,
          (int index) {
            return new PopupMenuItem(
              value: sortType[index],
              child: new AnimatedBuilder(
                child: new Text(sortType[index]),
                animation: _selectedItem,
                builder: (BuildContext context, Widget child) {
                  return new RadioListTile<String>(
                    value: sortType[index],
                    groupValue: _selectedItem.value,
                    title: child,
                    onChanged: (value) {
                      setState(() {
                        _selectedItem.value = value;
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
                      });
                      Get.back();
                    },
                    activeColor: Color(CommonUtil().getMyPrimaryColor()),
                  );
                },
              ),
            );
          },
        );
        menuItems
          ..insert(
              0,
              new CheckedPopupMenuItem(
                enabled: false,
                value: popUpChoiceSortLabel,
                child: new Text(
                  popUpChoiceSortLabel,
                  style: TextStyle(fontSize: 14.0.sp, color: Colors.blueGrey),
                ),
              ));
        return menuItems;
      },
    );
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        planListModel = planWizardViewModel.getDietPlanList(isVeg: true);
      });
    } else {
      setState(() {
        isSwitched = false;
        planListModel = planWizardViewModel.getDietPlanList();
      });
    }
  }
}
