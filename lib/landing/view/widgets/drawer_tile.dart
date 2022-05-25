import 'package:myfhb/common/CommonUtil.dart';

import '../../../src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    @required this.title,
    @required this.onPressed,
    this.icon,
    this.iconWidget,
  });

  final String title;
  final String icon;
  final Widget iconWidget;
  final Function onPressed;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Divider(
            height: CommonUtil().isTablet ? 3.0.h : 1.0.h,
          ),
          Material(
            color: Colors.transparent,
            child: ListTile(
              onTap: onPressed,
              leading: Container(
                width: CommonUtil().isTablet ? 27.0.sp : 24.0.sp,
                height: CommonUtil().isTablet ? 27.0.sp : 24.0.sp,
                child: iconWidget ??
                    ImageIcon(
                      AssetImage(icon),
                      color: Colors.black54,
                    ),
              ),
              title: Text(
                title ?? '',
                style: TextStyle(
                  fontSize: CommonUtil().isTablet ? 18.0.sp : 16.0.sp,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      );
}
