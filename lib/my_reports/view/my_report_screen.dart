import 'package:flutter/material.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../widgets/GradientAppBar.dart';
import 'my_report_list.dart';

class ReportListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 0,
        title: Text(strMyReports),
      ),
      body: MyReportList(),
    );
  }
}
