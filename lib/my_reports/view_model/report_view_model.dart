import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_reports/model/report_model.dart';
import 'package:myfhb/my_reports/services/report_service.dart';

class MyReportViewModel extends ChangeNotifier {
  ReportService reportService = ReportService();

  Future<ReportModel?> getReportList() async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    if (userid != null) {
      try {
        var myPlanListModel = await reportService.getReportList(userid);
        return myPlanListModel;
      } catch (e,stackTrace) {
        CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      }
    }
  }
}
