import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool selectedAlertList = true;
  TabController? tabController;
  int selectedTab = 0;
  double sliverBarHeight = 220;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: controller.currentSelectedTab.value);
    tabController?.addListener(_handleSelected);
  }

  void _handleSelected() {
    if (controller.isPatientClicked.value) {
      tabController?.index = controller.currentSelectedTab.value;
      controller.isPatientClicked.value = false;
    }
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
      Tab(child: getTabWidget(strAlerts, selectedAlertList)),
      Tab(child: getTabWidget(strRegimen, !selectedAlertList))
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
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2,
                unselectedLabelColor: Colors.black,
                controller: tabController,
                enableFeedback: true,
                isScrollable: false,
                automaticIndicatorColorAdjustment: true,
                tabs: getTabs(),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    Center(child: QurhomePatientALert()),
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
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: selectedAlertList
                  ? Color(CommonUtil().getQurhomePrimaryColor())
                  : Colors.black,
            ),
          ),
        ));
  }
}
