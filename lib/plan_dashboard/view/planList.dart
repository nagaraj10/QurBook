import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/view/planDetailsView.dart';
import 'package:myfhb/plan_dashboard/viewModel/planViewModel.dart';
import 'package:myfhb/plan_dashboard/viewModel/subscribeViewModel.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

class PlanList extends StatefulWidget {
  @override
  _MyPlanState createState() => _MyPlanState();

  final String categoryId;
  final String hosIcon;
  final String catIcon;

  final List<PlanListResult> planListResult;

  PlanList(this.categoryId, this.planListResult, this.hosIcon, this.catIcon);
}

class _MyPlanState extends State<PlanList> {
  PlanListModel myPlanListModel;
  PlanViewModel myPlanViewModel = new PlanViewModel();
  bool isSearch = false;
  List<PlanListResult> myPLanListResult = List();
  SubscribeViewModel subscribeViewModel = new SubscribeViewModel();
  FlutterToast toast = new FlutterToast();

  String categoryId = '';
  String hosIcon = '';
  String catIcon = '';
  List<PlanListResult> planListResult;
  bool isSelected = false;
  List<PlanListResult> planListUniq = [];

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
    categoryId = widget.categoryId;
    hosIcon = widget.hosIcon;
    catIcon = widget.catIcon;
    planListResult = widget.planListResult;
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
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios, // add custom icons also
              size: 24.0,
            ),
          ),
          title: Text(
            'Plans',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Visibility(
          visible:
              Provider.of<RegimentViewModel>(context).regimentsDataAvailable,
          child: Container(
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
          ),
          replacement: Center(
            child: Padding(
              padding: EdgeInsets.all(
                10.0.sp,
              ),
              child: Text(
                Constants.mplansForFamily,
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }

  onSearchedNew(String title, List<PlanListResult> planListOld) async {
    myPLanListResult.clear();
    if (title != null) {
      myPLanListResult =
          await myPlanViewModel.getSearchForPlanList(title, planListOld);
    }
    setState(() {});
  }

  Widget planList(List<PlanListResult> planList) {
    planListUniq = [];
    isSelected = false;
    if (planList != null && planList.length > 0) {
      planList.where((element1) {
        return element1.packcatid == categoryId;
      }).forEach((element) {
        if (element.isSubscribed == '1') {
          isSelected = true;
        }
        planListUniq.add(element);
      });
    }

    return (planListUniq != null && planListUniq.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            itemBuilder: (BuildContext ctx, int i) => planListItem(
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
              builder: (context) => MyPlanDetailView(
                    title: planList[i].title,
                    providerName: planList[i].providerName,
                    description: planList[i].description,
                    issubscription: planList[i].isSubscribed,
                    packageId: planList[i].packageid,
                    price: planList[i].price,
                    packageDuration: planList[i].packageDuration,
                    providerId: planList[i].plinkid,
                    isDisable: planList[i].catselecttype == '1' &&
                        planList[i].isSubscribed == '0' &&
                        isSelected,
                    hosIcon: hosIcon,
                    iconApi: planList[i]?.metadata?.icon,
                    catIcon: catIcon,
                    metaDataForURL: planList[i]?.metadata,
                  )),
        ).then((value) {
          if (value == 'refreshUI') {
            setState(() {});
          }
        });
      },
      child: Container(
          padding: EdgeInsets.all(4.0),
          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFe3e2e2),
                blurRadius: 16, // has the effect of softening the shadow
                spreadRadius: 5.0, // has the effect of extending the shadow
                offset: Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.0.w,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 20,
                    child: CommonUtil().customImage(getImage(i,planList)),
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
                              ? toBeginningOfSentenceCase(planList[i].title)
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
                                  planList[i].providerName)
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
                                planList[i].packageDuration != null
                                    ? Text(
                                        planList[i].packageDuration + ' days',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                planList[i].isSubscribed == '1'
                                    ? Text(
                                        'Start Date: ',
                                        style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w400),
                                      )
                                    : SizedBox(width: 55.w),
                                planList[i].isSubscribed == '1'
                                    ? Text(
                                        new CommonUtil().dateFormatConversion(
                                            planList[i].startDate),
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : SizedBox(width: 55.w),
                                planList[i].isSubscribed == '0'
                                    ? SizedBox(width: 60.w)
                                    : SizedBox(width: 55.w),
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
                          planList[i].price != null
                              ? Visibility(
                                  visible: planList[i].price.isNotEmpty &&
                                      planList[i].price != '0',
                                  child: TextWidget(
                                      text: INR + planList[i].price,
                                      fontsize: 16.0.sp,
                                      fontWeight: FontWeight.w500,
                                      colors: Color(new CommonUtil()
                                          .getMyPrimaryColor())),
                                  replacement: TextWidget(
                                      text: FREE,
                                      fontsize: 16.0.sp,
                                      fontWeight: FontWeight.w500,
                                      colors: Color(new CommonUtil()
                                          .getMyPrimaryColor())),
                                )
                              : Container(),
                          SizedBox(height: 8.h),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBoxWithChild(
                              width: 95.0.w,
                              height: 32.0.h,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: getBorderColor(i, planList))),
                                color: Colors.transparent,
                                textColor: planList[i].isSubscribed == '0'
                                    ? Color(new CommonUtil().getMyPrimaryColor())
                                    : Colors.grey,
                                padding: EdgeInsets.all(
                                  8.0.sp,
                                ),
                                onPressed: planList[i].catselecttype == '1' &&
                                        planList[i].isSubscribed == '0' &&
                                        isSelected
                                    ? null
                                    : () async {
                                        if (planList[i].isSubscribed == '0') {
                                          CommonUtil().profileValidationCheck(
                                              context,
                                              packageId: planList[i].packageid,
                                              isSubscribed:
                                                  planList[i].isSubscribed,
                                              providerId: planList[i].plinkid,
                                              isFrom: strIsFromSubscibe,
                                              refresh: () {
                                            setState(() {});
                                          });
                                        } /*else {
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
                            ),
                          ),
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

  String getImage(int i, List<PlanListResult> planList){
    String image;
    if(planList[i]!=null){
      if(planList[i].metadata!=null && planList[i].metadata!=''){
        if(planList[i].metadata.icon!=null && planList[i].metadata.icon!=''){
          image = planList[i].metadata.icon;
        }else{
          if(catIcon!=null && catIcon !=''){
            image = catIcon;
          }else{
            if(hosIcon!=null && hosIcon!=''){
              image = hosIcon;
            }else{
              image = '';
            }
          }
        }
      }else{
        if(catIcon!=null && catIcon !=''){
          image = catIcon;
        }else{
          if(hosIcon!=null && hosIcon!=''){
            image = hosIcon;
          }else{
            image = '';
          }
        }
      }
    }else{
      if(catIcon!=null && catIcon !=''){
        image = catIcon;
      }else{
        if(hosIcon!=null && hosIcon!=''){
          image = hosIcon;
        }else{
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
        return Color(new CommonUtil().getMyPrimaryColor());
      } else {
        return Colors.grey;
      }
    }
  }
}
