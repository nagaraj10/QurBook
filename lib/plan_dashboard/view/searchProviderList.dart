import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/SearchListModel.dart';
import 'package:myfhb/plan_dashboard/services/SearchListService.dart';
import 'package:myfhb/plan_dashboard/view/categoryList.dart';
import 'package:myfhb/plan_dashboard/viewModel/planViewModel.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;

class SearchProviderList extends StatefulWidget {
  @override
  _SearchProviderList createState() => _SearchProviderList();

  final List<SearchListResult> searchListResult;

  SearchProviderList(this.searchListResult);
}

class _SearchProviderList extends State<SearchProviderList> {
  PlanViewModel myPlanViewModel = new PlanViewModel();
  SearchListModel searchModel;
  SearchListService searchListService = new SearchListService();

  //bool isListVisible = false;
  bool isLoaderVisible = false;

  Future<SearchListModel> providerList;

  List<SearchListResult> searchFilterProviderList = List();
  List<SearchListResult> searchProviderList = [];

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  final GlobalKey _hospitalKey = GlobalKey();
  bool isFirst;
  BuildContext _myContext;
  bool isSearch = false;

  List<SearchListResult> providerSelectedList = new List();
  CommonWidgets commonWidgets = new CommonWidgets();

  @override
  void initState() {
    //searchFocus.requestFocus();
    super.initState();
    /*Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
      isInitial: true,
    );*/

    providerSelectedList = widget.searchListResult;

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
              searchHospitals,
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
                      isSearch = true;
                      onSearchedNew(title, searchProviderList);
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
  }

  onSearchedNew(String title, List<SearchListResult> searchList) async {
    searchFilterProviderList.clear();
    if (title != null) {
      searchFilterProviderList =
          await myPlanViewModel.getFilterForProvider(title, searchList);
    }
    setState(() {});
  }

  /*onSearchedNew(String title) async {
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
  }*/

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
    searchProviderList = [];
    if (searchListResult != null && searchListResult.length > 0) {
      searchProviderList = searchListResult;
      return (searchProviderList != null && searchProviderList.length > 0)
          ? ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                bottom: 8.0.h,
              ),
              itemBuilder: (BuildContext ctx, int i) => i != 0
                  ? searchListItem(ctx, i,
                      isSearch ? searchFilterProviderList : searchProviderList)
                  : FHBBasicWidget.customShowCase(
                      _hospitalKey,
                      Constants.HospitalDescription,
                      searchListItem(
                          ctx,
                          i,
                          isSearch
                              ? searchFilterProviderList
                              : searchProviderList),
                      Constants.HospitalSelection),
              itemCount: isSearch
                  ? searchFilterProviderList.length
                  : searchProviderList.length,
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
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.start,
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  ),
                  getSelectedIcon(providerSelectedList, searchList[i]),
                  SizedBox(width: 5.w),
                ],
              ),
              SizedBox(height: 5.h),
            ],
          )),
    );
  }

  Widget getSelectedIcon(List<SearchListResult> providerSelectedList,
      SearchListResult searchList) {
    Widget icon = SizedBox.shrink();

    if (providerSelectedList != null && searchList != null) {
      providerSelectedList.forEach((element) {
        if (element.linkid == searchList.linkid) {
          icon = commonWidgets.getIcon(width: 18.w, icon: Icons.check_circle);
        }
      });
    } else {
      icon = SizedBox.shrink();
    }

    return icon;
  }
}
