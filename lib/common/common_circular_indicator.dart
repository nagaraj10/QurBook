import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

class CommonCircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Color(
          CommonUtil().getMyPrimaryColor(),
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.8),
    ),
  );
}
