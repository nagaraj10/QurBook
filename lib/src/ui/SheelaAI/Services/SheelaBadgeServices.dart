
import 'package:myfhb/chat_socket/model/SheelaBadgeModel.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class SheelaBadgeServices {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SheelaBadgeModel> getSheelaBadgeCount() async {
    String userId = PreferenceUtil.getStringValue(KEY_USERID);
    final response =
    await _helper.getSheelaBadgeCount(qr_sheela_badge_icon_count+userId);
    return SheelaBadgeModel.fromJson(response);
  }

}
