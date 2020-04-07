import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:devicelocale/devicelocale.dart';
class FHBUtils {
  static String CURRENT_DATE_CODE='DMY';
  List<String> YMDList = ['','sq_AL','en_AU','de_AT','bn_BD','km_KH','en_CA','fr_CA','zh_CN',
    'da_DK','de_DE','en_HK','hu_HU','en_IN','fa_IR','en_JM','ja_JP','en_KE','ko_KP','ko_KR','lv_LV','lt_LT','mn_MN','my_MM','af_NA','en_NA','ne_NP','no_NO','ms_SG','sl_SI','en_ZA','si_LK','sv_SE',
  'zh_TW','en_GB','en_US'];
  List<String> MDYList = ['en_AU','en_CA','en_FM','en_KE','en_MY','en_PH','ar_SA','en_GB','en_US'];


  FHBUtils._privateCons();

  static final FHBUtils instance = FHBUtils._privateCons();

  FHBUtils();

  String convertMonthFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    String formattedDate = DateFormat('MMM').format(todayDate);

    return formattedDate.toUpperCase();
  }

  String convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    String formattedDate = DateFormat('dd').format(todayDate);
    return formattedDate;
  }

  String getFormattedDateString(String strDate) {
    //print('----------------CURRENT INVOKING METHOD{getFormattedDateString}-------------------');
    String formattedDate;
    if(CURRENT_DATE_CODE=='MDY'){
      formattedDate = DateFormat('MMM dd yyyy, hh:mm').format(DateTime.parse(strDate));
    }else if(CURRENT_DATE_CODE=='YMD'){
      formattedDate = DateFormat('yyyy MMM dd, hh:mm').format(DateTime.parse(strDate));
    }else{
      formattedDate = DateFormat('dd MMM yyyy, hh:mm').format(DateTime.parse(strDate));
    }
    //print('----------------MY DATE FORMAT$CURRENT_DATE_CODE-------------------');
    return formattedDate;
  }

  String getFormattedDateOnly(String strDate) {
    //print('----------------CURRENT INVOKING METHOD{getFormattedDateOnly}-------------------');
    String formattedDate;
    if(CURRENT_DATE_CODE=='MDY'){
      formattedDate = DateFormat('MM-dd-yyyy').format(DateTime.parse(strDate));
    }else if(CURRENT_DATE_CODE=='YMD'){
      formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(strDate));
    }else{
      formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(strDate));
    }
    //print('----------------MY DATE FORMAT$CURRENT_DATE_CODE-------------------');
    return formattedDate;
  }

  String getMonthDateYear(String strDate) {
    //print('----------------CURRENT INVOKING METHOD{getMonthDateYear}-------------------');
    String formattedDate;
    if(CURRENT_DATE_CODE=='MDY'){
      formattedDate = DateFormat('MM-dd-yyyy').format(DateTime.parse(strDate));
    }else if(CURRENT_DATE_CODE=='YMD'){
      formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(strDate));
    }else{
      formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(strDate));
    }
    //print('----------------MY DATE FORMAT$CURRENT_DATE_CODE-------------------');
    return formattedDate;
  }

  String getFormattedTimeOnly(String strDate) {
    String formattedDate = DateFormat('hh:mm').format(DateTime.parse(strDate));
    return formattedDate;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  Future<void> initPlatformState() async {
    //List languages;
    String currentLocale;

    // Platform messages may fail, so we use a try/catch PlatformException.
   /* try {
        languages = await Devicelocale.preferredLanguages;
      print('preferred language $languages');
    } on PlatformException {
      print("Error obtaining preferred languages");
    }*/
    try {
      await Devicelocale.currentLocale.then((val){
        if(val !=null && val !=''){
          //var temp = val.split('_')[1];
          getMyDateFormat(val);
        }
      });
    } on PlatformException {
      print("Error obtaining current locale");

    }
  }


  void getMyDateFormat(String localeCode){
      if(YMDList.contains(localeCode)){
        CURRENT_DATE_CODE='YMD';
        return;
      }else if(MDYList.contains(localeCode)){
        CURRENT_DATE_CODE = 'MDY';
        return;
      }else{
        CURRENT_DATE_CODE='DMY';
        return;
      }

  }


}
