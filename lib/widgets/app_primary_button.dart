import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class AppPrimaryButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String? text;
  final TextStyle? textStyle;
  final double? textSize;
  final Color? textColor;
  final Decoration? decoration;
  final EdgeInsets? padding;
  final FontWeight? fontWeight;
   bool isSecondaryButton;
   final Widget? child;
  void Function() onTap;


  AppPrimaryButton({Key? key,
    this.height,
    this.width,
     this.text,
    required this.onTap,
    this.textStyle,
    this.textSize,
    this.textColor,
    this.decoration,
    this.padding,
    this.fontWeight,
    this.isSecondaryButton = false,
    this.child,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      InkWell(
        onTap:onTap,
        child: Container(
          height: height,
          constraints: BoxConstraints(
            minWidth: width??260.0.w,
          ),
          padding:padding??
          EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 15.0.sp),
          decoration:decoration??
          BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
             border:isSecondaryButton?Border.all(color: Color(CommonUtil().getMyPrimaryColor())):null,
              boxShadow:!isSecondaryButton?[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2),
              ]:null,
              gradient:!isSecondaryButton? LinearGradient(end: Alignment.centerRight, colors: [
                Color(CommonUtil().getMyPrimaryColor()),
                Color(CommonUtil().getMyGredientColor())
              ]):null),
          child:child?? Text(
            text??'',
            textAlign: TextAlign.center,
            style:textStyle?? TextStyle(fontSize: textSize??16.0.sp, color: textColor ?? (isSecondaryButton ? Color(CommonUtil().getMyPrimaryColor()) : Colors.white),
            fontWeight: fontWeight),
          ),
        ),
      );
}
