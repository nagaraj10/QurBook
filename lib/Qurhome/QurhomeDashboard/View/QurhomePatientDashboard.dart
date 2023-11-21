import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurhomePatientRegimenList.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurhomePatientAlert.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/CareGiverPatientList.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
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

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  bool selectedAlertList = true;
  TabController? tabController;
  int selectedTab = 0;
  double sliverBarHeight = 220;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.currentSelectedTab?.value = 0;
    selectedAlertList = true;
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: controller.currentSelectedTab.value);
    tabController?.addListener(_handleSelected);
  }

  void _handleSelected() {
    if (controller.isPatientClicked.value)
      controller.isPatientClicked.value = false;

    this.setState(() {
      selectedTab = tabController?.index ?? 0;
      controller.currentSelectedTab?.value = selectedTab;
      if (selectedTab == 0) {
        selectedAlertList = true;
      } else {
        selectedAlertList = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    tabController?.animateTo(controller.currentSelectedTab?.value ?? 0);
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
      Tab(
          child: SizedBox(
              height: 50, child: getTabWidget(strAlerts, selectedAlertList))),
      Tab(
          child: SizedBox(
              height: 50, child: getTabWidget(strRegimen, !selectedAlertList)))
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
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Color(CommonUtil().getQurhomePrimaryColor()),
                  width: 1.3,
                ))),
                height: 50,
                width: 800,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: TabBar(
                  indicatorColor: Color(CommonUtil().getQurhomePrimaryColor()),
                  labelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 1,
                  indicator: BoxDecoration(
                    color: Color(CommonUtil().getQurhomePrimaryColor()),
                    border: Border.all(
                        color:
                            Color(CommonUtil().getQurhomePrimaryColor())),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                  ),
                  unselectedLabelColor: Colors.black,
                  controller: tabController,
                  enableFeedback: true,
                  isScrollable: false,
                  automaticIndicatorColorAdjustment: true,
                  tabs: getTabs(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    Center(child: QurhomePatientALert()),
                    Center(
                        child: QurHomePatientRegimenListScreen(
                            careGiverPatientListResult:
                                widget.careGiverPatientListResult))
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
        child: Center(
      child: Text(
        value,
        style: TextStyle(
          fontSize: CommonUtil().isTablet! ? tabHeader1 : mobileHeader1,
          fontWeight: FontWeight.bold,
          color: selectedAlertList
              ? Colors.white
              : Color(CommonUtil().getQurhomePrimaryColor()),
        ),
      ),
    ));
  }
}
