import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/view/planList.dart';
import 'package:myfhb/plan_dashboard/viewModel/planViewModel.dart';
import 'package:myfhb/plan_dashboard/viewModel/subscribeViewModel.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<CategoryList> {
  PlanListModel myPlanListModel;
  PlanViewModel myPlanViewModel = new PlanViewModel();
  bool isSearch = false;
  List<PlanListResult> myPLanListResult = List();
  SubscribeViewModel subscribeViewModel = new SubscribeViewModel();
  FlutterToast toast = new FlutterToast();

  List<PlanListResult> categoryListUniq = [];

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
                  isSearch = true;
                  onSearchedNew(title,categoryListUniq);
                } else {
                  setState(() {
                    isSearch = false;
                  });
                }
              },
            ),
            Expanded(
              child: myPlanListModel != null ?? myPlanListModel.isSuccess
                  ? categoryList(myPlanListModel.result)
                  : getCategoryList(),
            ),
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

  onSearchedNew(String title,List<PlanListResult> planListOld) async {
    myPLanListResult.clear();
    if (title != null) {
      myPLanListResult = await myPlanViewModel.getSearch(title,planListOld);
    }
    setState(() {});
  }

  Widget categoryList(List<PlanListResult> planList) {
    categoryListUniq = [];
    if (planList != null && planList.length > 0) {
      planList.forEach((element) {
        bool keysUniq = true;
        categoryListUniq.forEach((catElement) {
          if (catElement.packcatid == element.packcatid) {
            keysUniq = false;
          }
        });
        if (keysUniq) {
          categoryListUniq.add(element);
        }
      });
    }
    return (categoryListUniq != null && categoryListUniq.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
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
                child: Text(variable.strNoCategories),
              )),
            ),
          );
  }

  Widget getCategoryList() {
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
            return categoryList(snapshot.data.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: Text(variable.strNoCategories),
                )),
              ),
            );
          }
        }
      },
    );
  }

  Widget categoryListItem(BuildContext context, int i,
      List<PlanListResult> planList, List<PlanListResult> planListFull) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PlanList(planList[i].packcatid, planListFull)),
        ).then((value) {
          setState(() {});
        });
      },
      child: Container(
          padding: EdgeInsets.all(12.0),
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
