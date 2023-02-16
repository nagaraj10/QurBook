
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class NetworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    mInitialTime = DateTime.now();
    return WillPopScope(
      onWillPop: () {
        fbaLog(eveName: 'qurbook_screen_event', eveParams: {
          'eventTime': '${DateTime.now()}',
          'pageName': 'Network Screen',
          'screenSessionTime':
              '${DateTime.now().difference(mInitialTime).inSeconds} secs'
        });
        Future.value(false);
      } as Future<bool> Function()?,
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
                  color: Color(CommonUtil().getMyPrimaryColor()),
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
}
