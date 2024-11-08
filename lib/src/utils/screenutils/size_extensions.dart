import 'screenutil.dart';

extension SizeExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => ScreenUtil().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => ScreenUtil().setHeight(this);

  ///[ScreenUtil.radius]
  double get r => ScreenUtil().radius(this);

  ///[ScreenUtil.setSp]
  double get sp => ScreenUtil().setSp(this);

  ///[ScreenUtil.setSp]
  double get ssp => ScreenUtil().setSp(this, allowFontScalingSelf: true);

  ///[ScreenUtil.setSp]
  double get nsp => ScreenUtil().setSp(this, allowFontScalingSelf: false);

  ///Multiple of screen width
  double get sw => ScreenUtil().screenWidth! * this;

  ///Multiple of screen height
  double get sh => ScreenUtil().screenHeight! * this;
}

///Num Parse Extension to parse dynamic fields
extension ParseNumExtension on dynamic {
  num? parseNum() {
    if (this == null) {
      return null;
    } else if (this is num) {
      return this as num;
    } else if (this is String) {
      String trimmedString = (this as String).trim();
      if (trimmedString.isEmpty) {
        return null; // Return null if the string is empty after trimming
      }
      return num.tryParse(trimmedString);
    } else {
      // Handle other cases if needed
      return null;
    }
  }
}




