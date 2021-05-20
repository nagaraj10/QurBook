import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myfhb/constants/fhb_query.dart' as variable;
import 'package:flutter_svg/flutter_svg.dart';

class CustomImageNetwork extends StatelessWidget {
  const CustomImageNetwork({
    this.imageUrl,
    this.defaultWidget,
  });

  final String imageUrl;
  final Widget defaultWidget;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        return (imageUrl.toLowerCase()?.contains('.svg') ?? false)
            ? SvgPicture.network(
                variable.regimentImagePath + imageUrl,
              )
            : CachedNetworkImage(
                imageUrl: variable.regimentImagePath + imageUrl,
                placeholder: (context, url) => SizedBox.shrink(),
                errorWidget: (context, url, error) {
                  return defaultWidget ?? SizedBox.shrink();
                },
              );
      } catch (e) {
        return defaultWidget ?? SizedBox.shrink();
      }
    }
    return defaultWidget ?? SizedBox.shrink();
  }
}
