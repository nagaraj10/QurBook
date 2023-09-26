import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class AppPrimaryButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String text;
  final TextStyle? textStyle;
  final double? textSize;
  final Color? textColor;
  final Decoration? decoration;
  final EdgeInsets? padding;
  void Function() onTap;

  AppPrimaryButton({Key? key,
    this.height,
    this.width,
    required this.text,
    required this.onTap,
    this.textStyle,
    this.textSize,
    this.textColor,
    this.decoration,
    this.padding,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      InkWell(
        onTap:onTap,
        child: Container(
          height: height,
          width:width?? 260.0.w,
          padding:padding??
          EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 15.0.sp),
          alignment: Alignment.center,
          decoration:decoration?? BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(end: Alignment.centerRight, colors: [
                Color(CommonUtil().getMyPrimaryColor()),
                Color(CommonUtil().getMyGredientColor())
              ])),
          child: Text(
            text,
            style:textStyle?? TextStyle(fontSize: textSize??16.0.sp, color:textColor?? Colors.white),
          ),
        ),
      );
}
