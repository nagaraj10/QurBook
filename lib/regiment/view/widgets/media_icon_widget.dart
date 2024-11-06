
import 'package:flutter/material.dart';
import '../../../src/utils/screenutils/size_extensions.dart';

class MediaIconWidget extends StatelessWidget {
  const MediaIconWidget({
    required this.color,
    required this.icon,
    this.onPressed,
    this.padding,
  });

  final Color? color;
  final IconData icon;
  final Function? onPressed;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Padding(
        padding: padding != null
            ? EdgeInsets.all(padding ?? 5.0.sp)
            : EdgeInsets.only(
                top: 5.0.sp,
                left: 5.0.sp,
                bottom: 5.0.sp,
              ),
        child: Icon(
          icon,
          color: color,
          size: 30.0.sp,
        ),
      ),
    );
  }
}
