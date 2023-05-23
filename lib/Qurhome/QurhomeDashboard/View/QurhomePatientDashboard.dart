import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurhomeAlertList.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/CareGiverPatientList.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';

class QurhomePatientDashboard extends StatefulWidget {
  CareGiverPatientListResult? careGiverPatientListResult;

  QurhomePatientDashboard({this.careGiverPatientListResult});
  @override
  _QurhomePatientDashboardState createState() =>
      _QurhomePatientDashboardState();
}

class _QurhomePatientDashboardState extends State<QurhomePatientDashboard>
    with RouteAware, SingleTickerProviderStateMixin {
  final controller = Get.put(QurhomeDashboardController());
  final qurHomeRegimenController =
      CommonUtil().onInitQurhomeRegimenController();
  MyProfileModel? myProfile;

  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool selectedAlertList = true;
  TabController? tabController;
  int selectedTab = 0;
  double sliverBarHeight = 220;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    tabController?.addListener(_handleSelected);
  }

  void _handleSelected() {
    this.setState(() {
      selectedTab = tabController?.index ?? 0;
      if (selectedTab == 0) {
        selectedAlertList = true;
      } else {
        selectedAlertList = false;
      }
      if (selectedTab != 0) {
        sliverBarHeight = 50;
      } else {
        sliverBarHeight = 220;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.loadingData.isTrue
          ? Center(
              child: CircularProgressIndicator(),
            )
          : renderWidget(),
    );
  }

  getTabs() {
    List<Tab> myTabs = <Tab>[
      Tab(child: getTabWidget("Alerts", selectedAlertList)),
      Tab(child: getTabWidget("Regimen", !selectedAlertList))
    ];

    return myTabs;
  }

  renderWidget() {
    return Center(
      child: DefaultTabController(
        length: 2,
        child: Container(
          child: Column(
            children: [
              TabBar(
                indicatorColor: Color(CommonUtil().getQurhomePrimaryColor()),
                controller: tabController,
                physics: BouncingScrollPhysics(),
                indicator: BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0)),
                    color: Color(CommonUtil().getQurhomePrimaryColor())),
                enableFeedback: true,
                isScrollable: false,
                automaticIndicatorColorAdjustment: true,
                tabs: getTabs(),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Center(child: Text("PatientQurhomeAlert")),
                    Center(child: Text("Regimen"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getTabWidget(String value, bool selectedAlertList) {
    return Container(
        width: double.infinity,
        decoration: new BoxDecoration(
            color: selectedAlertList
                ? Color(CommonUtil().getQurhomePrimaryColor())
                : Colors.transparent,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: selectedAlertList
                  ? Colors.white
                  : Color(CommonUtil().getQurhomePrimaryColor()),
            ),
          ),
        ));
  }
}
