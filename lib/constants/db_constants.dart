library db_constants;

import 'package:flutter/cupertino.dart';

const String CT_COUNTRY_METRICS =
    'CREATE TABLE CountryMetrics(countryCode INTEGER PRIMARY KEY, name TEXT, bpSPUnit TEXT, bpDPUnit TEXT,bpPulseUnit TEXT, glucometerUnit TEXT, poOxySatUnit TEXT,poPulseUnit TEXT, tempUnit TEXT, weightUnit TEXT)';
const String CT_UNITS =
    'CREATE TABLE UnitsTable (id INTEGER PRIMARY KEY, units TEXT,minValue INTEGER,maxValue INTEGER)';
const String DB_NAME = 'main.db';
const String UT_NAME = 'UnitsTable';
const String CM_NAME = 'CountryMetrics';
const String UT_QUERY = 'SELECT * FROM UnitsTable';
const String UT_QUERY_BY_UN = 'SELECT * FROM UnitsTable WHERE units=? ';
const String CM_QUERY = 'SELECT * FROM CountryMetrics';
const String CM_QUERY_BY_CC =
    'SELECT * FROM CountryMetrics WHERE countryCode = ';
const String CM_DEL_QUERY_BY_CC =
    'DELETE FROM CountryMetrics WHERE countryCode = ?';
const String PRO_COUNTRY_CODE = 'countryCode';
const String PRO_NAME = 'name';
const String PRO_BPSP = 'bpSPUnit';
const String PRO_BPDP = 'bpDPUnit';
const String PRO_BPPULSE = 'bpPulseUnit';
const String PRO_GLUCO = 'glucometerUnit';
const String PRO_PO_OXY = 'poOxySatUnit';
const String PRO_PO_PULSE = 'poPulseUnit';
const String PRO_TEMP = 'tempUnit';
const String PRO_WEIGHT = 'weightUnit';
const String PRO_PMIN = 'p/min';
const String PRO_MMHG = 'mmHg';
const String PRO_MGDL = 'mg/dL';
const String PRO_SPO2 = '%';
const String PRO_PRBPM = 'PR bpm';
const String PRO_F = 'F';
const String PRO_KG = 'kgs';
const String CC_WHR_CALUSE = 'countryCode = ?';
const String CT_APPOINTMENTS =
    'CREATE TABLE appointments(id TEXT PRIMARY KEY, hosname TEXT, docname TEXT, appdate TEXT, apptime TEXT, reason TEXT)';
const String CT_REMINDERS =
    'CREATE TABLE reminders(id TEXT PRIMARY KEY, title TEXT, notes TEXT, date TEXT, time TEXT, interval TEXT)';
const String DB_NAME_2 = 'myfhb.db';
const String TL_APPNT = 'appointments';
const String TL_REMIND = 'reminders';
const String PRO_ID = 'id';
const String PRO_HNAME = 'hosname';
const String PRO_DOC_NAME = 'docname';
const String PRO_APP_DATE = 'appdate';
const String PRO_APP_TIME = 'apptime';
const String PRO_REASON = 'reason';
const String PRO_TITLE = 'title';
const String PRO_NOTES = 'notes';
const String PRO_DATE = 'date';
const String PRO_TIME = 'time';
const String PRO_INTERVAL = 'interval';
const String PRO_PATTERN = r'(^(?:[+0]9)?[0-9]{10,12}$)';
