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
import '../../../view_model/plan_wizard_view_model.dart';
import '../../widgets/care_plan_card.dart';
import '../../widgets/next_button.dart';

class FreeCarePlans extends StatefulWidget {
  @override
  _FreeCarePlans createState() => _FreeCarePlans();
}

class _FreeCarePlans extends State<FreeCarePlans> {
  late Future<PlanListModel?> planListModel; // FUcrash

  PlanListModel? myPlanListModel;

  bool isSearch = false;

  List<PlanListResult> planSearchList = [];

  String? _selectedView = popUpChoiceDefault;

  int carePlanListLength = 0;

  PlanWizardViewModel? planListProvider;

  List sortType = ['Default', 'Price', 'Duration'];
  final ValueNotifier<String?> _selectedItem =
      ValueNotifier<String?>('Default');

  @override
  void initState() {
    super.initState();
    Provider.of<PlanWizardViewModel>(context, listen: false)
        .currentPackageFreeCareId = '';

    planListModel = Provider.of<PlanWizardViewModel>(
      context,
      listen: false,
    ).getCarePlanList(strFreeCare);
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
            Expanded(
              child: getCarePlanList(),
            ),
          ],
        ),
        floatingActionButton: NextButton(
          onPressed: () {
            if (carePlanListLength > 0 &&
                (planListProvider?.currentPackageFreeCareId ?? '').isEmpty &&
                (planListProvider?.currentPackageProviderCareId ?? '')
                    .isEmpty) {
              _alertForUncheckPlan();
            } else {
              planListProvider!.changeCurrentPage(2);
            }
          },
        ));
  }

  onSearched(String? title, String filterBy) async {
    planSearchList.clear();
    if (filterBy == popUpChoicePrice) {
      planSearchList =
          await planListProvider!.filterSortingForFree(popUpChoicePrice);
    } else if (filterBy == popUpChoiceDura) {
      planSearchList =
          await planListProvider!.filterSortingForFree(popUpChoiceDura);
    } else if (filterBy == popUpChoiceDefault) {
      planSearchList =
          await planListProvider!.filterSortingForFree(popUpChoiceDefault);
    } else if (filterBy == 'localSearch') {
      if (title != null) {
        planSearchList = await planListProvider!.filterPlanNameFree(title);
      }
    }
    setState(() {});
  }

  Widget getCarePlanList() {
    return FutureBuilder<PlanListModel?>(
      // FUcrash
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
            return carePlanList(
                isSearch ? planSearchList : snapshot.data?.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: Text(variable.strNoPlans,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader2
                              : mobileHeader2)),
                )),
              ),
            );
          }
        }
      },
    );
  }

  Widget carePlanList(List<PlanListResult>? planList) {
    return (planList != null && planList.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 50.0.h,
            ),
            itemBuilder: (BuildContext ctx, int i) => CarePlanCard(
              planList: isSearch ? planSearchList[i] : planList[i],
              onClick: () {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              isFrom: strFreeCare,
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
                        color: Colors.grey,
                        fontSize: CommonUtil().isTablet!
                            ? tabHeader2
                            : mobileHeader2)),
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
              Provider.of<PlanWizardViewModel>(context, listen: false)
                  .changeCurrentPage(2);
            },
            title: 'Yes',
          ),
        ],
      ),
    ).then((value) => value as bool);
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
          child: Text(
            popUpChoiceSortLabel,
            style: TextStyle(fontSize: 14.0.sp, color: Colors.blueGrey),
          ),
        ),
        new CheckedPopupMenuItem(
          checked: _selectedView == popUpChoicePrice,
          value: popUpChoicePrice,
          child:
              Text(popUpChoicePrice, style: TextStyle(fontSize: 16.0.sp)),
        ),
        new CheckedPopupMenuItem(
          checked: _selectedView == popUpChoiceDura,
          value: popUpChoiceDura,
          child: Text(popUpChoiceDura, style: TextStyle(fontSize: 14.0.sp)),
        ),
        new CheckedPopupMenuItem(
          checked: _selectedView == popUpChoiceDefault,
          value: popUpChoiceDefault,
          child:
              Text(popUpChoiceDefault, style: TextStyle(fontSize: 14.0.sp)),
        ),
      ],
    );
  } */

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
}
