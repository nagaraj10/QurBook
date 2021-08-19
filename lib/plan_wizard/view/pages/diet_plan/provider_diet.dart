import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/add_provider_plan/view/AddProviderPlan.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/view/widgets/diet_plan_card.dart';
import 'package:myfhb/plan_wizard/view/widgets/next_button.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import 'package:provider/provider.dart';

class ProviderDietPlans extends StatefulWidget {
  @override
  _ProviderDietPlans createState() => _ProviderDietPlans();
}

class _ProviderDietPlans extends State<ProviderDietPlans> {
  Future<PlanListModel> planListModel;

  PlanListModel myPlanListModel;

  bool isSearch = false;

  List<PlanListResult> planSearchList = List();

  String _selectedView = popUpChoiceDefault;

  int carePlanListLength = 0;

  PlanWizardViewModel planListProvider;

  List sortType = ['Default', 'Price', 'Duration'];
  ValueNotifier<String> _selectedItem = new ValueNotifier<String>('Default');

  bool isSwitched = false;

  @override
  void initState() {
    Provider.of<PlanWizardViewModel>(context, listen: false)
        .currentPackageProviderDietId = '';

    planListModel = Provider.of<PlanWizardViewModel>(context, listen: false)
        .getDietPlanListNew(isFrom: strProviderDiet);

    Provider.of<PlanWizardViewModel>(context, listen: false)?.isDietListEmpty =
        false;
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
              child: getDietPlanList(),
            ),
          ],
        ),
        floatingActionButton: NextButton(
          onPressed: () {
            if (carePlanListLength > 0 &&
                (planListProvider?.currentPackageProviderDietId ?? '')
                    .isEmpty &&
                (planListProvider?.currentPackageFreeDietId ?? '').isEmpty) {
              _alertForUncheckPlan();
            } else {
              Get.to(CheckoutPage());
            }
          },
        ));
  }

  onSearched(String title, String filterBy) async {
    planSearchList.clear();
    if (filterBy == popUpChoicePrice) {
      planSearchList =
          await planListProvider.filterSortingForProviderDiet(popUpChoicePrice);
    } else if (filterBy == popUpChoiceDura) {
      planSearchList =
          await planListProvider.filterSortingForProviderDiet(popUpChoiceDura);
    } else if (filterBy == popUpChoiceDefault) {
      planSearchList = await planListProvider
          .filterSortingForProviderDiet(popUpChoiceDefault);
    } else if (filterBy == 'localSearch') {
      if (title != null) {
        planSearchList =
            await planListProvider.filterPlanNameProviderDiet(title);
      }
    }
    setState(() {});
  }

  Widget getDietPlanList() {
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
                  child: CommonCircularIndicator(),
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
            carePlanListLength = isSearch
                ? planSearchList.length
                : snapshot?.data?.result?.length ?? 0;
            if (((Provider.of<PlanWizardViewModel>(context, listen: false)
                    ?.isDynamicLink) ??
                false)) {
              Future.delayed(Duration(), () {
                var searchText =
                    Provider.of<PlanWizardViewModel>(context, listen: false)
                            ?.dynamicLinkSearchText ??
                        '';
                if (searchText?.isNotEmpty ?? false) {
                  isSearch = true;
                  onSearched(searchText, 'localSearch');
                }
                Provider.of<PlanWizardViewModel>(context, listen: false)
                    ?.isDynamicLink = false;
              });
            }

            Future.delayed(Duration(milliseconds: 100), () {
              bool needReload =
                  Provider.of<PlanWizardViewModel>(context, listen: false)
                          ?.isDietListEmpty !=
                      (snapshot?.data?.result.length > 0 ? true : false);

              Provider.of<PlanWizardViewModel>(context, listen: false)
                  ?.updateBottonLayoutEmptyDietList(
                      snapshot?.data?.result.length > 0 ? true : false,
                      needReload: needReload);
            });

            return dietPlanList(
                isSearch ? planSearchList : snapshot?.data?.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: clickTextAllEmpty(),
                    )),
              ),
            );
          }
        }
      },
    );
  }

  Widget dietPlanList(List<PlanListResult> planList) {
    return (planList != null && planList.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 50.0.h,
            ),
            itemBuilder: (BuildContext ctx, int i) => DietPlanCard(
              planList: isSearch ? planSearchList[i] : planList[i],
              onClick: () {},
              isFrom: strProviderDiet,
            ),
            itemCount: isSearch ? planSearchList.length : planList.length,
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: clickTextAllEmpty(),
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
        planListModel = planListProvider.getDietPlanListNew(
            isFrom: strProviderDiet, isVeg: true);
      });
    } else {
      setState(() {
        isSwitched = false;
        planListModel =
            planListProvider.getDietPlanListNew(isFrom: strProviderDiet);
      });
    }
  }


  Widget clickTextAllEmpty() {
    TextStyle defaultStyle = TextStyle(color: Colors.grey);
    TextStyle linkStyle = TextStyle(
        color: Color(CommonUtil().getMyPrimaryColor()), fontSize: 18.sp);

    if (Provider.of<PlanWizardViewModel>(context, listen: false)
        ?.providerHosCount ==
        0 &&
        Provider.of<PlanWizardViewModel>(context, listen: false)
            ?.planWizardProviderCount ==
            0) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: defaultStyle,
          children: <TextSpan>[
            TextSpan(text: strNoPlansCheckFree),
          ],
        ),
      );
    } else if (Provider.of<PlanWizardViewModel>(context, listen: false)
        ?.planWizardProviderCount ==
        0) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: defaultStyle,
          children: <TextSpan>[
            TextSpan(text: strNoPlansCheckFree),
          ],
        ),
      );
    } else if (Provider.of<PlanWizardViewModel>(context, listen: false)
        ?.planWizardProviderCount !=
        0 && Provider.of<PlanWizardViewModel>(context, listen: false)
        ?.providerHosCount !=
        0) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: defaultStyle,
          children: <TextSpan>[
            TextSpan(
                text: 'Your providers do not offer diet plans yet for ' +
                    planListProvider?.healthTitle ??
                    ''),
            TextSpan(
                text: ' Tap here',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    callMyProviderPage();
                  }),
            TextSpan(text: ' to add a new provider that offers a plan'),
          ],
        ),
      );
    } else if (Provider.of<PlanWizardViewModel>(context, listen: false)
        ?.providerHosCount ==
        0 && Provider.of<PlanWizardViewModel>(context, listen: false)
        ?.planWizardProviderCount !=
        0) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: defaultStyle,
          children: <TextSpan>[
            TextSpan(text: 'You\'ve no providers added to your list.'),
            TextSpan(
                text: 'Tap here',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    callMyProviderPage();
                  }),
            TextSpan(
                text: ' to add a provider and see plans recommended by them'),
          ],
        ),
      );
    } else {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: defaultStyle,
          children: <TextSpan>[
            TextSpan(text: strNoPlansCheckFree),
          ],
        ),
      );
    }
  }

  void callMyProviderPage(){

    Get.to(AddProviderPlan(
        planListProvider.selectedTag)).then((value) =>  setState(() {
      planListModel = Provider.of<PlanWizardViewModel>(context, listen: false)
          .getDietPlanListNew(isFrom: strProviderDiet);
    }));

    /*Navigator.pushNamed(
      Get.context,
      rt_UserAccounts,
      arguments: UserAccountsArguments(
        selectedIndex: 2,
      ),
    ).then((value) =>  setState(() {
      planListModel = Provider.of<PlanWizardViewModel>(context, listen: false)
          .getDietPlanListNew(isFrom: strProviderDiet);
    }));*/
  }
}
