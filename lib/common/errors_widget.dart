import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/common/CommonUtil.dart';

class ErrorsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            variable.icon_something_wrong,
            height: 250.0.h,
            width: 250.0.h,
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Text(
            NOT_FILE_IMAGE,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0.sp,
              color: Color(CommonUtil().getMyPrimaryColor()),
            ),
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Text(
            TRY_AGAIN,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0.sp,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
