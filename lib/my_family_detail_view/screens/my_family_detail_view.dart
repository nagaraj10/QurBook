import 'package:flutter/material.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../bloc/my_family_detail_view_boc.dart';
import '../models/my_family_detail_view_arguments.dart';
import 'my_family_detail_view_hospital.dart';
import 'my_family_detail_view_insurance.dart';
import '../../src/model/Category/CategoryData.dart';
import '../../src/model/Category/catergory_data_list.dart';
import '../../src/model/Health/CompleteData.dart';
import '../../src/model/Category/CategoryResponseList.dart';
import '../../src/model/Category/catergory_result.dart';
import '../../src/model/Health/UserHealthResponseList.dart';
import '../../src/model/Health/asgard/health_record_list.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';

import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/model/Health/CompleteData.dart';
import '../../constants/router_variable.dart' as router;
import '../../constants/fhb_query.dart' as query;
import '../../common/errors_widget.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

class MyFamilyDetailView extends StatefulWidget {
  MyFamilyDetailViewArguments arguments;

  MyFamilyDetailView({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return MyFamilyDetailViewState();
  }
}

class MyFamilyDetailViewState extends State<MyFamilyDetailView>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int activeTabIndex = 0;
  MyFamilyDetailViewBloc myFamilyDetailViewBloc;
  List<CategoryResult> categoryData;
  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    activeTabIndex = widget.arguments.index;

    tabController.addListener(_setActiveTabIndex);
    tabController.animateTo(activeTabIndex);

    myFamilyDetailViewBloc = MyFamilyDetailViewBloc();
    //getCategories();

    myFamilyDetailViewBloc.userId = widget.arguments.sharedbyme.child.id;

    PreferenceUtil.saveString(
        Constants.KEY_FAMILYMEMBERID, myFamilyDetailViewBloc.userId);
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Family List Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  void _setActiveTabIndex() {
    activeTabIndex = tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold_state,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          CommonConstants.my_family_title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 18.0.sp,
          ),
        ),
        bottom: TabBar(
          tabs: [
            Tab(
              text: CommonConstants.insurance,
            ),
            Tab(
              text: CommonConstants.hospitals,
            ),
          ],
          controller: tabController,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Color(CommonUtil().getMyPrimaryColor()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FHBUtils().check().then((intenet) {
              if (intenet != null && intenet) {
                if (activeTabIndex == 0) {
                  PreferenceUtil.saveString(Constants.KEY_IDDOCSCATEGORYTYPE,
                      CommonConstants.CAT_JSON_INSURANCE);
                } else {
                  PreferenceUtil.saveString(Constants.KEY_IDDOCSCATEGORYTYPE,
                      CommonConstants.CAT_JSON_HOSPITAL);
                }

                for (final e in categoryData) {
                  if (e.categoryDescription ==
                      CommonConstants.categoryDescriptionIDDocs) {
                    PreferenceUtil.saveString(Constants.KEY_DEVICENAME, '')
                        .then((onValue) {
                      PreferenceUtil.saveString(
                              Constants.KEY_CATEGORYNAME, e.categoryName)
                          .then((onValue) {
                        PreferenceUtil.saveString(
                                Constants.KEY_CATEGORYID, e.id)
                            .then((value) {
                          PreferenceUtil.saveString(
                                  Constants.KEY_FAMILYMEMBERID,
                                  widget.arguments.sharedbyme.child.id)
                              .then((value) {
                            Navigator.pushNamed(context, router.rt_TakePicture)
                                .then((value) {
                              myFamilyDetailViewBloc.getHelthReportLists(
                                  myFamilyDetailViewBloc.userId);
                            });
                          });
                        });
                      });
                    });
                  }
                }
              } else {
                FHBBasicWidget().showInSnackBar(
                    Constants.STR_NO_CONNECTIVITY, scaffold_state);
              }
            });
          },
          child: Icon(
            Icons.add,
            size: 24.0.sp,
          )),
      body: getResponseFromApiWidget(),
    );
  }

  Widget getValuesFromSharedPrefernce() {
    return FutureBuilder<List<CategoryResult>>(
      future: getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CommonCircularIndicator(),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          return getHealthReportToDisplayInBody();
        }
      },
    );
  }

  Widget getHealthReportToDisplayInBody() {
    myFamilyDetailViewBloc = MyFamilyDetailViewBloc();
    myFamilyDetailViewBloc.userId = widget.arguments.sharedbyme.child.id;
    //getCategories();
    myFamilyDetailViewBloc.getHelthReportLists(myFamilyDetailViewBloc.userId);

    return StreamBuilder<ApiResponse<HealthRecordList>>(
      stream: myFamilyDetailViewBloc.healthReportStreams,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: CommonCircularIndicator(),
                )),
              );
              break;

            case Status.ERROR:
              return Center(
                  child: Text(Constants.STR_ERROR_LOADING_DATA,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0.sp,
                      )));
              break;

            case Status.COMPLETED:
              myFamilyDetailViewBloc = null;

              return displayTabBarViewInFamilyDetail(snapshot.data.data);
              break;
          }
        } else {
          return Container(
            height: 0.0.h,
            color: Colors.white,
          );
        }
      },
    );
  }

  Widget displayTabBarViewInFamilyDetail(HealthRecordList completeData) {
    return TabBarView(
      controller: tabController,
      children: [
        Container(
            color: ColorUtils.greycolor,
            child: MyFamilyDetailViewInsurance(completeData: completeData)),
        Container(
            color: ColorUtils.greycolor,
            child: MyFamilyDetailViewHospital(completeData: completeData)),
      ],
    );
  }

  Future<List<CategoryResult>> getCategories() async {
    final categoryDatalist = await myFamilyDetailViewBloc.getCategoryLists();
    categoryData = categoryDatalist.result;
    return categoryData;
  }

  Widget getResponseFromApiWidget() {
    myFamilyDetailViewBloc = MyFamilyDetailViewBloc();

    myFamilyDetailViewBloc.getCategoryLists();

    return StreamBuilder<ApiResponse<CategoryDataList>>(
      stream: myFamilyDetailViewBloc.categoryListStreams,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(
                  child: SizedBox(
                child: CommonCircularIndicator(),
                width: 30.0.h,
                height: 30.0.h,
              ));
              break;

            case Status.ERROR:
              return FHBBasicWidget.getRefreshContainerButton(
                  snapshot.data.message, () {
                setState(() {});
              });
              break;

            case Status.COMPLETED:
              if (snapshot.data.data.result != null &&
                  snapshot.data.data.result.isNotEmpty) {
                categoryData = snapshot.data.data.result;
                return getHealthReportToDisplayInBody();
              } else {
                return Container(
                  width: 100.0.h,
                  height: 100.0.h,
                  child: Text(''),
                );
              }

              break;
          }
        } else {
          return Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }
      },
    );
  }
}
