import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/variable_constant.dart' as variable;
import '../model/PlanListModel.dart';
import 'categoryList.dart';
import '../viewModel/planViewModel.dart';
import '../viewModel/subscribeViewModel.dart';
import '../../regiment/view_model/regiment_view_model.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/SearchWidget/view/SearchWidget.dart';
import '../../widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class SearchProviderList extends StatefulWidget {
  @override
  _SearchProviderList createState() => _SearchProviderList();

  final String diseases;

  final List<PlanListResult> planListResult;

  const SearchProviderList(this.diseases, this.planListResult);
}

class _SearchProviderList extends State<SearchProviderList> {
  PlanListModel myPlanListModel;
  PlanViewModel myPlanViewModel = PlanViewModel();
  bool isSearch = false;
  List<PlanListResult> myPLanListResult = [];
  SubscribeViewModel subscribeViewModel = SubscribeViewModel();
  FlutterToast toast = FlutterToast();

  String diseases = '';
  String hosIcon = '';
  String catIcon = '';
  List<PlanListResult> planListResult;
  List<PlanListResult> planListUniq = [];

  //final GlobalKey _searchKey = GlobalKey();
  //final GlobalKey _hospitalKey = GlobalKey();
  final GlobalKey _subscribeKey = GlobalKey();
  bool isFirst;
  BuildContext _myContext;

  @override
  void initState() {
    FocusManager.instance.primaryFocus.unfocus();
    super.initState();
    Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
      isInitial: true,
    );
    Provider.of<RegimentViewModel>(
      context,
      listen: false,
    ).handleSearchField();
    diseases = widget.diseases;
    planListResult = widget.planListResult;
    PreferenceUtil.init();

    final isFirst = PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_Plan);
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(
            Duration(milliseconds: 1000),
            () => isFirst
                ? null
                : ShowCaseWidget.of(_myContext).startShowCase([_subscribeKey]));
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(onFinish: () {
      PreferenceUtil.saveString(Constants.KEY_SHOWCASE_Plan, variable.strtrue);
    }, builder: Builder(builder: (context) {
      _myContext = context;
      return Scaffold(
          appBar: AppBar(
            flexibleSpace: GradientAppBar(),
            leading: GestureDetector(
              onTap: Get.back,
              child: Icon(
                Icons.arrow_back_ios, // add custom icons also
                size: 24,
              ),
            ),
            title: Text(
              searchHospitals,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                SearchWidget(
                  onChanged: (title) {
                    if (title != '' && title.length > 2) {
                      isSearch = true;
                      onSearchedNew(title, planListUniq);
                    } else {
                      setState(() {
                        isSearch = false;
                      });
                    }
                  },
                  hintText: variable.strSearchByHosLoc,
                ),
                SizedBox(
                  height: 5.0.h,
                ),
                Expanded(child: planList(planListResult)),
                SizedBox(height: 10)
              ],
            ),
          ));
    }));
  }

  onSearchedNew(String title, List<PlanListResult> planListOld) async {
    myPLanListResult.clear();
    if (title != null) {
      myPLanListResult =
          myPlanViewModel.getFilterForProvider(title, planListOld);
    }
    setState(() {});
  }

  Widget planList(List<PlanListResult> planList) {
    planListUniq = [];
    /*if (planList != null && planList.length > 0) {
      planList.forEach((element) {
        if (element?.metadata?.diseases == diseases) {
          bool keysUniq = true;
          planListUniq.forEach((catElement) {
            if (catElement?.metadata?.diseases == diseases) {
              keysUniq = false;
            }
          });
          if (keysUniq) {
            planListUniq.add(element);
          }
        }
      });
    }*/

    if (planList != null && planList.isNotEmpty) {
      planList.where((element1) {
        return (element1?.metadata?.diseases ?? '') == diseases;
      }).forEach((element) {
        var keysUniq = true;
        planListUniq.forEach((catElement) {
          if (catElement?.plinkid == element.plinkid) {
            keysUniq = false;
          }
        });
        if (keysUniq) {
          planListUniq.add(element);
        }
      });
    }

    return (planListUniq != null && planListUniq.isNotEmpty)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            itemBuilder: (ctx, i) => planListItem(
                ctx, i, isSearch ? myPLanListResult : planListUniq),
            itemCount: isSearch ? myPLanListResult.length : planListUniq.length,
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  child: Center(
                child: Text(variable.strNodata),
              )),
            ),
          );
  }

  /*Widget getPlanList() {
    return new FutureBuilder<PlanListModel>(
      future: myPlanViewModel.getPlanList(),
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
            return planList(snapshot.data.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: Text(variable.strNoPlans),
                )),
              ),
            );
          }
        }
      },
    );
  }*/

  Widget planListItem(
      BuildContext context, int i, List<PlanListResult> planList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryList(
                  planList[i].providerid,
                  planList[i]?.metadata?.icon,
                  planList[i]?.metadata?.diseases)),
        ).then((value) {
          setState(() {});
        });
      },
      child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFe3e2e2),
                blurRadius: 16, // has the effect of softening the shadow
                spreadRadius: 5, // has the effect of extending the shadow
                offset: Offset(
                  0, // horizontal, move right 10
                  0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.0.w,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 20,
                      child: CommonUtil().customImage(
                          planList[i]?.providerMetadata?.icon ?? '')),
                  SizedBox(
                    width: 20.0.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          planList[i].providerName != null
                              ? toBeginningOfSentenceCase(
                                  planList[i].providerName)
                              : '',
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          planList[i].providerDesc != null
                              ? toBeginningOfSentenceCase(
                                  planList[i].providerDesc)
                              : '',
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.lightgraycolor,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        if (planList[i].providerName != null &&
                            planList[i].providerName != '' &&
                            planList[i].providerName == strQurhealth)
                          Text(
                            strCovidFree,
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.start,
                          )
                        else
                          SizedBox.shrink()
                      ],
                    ),
                  ),
                  //getSelectedIcon(providerSelectedList, searchList[i]),
                  //SizedBox(width: 5.w),
                ],
              ),
              SizedBox(height: 5.h),
            ],
          )),
    );
  }

  String getImage(int i, List<PlanListResult> planList) {
    String image;
    if (planList[i] != null) {
      if (planList[i].metadata != null && planList[i].metadata != '') {
        if (planList[i].metadata.icon != null &&
            planList[i].metadata.icon != '') {
          image = planList[i].metadata.icon;
        } else {
          if (catIcon != null && catIcon != '') {
            image = catIcon;
          } else {
            if (hosIcon != null && hosIcon != '') {
              image = hosIcon;
            } else {
              image = '';
            }
          }
        }
      } else {
        if (catIcon != null && catIcon != '') {
          image = catIcon;
        } else {
          if (hosIcon != null && hosIcon != '') {
            image = hosIcon;
          } else {
            image = '';
          }
        }
      }
    } else {
      if (catIcon != null && catIcon != '') {
        image = catIcon;
      } else {
        if (hosIcon != null && hosIcon != '') {
          image = hosIcon;
        } else {
          image = '';
        }
      }
    }

    return image;
  }
}
