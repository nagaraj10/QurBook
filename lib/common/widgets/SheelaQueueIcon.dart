import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import '../../constants/variable_constant.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class SheelaQueueIcon extends StatelessWidget {
  SheelaQueueIcon({
    Key? key,
    required double this.size,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return AssetImageWidget(
      icon: icon_sheela_queue,
      height: size.h,
      width: size.w,
    );
  }
}
