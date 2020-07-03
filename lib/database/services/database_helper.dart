import 'dart:async';
import 'dart:io' as io;

import 'package:myfhb/database/model/CountryMetrics.dart';
import 'package:myfhb/database/model/UnitsMesurement.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE CountryMetrics(countryCode INTEGER PRIMARY KEY, name TEXT, bpSPUnit TEXT, bpDPUnit TEXT,bpPulseUnit TEXT, glucometerUnit TEXT, poOxySatUnit TEXT,poPulseUnit TEXT, tempUnit TEXT, weightUnit TEXT)");

    //create a table for validation of units diplaying in devices card
    await db.execute(
        "CREATE TABLE UnitsTable (id INTEGER PRIMARY KEY, units TEXT,minValue INTEGER,maxValue INTEGER)");
  }

  Future<int> saveUnitMeasurements(UnitsMesurements unitsMesurements) async {
    var dbClient = await db;
    int res = await dbClient.insert("UnitsTable", unitsMesurements.toMap());
    return res;
  }

  Future<UnitsMesurements> getMeasurementsBasedOnUnits(
      String unitsMeasure) async {
    var dbClient = await db;

    // var results = await dbClient.rawQuery('SELECT * FROM UnitsTable WHERE units = $unitsMeasure');
    var results = await dbClient
        .rawQuery('SELECT * FROM UnitsTable WHERE units=? ', [unitsMeasure]);

    if (results.length > 0) {
      return new UnitsMesurements.map(results.first);
    }
  }

  Future<int> saveCountryMetrics(CountryMetrics countryMetrics) async {
    var dbClient = await db;
    int res = await dbClient.insert("CountryMetrics", countryMetrics.toMap());
    return res;
  }

  Future<List<CountryMetrics>> getCountryMetrics() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM CountryMetrics');
    List<CountryMetrics> employees = new List();
    for (int i = 0; i < list.length; i++) {
      var user = new CountryMetrics(
          list[i]["countryCode"],
          list[i]["name"],
          list[i]["bpSPUnit"],
          list[i]["bpDPUnit"],
          list[i]["bpPulseUnit"],
          list[i]["glucometerUnit"],
          list[i]["poOxySatUnit"],
          list[i]["poPulseUnit"],
          list[i]["tempUnit"],
          list[i]["weightUnit"]);
      user.setUserId(list[i]["countryCode"]);
      employees.add(user);
    }
    return employees;
  }

  Future<int> getDBLength() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM CountryMetrics');

    return list.length;
  }

  Future<CountryMetrics> getCustomer(int id) async {
    var dbClient = await db;
    String countryName =
        PreferenceUtil.getStringValue(CommonConstants.KEY_COUNTRYNAME);

    var results = await dbClient
        .rawQuery('SELECT * FROM CountryMetrics WHERE countryCode = $id');

    if (results.length > 0) {
      return new CountryMetrics.map(results.first);
    }

    return new CountryMetrics(id, countryName, 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kg');
  }

  Future<int> deleteCountryMetrics(CountryMetrics user) async {
    var dbClient = await db;

    int res = await dbClient.rawDelete(
        'DELETE FROM CountryMetrics WHERE countryCode = ?', [user.countryCode]);
    return res;
  }

  Future<bool> updateCountryMetrics(CountryMetrics user) async {
    var dbClient = await db;
    int res = await dbClient.update("CountryMetrics", user.toMap(),
        where: "countryCode = ?", whereArgs: <int>[user.countryCode]);
    return res > 0 ? true : false;
  }

  Future<int> getDBLengthUnit() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM UnitsTable');

    return list.length;
  }

  Future<List<UnitsMesurements>> getUnitsMeasurement() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM UnitsTable');
    List<UnitsMesurements> unitsList = new List();
    for (int i = 0; i < list.length; i++) {
      var unitObj = new UnitsMesurements(
        list[i]["countryCode"],
        list[i]["name"],
        list[i]["bpSPUnit"],
        list[i]["bpDPUnit"],
      );
      unitsList.add(unitObj);
    }
    return unitsList;
  }
}
