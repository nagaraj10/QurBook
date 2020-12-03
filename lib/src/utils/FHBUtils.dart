import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/constants/db_constants.dart' as DBConstants;
import 'package:myfhb/src/model/AppointmentModel.dart';
import 'package:myfhb/src/model/ReminderModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FHBUtils {
  static String CURRENT_DATE_CODE = 'DMY';
  static final String ANDROID_FILE_PATH = '/storage/emulated/0/MYFHB/';
  List<String> YMDList = [
    'sq_AL',
    'en_AU',
    'de_AT',
    'bn_BD',
    'km_KH',
    'en_CA',
    'fr_CA',
    'zh_CN',
    'da_DK',
    'de_DE',
    'en_HK',
    'hu_HU',
    'fa_IR',
    'en_JM',
    'ja_JP',
    'en_KE',
    'ko_KP',
    'ko_KR',
    'lv_LV',
    'lt_LT',
    'mn_MN',
    'my_MM',
    'af_NA',
    'en_NA',
    'ne_NP',
    'no_NO',
    'ms_SG',
    'sl_SI',
    'en_ZA',
    'si_LK',
    'sv_SE',
    'zh_TW',
    'en_GB',
  ];
  List<String> MDYList = [
    'en_AU',
    'en_CA',
    'en_FM',
    'en_KE',
    'en_MY',
    'en_PH',
    'ar_SA',
    'en_GB',
    'en_US'
  ];

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
    String formattedDate = '';

    if (strDate != null && strDate != '') {
      if (CURRENT_DATE_CODE == 'MDY') {
        formattedDate = DateFormat('MMM dd yyyy, hh:mm aa')
            .format(DateTime.parse(strDate).toLocal());
      } else if (CURRENT_DATE_CODE == 'YMD') {
        formattedDate = DateFormat('yyyy MMM dd, hh:mm aa')
            .format(DateTime.parse(strDate).toLocal());
      } else {
        formattedDate = DateFormat('dd MMM yyyy, hh:mm aa')
            .format(DateTime.parse(strDate).toLocal());
      }
    }
    return formattedDate;
  }

  String getFormattedDateForUser(String strDate) {
    String formattedDate;
    try {
      formattedDate =
          DateFormat('MM-dd-yyyy').format(DateTime.parse(strDate).toLocal());
    } catch (e) {
      formattedDate = strDate;
    }

    return formattedDate;
  }

  String getFormattedDateForUserBirth(String strDate) {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(strDate));
    return formattedDate;
  }

  String getFormattedDateOnly(String strDate) {
    String formattedDate;
    try {
      if (CURRENT_DATE_CODE == 'MDY') {
        formattedDate =
            DateFormat('MM-dd-yyyy').format(DateTime.parse(strDate));
      } else if (CURRENT_DATE_CODE == 'YMD') {
        formattedDate =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(strDate));
      } else {
        formattedDate =
            DateFormat('dd-MM-yyyy').format(DateTime.parse(strDate));
      }
    } catch (e) {
      formattedDate = strDate;
    }
    return formattedDate;
  }

  String getFormattedDateOnlyNew(String strDate) {
    String formattedDate;
    try {
      if (CURRENT_DATE_CODE == 'MDY') {
        formattedDate =
            DateFormat('MM-dd-yyyy').format(DateTime.parse(strDate).toLocal());
      } else if (CURRENT_DATE_CODE == 'YMD') {
        formattedDate =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(strDate).toLocal());
      } else {
        formattedDate =
            DateFormat('dd-MM-yyyy').format(DateTime.parse(strDate).toLocal());
      }
    } catch (e) {
      formattedDate = strDate;
    }
    return formattedDate;
  }

  String getMonthDateYear(String strDate) {
    String formattedDate;
    if (CURRENT_DATE_CODE == 'MDY') {
      formattedDate = DateFormat('MM-dd-yyyy').format(DateTime.parse(strDate));
    } else if (CURRENT_DATE_CODE == 'YMD') {
      formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(strDate));
    } else {
      formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(strDate));
    }
    return formattedDate;
  }

  String getFormattedTimeOnly(String strDate) {
    String formattedDate =
        DateFormat('hh:mm aa').format(DateTime.parse(strDate));
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
    } on PlatformException {
    }*/
    try {
      await Devicelocale.currentLocale.then((val) {
        if (val != null && val != '') {
          //var temp = val.split('_')[1];
          getMyDateFormat(val);
        }
      });
    } on PlatformException {}
  }

  void getMyDateFormat(String localeCode) {
    if (YMDList.contains(localeCode)) {
      CURRENT_DATE_CODE = 'YMD';
      return;
    } else if (MDYList.contains(localeCode)) {
      CURRENT_DATE_CODE = 'MDY';
      return;
    } else {
      CURRENT_DATE_CODE = 'DMY';
      return;
    }
  }

  Future<Database> getDb() async {
    return openDatabase(
      //const path = await getDatabasesPath(),
      join(await getDatabasesPath(), DBConstants.DB_NAME_2),
      version: 1,
      onCreate: (db, version) => _createTable(db),
    );
  }

  static void _createTable(Database db) async {
    await db.execute(
      DBConstants.CT_APPOINTMENTS,
    );
    await db.execute(
      DBConstants.CT_REMINDERS,
    );
  }

  Future<void> createNewAppointment(AppointmentModel appModel) async {
    final Database db = await getDb();
    await db
        .insert(DBConstants.TL_APPNT, appModel.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((res) {});
  }

  static String base64String(List<dynamic> data) {
    return base64Encode(data);
  }

  static Image getImageFromString(String data) {
    return Image.memory(
      base64Decode(data),
      fit: BoxFit.fill,
    );
  }

  static Future<String> createFolderInAppDocDir(String folderName) async {
    Directory _appDocDirFolder;
    //Create Directory with app name
    if (Platform.isAndroid) {
      _appDocDirFolder = Directory(ANDROID_FILE_PATH);
    } else {
      final Directory _appDocDir = await getApplicationDocumentsDirectory();
      _appDocDirFolder = Directory('${_appDocDir.path}/MYFHB');
    }

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

   static Future<String> createFolderInAppDocDirClone(String folderName) async {
    Directory _appDocDirFolder;
    //Create Directory with app name
     final Directory _appDocDir = await getTemporaryDirectory();
      _appDocDirFolder = Directory(_appDocDir.path);

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }
  

  Future<List<AppointmentModel>> getAllAppointments() async {
    // Get a reference to the database.
    final Database db = await getDb();
    // Query the table for all The Appointments.
    final List<Map<String, dynamic>> maps =
        await db.query(DBConstants.TL_APPNT);
    // Convert the List<Map<String, dynamic> into a List<Appointment>.
    return List.generate(maps.length, (i) {
      return AppointmentModel(
        id: maps[i][DBConstants.PRO_ID],
        hName: maps[i][DBConstants.PRO_HNAME],
        dName: maps[i][DBConstants.PRO_DOC_NAME],
        appDate: maps[i][DBConstants.PRO_APP_DATE],
        appTime: maps[i][DBConstants.PRO_APP_TIME],
        reason: maps[i][DBConstants.PRO_REASON],
      );
    });
  }

  Future<void> deleteAppointment(String id) async {
    // Get a reference to the database.
    final db = await getDb();

    // Remove the Appointment from the database.
    await db.delete(
      DBConstants.TL_APPNT,
      // Use a `where` clause to delete a specific Appointment.
      where: DBConstants.PRO_ID + " = ?",
      // Pass the Appointment's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> create(dynamic model, String tableName) async {
    final Database db = await getDb();
    await db
        .insert(tableName, model.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((res) {});
  }

  Future<void> delete(String tableName, String id) async {
    // Get a reference to the database.
    final db = await getDb();

    // Remove the Appointment from the database.
    await db.delete(
      tableName,
      // Use a `where` clause to delete a specific Appointment.
      where: DBConstants.PRO_ID + " = ?",
      // Pass the Appointment's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    ).then((res) {});
  }

  Future<void> update(String tableName, dynamic model) async {
    // Get a reference to the database.
    final db = await getDb();

    // Update the given Dog.
    await db.update(
      tableName,
      model.toMap(),
      // Ensure that the Dog has a matching id.
      where: DBConstants.PRO_ID + " = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [model.id],
    ).then((res) {});
  }

  Future<List<dynamic>> getAll(
    String tableName,
  ) async {
    // Get a reference to the database.
    final Database db = await getDb();
    // Query the table for all The Appointments.
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    // Convert the List<Map<String, dynamic> into a List<Appointment>.
    return List.generate(maps.length, (i) {
      if (tableName == DBConstants.TL_APPNT) {
        return AppointmentModel(
          id: maps[i][DBConstants.PRO_ID],
          hName: maps[i][DBConstants.PRO_HNAME],
          dName: maps[i][DBConstants.PRO_DOC_NAME],
          appDate: maps[i][DBConstants.PRO_APP_DATE],
          appTime: maps[i][DBConstants.PRO_APP_TIME],
          reason: maps[i][DBConstants.PRO_REASON],
        );
      } else if (tableName == DBConstants.TL_REMIND) {
        return ReminderModel(
          id: maps[i][DBConstants.PRO_ID],
          title: maps[i][DBConstants.PRO_TITLE],
          notes: maps[i][DBConstants.PRO_NOTES],
          date: maps[i][DBConstants.PRO_DATE],
          time: maps[i][DBConstants.PRO_TIME],
          interval: maps[i][DBConstants.PRO_INTERVAL],
        );
      } else {
        return null;
      }
    });
  }

  bool checkdate(DateTime pickedDate) {
    var currentDate = DateTime.now();
    pickedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    final dateDifference = currentDate.difference(pickedDate).isNegative;
    return dateDifference;
  }

  bool checkTime(TimeOfDay picktime) {
    var pickedTime = formatTimeOfDay(picktime);
    var currentTime = DateFormat.jm().format(DateTime.now());
    var arr = currentTime.split(':');
    var hour = int.parse(arr[0]);
    var temp = arr[1].split(' ');
    var mins = int.parse(temp[0]);
    var ampm = temp[1];

    var arr1 = pickedTime.split(':');
    var phour = int.parse(arr1[0]);
    var temp1 = arr1[1].split(' ');
    var pmins = int.parse(temp1[0]);
    var p_ampm = temp1[1];

    if (phour > hour) {
      if (p_ampm != ampm) {
        return false;
      }
      return true;
    } else if (phour == hour) {
      if (pmins > mins) {
        return true;
      } else if (pmins == mins) {
        if (p_ampm != ampm) {
          return false;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
