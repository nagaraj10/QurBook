import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

import '../main.dart';

class CommonCircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        mAppThemeProvider.getCommonPrimaryColorQurHomeBook(),
      ),
      backgroundColor: Colors.white.withOpacity(0.8),
    ),
  );
}
