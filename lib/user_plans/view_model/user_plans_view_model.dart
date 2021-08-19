import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/user_plans/model/user_plans_response_model.dart';
import 'package:myfhb/user_plans/service/user_plans_services.dart';

class UserPlansViewModel extends ChangeNotifier {
  bool isGoldMember = false;

  Future<void> getUserPlanInfo() async {
    UserPlansResponseModel userPlansData =
        await UserPlansService.getUserPlanInfo();
    if (userPlansData?.isSuccess &&
        ((userPlansData?.result?.length ?? 0) > 0)) {
      await PreferenceUtil.saveString(KEY_MEMBERSHIP, GOLD_MEMBERSHIP);
      isGoldMember = true;
    } else {
      await PreferenceUtil.saveString(KEY_MEMBERSHIP, '');
      isGoldMember = false;
    }
    notifyListeners();
  }

  Future<void> getUserPlanInfoLocal() async {
    var membership = PreferenceUtil.getStringValue(KEY_MEMBERSHIP);
    if ((membership ?? '').isNotEmpty) {
      isGoldMember = true;
      notifyListeners();
    } else {
      await getUserPlanInfo();
    }
  }
}
