import 'dart:convert';

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class PlanWizardServices {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<dynamic> getHealthConditions() async {
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_getUserPack + qr_patientEqaul + userId;
    var jsonString = jsonEncode(body);
    final response =
        await _helper.getHealthConditions(qr_plan_list, jsonString);
    print(response);
    // return MyPlanListModel.fromJson(response);
  }
}
