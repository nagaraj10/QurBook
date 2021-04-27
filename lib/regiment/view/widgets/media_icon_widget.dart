import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class MediaIconWidget extends StatelessWidget {
  MediaIconWidget({
    @required this.color,
    @required this.icon,
    this.onPressed,
    this.padding,
  });

  final Color color;
  final IconData icon;
  final Function onPressed;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.all(padding ?? 5.0.sp),
        child: Icon(
          icon,
          color: color,
          size: 30.0.sp,
        ),
      ),
    );
  }
}
