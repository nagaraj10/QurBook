import 'package:myfhb/database/model/CountryMetrics.dart';
import 'package:myfhb/database/model/UnitsMesurement.dart';
import 'package:myfhb/database/services/database_helper.dart';

class DatabaseUtil {
  static void insertCountryMetricsData() async {
    var db = new DatabaseHelper();
    var IN = new CountryMetrics(91, 'India', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(IN);
    var DZ = new CountryMetrics(213, 'Algeria', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(DZ);
    var AR = new CountryMetrics(54, 'Argentina', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(AR);
    var AU = new CountryMetrics(61, 'Australia', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'g');
    await db.saveCountryMetrics(AU);
    var AT = new CountryMetrics(43, 'Austria', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(AT);
    var BH = new CountryMetrics(973, 'Bahrain', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(BH);
    var BD = new CountryMetrics(880, 'Bangladesh', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(BD);
    var BE = new CountryMetrics(32, 'Belgium', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(BE);
    var BR = new CountryMetrics(55, 'Brazil', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(BR);
    var CA = new CountryMetrics(11, 'Canada', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(CA);
    var CC = new CountryMetrics(999, 'Carribean Countries', 'p/min', 'mmHg',
        'p/min', 'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(CC);
    var CL = new CountryMetrics(56, 'Chile', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(CL);
    var CN = new CountryMetrics(86, 'China', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(CN);
    var CO = new CountryMetrics(57, 'Colombia', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(CO);
    var CZ = new CountryMetrics(420, 'Czech Republic', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(CZ);
    var DK = new CountryMetrics(45, 'Denmark', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(DK);

    var GQ = new CountryMetrics(240, 'Equatorial Guinea', 'p/min', 'mmHg',
        'p/min', 'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(GQ);
    var EG = new CountryMetrics(20, 'Egypt', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(EG);
    var FI = new CountryMetrics(358, 'Finland', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(FI);
    var FR = new CountryMetrics(33, 'France', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(FR);

    var GE = new CountryMetrics(995, 'Georgia', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(GE);

    var DE = new CountryMetrics(49, 'Germany', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(DE);
    var GR = new CountryMetrics(30, 'Greece', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'g');
    await db.saveCountryMetrics(GR);

    var HK = new CountryMetrics(852, 'Hong Kong', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(HK);
    var ID = new CountryMetrics(62, 'Indonesia', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(ID);
    var IE = new CountryMetrics(353, 'Ireland', 'p/min', 'mmHg', 'p/min',
        'mmmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(IE);
    var IL = new CountryMetrics(972, 'Israel', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(IL);
    var IT = new CountryMetrics(39, 'Italy', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(IT);
    var JP = new CountryMetrics(81, 'Japan', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(JP);
    var JO = new CountryMetrics(962, 'Jordan', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(JO);
    var KZ = new CountryMetrics(7, 'Kazakhstan', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(KZ);
    var MY = new CountryMetrics(60, 'Malaysia', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(MY);
    var MT = new CountryMetrics(356, 'Malta', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(MT);

    var MX = new CountryMetrics(52, 'Mexico', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(MX);

    var NL = new CountryMetrics(31, 'Netherlands', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(NL);

    var NZ = new CountryMetrics(64, 'New Zealand', 'p/min', 'mmHg', 'p/min',
        'mmmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(NZ);

    var NO = new CountryMetrics(47, 'Norway', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(NO);
    var OM = new CountryMetrics(968, 'Oman', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(OM);
    var PE = new CountryMetrics(51, 'Peru', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(PE);

    var PH = new CountryMetrics(63, 'Philippines', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(PH);
    var PL = new CountryMetrics(48, 'Poland', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(PL);
    var PT = new CountryMetrics(351, 'Portugal', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(PT);
    var QA = new CountryMetrics(974, 'Qatar', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(QA);
    var RU = new CountryMetrics(777, 'Russia', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(RU);

    var SA = new CountryMetrics(966, 'Saudi Arabia', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(SA);
    var SG = new CountryMetrics(65, 'Singapore', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(SG);
    var SK = new CountryMetrics(421, 'Slovakia', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(SK);

    var ZA = new CountryMetrics(27, 'South Africa', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(ZA);
    var ES = new CountryMetrics(34, 'Spain', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(ES);
    var SE = new CountryMetrics(46, 'Sweden', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(SE);

    var CH = new CountryMetrics(41, 'Switzerland', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(CH);
    var SY = new CountryMetrics(963, 'Syria', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(SY);
    var TW = new CountryMetrics(886, 'Taiwan', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(TW);
    var TH = new CountryMetrics(66, 'Thailand', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(TH);
    var TN = new CountryMetrics(216, 'Tunisia', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(TN);
    var TR = new CountryMetrics(90, 'Turkey', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(TR);
    var UA = new CountryMetrics(380, 'Ukraine', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(UA);
    var AE = new CountryMetrics(971, 'United Arab Emirates', 'p/min', 'mmHg',
        'p/min', 'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(AE);
    var GB = new CountryMetrics(44, 'United Kingdom', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'Pound');
    await db.saveCountryMetrics(GB);

    var US = new CountryMetrics(1, 'United States', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'Pound');
    await db.saveCountryMetrics(US);
    var UY = new CountryMetrics(598, 'Uruguay', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(UY);
    var KP = new CountryMetrics(850, 'Korea', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(KP);
    var KW = new CountryMetrics(965, 'Kuwait', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(KW);
    var LB = new CountryMetrics(961, 'Lebanon', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(LB);
    var LU = new CountryMetrics(352, 'Luxembourg', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(LU);
    var VE = new CountryMetrics(58, 'Venezuela', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(VE);
    var VN = new CountryMetrics(84, 'Vietnam', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(VN);
    var YE = new CountryMetrics(967, 'Yemen', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'F', 'kgs');
    await db.saveCountryMetrics(YE);
  }

  static void getCountryMetrics(int countryCode) async {
    var db = new DatabaseHelper();
    CountryMetrics countryMetrics = await db.getCustomer(countryCode);
  }

  static void insertUnitsForDevices() async {
    var db = new DatabaseHelper();

    var faren = new UnitsMesurements(1, "F", 95, 99);
    await db.saveUnitMeasurements(faren);

    var thermo = new UnitsMesurements(2, "C", 35, 38);
    await db.saveUnitMeasurements(thermo);

    var gluco = new UnitsMesurements(3, "mgdl", 60, 160);
    await db.saveUnitMeasurements(gluco);
    var bp = new UnitsMesurements(4, "mmHg", 90, 130);
    await db.saveUnitMeasurements(bp);
    var pul = new UnitsMesurements(5, "%spo2", 90, 100);
    await db.saveUnitMeasurements(pul);
    var pr = new UnitsMesurements(6, "PR bpm", 70, 120);
    await db.saveUnitMeasurements(pr);
    var kg = new UnitsMesurements(7, "kgs", 0, 250);
    await db.saveUnitMeasurements(kg);
    var gram = new UnitsMesurements(8, "g", 0, 25000);
    await db.saveUnitMeasurements(gram);
    var dp = new UnitsMesurements(9, "dp", 60, 80);
    await db.saveUnitMeasurements(dp);
    var pulse = new UnitsMesurements(10, "pulse", 60, 100);
    await db.saveUnitMeasurements(pulse);
  }

  static Future<int> getDBLength() async {
    var db = new DatabaseHelper();
    int length = await db.getDBLength();
    return length;
  }

  static Future<int> getDBLengthUnit() async {
    var db = new DatabaseHelper();
    int length = await db.getDBLengthUnit();
    return length;
  }
}
