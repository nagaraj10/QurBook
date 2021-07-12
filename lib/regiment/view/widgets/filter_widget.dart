import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    this.title,
    this.value,
    this.onChanged,
  });

  final String title;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Color(CommonUtil().getMyPrimaryColor()),
            ),
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: value,
              activeColor: Color(CommonUtil().getMyPrimaryColor()),
              onChanged: onChanged,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Color(CommonUtil().getMyPrimaryColor()),
            ),
          ),
        ],
      );
}
