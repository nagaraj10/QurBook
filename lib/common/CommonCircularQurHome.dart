import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

import '../main.dart';

class CommonCircularQurHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        mAppThemeProvider.qurHomePrimaryColor,
      ),
      backgroundColor: Colors.white.withOpacity(0.5),
    ),
  );
}
