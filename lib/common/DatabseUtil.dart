import '../database/model/CountryMetrics.dart';
import '../database/model/UnitsMesurement.dart';
import '../database/services/database_helper.dart';

class DatabaseUtil {
  static void insertCountryMetricsData() async {
    final db = DatabaseHelper();
    final IN = CountryMetrics(91, 'India', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(IN);
    final DZ = CountryMetrics(213, 'Algeria', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(DZ);
    final AR = CountryMetrics(54, 'Argentina', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(AR);
    final AU = CountryMetrics(61, 'Australia', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'g');
    await db.saveCountryMetrics(AU);
    final AT = CountryMetrics(43, 'Austria', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(AT);
    final BH = CountryMetrics(973, 'Bahrain', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(BH);
    final BD = CountryMetrics(880, 'Bangladesh', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(BD);
    final BE = CountryMetrics(32, 'Belgium', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(BE);
    final BR = CountryMetrics(55, 'Brazil', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(BR);
    final CA = CountryMetrics(11, 'Canada', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(CA);
    final CC = CountryMetrics(999, 'Carribean Countries', 'p/min', 'mmHg',
        'p/min', 'mg/dL', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(CC);
    final CL = CountryMetrics(56, 'Chile', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(CL);
    final CN = CountryMetrics(86, 'China', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(CN);
    final CO = CountryMetrics(57, 'Colombia', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(CO);
    final CZ = CountryMetrics(420, 'Czech Republic', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(CZ);
    final DK = CountryMetrics(45, 'Denmark', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(DK);

    final GQ = CountryMetrics(240, 'Equatorial Guinea', 'p/min', 'mmHg',
        'p/min', 'mg/dL', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(GQ);
    final EG = CountryMetrics(20, 'Egypt', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(EG);
    final FI = CountryMetrics(358, 'Finland', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(FI);
    final FR = CountryMetrics(33, 'France', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(FR);

    final GE = CountryMetrics(995, 'Georgia', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(GE);

    final DE = CountryMetrics(49, 'Germany', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(DE);
    final GR = CountryMetrics(30, 'Greece', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'g');
    await db.saveCountryMetrics(GR);

    final HK = CountryMetrics(852, 'Hong Kong', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(HK);
    final ID = CountryMetrics(62, 'Indonesia', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(ID);
    final IE = CountryMetrics(353, 'Ireland', 'p/min', 'mmHg', 'p/min',
        'mmmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(IE);
    final IL = CountryMetrics(972, 'Israel', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(IL);
    final IT = CountryMetrics(39, 'Italy', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(IT);
    final JP = CountryMetrics(81, 'Japan', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(JP);
    final JO = CountryMetrics(962, 'Jordan', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(JO);
    final KZ = CountryMetrics(7, 'Kazakhstan', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(KZ);
    final MY = CountryMetrics(60, 'Malaysia', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(MY);
    final MT = CountryMetrics(356, 'Malta', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(MT);

    final MX = CountryMetrics(52, 'Mexico', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(MX);

    final NL = CountryMetrics(31, 'Netherlands', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(NL);

    final NZ = CountryMetrics(64, 'New Zealand', 'p/min', 'mmHg', 'p/min',
        'mmmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(NZ);

    final NO = CountryMetrics(47, 'Norway', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(NO);
    final OM = CountryMetrics(968, 'Oman', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(OM);
    final PE = CountryMetrics(51, 'Peru', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(PE);

    final PH = CountryMetrics(63, 'Philippines', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(PH);
    final PL = CountryMetrics(48, 'Poland', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(PL);
    final PT = CountryMetrics(351, 'Portugal', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(PT);
    final QA = CountryMetrics(974, 'Qatar', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(QA);
    final RU = CountryMetrics(777, 'Russia', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(RU);

    final SA = CountryMetrics(966, 'Saudi Arabia', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(SA);
    final SG = CountryMetrics(65, 'Singapore', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(SG);
    final SK = CountryMetrics(421, 'Slovakia', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(SK);

    final ZA = CountryMetrics(27, 'South Africa', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(ZA);
    final ES = CountryMetrics(34, 'Spain', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(ES);
    final SE = CountryMetrics(46, 'Sweden', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(SE);

    final CH = CountryMetrics(41, 'Switzerland', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(CH);
    final SY = CountryMetrics(963, 'Syria', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(SY);
    final TW = CountryMetrics(886, 'Taiwan', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(TW);
    final TH = CountryMetrics(66, 'Thailand', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(TH);
    final TN = CountryMetrics(216, 'Tunisia', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(TN);
    final TR = CountryMetrics(90, 'Turkey', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(TR);
    final UA = CountryMetrics(380, 'Ukraine', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(UA);
    final AE = CountryMetrics(971, 'United Arab Emirates', 'p/min', 'mmHg',
        'p/min', 'mg/dL', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(AE);
    final GB = CountryMetrics(44, 'United Kingdom', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'Pound');
    await db.saveCountryMetrics(GB);

    final US = CountryMetrics(1, 'United States', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'C', 'Pound');
    await db.saveCountryMetrics(US);
    final UY = CountryMetrics(598, 'Uruguay', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(UY);
    final KP = CountryMetrics(850, 'Korea', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(KP);
    final KW = CountryMetrics(965, 'Kuwait', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(KW);
    final LB = CountryMetrics(961, 'Lebanon', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(LB);
    final LU = CountryMetrics(352, 'Luxembourg', 'p/min', 'mmHg', 'p/min',
        'mmol/L', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(LU);
    final VE = CountryMetrics(58, 'Venezuela', 'p/min', 'mmHg', 'p/min',
        'mg/dL', '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(VE);
    final VN = CountryMetrics(84, 'Vietnam', 'p/min', 'mmHg', 'p/min', 'mmol/L',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(VN);
    final YE = CountryMetrics(967, 'Yemen', 'p/min', 'mmHg', 'p/min', 'mg/dL',
        '%spo2', 'PR bpm', 'C', 'kgs');
    await db.saveCountryMetrics(YE);
  }

  static void getCountryMetrics(int countryCode) async {
    final db = DatabaseHelper();
    var countryMetrics = await db.getCustomer(countryCode);
  }

  static void insertUnitsForDevices() async {
    final db = DatabaseHelper();

    final faren = UnitsMesurements(1, 'f', 97.8, 99.1, "");
    await db.saveUnitMeasurements(faren);

    final thermo = UnitsMesurements(2, 'c', 36.5, 37.5, "");
    await db.saveUnitMeasurements(thermo);

    final gluco = UnitsMesurements(3, 'mgdl', 70, 120, "Fast");
    await db.saveUnitMeasurements(gluco);

    final bp = UnitsMesurements(4, 'mmHg', 60, 90, "Dia");
    await db.saveUnitMeasurements(bp);
    final pul = UnitsMesurements(5, '%spo2', 95, 100, "");
    await db.saveUnitMeasurements(pul);
    final pr = UnitsMesurements(6, 'PR bpm', 70, 120, "");
    await db.saveUnitMeasurements(pr);
    final kg = UnitsMesurements(7, 'kg', 0, 250, "");
    await db.saveUnitMeasurements(kg);
    final gram = UnitsMesurements(8, 'g', 0, 25000, "");
    await db.saveUnitMeasurements(gram);
    final dp = UnitsMesurements(9, 'dp', 60, 80, "");
    await db.saveUnitMeasurements(dp);
    final pulse = UnitsMesurements(10, 'pulse', 60, 100, "");
    await db.saveUnitMeasurements(pulse);
    final glucoPP = UnitsMesurements(11, 'mgdl', 70, 140, "PP");
    await db.saveUnitMeasurements(glucoPP);
    final glucoRandom = UnitsMesurements(12, 'mgdl', 70, 200, "Random");
    await db.saveUnitMeasurements(glucoRandom);
    final sp = UnitsMesurements(13, 'mmHg', 80, 139, "Sys");
    await db.saveUnitMeasurements(sp);
    final pounds = UnitsMesurements(14, 'lb', 0, 551, "");
    await db.saveUnitMeasurements(pounds);
  }

  static Future<int> getDBLength() async {
    final db = DatabaseHelper();
    final length = await db.getDBLength();
    return length;
  }

  static Future<int> getDBLengthUnit() async {
    final db = DatabaseHelper();
    final length = await db.getDBLengthUnit();
    return length;
  }
}
