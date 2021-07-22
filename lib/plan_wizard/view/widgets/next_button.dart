import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class NextButton extends StatelessWidget {
  final Function() onPressed;
  const NextButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Color(new CommonUtil().getMyPrimaryColor()),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0.sp)),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Next',
              style: TextStyle(color: Colors.white, fontSize: 16.0.sp)),
          SizedBox(width: 2.w),
          Icon(
            Icons.navigate_next,
            color: Colors.white,
            size: 26.0.sp,
          ),
        ],
      ),
    );
  }
}
