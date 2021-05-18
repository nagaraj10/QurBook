import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
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
import 'package:provider/provider.dart';

class SearchListHome extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchListHome> {
  PlanViewModel myPlanViewModel = new PlanViewModel();
  SearchListModel searchModel;
  SearchListService searchListService = new SearchListService();

  bool isListVisible = false;
  bool isLoaderVisible = false;

  @override
  void initState() {
    super.initState();
    Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
      isInitial: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Visibility(
      visible: Provider.of<RegimentViewModel>(context).regimentsDataAvailable,
      child: Container(
        child: Column(
          children: [
            SearchWidget(
              onChanged: (title) {
                if (title != '' && title.length > 2) {
                  onSearchedNew(title);
                } else {
                  setState(() {
                    isListVisible = false;
                  });
                }
              },
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
            Visibility(
                visible: isListVisible,
                child: Expanded(
                    child: searchModel != null
                        ? searchModel.isSuccess
                            ? searchListView(searchModel.result)
                            : Container()
                        : Container()),
                replacement: Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.only(left: 12, right: 12, top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFe3e2e2),
                          blurRadius: 16,
                          // has the effect of softening the shadow
                          spreadRadius: 5.0,
                          // has the effect of extending the shadow
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    searchTextFirst,
                                    style: TextStyle(
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  SizedBox(height: 30.h),
                                  Text(
                                    searchTextSecond,
                                    style: TextStyle(
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                      ],
                    )))
          ],
        ),
      ),
      replacement: Center(
        child: Padding(
          padding: EdgeInsets.all(
            10.0.sp,
          ),
          child: Text(
            Constants.categoriesForFamily,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
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
              isListVisible = true;
            });
          }else{
            setState(() {
              isLoaderVisible = false;
            });
          }
        }else{
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
            itemBuilder: (BuildContext ctx, int i) =>
                searchListItem(ctx, i, searchListResult),
            itemCount: searchListResult.length,
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

  Widget searchListItem(
      BuildContext context, int i, List<SearchListResult> searchList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryList(searchList[i].providerid)),
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
                    child: ClipOval(
                        child: CircleAvatar(
                      backgroundImage: AssetImage('assets/launcher/myfhb1.png'),
                      radius: 18,
                      backgroundColor: Colors.transparent,
                    )),
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
                              ? toBeginningOfSentenceCase(searchList[i].description)
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
