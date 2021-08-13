import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/view/widgets/care_plan_card.dart';
import 'package:myfhb/plan_wizard/view/widgets/next_button.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

class ProviderCarePlans extends StatefulWidget {
  @override
  _ProviderCarePlans createState() => _ProviderCarePlans();
}

class _ProviderCarePlans extends State<ProviderCarePlans> {
  Future<PlanListModel> planListModel;

  PlanListModel myPlanListModel;

  bool isSearch = false;

  List<PlanListResult> planSearchList = List();

  String _selectedView = popUpChoiceDefault;

  int carePlanListLength = 0;

  PlanWizardViewModel planListProvider;

  List sortType = ['Default', 'Price', 'Duration'];
  ValueNotifier<String> _selectedItem = new ValueNotifier<String>('Default');
  String conditionChosen;

  @override
  void initState() {
    Provider.of<PlanWizardViewModel>(context, listen: false)
        .currentPackageProviderCareId = '';
    conditionChosen =
        Provider.of<PlanWizardViewModel>(context, listen: false).selectedTag;
    planListModel = Provider.of<PlanWizardViewModel>(context, listen: false)
        .getCarePlanList(strProviderCare);

    Provider.of<PlanWizardViewModel>(context, listen: false)?.isListEmpty =
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
            Expanded(
              child: getCarePlanList(),
            ),
          ],
        ),
        floatingActionButton: NextButton(
          onPressed: () {
            if (carePlanListLength > 0 &&
                (planListProvider?.currentPackageProviderCareId ?? '')
                    .isEmpty &&
                (planListProvider?.currentPackageFreeCareId ?? '').isEmpty) {
              _alertForUncheckPlan();
            } else {
              planListProvider.changeCurrentPage(2);
            }
          },
        ));
  }

  onSearched(String title, String filterBy) async {
    planSearchList.clear();
    if (filterBy == popUpChoicePrice) {
      planSearchList =
          await planListProvider.filterSortingForProvider(popUpChoicePrice);
    } else if (filterBy == popUpChoiceDura) {
      planSearchList =
          await planListProvider.filterSortingForProvider(popUpChoiceDura);
    } else if (filterBy == popUpChoiceDefault) {
      planSearchList =
          await planListProvider.filterSortingForProvider(popUpChoiceDefault);
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
                          ?.isListEmpty !=
                      (snapshot?.data?.result.length > 0 ? true : false);

              Provider.of<PlanWizardViewModel>(context, listen: false)
                  ?.updateBottonLayoutEmptyList(
                      snapshot?.data?.result.length > 0 ? true : false,
                      needReload: needReload);
            });

            return carePlanList(
                isSearch ? planSearchList : snapshot?.data?.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Provider.of<PlanWizardViewModel>(context,
                                      listen: false)
                                  ?.providerHosCount ==
                              0
                          ? clickTextProviderEmpty()
                          : clickTextNoPlans(),
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
              isFrom: strProviderCare,
            ),
            itemCount: isSearch ? planSearchList.length : planList.length,
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child:
                        Provider.of<PlanWizardViewModel>(context, listen: false)
                                    ?.providerHosCount ==
                                0
                            ? clickTextProviderEmpty()
                            : clickTextNoPlans(),
                  )),
            ),
          );
  }

  Widget clickTextNoPlans() {
    TextStyle defaultStyle = TextStyle(color: Colors.grey);
    TextStyle linkStyle = TextStyle(
        color: Color(CommonUtil().getMyPrimaryColor()), fontSize: 18.sp);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(
              text:
                  'Your providers do not offer care plans yet for Healthcondition.'),
          TextSpan(
              text: 'Tap here',
              style: linkStyle,
              recognizer: TapGestureRecognizer()..onTap = () {
                callMyProviderPage();
              }),
          TextSpan(text: ' to add a new provider that offers a plan'),
        ],
      ),
    );
  }

  Widget clickTextProviderEmpty() {
    TextStyle defaultStyle = TextStyle(color: Colors.grey);
    TextStyle linkStyle = TextStyle(
        color: Color(CommonUtil().getMyPrimaryColor()), fontSize: 18.sp);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(text: 'You\'ve no providers added to your list.'),
          TextSpan(
              text: 'Tap here',
              style: linkStyle,
              recognizer: TapGestureRecognizer()..onTap = () {
                callMyProviderPage();
              }),
          TextSpan(
              text: ' to add a provider and see plans recommended by them'),
        ],
      ),
    );
  }

  void callMyProviderPage(){
    Navigator.pushNamed(
      Get.context,
      rt_UserAccounts,
      arguments: UserAccountsArguments(
        selectedIndex: 2,
      ),
    ).then((value) =>  setState(() {
      planListModel = Provider.of<PlanWizardViewModel>(context, listen: false)
          .getCarePlanList(strProviderCare);
    }));
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
}
