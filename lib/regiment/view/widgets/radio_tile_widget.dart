import 'package:flutter/material.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../common/CommonUtil.dart';

class RadioTileWidget extends StatelessWidget {
  const RadioTileWidget({
    @required this.title,
    @required this.value,
    @required this.radioGroupValue,
    @required this.onSelected,
  });

  final dynamic value;
  final dynamic radioGroupValue;
  final String title;
  final Function(dynamic selectedValue) onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<dynamic>(
          groupValue: radioGroupValue,
          value: value,
          activeColor: Color(CommonUtil().getMyPrimaryColor()),
          onChanged: onSelected,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 2.0.w,
            right: 10.0.w,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
