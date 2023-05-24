import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurhomeDashboard.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';

class QurhomePatientALert extends StatefulWidget {
  @override
  _QurhomePatientALertState createState() => _QurhomePatientALertState();
}

class _QurhomePatientALertState extends State<QurhomePatientALert> {
  final controller = Get.put(QurhomeDashboardController());
  final qurhomeRegimenController = Get.put(QurhomeRegimenController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      child: Text(controller.careGiverPatientListResult?.firstName ?? ''),
    );
  }
}
