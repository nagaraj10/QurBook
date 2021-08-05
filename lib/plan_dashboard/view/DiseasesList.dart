import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import '../../common/CommonUtil.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/variable_constant.dart' as variable;
import '../model/PlanListModel.dart';
import 'categoryList.dart';
import 'searchProviderList.dart';
import '../viewModel/planViewModel.dart';
import '../viewModel/subscribeViewModel.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

class DiseasesList extends StatefulWidget {
  @override
  _DiseasesList createState() => _DiseasesList();
}

class _DiseasesList extends State<DiseasesList> {
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

  Future<PlanListModel> planListModel;

  List<PlanListResult> providerList = [];

  @override
  void initState() {
    FocusManager.instance.primaryFocus.unfocus();
    super.initState();

    planListModel = myPlanViewModel.getPlanList('');
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            height: 5.0.h,
          ),
          Expanded(
            child: getDiseasesList(''),
          ),
        ],
      ),
    ));
  }

  onSearchedNew(String title, List<PlanListResult> planListOld) async {
    myPLanListResult.clear();
    if (title != null) {
      myPLanListResult = myPlanViewModel.getSearchDiseases(title, planListOld);
    }
    setState(() {});
  }

  Widget diseasesList(List<PlanListResult> planList) {
    categoryListUniq = [];
    selectTitle = {};
    selectedTitle = {};
    providerList = [];

    if (planList != null && planList.isNotEmpty) {
      planList.forEach((element) {
        if (element?.metadata != null && element?.metadata != '') {
          if (element?.metadata?.diseases != null &&
              element?.metadata?.diseases != '') {
            var keysUniq = true;
            categoryListUniq.forEach((catElement) {
              if (catElement?.metadata?.diseases ==
                  element?.metadata?.diseases) {
                keysUniq = false;
              }
            });
            if (keysUniq) {
              categoryListUniq.add(element);
            }
          }
        }
      });
    }
    return (categoryListUniq != null && categoryListUniq.isNotEmpty)
        ? Column(
            children: [
              SizedBox(
                height: 8.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                width: 1.sw,
                //margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                color: Color(CommonUtil().getMyPrimaryColor()),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    strAllPlans,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    bottom: 8.0.h,
                  ),
                  itemBuilder: (ctx, i) => diseasesListItem(ctx, i,
                      isSearch ? myPLanListResult : categoryListUniq, planList),
                  itemCount: isSearch
                      ? myPLanListResult.length
                      : categoryListUniq.length,
                ),
              ),
            ],
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
    /*return (categoryListUniq != null && categoryListUniq.length > 0)
        ? Flexible(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            margin:
                                EdgeInsets.only(left: 16, right: 16, top: 8),
                            color: Colors.blueAccent,
                            child: Text(
                              'Top 5 Plans',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: 8.0.h,
                      ),
                      itemBuilder: (BuildContext ctx, int i) =>
                          diseasesListItem(
                              ctx,
                              i,
                              categoryListUniq.length >= 4
                                  ? categoryListUniq.take(4).toList()
                                  : categoryListUniq,
                              planList),
                      itemCount: categoryListUniq.length,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            margin:
                                EdgeInsets.only(left: 16, right: 16, top: 8),
                            color: Colors.deepPurple,
                            child: Text(
                              'All Plans',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: 8.0.h,
                      ),
                      itemBuilder: (BuildContext ctx, int i) =>
                          diseasesListItem(
                              ctx,
                              i,
                              isSearch ? myPLanListResult : categoryListUniq,
                              planList),
                      itemCount: isSearch
                          ? myPLanListResult.length
                          : categoryListUniq.length,
                    ),
                  ],
                ),
              ),
            ),
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  child: Center(
                child: Text(variable.strNodata),
              )),
            ),
          );*/
  }

  Widget getDiseasesList(String providerId) {
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
            return diseasesList(snapshot.data.result);
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

  Widget diseasesListItem(BuildContext context, int i,
      List<PlanListResult> planList, List<PlanListResult> planListFull) {
    return InkWell(
      onTap: () {
        try {
          if (planListFull != null && planList.isNotEmpty) {
            planListFull.where((element1) {
              return (element1?.metadata?.diseases ?? '') ==
                  planList[i]?.metadata?.diseases;
            }).forEach((element) {
              var keysUniq = true;
              providerList.forEach((catElement) {
                if (catElement?.plinkid == element.plinkid) {
                  keysUniq = false;
                }
              });
              if (keysUniq) {
                providerList.add(element);
              }
            });
          }
        } catch (e) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchProviderList(
                    planList[i]?.metadata?.diseases ?? '', planListFull)),
          ).then((value) => {
                setState(() {
                  planListModel = myPlanViewModel.getPlanList('');
                })
              });
        }

        if (providerList != null) {
          if (providerList?.length == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryList(
                      planList[i].providerid,
                      planList[i]?.metadata?.icon,
                      planList[i]?.metadata?.diseases)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchProviderList(
                      planList[i]?.metadata?.diseases ?? '', planListFull)),
            ).then((value) => {
                  setState(() {
                    planListModel = myPlanViewModel.getPlanList('');
                  })
                });
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchProviderList(
                    planList[i]?.metadata?.diseases ?? '', planListFull)),
          ).then((value) => {
                setState(() {
                  planListModel = myPlanViewModel.getPlanList('');
                })
              });
        }
      },
      child: Container(
        padding: EdgeInsets.all(6),
        //margin: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 20,
                    child: CommonUtil().customImage(
                        (planList[i]?.metadata?.diseaseIcon ?? '').isNotEmpty
                            ? planList[i]?.metadata?.diseaseIcon
                            : '')),
                SizedBox(
                  width: 10.0.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        planList[i].metadata?.diseases != null
                            ? toBeginningOfSentenceCase(
                                planList[i]?.metadata?.diseases)
                            : '',
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          fontWeight: FontWeight.w500,
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
            SizedBox(
              height: 8.h,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
