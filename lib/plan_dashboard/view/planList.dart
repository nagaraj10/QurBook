import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/variable_constant.dart' as variable;
import '../../main.dart';
import '../model/PlanListModel.dart';
import 'planDetailsView.dart';
import '../viewModel/planViewModel.dart';
import '../viewModel/subscribeViewModel.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/SearchWidget/view/SearchWidget.dart';
import '../../widgets/GradientAppBar.dart';
import 'package:showcaseview/showcaseview.dart';

class PlanList extends StatefulWidget {
  @override
  _MyPlanState createState() => _MyPlanState();

  final String? categoryId;
  final String? hosIcon;
  final String? catIcon;
  final String? diseases;

  final List<PlanListResult> planListResult;

  const PlanList(this.categoryId, this.planListResult, this.hosIcon,
      this.catIcon, this.diseases);
}

class _MyPlanState extends State<PlanList> {
  PlanListModel? myPlanListModel;
  PlanViewModel myPlanViewModel = PlanViewModel();
  bool isSearch = false;
  List<PlanListResult> myPLanListResult = [];
  SubscribeViewModel subscribeViewModel = SubscribeViewModel();
  FlutterToast toast = FlutterToast();

  String? categoryId = '';
  String? hosIcon = '';
  String? catIcon = '';
  String? diseases = '';
  List<PlanListResult>? planListResult;
  bool isSelected = false;
  List<PlanListResult> planListUniq = [];

  //final GlobalKey _searchKey = GlobalKey();
  //final GlobalKey _hospitalKey = GlobalKey();
  final GlobalKey _subscribeKey = GlobalKey();
  bool? isFirst;
  late BuildContext _myContext;

  @override
  void initState() {
    FocusManager.instance.primaryFocus!.unfocus();
    super.initState();
    // Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
    //   isInitial: true,
    // );
    // Provider.of<RegimentViewModel>(
    //   context,
    //   listen: false,
    // ).handleSearchField();
    categoryId = widget.categoryId;
    hosIcon = widget.hosIcon;
    catIcon = widget.catIcon;
    diseases = widget.diseases;
    planListResult = widget.planListResult;
    PreferenceUtil.init();

    final isFirst = PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_Plan);
    try {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Future.delayed(
            Duration(milliseconds: 1000),
            () => isFirst
                ? null
                : ShowCaseWidget.of(_myContext)!
                    .startShowCase([_subscribeKey]));
      });
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus!.unfocus();
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
              'Plans',
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
          myPlanViewModel.getSearchForPlanList(title, planListOld);
    }
    setState(() {});
  }

  Widget planList(List<PlanListResult>? planList) {
    planListUniq = [];
    isSelected = false;
    if (planList != null && planList.isNotEmpty) {
      planList.where((element1) {
        return element1.packcatid == categoryId &&
            (element1.metadata?.diseases == diseases);
      }).forEach((element) {
        if (element.isSubscribed == '1') {
          isSelected = true;
        }
        planListUniq.add(element);
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
                child: Text(variable.strNoPlans),
              )),
            ),
          );
  }

  /*Widget getPlanList() {
    return FutureBuilder<PlanListModel>(
      future: myPlanViewModel.getPlanList(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: Center(
                child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: CircularProgressIndicator(
                      backgroundColor:
                          mAppThemeProvider.primaryColor),
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
              builder: (context) => MyPlanDetailView(
                    // title: planList[i].title,
                    // providerName: planList[i].providerName,
                    // description: planList[i].description,
                    // issubscription: planList[i].isSubscribed,
                    packageId: planList[i].packageid,
                    // price: planList[i].price,
                    // packageDuration: planList[i].packageDuration,
                    // providerId: planList[i].plinkid,
                    // isDisable: planList[i].catselecttype == '1' &&
                    //     planList[i].isSubscribed == '0' &&
                    //     isSelected,
                    // hosIcon: hosIcon,
                    // iconApi: planList[i]?.metadata?.icon,
                    // catIcon: catIcon,
                    // metaDataForURL: planList[i]?.metadata,
                    // isRenew: planList[i]?.isexpired == '1' ? true : false,
                  )),
        ).then((value) {
          if (value == 'refreshUI') {
            setState(() {});
          }
        });
      },
      child: Container(
          padding: EdgeInsets.all(4),
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
                      getImage(i, planList),
                      planInitial: planList[i].providerName,
                    ),
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
                          planList[i].title != null
                              ? toBeginningOfSentenceCase(planList[i].title)!
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
                          planList[i].providerName != null
                              ? toBeginningOfSentenceCase(
                                  planList[i].providerName)!
                              : '',
                          style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.lightgraycolor),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Duration: ',
                                  style: TextStyle(
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                if (planList[i].packageDuration != null)
                                  Text(
                                    planList[i].packageDuration! + ' days',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600),
                                  )
                                else
                                  Container()
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                if (planList[i].isSubscribed == '1')
                                  Text(
                                    'Start Date: ',
                                    style: TextStyle(
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w400),
                                  )
                                else
                                  SizedBox(width: 55.w),
                                if (planList[i].isSubscribed == '1')
                                  Text(
                                    CommonUtil().dateFormatConversion(
                                        planList[i].startDate),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600),
                                  )
                                else
                                  SizedBox(width: 55.w),
                                if (planList[i].isSubscribed == '0')
                                  SizedBox(width: 60.w)
                                else
                                  SizedBox(width: 55.w),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          if (planList[i].price != null)
                            Visibility(
                              visible: planList[i].price!.isNotEmpty &&
                                  planList[i].price != '0',
                              child: TextWidget(
                                  text:
                                      CommonUtil.CURRENCY + planList[i].price!,
                                  fontsize: 16.0.sp,
                                  fontWeight: FontWeight.w500,
                                  colors: mAppThemeProvider.primaryColor),
                              replacement: TextWidget(
                                  text: FREE,
                                  fontsize: 16.0.sp,
                                  fontWeight: FontWeight.w500,
                                  colors: mAppThemeProvider.primaryColor),
                            )
                          else
                            Container(),
                          SizedBox(height: 8.h),
                          Align(
                              child: i != 0
                                  ? SizedBoxWithChild(
                                      width: 95.0.w,
                                      height: 32.0.h,
                                      child: ElevatedButton(style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            side: BorderSide(
                                                color: getBorderColor(
                                                    i, planList))),
                                        backgroundColor: Colors.transparent,
                                        foregroundColor:
                                            planList[i].isSubscribed == '0'
                                                ? mAppThemeProvider.primaryColor
                                                : Colors.grey,
                                        padding: EdgeInsets.all(
                                          8.0.sp,
                                        ),),
                                        onPressed:
                                            planList[i].catselecttype == '1' &&
                                                    planList[i].isSubscribed ==
                                                        '0' &&
                                                    isSelected
                                                ? null
                                                : () async {
                                                    if (planList[i]
                                                            .isSubscribed ==
                                                        '0') {
                                                      CommonUtil().profileValidationCheck(
                                                          context,
                                                          packageId: planList[i]
                                                              .packageid,
                                                          isSubscribed:
                                                              planList[i]
                                                                  .isSubscribed,
                                                          providerId: planList[
                                                                  i]
                                                              .plinkid,
                                                          isFrom:
                                                              strIsFromSubscibe,
                                                          feeZero: planListResult![
                                                                          i]
                                                                      .price ==
                                                                  '' ||
                                                              planList[i]
                                                                      .price ==
                                                                  '0',
                                                          refresh: () {
                                                        setState(() {});
                                                      });
                                                    }
                                                    /*else {
                                          CommonUtil().unSubcribeAlertDialog(
                                              context,
                                              packageId: planList[i].packageid,
                                              refresh: () {
                                            setState(() {});
                                          });
                                        }*/
                                                  },
                                        child: TextWidget(
                                          text: planList[i].isSubscribed == '0'
                                              ? strSubscribe
                                              : strSubscribed,
                                          fontsize: 12.0.sp,
                                        ),
                                      ),
                                    )
                                  : FHBBasicWidget.customShowCase(
                                      _subscribeKey,
                                      Constants.SubscribeDescription,
                                      SizedBoxWithChild(
                                        width: 95.0.w,
                                        height: 32.0.h,
                                        child: ElevatedButton(style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              side: BorderSide(
                                                  color: getBorderColor(
                                                      i, planList))),
                                          backgroundColor: Colors.transparent,
                                          foregroundColor:
                                              planList[i].isSubscribed == '0'
                                                  ? mAppThemeProvider.primaryColor
                                                  : Colors.grey,
                                          padding: EdgeInsets.all(
                                            8.0.sp,
                                          ),),
                                          onPressed:
                                              planList[i].catselecttype ==
                                                          '1' &&
                                                      planList[i]
                                                              .isSubscribed ==
                                                          '0' &&
                                                      isSelected
                                                  ? null
                                                  : () async {
                                                      if (planList[i]
                                                              .isSubscribed ==
                                                          '0') {
                                                        CommonUtil().profileValidationCheck(
                                                            context,
                                                            packageId:
                                                                planList[i]
                                                                    .packageid,
                                                            isSubscribed:
                                                                planList[i]
                                                                    .isSubscribed,
                                                            providerId:
                                                                planList[i]
                                                                    .plinkid,
                                                            isFrom:
                                                                strIsFromSubscibe,
                                                            feeZero: planList[i]
                                                                        .price ==
                                                                    '' ||
                                                                planList[i]
                                                                        .price ==
                                                                    '0',
                                                            refresh: () {
                                                          setState(() {});
                                                        });
                                                      }
                                                      /*else {
                                          CommonUtil().unSubcribeAlertDialog(
                                              context,
                                              packageId: planList[i].packageid,
                                              refresh: () {
                                            setState(() {});
                                          });
                                        }*/
                                                    },
                                          child: TextWidget(
                                            text:
                                                planList[i].isSubscribed == '0'
                                                    ? strSubscribe
                                                    : strSubscribed,
                                            fontsize: 12.0.sp,
                                          ),
                                        ),
                                      ),
                                      Constants.Subscribe)),
                        ],
                      ),
                      SizedBox(width: 4.w),
                    ],
                  )
                ],
              ),
              SizedBox(height: 5.h),
            ],
          )),
    );
  }

  String? getImage(int i, List<PlanListResult> planList) {
    String? image;
    if (planList[i] != null) {
      if (planList[i].metadata != null && planList[i].metadata != '') {
        if (planList[i].metadata!.icon != null &&
            planList[i].metadata!.icon != '') {
          image = planList[i].metadata!.icon;
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

  Color getBorderColor(int i, List<PlanListResult> planList) {
    if (planList[i].catselecttype == '1' &&
        planList[i].isSubscribed == '0' &&
        isSelected) {
      return Colors.grey;
    } else {
      if (planList[i].isSubscribed == '0') {
        return mAppThemeProvider.primaryColor;
      } else {
        return Colors.grey;
      }
    }
  }
}
