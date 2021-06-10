import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

class LandingViewModel extends ChangeNotifier {
  Color primaryColor = Color(CommonUtil().getMyPrimaryColor());

  void updatePrimaryColor() {
    primaryColor = Color(CommonUtil().getMyPrimaryColor());
    notifyListeners();
  }
}
