import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class LoaderClass {
  static showLoadingDialog(
    BuildContext context, {
    bool canDismiss = true,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(canDismiss);
            },
            child: Container(
              child: SimpleDialog(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 70.0.h,
                      height: 70.0.h,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(41, 135, 135, 135),
                            offset: Offset(0, 3),
                            blurRadius: 20,
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0.sp,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(CommonUtil().getMyPrimaryColor())),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  static hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
