import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family_detail_view/bloc/my_family_detail_view_boc.dart';
import 'package:myfhb/my_family_detail_view/models/my_family_detail_view_arguments.dart';
import 'package:myfhb/my_family_detail_view/screens/my_family_detail_view_hospital.dart';
import 'package:myfhb/my_family_detail_view/screens/my_family_detail_view_insurance.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/common/CommonUtil.dart';

class MyFamilyDetailView extends StatefulWidget {
  MyFamilyDetailViewArguments arguments;

  MyFamilyDetailView({this.arguments});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyFamilyDetailViewState();
  }
}

class MyFamilyDetailViewState extends State<MyFamilyDetailView>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int activeTabIndex = 0;
  MyFamilyDetailViewBloc myFamilyDetailViewBloc;
  List<CategoryData> categoryData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = new TabController(length: 2, vsync: this);
    activeTabIndex = widget.arguments.index;

    tabController.addListener(_setActiveTabIndex);
    tabController.animateTo(activeTabIndex);

    myFamilyDetailViewBloc = new MyFamilyDetailViewBloc();
    myFamilyDetailViewBloc.getCategoryList().then((value) {
      categoryData = value.response.data;
      PreferenceUtil.saveCategoryList(Constants.KEY_CATEGORYLIST, categoryData);
    });

    myFamilyDetailViewBloc.userId = widget.arguments.sharedbyme.profileData.id;

    PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID,
        widget.arguments.sharedbyme.profileData.id);
  }

  void _setActiveTabIndex() {
    activeTabIndex = tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
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
            fontSize: 18,
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
          indicatorColor: Color(new CommonUtil().getMyPrimaryColor()),
          indicatorWeight: 2,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            if (activeTabIndex == 0) {
              PreferenceUtil.saveString(Constants.KEY_IDDOCSCATEGORYTYPE,
                  CommonConstants.CAT_JSON_INSURANCE);
            } else {
              PreferenceUtil.saveString(Constants.KEY_IDDOCSCATEGORYTYPE,
                  CommonConstants.CAT_JSON_HOSPITAL);
            }

            for (var e in categoryData) {
              if (e.categoryDescription ==
                  CommonConstants.categoryDescriptionIDDocs) {
                PreferenceUtil.saveString(Constants.KEY_DEVICENAME, null)
                    .then((onValue) {
                  PreferenceUtil.saveString(
                          Constants.KEY_CATEGORYNAME, e.categoryName)
                      .then((onValue) {
                    PreferenceUtil.saveString(Constants.KEY_CATEGORYID, e.id)
                        .then((value) {
                      PageNavigator.goTo(context, '/take_picture_screen');
                    });
                  });
                });
              }
            }
          }),
      body: getHealthReportToDisplayInBody(),
    );
  }

  Widget getHealthReportToDisplayInBody() {
    myFamilyDetailViewBloc = new MyFamilyDetailViewBloc();
    myFamilyDetailViewBloc.userId = widget.arguments.sharedbyme.profileData.id;

    myFamilyDetailViewBloc.getHelthReportList();

    return StreamBuilder<ApiResponse<UserHealthResponseList>>(
      stream: myFamilyDetailViewBloc.healthReportStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<UserHealthResponseList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 30,
                  height: 30,
                )),
              );
              break;

            case Status.ERROR:
              return Center(
                  child: Text('Oops, something went wrong',
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              myFamilyDetailViewBloc = null;

              return displayTabBarViewInFamilyDetail(
                  snapshot.data.data.response.data);
              break;
          }
        } else {
          return Container(height: 0, color: Colors.white);
        }
      },
    );
  }

  Widget displayTabBarViewInFamilyDetail(CompleteData completeData) {
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
}
