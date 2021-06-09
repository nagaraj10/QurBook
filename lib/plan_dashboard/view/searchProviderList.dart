import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/model/SearchListModel.dart';
import 'package:myfhb/plan_dashboard/services/SearchListService.dart';
import 'package:myfhb/plan_dashboard/view/categoryList.dart';
import 'package:myfhb/plan_dashboard/view/planList.dart';
import 'package:myfhb/plan_dashboard/viewModel/planViewModel.dart';
import 'package:myfhb/plan_dashboard/viewModel/subscribeViewModel.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';

class SearchProviderList extends StatefulWidget {
  @override
  _SearchProviderList createState() => _SearchProviderList();
}

class _SearchProviderList extends State<SearchProviderList> {
  PlanViewModel myPlanViewModel = new PlanViewModel();
  SearchListModel searchModel;
  SearchListService searchListService = new SearchListService();

  //bool isListVisible = false;
  bool isLoaderVisible = false;

  Future<SearchListModel> providerList;

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  final GlobalKey _hospitalKey = GlobalKey();
  bool isFirst;
  BuildContext _myContext;

  @override
  void initState() {
    searchFocus.requestFocus();
    super.initState();
    /*Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
      isInitial: true,
    );*/
    providerList = myPlanViewModel.getSearchListInit('');
    isFirst = PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_hospitalList);

    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(
            Duration(milliseconds: 1000),
            () => isFirst
                ? null
                : ShowCaseWidget.of(_myContext).startShowCase([_hospitalKey]));
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
      PreferenceUtil.saveString(
          Constants.KEY_SHOWCASE_hospitalList, variable.strtrue);
    }, builder: Builder(builder: (context) {
      _myContext = context;
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
              'Search Provider',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                SearchWidget(
                  searchController: searchController,
                  searchFocus: searchFocus,
                  onChanged: (title) {
                    if (title != '' && title.length > 2) {
                      onSearchedNew(title);
                    } else {
                      setState(() {
                        searchModel = null;
                      });
                    }
                  },
                  hintText: variable.strSearchByHosLoc,
                ),
                SizedBox(
                  height: 5.0.h,
                ),
                Visibility(
                    visible: isLoaderVisible,
                    child: new Center(
                      child: SizedBox(
                        width: 30.0.h,
                        height: 30.0.h,
                        child: new CircularProgressIndicator(
                            strokeWidth: 1.5,
                            backgroundColor:
                                Color(new CommonUtil().getMyPrimaryColor())),
                      ),
                    )),
                Expanded(
                    child: searchModel != null ?? searchModel.isSuccess
                        ? searchListView(searchModel.result)
                        : getProviderList())
              ],
            ),
          ));
    }));
  }

  Widget getProviderList() {
    return new FutureBuilder<SearchListModel>(
      future: providerList,
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
            return searchListView(snapshot.data.result);
          } else {
            return SizedBox.shrink();
          }
        }
      },
    );
  }

  onSearchedNew(String title) async {
    if (title != null) {
      setState(() {
        isLoaderVisible = true;
      });
      searchListService.getSearchList(title).then((value) {
        if (value.isSuccess) {
          if (value.result != null) {
            setState(() {
              isLoaderVisible = false;
              searchModel = value;
              //isListVisible = true;
            });
          } else {
            setState(() {
              isLoaderVisible = false;
            });
          }
        } else {
          setState(() {
            isLoaderVisible = false;
          });
        }
      });
    }
  }

  /*Widget getSearchList(String title) {
    return new FutureBuilder<SearchListModel>(
      future: myPlanViewModel.getSearchListBasedOnValue(title),
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
            return searchListView(snapshot.data.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: Text(variable.strNodata),
                )),
              ),
            );
          }
        }
      },
    );
  }*/

  Widget searchListView(List<SearchListResult> searchListResult) {
    return (searchListResult != null && searchListResult.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            itemBuilder: (BuildContext ctx, int i) => i != 0
                ? searchListItem(ctx, i, searchListResult)
                : FHBBasicWidget.customShowCase(
                    _hospitalKey,
                    Constants.HospitalDescription,
                    searchListItem(ctx, i, searchListResult),
                    Constants.HospitalSelection),
            itemCount: searchListResult.length,
          )
        : SizedBox.shrink();
  }

  Widget searchListItem(
      BuildContext context, int i, List<SearchListResult> searchList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryList(
                  searchList[i].providerid, searchList[i]?.metadata?.icon)),
        ).then((value) {
          setState(() {});
        });
      },
      child: Container(
          padding: EdgeInsets.all(8.0),
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
                      child: CommonUtil()
                          .customImage(searchList[i]?.metadata?.icon ?? '')),
                  SizedBox(
                    width: 20.0.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          searchList[i].title != null
                              ? toBeginningOfSentenceCase(searchList[i].title)
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
                          searchList[i].description != null
                              ? toBeginningOfSentenceCase(
                                  searchList[i].description)
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
                        searchList[i].title != null &&
                                searchList[i].title != '' &&
                                searchList[i].title == strQurhealth
                            ? Text(
                                strCovidFree,
                                style: TextStyle(
                                  fontSize: 15.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(
                                      new CommonUtil().getMyPrimaryColor()),
                                ),
                                textAlign: TextAlign.start,
                              )
                            : SizedBox.shrink()
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
}
