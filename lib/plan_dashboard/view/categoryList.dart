import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import '../../common/CommonUtil.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/variable_constant.dart' as variable;
import '../model/PlanListModel.dart';
import 'planDetailsView.dart';
import 'planList.dart';
import '../viewModel/planViewModel.dart';
import '../viewModel/subscribeViewModel.dart';
import '../../regiment/view_model/regiment_view_model.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/SearchWidget/view/SearchWidget.dart';
import '../../widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();

  final String providerId;
  final String diseases;
  final String icon;

  const CategoryList(this.providerId, this.icon, this.diseases);
}

class _CategoryState extends State<CategoryList> {
  PlanListModel myPlanListModel;
  PlanViewModel myPlanViewModel = PlanViewModel();
  bool isSearch = false;
  List<PlanListResult> myPLanListResult = [];
  SubscribeViewModel subscribeViewModel = SubscribeViewModel();
  FlutterToast toast = FlutterToast();

  List<PlanListResult> categoryListUniq = [];
  List<String> selectPlan = [];
  Map<String, List<String>> selectTitle = {};
  Map<String, List<String>> selectedTitle = {};

  bool isSubscribedOne = false;

  String providerId = '';
  String icon = '';
  String diseases = '';

  Future<PlanListModel> planListModel;
  Map<String, List<PlanListResult>> planListResultMap;
  Map<String, bool> isSelectedMap;

  List<PlanListResult> planListResult = [];

  @override
  void initState() {
    FocusManager.instance.primaryFocus.unfocus();
    super.initState();
    // Provider.of<RegimentViewModel>(
    //   context,
    //   listen: false,
    // ).updateTabIndex(currentIndex: 2);
    // Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
    //   isInitial: true,
    // );

    providerId = widget.providerId;
    icon = widget.icon;
    diseases = widget.diseases;

    planListModel = myPlanViewModel.getPlanList(providerId);
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            strPlans,
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
                    onSearchedNew(title, categoryListUniq);
                  } else {
                    setState(() {
                      isSearch = false;
                    });
                  }
                },
              ),
              SizedBox(
                height: 10.0.h,
              ),
              Expanded(
                child: myPlanListModel != null ?? myPlanListModel.isSuccess
                    ? categoryList(myPlanListModel.result)
                    : getCategoryList(providerId),
              ),
            ],
          ),
        ));
  }

  onSearchedNew(String title, List<PlanListResult> planListOld) async {
    myPLanListResult.clear();
    if (title != null) {
      myPLanListResult =
          myPlanViewModel.getSearchForCategory(title, planListOld);
    }
    setState(() {});
  }

  Widget categoryList(List<PlanListResult> planList) {
    categoryListUniq = [];
    //selectTitle = {};
    //selectedTitle = {};
    isSubscribedOne = false;
    planListResultMap = {};
    isSelectedMap = {};
    if (planList != null && planList.isNotEmpty) {
      planList.forEach((element) {
        if (element?.metadata?.diseases == diseases) {
          var keysUniq = true;
          categoryListUniq.forEach((catElement) {
            if (catElement?.packcatid == element?.packcatid) {
              keysUniq = false;
            }
          });
          if (keysUniq) {
            categoryListUniq.add(element);
          }
        }
      });
      categoryListUniq.forEach((elementNew) {
        /*selectTitle.putIfAbsent(
          elementNew.packcatid,
          () => [],
        );
        selectedTitle.putIfAbsent(
          elementNew.packcatid,
          () => [],
        );*/
        planListResultMap.putIfAbsent(
          elementNew.packcatid,
          () => [],
        );
        isSelectedMap.putIfAbsent(
          elementNew.packcatid,
          () => false,
        );
        planList.where((elementWhere) {
          return (elementWhere?.metadata?.diseases == diseases) &&
              (elementNew?.packcatid == elementWhere?.packcatid);
        }).forEach((elementLast) {
          if (elementLast?.isSubscribed == '1') {
            isSelectedMap[elementLast.packcatid] = true;
            isSubscribedOne = true;
            //selectedTitle[elementLast.packcatid].add(elementLast.title);
          }
          //selectTitle[elementLast.packcatid].add(elementLast.title);

          planListResultMap[elementLast.packcatid].add(elementLast);
        });
      });
    }
    /*return (categoryListUniq != null && categoryListUniq.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            itemBuilder: (BuildContext ctx, int i) => categoryListItem(ctx, i,
                isSearch ? myPLanListResult : categoryListUniq, planList),
            itemCount:
                isSearch ? myPLanListResult.length : categoryListUniq.length,
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  child: Center(
                child: Text(variable.strNoPackages),
              )),
            ),
          );*/
    return (categoryListUniq != null &&
            categoryListUniq.isNotEmpty &&
            planListResultMap != null &&
            planListResultMap.isNotEmpty)
        ? GroupListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            sectionsCount:
                isSearch ? myPLanListResult.length : categoryListUniq.length,
            countOfItemInSection: (section) {
              return planListResultMap[isSearch
                          ? myPLanListResult[section]?.packcatid
                          : categoryListUniq[section]?.packcatid]
                      ?.length ??
                  0;
            },
            itemBuilder: _itemBuilder,
            groupHeaderBuilder: (context, section) {
              final catName = isSearch
                  ? myPLanListResult[section]?.catname
                  : categoryListUniq[section]?.catname;
              return Column(
                children: [
                  SizedBox(height: 8.0.h),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    width: 1.sw,
                    color: Color(CommonUtil().getMyPrimaryColor()),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        toBeginningOfSentenceCase(catName),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => SizedBoxWidget(
              height: 2.0.h,
            ),
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  child: Center(
                child: Text(variable.strNoPackages),
              )),
            ),
          );
  }

  Widget getCategoryList(String providerId) {
    return FutureBuilder<PlanListModel>(
      future: planListModel,
      builder: (context, snapshot) {
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
          if (snapshot?.hasData &&
              snapshot?.data?.result != null &&
              snapshot?.data?.result.isNotEmpty) {
            return categoryList(snapshot.data.result);
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

  //// old flow (not using)
  Widget categoryListItem(BuildContext context, int i,
      List<PlanListResult> planList, List<PlanListResult> planListFull) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlanList(
                  planList[i].packcatid,
                  planListFull,
                  icon,
                  planList[i]?.catmetadata?.icon,
                  planList[i]?.metadata?.diseases)),
        ).then((value) {
          setState(() {
            planListModel = myPlanViewModel.getPlanList(providerId);
          });
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
                          (planList[i]?.catmetadata?.icon ?? '').isNotEmpty
                              ? planList[i]?.catmetadata?.icon
                              : icon)),
                  SizedBox(
                    width: 20.0.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          planList[i].catname != null
                              ? toBeginningOfSentenceCase(planList[i].catname)
                              : '',
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          planList[i].providerName != null
                              ? toBeginningOfSentenceCase(
                                  planList[i].providerName)
                              : '',
                          style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.lightgraycolor),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          selectTitle[planList[i].packcatid] != null
                              ? isSubscribedOne
                                  ? planList[i].catselecttype == '1'
                                      ? strSelectedPlan +
                                          selectedTitle[planList[i].packcatid]
                                              .join(', ')
                                      : strSelectedPlans +
                                          selectedTitle[planList[i].packcatid]
                                              .join(', ')
                                  : planList[i].catselecttype == '1'
                                      ? strSelectPlan
                                      : strSelectPlans
                              : '',
                          style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(CommonUtil().getMyPrimaryColor())),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
            ],
          )),
    );
  }

  Widget _itemBuilder(BuildContext context, IndexPath inx) {
    if ((planListResultMap?.length ?? 0) > 0 &&
        (categoryListUniq?.length ?? 0) > 0) {
      final planListResult = planListResultMap[isSearch
          ? myPLanListResult[inx.section]?.packcatid
          : categoryListUniq[inx.section]?.packcatid];
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyPlanDetailView(
                      // title: planListResult[inx.index]?.title,
                      // providerName: planListResult[inx.index]?.providerName,
                      // description: planListResult[inx.index]?.description,
                      // issubscription: planListResult[inx.index]?.isSubscribed,
                      packageId: planListResult[inx.index]?.packageid,
                      // price: planListResult[inx.index]?.price,
                      // packageDuration:
                      //     planListResult[inx.index]?.packageDuration,
                      // providerId: planListResult[inx.index]?.plinkid,
                      // isDisable: planListResult[inx.index]?.catselecttype == '1'
                      //     ? (planListResult[inx.index]?.isSubscribed == '1' ||
                      //         (isSelectedMap[
                      //                 planListResult[inx.index]?.packcatid] ??
                      //             false))
                      //     : (planListResult[inx.index]?.isSubscribed == '1'),
                      // hosIcon:
                      //     planListResult[inx.index]?.providerMetadata?.icon,
                      // iconApi: planListResult[inx.index]?.metadata?.icon,
                      // catIcon: planListResult[inx.index]?.catmetadata?.icon,
                      // metaDataForURL: planListResult[inx.index]?.metadata,
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
                      child: CommonUtil()
                          .customImage(getImage(inx.index, planListResult)),
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
                            planListResult[inx.index]?.title != null
                                ? toBeginningOfSentenceCase(
                                    planListResult[inx.index]?.title)
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
                            planListResult[inx.index]?.providerName != null
                                ? toBeginningOfSentenceCase(
                                    planListResult[inx.index]?.providerName)
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
                                  if (planListResult[inx.index]
                                          ?.packageDuration !=
                                      null)
                                    Text(
                                      planListResult[inx.index]
                                              ?.packageDuration +
                                          ' days',
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
                                  if (planListResult[inx.index]?.isSubscribed ==
                                      '1')
                                    Text(
                                      'Start Date: ',
                                      style: TextStyle(
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w400),
                                    )
                                  else
                                    SizedBox(width: 55.w),
                                  planListResult[inx.index]?.isSubscribed == '1'
                                      ? Text(
                                          CommonUtil().dateFormatConversion(
                                              planListResult[inx.index]
                                                  ?.startDate),
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : SizedBox(width: 55.w),
                                  if (planListResult[inx.index]?.isSubscribed ==
                                      '0')
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
                            planListResult[inx.index].price != null
                                ? Visibility(
                                    visible: planListResult[inx.index]
                                            .price
                                            .isNotEmpty &&
                                        planListResult[inx.index]?.price != '0',
                                    replacement: TextWidget(
                                        text: FREE,
                                        fontsize: 16.0.sp,
                                        fontWeight: FontWeight.w500,
                                        colors: Color(
                                            CommonUtil().getMyPrimaryColor())),
                                    child: TextWidget(
                                        text: CommonUtil.CURRENCY +
                                            planListResult[inx.index]?.price,
                                        fontsize: 16.0.sp,
                                        fontWeight: FontWeight.w500,
                                        colors: Color(new CommonUtil()
                                            .getMyPrimaryColor())),
                                  )
                                : Container(),
                            SizedBox(height: 8.h),
                            Align(
                                child: SizedBoxWithChild(
                              width: 95.0.w,
                              height: 32.0.h,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(
                                        color: getBorderColor(
                                            inx.index, planListResult))),
                                color: Colors.transparent,
                                textColor: planListResult[inx.index]
                                            ?.isSubscribed ==
                                        '0'
                                    ? Color(CommonUtil().getMyPrimaryColor())
                                    : Colors.grey,
                                padding: EdgeInsets.all(
                                  8.0.sp,
                                ),
                                onPressed: (planListResult[inx.index]
                                                ?.catselecttype ==
                                            '1'
                                        ? (planListResult[inx.index]
                                                    ?.isSubscribed ==
                                                '1' ||
                                            (isSelectedMap[
                                                    planListResult[inx.index]
                                                        ?.packcatid] ??
                                                false))
                                        : (planListResult[inx.index]
                                                ?.isSubscribed ==
                                            '1'))
                                    ? null
                                    : () async {
                                        if (planListResult[inx.index]
                                                ?.isSubscribed ==
                                            '0') {
                                          CommonUtil().profileValidationCheck(
                                              context,
                                              packageId:
                                                  planListResult[inx.index]
                                                      ?.packageid,
                                              isSubscribed:
                                                  planListResult[inx.index]
                                                      ?.isSubscribed,
                                              providerId:
                                                  planListResult[inx.index]
                                                      ?.plinkid,
                                              isFrom: strIsFromSubscibe,
                                              feeZero: planListResult[inx.index]
                                                          ?.price ==
                                                      '' ||
                                                  planListResult[inx.index]
                                                          ?.price ==
                                                      '0', refresh: () {
                                            setState(() {
                                              planListModel = myPlanViewModel
                                                  .getPlanList(providerId);
                                            });
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
                                      planListResult[inx.index]?.isSubscribed ==
                                              '0'
                                          ? strSubscribe
                                          : strSubscribed,
                                  fontsize: 12.0.sp,
                                ),
                              ),
                            )),
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
    } else {
      return SizedBox.shrink();
    }
  }

  String getImage(int i, List<PlanListResult> planList) {
    String image;
    if (planList[i] != null) {
      if (planList[i].metadata != null && planList[i].metadata != '') {
        if (planList[i].metadata.icon != null &&
            planList[i].metadata.icon != '') {
          image = planList[i].metadata.icon;
        } else {
          if (planList[i].catmetadata != null &&
              planList[i].catmetadata != '') {
            if (planList[i].catmetadata.icon != null &&
                planList[i].catmetadata.icon != '') {
              image = planList[i].catmetadata.icon;
            }
          } else {
            if (planList[i].providerMetadata != null &&
                planList[i].providerMetadata != '') {
              if (planList[i].providerMetadata.icon != null &&
                  planList[i].providerMetadata.icon != '') {
                image = planList[i].providerMetadata.icon;
              }
            } else {
              image = '';
            }
          }
        }
      } else {
        if (planList[i].catmetadata != null && planList[i].catmetadata != '') {
          if (planList[i].catmetadata.icon != null &&
              planList[i].catmetadata.icon != '') {
            image = planList[i].catmetadata.icon;
          }
        } else {
          if (planList[i].providerMetadata != null &&
              planList[i].providerMetadata != '') {
            if (planList[i].providerMetadata.icon != null &&
                planList[i].providerMetadata.icon != '') {
              image = planList[i].providerMetadata.icon;
            }
          } else {
            image = '';
          }
        }
      }
    } else {
      if (planList[i].catmetadata != null && planList[i].catmetadata != '') {
        if (planList[i].catmetadata.icon != null &&
            planList[i].catmetadata.icon != '') {
          image = planList[i].catmetadata.icon;
        }
      } else {
        if (planList[i].providerMetadata != null &&
            planList[i].providerMetadata != '') {
          if (planList[i].providerMetadata.icon != null &&
              planList[i].providerMetadata.icon != '') {
            image = planList[i].providerMetadata.icon;
          }
        } else {
          image = '';
        }
      }
    }

    return image;
  }

  Color getBorderColor(int i, List<PlanListResult> planList) {
    if (planList[i]?.catselecttype == '1'
        ? (planList[i]?.isSubscribed == '1' ||
            (isSelectedMap[planList[i]?.packcatid] ?? false))
        : (planList[i]?.isSubscribed == '1')) {
      return Colors.grey;
    } else {
      if (planList[i]?.isSubscribed == '0') {
        return Color(CommonUtil().getMyPrimaryColor());
      } else {
        return Colors.grey;
      }
    }
  }
}
