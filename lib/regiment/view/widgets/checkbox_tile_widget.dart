import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myfhb/constants/fhb_query.dart' as variable;
import 'package:flutter_svg/flutter_svg.dart';

class CheckboxTileWidget extends StatefulWidget {
  CheckboxTileWidget({
    @required this.title,
    @required this.onSelected,
    @required this.value,
  });

  final String title;
  final String value;
  final Function(dynamic selectedValue, String valueText) onSelected;

  @override
  _CheckboxTileWidgetState createState() => _CheckboxTileWidgetState();
}

class _CheckboxTileWidgetState extends State<CheckboxTileWidget> {
  bool checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    var titleText;
    var imagePath;
    List<dynamic> dataList = widget.title.split(':');
    if (dataList.length == 2) {
      imagePath = dataList[0];
      titleText = dataList[1];
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.0.h,
      ),
      child: Row(
        children: [
          Checkbox(
            value: checkboxValue,
            activeColor: Color(CommonUtil().getMyPrimaryColor()),
            onChanged: (value) {
              setState(() {
                checkboxValue = value;
              });
              widget.onSelected(value, widget.value);
            },
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                left: 2.0.w,
                right: 10.0.w,
              ),
              child: Column(
                children: [
                  Text(
                    titleText ?? '',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (imagePath.toString().split('!').length == 2)
                    (imagePath
                                .toString()
                                .split('!')[1]
                                .toLowerCase()
                                ?.contains('.svg') ??
                            false)
                        ? SvgPicture.network(
                            variable.regimentImagePath +
                                imagePath.toString().split('!')[1],
                          )
                        : CachedNetworkImage(
                            imageUrl: variable.regimentImagePath +
                                imagePath.toString().split('!')[1],
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                SizedBox.shrink(),
                          ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
