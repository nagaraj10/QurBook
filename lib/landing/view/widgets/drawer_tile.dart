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
          ListTile(
            onTap: onPressed,
            leading: Container(
              width: 24.0.sp,
              height: 24.0.sp,
              child: iconWidget ??
                  ImageIcon(
                    AssetImage(icon),
                    color: Colors.black54,
                  ),
            ),
            title: Text(
              title ?? '',
              style: TextStyle(
                fontSize: 16.0.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
}
