import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:myfhb/src/model/AppointmentModel.dart';
import 'package:myfhb/src/model/ReminderModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FHBUtils {
  static String CURRENT_DATE_CODE = 'DMY';
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
    //print('----------------CURRENT INVOKING METHOD{getFormattedDateString}-------------------');
    String formattedDate;
    if (CURRENT_DATE_CODE == 'MDY') {
      formattedDate =
          DateFormat('MMM dd yyyy, hh:mm').format(DateTime.parse(strDate));
    } else if (CURRENT_DATE_CODE == 'YMD') {
      formattedDate =
          DateFormat('yyyy MMM dd, hh:mm').format(DateTime.parse(strDate));
    } else {
      formattedDate =
          DateFormat('dd MMM yyyy, hh:mm').format(DateTime.parse(strDate));
    }
    //print('----------------MY DATE FORMAT$CURRENT_DATE_CODE-------------------');
    return formattedDate;
  }

  String getFormattedDateOnly(String strDate) {
    //print('----------------CURRENT INVOKING METHOD{getFormattedDateOnly}-------------------');
    String formattedDate;
    if (CURRENT_DATE_CODE == 'MDY') {
      formattedDate = DateFormat('MM-dd-yyyy').format(DateTime.parse(strDate));
    } else if (CURRENT_DATE_CODE == 'YMD') {
      formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(strDate));
    } else {
      formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(strDate));
    }
    //print('----------------MY DATE FORMAT$CURRENT_DATE_CODE-------------------');
    return formattedDate;
  }

  String getMonthDateYear(String strDate) {
    //print('----------------CURRENT INVOKING METHOD{getMonthDateYear}-------------------');
    String formattedDate;
    if (CURRENT_DATE_CODE == 'MDY') {
      formattedDate = DateFormat('MM-dd-yyyy').format(DateTime.parse(strDate));
    } else if (CURRENT_DATE_CODE == 'YMD') {
      formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(strDate));
    } else {
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
      await Devicelocale.currentLocale.then((val) {
        if (val != null && val != '') {
          //var temp = val.split('_')[1];
          getMyDateFormat(val);
        }
      });
    } on PlatformException {
      print("Error obtaining current locale");
    }
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
      join(await getDatabasesPath(), 'myfhb.db'),
      version: 1,
      onCreate: (db, version) => _createTable(db),
    );
  }

  static void _createTable(Database db) async {
    await db.execute(
      "CREATE TABLE appointments(id TEXT PRIMARY KEY, hosname TEXT, docname TEXT, appdate TEXT, reason TEXT)",
    );
    await db.execute(
      "CREATE TABLE reminders(id TEXT PRIMARY KEY, title TEXT, notes TEXT, date TEXT, time TEXT, interval TEXT)",
    );
  }

  Future<void> createNewAppointment(AppointmentModel appModel) async {
    final Database db = await getDb();
    await db
        .insert('appointments', appModel.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((res) {
      print('--------------createNewAppointment result $res');
    });
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
    //Get this App Document Directory
    final Directory _appDocDir = await getExternalStorageDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$folderName/');

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
    final List<Map<String, dynamic>> maps = await db.query('appointments');

    // Convert the List<Map<String, dynamic> into a List<Appointment>.
    return List.generate(maps.length, (i) {
      return AppointmentModel(
        id: maps[i]['id'],
        hName: maps[i]['hosname'],
        dName: maps[i]['docname'],
        appDate: maps[i]['appdate'],
        reason: maps[i]['reason'],
      );
    });
  }

  Future<void> deleteAppointment(String id) async {
    // Get a reference to the database.
    final db = await getDb();

    // Remove the Appointment from the database.
    await db.delete(
      'appointments',
      // Use a `where` clause to delete a specific Appointment.
      where: "id = ?",
      // Pass the Appointment's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> create(dynamic model, String tableName) async {
    final Database db = await getDb();
    await db
        .insert(tableName, model.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((res) {
      print('--------------inserted $res row into $tableName----------');
    });
  }

  Future<void> delete(String tableName, String id) async {
    // Get a reference to the database.
    final db = await getDb();

    // Remove the Appointment from the database.
    await db.delete(
      tableName,
      // Use a `where` clause to delete a specific Appointment.
      where: "id = ?",
      // Pass the Appointment's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    ).then((res) {
      print('--------------deleted $res row into $tableName------------------');
    });
  }

  Future<void> update(String tableName, dynamic model) async {
    // Get a reference to the database.
    final db = await getDb();

    // Update the given Dog.
    await db.update(
      tableName,
      model.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [model.id],
    ).then((res) {
      print('--------------updated $res row into $tableName------------------');
    });
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
      if (tableName == 'appointments') {
        return AppointmentModel(
          id: maps[i]['id'],
          hName: maps[i]['hosname'],
          dName: maps[i]['docname'],
          appDate: maps[i]['appdate'],
          reason: maps[i]['reason'],
        );
      } else if (tableName == 'reminders') {
        return ReminderModel(
          id: maps[i]['id'],
          title: maps[i]['title'],
          notes: maps[i]['notes'],
          date: maps[i]['date'],
          time: maps[i]['time'],
          interval: maps[i]['interval'],
        );
      } else {
        return null;
      }
    });
  }
}
