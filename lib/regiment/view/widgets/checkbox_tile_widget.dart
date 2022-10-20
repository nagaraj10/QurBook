import 'package:flutter/material.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../common/CommonUtil.dart';
import 'custom_image_network.dart';

class CheckboxTileWidget extends StatefulWidget {
  const CheckboxTileWidget({
    @required this.title,
    @required this.onSelected,
    @required this.value,
    @required this.canEdit,
  });

  final String title;
  final String value;
  final Function(dynamic selectedValue, String valueText) onSelected;
  final bool canEdit;

  @override
  _CheckboxTileWidgetState createState() => _CheckboxTileWidgetState();
}

class _CheckboxTileWidgetState extends State<CheckboxTileWidget> {
  bool checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    var titleText;
    var imagePath;
    final List<dynamic> dataList = widget.title.split(':');
    if (dataList.length == 2) {
      imagePath = dataList[0];
      titleText = dataList[1];
    }else{
      titleText = widget.title;
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
            onChanged: widget.canEdit
                ? (value) {
                    setState(() {
                      checkboxValue = value;
                    });
                    widget.onSelected(value, widget.value);
                  }
                : null,
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
                  CustomImageNetwork(
                    imageUrl: (imagePath.toString().split('!').length == 2)
                        ? imagePath.toString().split('!')[1]
                        : '',
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
