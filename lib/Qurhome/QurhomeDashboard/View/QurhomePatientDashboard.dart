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
    with RouteAware {
  final controller = Get.put(QurhomeDashboardController());
  final qurHomeRegimenController =
      CommonUtil().onInitQurhomeRegimenController();
  MyProfileModel? myProfile;

  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool selectedAlertList = true;

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

  renderWidget() {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    selectedAlertList = true;
                    setState(() {});
                  },
                  child: Container(
                    decoration: new BoxDecoration(
                        color: selectedAlertList
                            ? Color(CommonUtil().getQurhomePrimaryColor())
                            : Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0))),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Alerts',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedAlertList
                                    ? Colors.white
                                    : Color(
                                        CommonUtil().getQurhomePrimaryColor(),
                                      ),
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    selectedAlertList = false;
                    setState(() {});
                  },
                  child: Container(
                    decoration: new BoxDecoration(
                        color: !selectedAlertList
                            ? Color(CommonUtil().getQurhomePrimaryColor())
                            : Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0))),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Regimen',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !selectedAlertList
                                    ? Colors.white
                                    : Color(
                                        CommonUtil().getQurhomePrimaryColor()),
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: selectedAlertList
                ? QurhomeAlertList()
                : Container(
                    child: Center(
                        child: Text(selectedAlertList ? "Alerts" : "Regimen")),
                  ))
      ],
    );
  }
}
