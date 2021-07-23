import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_parameters.dart';
import '../../constants/variable_constant.dart' as variable;
import '../model/PlanListModel.dart';
import '../model/SearchListModel.dart';
import '../services/SearchListService.dart';
import 'categoryList.dart';
import 'planList.dart';
import 'searchProviderList.dart';
import '../viewModel/planViewModel.dart';
import '../viewModel/subscribeViewModel.dart';
import '../../regiment/view_model/regiment_view_model.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

class SearchListHome extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchListHome> {
  PlanViewModel myPlanViewModel = PlanViewModel();
  SearchListModel searchModel;
  SearchListService searchListService = SearchListService();

  //bool isListVisible = false;
  bool isLoaderVisible = false;

  Future<SearchListModel> providerList;

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  final GlobalKey _hospitalKey = GlobalKey();
  bool isFirst;
  BuildContext _myContext;

  List<SearchListResult> providerListSelected = [];

  @override
  void initState() {
    FocusManager.instance.primaryFocus.unfocus();
    super.initState();
    // Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
    //   isInitial: true,
    // );
    providerList = myPlanViewModel.getUserSearchListInit();
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
          body: Container(
            child: Column(
              children: [
                /* SearchWidget(
              searchController: searchController,
              searchFocus: searchFocus,
              onChanged: (title) {
                if (title != '' && title.length > 2) {
                  onSearchedNew(title);
                } else {
                  onSearchedNew(title);
                }
              },
              hintText: variable.strSearchByHosLoc,
            ),*/
                SizedBox(
                  height: 5.0.h,
                ),
                Visibility(
                    visible: isLoaderVisible,
                    child: Center(
                      child: SizedBox(
                        width: 30.0.h,
                        height: 30.0.h,
                        child: CommonCircularIndicator(),
                      ),
                    )),
                Expanded(
                    child: searchModel != null ?? searchModel.isSuccess
                        ? searchListView(searchModel.result)
                        : getProviderList())
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'searchOpt',
            onPressed: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchProviderList(
                        providerListSelected != null
                            ? providerListSelected
                            : [])),
              );*/
            },
            child: Icon(
              Icons.add,
              color: Color(CommonUtil().getMyPrimaryColor()),
              size: 24.0.sp,
            ),
          ));
    }));
  }

  Widget getProviderList() {
    return FutureBuilder<SearchListModel>(
      future: providerList,
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
            providerListSelected = snapshot?.data?.result;
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

  onSearchedNew(String title) async {
    if (title != null) {
      setState(() {
        isLoaderVisible = true;
      });
      await searchListService.getSearchList(title).then((value) {
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
    return (searchListResult != null && searchListResult.isNotEmpty)
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            itemBuilder: (ctx, i) => i != 0
                ? searchListItem(ctx, i, searchListResult)
                : FHBBasicWidget.customShowCase(
                    _hospitalKey,
                    Constants.HospitalDescription,
                    searchListItem(ctx, i, searchListResult),
                    Constants.HospitalSelection),
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
              builder: (context) => CategoryList(
                  searchList[i].providerid, searchList[i]?.metadata?.icon, '')),
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
                        if (searchList[i].title != null &&
                            searchList[i].title != '' &&
                            searchList[i].title == strQurhealth)
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
                ],
              ),
              SizedBox(height: 5.h),
            ],
          )),
    );
  }
}
