// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import '../../common/CommonUtil.dart';
import '../../constants/variable_constant.dart' as variable;
import '../utils/screenutils/size_extensions.dart';

class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  variable.icon_no_internet,
                  height: 150.0.h,
                  width: 150.0.h,
                ),
                SizedBox(
                  height: 5.0.h,
                ),
                Text(
                  variable.strNoInternet,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mAppThemeProvider.primaryColor,
                    fontSize: 20.0.sp,
                  ),
                ),
                SizedBox(
                  height: 5.0.h,
                ),
                Text(
                  variable.strCheckConnection,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18.0.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
