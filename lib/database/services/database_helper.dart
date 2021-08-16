import 'dart:async';
import 'dart:io' as io;

import '../model/CountryMetrics.dart';
import '../model/UnitsMesurement.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../common/CommonConstants.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/db_constants.dart' as DBConstants;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (DatabaseHelper._db != null) {
      return DatabaseHelper._db;
    } else {
      await initDb();
      return DatabaseHelper._db;
    }
  }

  DatabaseHelper.internal();

  initDb() async {
    if (DatabaseHelper._db == null) {
      var documentsDirectory = await getApplicationDocumentsDirectory();
      DatabaseHelper._db = await openDatabase(
          join(documentsDirectory.path, DBConstants.DB_NAME),
          version: 1,
          onCreate: _onCreate);
    }
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(DBConstants.CT_COUNTRY_METRICS);

    //create a table for validation of units diplaying in devices card
    await db.execute(DBConstants.CT_UNITS);
  }

  Future<int> saveUnitMeasurements(UnitsMesurements unitsMesurements) async {
    final dbClient = await db;
    final res =
        await dbClient.insert(DBConstants.UT_NAME, unitsMesurements.toMap());
    return res;
  }

  Future<UnitsMesurements> getMeasurementsBasedOnUnits(
      String unitsMeasure,String range) async {
    final dbClient = await db;

    final results =
        await dbClient.rawQuery(DBConstants.UT_QUERY_BY_UN, [unitsMeasure,range]);

    if (results.isNotEmpty) {
      return UnitsMesurements.map(results.first);
    }
  }

  Future<int> saveCountryMetrics(CountryMetrics countryMetrics) async {
    final dbClient = await db;
    var res =
        await dbClient.insert(DBConstants.CM_NAME, countryMetrics.toMap());
    return res;
  }

  Future<List<CountryMetrics>> getCountryMetrics() async {
    final dbClient = await db;
    final List<Map> list = await dbClient.rawQuery(DBConstants.CM_QUERY);
    final List<CountryMetrics> employees = [];
    for (var i = 0; i < list.length; i++) {
      final user = CountryMetrics(
          list[i][DBConstants.PRO_COUNTRY_CODE],
          list[i][DBConstants.PRO_NAME],
          list[i][DBConstants.PRO_BPSP],
          list[i][DBConstants.PRO_BPDP],
          list[i][DBConstants.PRO_BPPULSE],
          list[i][DBConstants.PRO_GLUCO],
          list[i][DBConstants.PRO_PO_OXY],
          list[i][DBConstants.PRO_PO_PULSE],
          list[i][DBConstants.PRO_TEMP],
          list[i][DBConstants.PRO_WEIGHT]);
      user.setUserId(list[i][DBConstants.PRO_COUNTRY_CODE]);
      employees.add(user);
    }
    return employees;
  }

  Future<int> getDBLength() async {
    final dbClient = await db;
    final List<Map> list = await dbClient.rawQuery(DBConstants.CM_QUERY);

    return list.length;
  }

  Future<CountryMetrics> getCustomer(int id) async {
    final dbClient = await db;
    var countryName =
        PreferenceUtil.getStringValue(CommonConstants.KEY_COUNTRYNAME);

    final results = await dbClient.rawQuery(DBConstants.CM_QUERY_BY_CC + '$id');

    if (results.isNotEmpty) {
      return CountryMetrics.map(results.first);
    }

    return CountryMetrics(
        id,
        countryName,
        DBConstants.PRO_PMIN,
        DBConstants.PRO_MMHG,
        DBConstants.PRO_PMIN,
        DBConstants.PRO_MGDL,
        DBConstants.PRO_SPO2,
        DBConstants.PRO_PRBPM,
        DBConstants.PRO_F,
        DBConstants.PRO_KG);
  }

  Future<int> deleteCountryMetrics(CountryMetrics user) async {
    final dbClient = await db;

    var res = await dbClient
        .rawDelete(DBConstants.CM_DEL_QUERY_BY_CC, [user.countryCode]);
    return res;
  }

  Future<bool> updateCountryMetrics(CountryMetrics user) async {
    final dbClient = await db;
    var res = await dbClient.update(DBConstants.CM_NAME, user.toMap(),
        where: DBConstants.CC_WHR_CALUSE, whereArgs: <int>[user.countryCode]);
    return res > 0 ? true : false;
  }

  Future<int> getDBLengthUnit() async {
    final dbClient = await db;
    final List<Map> list = await dbClient.rawQuery(DBConstants.UT_QUERY);

    return list.length;
  }

  Future<List<UnitsMesurements>> getUnitsMeasurement() async {
    final dbClient = await db;
    final List<Map> list = await dbClient.rawQuery(DBConstants.UT_QUERY);
    final List<UnitsMesurements> unitsList = [];
    for (var i = 0; i < list.length; i++) {
      final unitObj = UnitsMesurements(
        list[i][DBConstants.PRO_COUNTRY_CODE],
        list[i][DBConstants.PRO_NAME],
        list[i][DBConstants.PRO_BPSP],
        list[i][DBConstants.PRO_BPDP],
        list[i][DBConstants.PRO_RANGE],
      );
      unitsList.add(unitObj);
    }
    return unitsList;
  }
}
