import 'package:flutter/material.dart';
import '../../common/CommonUtil.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../main.dart';
import '../../widgets/GradientAppBar.dart';
import 'my_report_list.dart';

class ReportListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FABService.trackCurrentScreen(FBAMyReportsScreen);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: mAppThemeProvider.primaryColor,
        elevation: 0,
        title: Text(strMyReports,
            style: TextStyle(
                fontSize:
                    CommonUtil().isTablet! ? tabFontTitle : mobileFontTitle)),
      ),
      body: MyReportList(),
    );
  }
}
