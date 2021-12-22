import 'dart:convert';

import 'package:myfhb/landing/model/membership_detail_response.dart';

import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_query.dart' as variable;
import '../model/qur_plan_dashboard_model.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

class LandingService {
  static Future<QurPlanDashboardModel> getQurPlanDashBoard({
    String includeText = variable.qr_all,
  }) async {
    var _helper = ApiBaseHelper();
    final userId = PreferenceUtil.getStringValue(KEY_USERID);
    final url = variable.qr_qur_plan_dashboard +
        variable.qr_include +
        includeText +
        variable.qr_userid_dashboard +
        userId +
        variable.qr_date +
        '${DateTime.now()}';
    var response = await _helper.getQurPlanDashBoard(
      url,
    );
    return QurPlanDashboardModel.fromJson(response ?? '');
  }

  static Future<MemberShipDetailResponse> getMemberShipDetails() async {
    print('call working');

    var _helper = ApiBaseHelper();
    final userId = PreferenceUtil.getStringValue(KEY_USERID);
    final url = variable.qr_qur_plan_dashboard +
        variable.qr_membership +
        userId +
        variable.qr_organizationid;
    print('======working========');

    var response = await _helper.getMemberShipDetails(
      url,
    );
    print('======resp========');
    print(response);
    return MemberShipDetailResponse.fromJson(response ?? '');
  }
}
