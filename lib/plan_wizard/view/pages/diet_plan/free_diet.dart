import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import 'package:provider/provider.dart';

import '../../../../authentication/constants/constants.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../common/common_circular_indicator.dart';
import '../../../../common/errors_widget.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/variable_constant.dart' as variable;
import '../../../../main.dart';
import '../../../../plan_dashboard/model/PlanListModel.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../telehealth/features/SearchWidget/view/SearchWidget.dart';
import '../../../../telehealth/features/chat/constants/const.dart';
import '../../../../widgets/checkout_page.dart';
import '../../../view_model/plan_wizard_view_model.dart';
import '../../widgets/diet_plan_card.dart';
import '../../widgets/next_button.dart';

class FreeDietPlans extends StatefulWidget {
  @override
  _FreeDietPlans createState() => _FreeDietPlans();
}

class _FreeDietPlans extends State<FreeDietPlans> {
  late Future<PlanListModel?> planListModel;

  PlanListModel? myPlanListModel;

  bool isSearch = false;

  List<PlanListResult> planSearchList = [];

  String? _selectedView = popUpChoiceDefault;

  int carePlanListLength = 0;

  PlanWizardViewModel? planListProvider;

  List sortType = ['Default', 'Price', 'Duration'];
  final ValueNotifier<String?> _selectedItem =
      ValueNotifier<String?>('Default');

  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    Provider.of<PlanWizardViewModel>(context, listen: false)
        .currentPackageFreeDietId = '';

    planListModel = Provider.of<PlanWizardViewModel>(context, listen: false)
        .getDietPlanListNew(isFrom: strFreeDiet);
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
                    onClosePress: () {
                      FocusManager.instance.primaryFocus!.unfocus();
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
                  activeColor: mAppThemeProvider.primaryColor,
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
              child: getDietPlanList(),
            ),
          ],
        ),
        floatingActionButton: NextButton(
          onPressed: () {
            if (carePlanListLength > 0 &&
                (planListProvider?.currentPackageFreeDietId ?? '').isEmpty &&
                (planListProvider?.currentPackageProviderDietId ?? '')
                    .isEmpty) {
              _alertForUncheckPlan();
            } else {
              Get.to(CheckoutPage())!.then(
                  (value) => FocusManager.instance.primaryFocus!.unfocus());
            }
          },
        ));
  }

  onSearched(String? title, String filterBy) async {
    planSearchList.clear();
    if (filterBy == popUpChoicePrice) {
      planSearchList =
          await planListProvider!.filterSortingForFreeDiet(popUpChoicePrice);
    } else if (filterBy == popUpChoiceDura) {
      planSearchList =
          await planListProvider!.filterSortingForFreeDiet(popUpChoiceDura);
    } else if (filterBy == popUpChoiceDefault) {
      planSearchList =
          await planListProvider!.filterSortingForFreeDiet(popUpChoiceDefault);
    } else if (filterBy == 'localSearch') {
      if (title != null) {
        planSearchList = await planListProvider!.filterPlanNameFreeDiet(title);
      }
    }
    setState(() {});
  }

  Widget getDietPlanList() {
    return FutureBuilder<PlanListModel?>(
      future: planListModel,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: Center(
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
          if (snapshot.hasData &&
              snapshot.data!.result != null &&
              snapshot.data!.result!.length > 0) {
            carePlanListLength = isSearch
                ? planSearchList.length
                : snapshot.data?.result?.length ?? 0;
            if (((Provider.of<PlanWizardViewModel>(context, listen: false)
                .isDynamicLink))) {
              Future.delayed(Duration(), () {
                var searchText =
                    Provider.of<PlanWizardViewModel>(context, listen: false)
                            .dynamicLinkSearchText ??
                        '';
                if (searchText.isNotEmpty) {
                  isSearch = true;
                  onSearched(searchText, 'localSearch');
                }
                Provider.of<PlanWizardViewModel>(context, listen: false)
                    .isDynamicLink = false;
              });
            }
            return dietPlanList(
                isSearch ? planSearchList : snapshot.data?.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: Text(variable.strNoPlans,
                      style: TextStyle(
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader2
                              : mobileHeader2,
                          color: Colors.grey)),
                )),
              ),
            );
          }
        }
      },
    );
  }

  Widget dietPlanList(List<PlanListResult>? planList) {
    return (planList != null && planList.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 50.0.h,
            ),
            itemBuilder: (BuildContext ctx, int i) => DietPlanCard(
              planList: isSearch ? planSearchList[i] : planList[i],
              onClick: () {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              isFrom: strFreeDiet,
            ),
            itemCount: isSearch ? planSearchList.length : planList.length,
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  child: Center(
                child: Text(variable.strNoPlans,
                    style: TextStyle(
                        fontSize:
                            CommonUtil().isTablet! ? tabHeader2 : mobileHeader2,
                        color: Colors.grey)),
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
            'You’ve not chosen any diet plan. Are you sure you want to continue'),
        actions: <Widget>[
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            onPress: () => Navigator.pop(context),
            title: 'No',
          ),
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            onPress: () {
              Navigator.pop(context);
              Get.to(CheckoutPage())!.then(
                  (value) => FocusManager.instance.primaryFocus!.unfocus());
            },
            title: 'Yes',
          ),
        ],
      ),
    ).then((value) => value as bool);
  }

  Widget popMenuItemNew() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.sort,
      ),
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<String>> menuItems =
            List<PopupMenuEntry<String>>.generate(
          sortType.length,
          (int index) {
            return PopupMenuItem(
              value: sortType[index],
              child: AnimatedBuilder(
                child: Text(sortType[index]),
                animation: _selectedItem,
                builder: (BuildContext context, Widget? child) {
                  return RadioListTile<String>(
                    value: sortType[index],
                    groupValue: _selectedItem.value,
                    title: child,
                    onChanged: (value) {
                      setState(() {
                        _selectedItem.value = value;
                        FocusManager.instance.primaryFocus!.unfocus();
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
                    activeColor: mAppThemeProvider.primaryColor,
                  );
                },
              ),
            );
          },
        );
        menuItems
          ..insert(
              0,
              CheckedPopupMenuItem(
                enabled: false,
                value: popUpChoiceSortLabel,
                child: Text(
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
        planListModel = planListProvider!
            .getDietPlanListNew(isFrom: strFreeDiet, isVeg: true);
      });
    } else {
      setState(() {
        isSwitched = false;
        planListModel =
            planListProvider!.getDietPlanListNew(isFrom: strFreeDiet);
      });
    }
  }
}
