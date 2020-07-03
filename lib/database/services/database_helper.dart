import 'dart:async';
import 'dart:io' as io;

import 'package:myfhb/database/model/CountryMetrics.dart';
import 'package:myfhb/database/model/UnitsMesurement.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/db_constants.dart' as DBConstants;

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (DatabaseHelper._db != null) {
      return DatabaseHelper._db;
    }
    else{
      await initDb();
      return DatabaseHelper._db;
    }

  }



  DatabaseHelper.internal();

  /*initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DBConstants.DB_NAME);
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }*/

  initDb() async {
    if (DatabaseHelper._db == null){
      io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
      DatabaseHelper._db = await openDatabase(join(documentsDirectory.path, DBConstants.DB_NAME), version: 1, onCreate: _onCreate);
    }
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(DBConstants.CT_COUNTRY_METRICS);

    //create a table for validation of units diplaying in devices card
    await db.execute(DBConstants.CT_UNITS);
  }

  Future<int> saveUnitMeasurements(UnitsMesurements unitsMesurements) async {
    var dbClient = await db;
    int res = await dbClient.insert(DBConstants.UT_NAME, unitsMesurements.toMap());
    return res;
  }

  Future<UnitsMesurements> getMeasurementsBasedOnUnits(
      String unitsMeasure) async {
    var dbClient = await db;

    var results = await dbClient
        .rawQuery(DBConstants.UT_QUERY_BY_UN, [unitsMeasure]);

    if (results.length > 0) {
      return new UnitsMesurements.map(results.first);
    }
  }

  Future<int> saveCountryMetrics(CountryMetrics countryMetrics) async {
    var dbClient = await db;
    int res = await dbClient.insert(DBConstants.CM_NAME, countryMetrics.toMap());
    return res;
  }

  Future<List<CountryMetrics>> getCountryMetrics() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(DBConstants.CM_QUERY);
    List<CountryMetrics> employees = new List();
    for (int i = 0; i < list.length; i++) {
      var user = new CountryMetrics(
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
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(DBConstants.CM_QUERY);

    return list.length;
  }

  Future<CountryMetrics> getCustomer(int id) async {
    var dbClient = await db;
    String countryName =
        PreferenceUtil.getStringValue(CommonConstants.KEY_COUNTRYNAME);

    var results = await dbClient
        .rawQuery(DBConstants.CM_QUERY_BY_CC+'$id');

    if (results.length > 0) {
      return new CountryMetrics.map(results.first);
    }

    return new CountryMetrics(id, countryName, DBConstants.PRO_PMIN, DBConstants.PRO_MMHG, DBConstants.PRO_PMIN,
        DBConstants.PRO_MGDL, DBConstants.PRO_SPO2, DBConstants.PRO_PRBPM, DBConstants.PRO_F, DBConstants.PRO_KG);
  }

  Future<int> deleteCountryMetrics(CountryMetrics user) async {
    var dbClient = await db;

    int res = await dbClient.rawDelete(DBConstants.CM_DEL_QUERY_BY_CC, [user.countryCode]);
    return res;
  }

  Future<bool> updateCountryMetrics(CountryMetrics user) async {
    var dbClient = await db;
    int res = await dbClient.update(DBConstants.CM_NAME, user.toMap(),
        where: DBConstants.CC_WHR_CALUSE, whereArgs: <int>[user.countryCode]);
    return res > 0 ? true : false;
  }

  Future<int> getDBLengthUnit() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(DBConstants.UT_QUERY);

    return list.length;
  }

  Future<List<UnitsMesurements>> getUnitsMeasurement() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(DBConstants.UT_QUERY);
    List<UnitsMesurements> unitsList = new List();
    for (int i = 0; i < list.length; i++) {
      var unitObj = new UnitsMesurements(
        list[i][DBConstants.PRO_COUNTRY_CODE],
        list[i][DBConstants.PRO_NAME],
        list[i][DBConstants.PRO_BPSP],
        list[i][DBConstants.PRO_BPDP],
      );
      unitsList.add(unitObj);
    }
    return unitsList;
  }
}
