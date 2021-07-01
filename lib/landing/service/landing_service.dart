import 'dart:convert';

import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_query.dart' as variable;
import '../model/qur_plan_dashboard_model.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

class LandingService {
  static Future<QurPlanDashboardModel> getQurPlanDashBoard() async {
    var _helper = ApiBaseHelper();
    final userId = PreferenceUtil.getStringValue(KEY_USERID);
    final url = variable.qr_qur_plan_dashboard +
        variable.qr_include +
        variable.qr_all +
        variable.qr_userid_dashboard +
        userId +
        variable.qr_date +
        '${DateTime.now()}';
    var response = await _helper.getQurPlanDashBoard(
      url,
    );
    return QurPlanDashboardModel.fromJson(response ?? '');
  }
}
