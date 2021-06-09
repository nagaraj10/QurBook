import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
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
          InkWell(
            onTap: onPressed,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0.w,
                vertical: 5.0.h,
              ),
              child: Row(
                children: [
                  Container(
                    width: 24.0.sp,
                    height: 24.0.sp,
                    child: iconWidget ??
                        ImageIcon(
                          AssetImage(icon),
                          color: Colors.black54,
                        ),
                  ),
                  SizedBox(
                    width: 20.0.w,
                  ),
                  Text(
                    title ?? '',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
        ],
      );
}
