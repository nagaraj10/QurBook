import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/user_plans/model/user_plans_response_model.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

class UserPlansService {
  static Future<UserPlansResponseModel> getUserPlanInfo() async {
    final userId = PreferenceUtil.getStringValue(KEY_USERID);
    var url = '$qr_user_plan$userId/$GOLD_MEMBERSHIP';
    var response = await ApiBaseHelper().getUserPlanInfo(url);
    return UserPlansResponseModel.fromJson(response);
  }
}
