import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';

class QurhomeAlertList extends StatefulWidget {
  @override
  _QurhomeAlertListState createState() => _QurhomeAlertListState();
}

class _QurhomeAlertListState extends State<QurhomeAlertList> with RouteAware {
  final controller = Get.put(QurhomeDashboardController());
  final qurHomeRegimenController =
      CommonUtil().onInitQurhomeRegimenController();
  MyProfileModel? myProfile;

  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
