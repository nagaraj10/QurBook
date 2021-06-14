import 'dart:convert';

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart' as variable;
import 'package:myfhb/landing/model/qur_plan_dashboard_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class LandingService {
  static Future<QurPlanDashboardModel> getQurPlanDashBoard() async {
    ApiBaseHelper _helper = ApiBaseHelper();
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    var url = variable.qr_qur_plan_dashboard +
        variable.qr_include +
        variable.qr_all +
        variable.qr_userid_dashboard +
        userId +
        variable.qr_date +
        '${DateTime.now()}';
    final response = await _helper.getQurPlanDashBoard(
      url,
    );
    return QurPlanDashboardModel.fromJson(response);
  }
}
