import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/database/model/CountryMetrics.dart';
import 'package:myfhb/database/model/UnitsMesurement.dart';
import 'package:myfhb/database/services/database_helper.dart';

class CommonConstants {
  static const String categoryDescriptionPrescription = 'Catcode001';
  static const String categoryDescriptionDevice = 'Catcode002';
  static const String categoryDescriptionLabReport = 'Catcode003';
  static const String categoryDescriptionMedicalReport = 'Catcode004';
  static const String categoryDescriptionBills = 'Catcode005';
  static const String categoryDescriptionIDDocs = 'Catcode006';
  static const String categoryDescriptionOthers = 'Catcode007';
  static const String categoryDescriptionWearable = 'Catcode008';
  static const String categoryDescriptionFeedback = 'Catcode009';
  static const String categoryDescriptionVoiceRecord = 'Catcode010';
  static const String categoryDescriptionClaimsRecord = 'Catcode011';
    static const String categoryDescriptionNotes='Catcode013';


  static final String CAT_JSON_GLUCOMETER = "Catcode002_Typecode001";
  static final String CAT_JSON_BP_METER = "Catcode002_Typecode002";
  static final String CAT_JSON_THERMOMETER = "Catcode002_Typecode003";
  static final String CAT_JSON_WEIGHTING_SCALE = "Catcode002_Typecode004";
  static final String CAT_JSON_OXIMETER = "Catcode002_Typecode005";
  static final String CAT_JSON_PRESCRIPTION = "Catcode001_Typecode001";
  static final String CAT_JSON_MEDICAL_REPORT = "Catcode004_Typecode001";
  static final String CAT_JSON_LAB = "Catcode003_Typecode001";
  static final String CAT_JSON_BILLS = "Catcode005_Typecode001";
  static final String CAT_JSON_ID_DOC = "Catcode006_Typecode001";
  static final String CAT_JSON_Voice = "Catcode010_Typecode001";
  static final String CAT_JSON_OTHERS = "Catcode007_Typecode001";
  static final String CAT_JSON_WEARABLES = "Catcode008_Typecode001";
  static final String CAT_JSON_OTHERID = "Catcode006_Typecode003";
  static final String CAT_JSON_INSURANCE = "Catcode006_Typecode002";
  static final String CAT_JSON_FEEDBACK = "Catcode009_Typecode001";
  static final String CAT_JSON_HOSPITAL = "Catcode006_Typecode001";

  static String appVersion = 'default app version';
  static String serach_specific_list = 'Search Specific List';

  /**
   * KeyWords tp save prefernce values,error dipslay 
   */
  static String keyDoctor = 'Doctors';
  static String keyHospital = 'Hospitals';
  static String keyLab = 'Lab';

  /**
   * Following are the constants string used as hint text for the pop 
   * box that appears when a card is saved
   */
  //static String strMessage = 'Message';
  static String strDateOfVisit = 'Date of visit *';
  static String strHospitalName = 'Hospital Name *';
  static String strHospitalNameWithoutStar = 'Hospital Name ';
  static String strFileName = 'File Name *';
  static String strDoctorsName = 'Doctor Name *';
  static String strSave = 'Save';
  static String strLabName = 'Lab Name *';

  /**
   * STring for Signin the app
   */
  static String strTrident = 'tridentApp';
  static String strOperationSignIN = 'signIn';
  static String strTridentValue = 'trident';

  static String searchPlaces = "Search Places";
  static String comingSoon = "Coming Soon";

  static String fromClass = "My Providers";

  static String doctors = 'Doctors';
  static String hospitals = 'Hospitals';
  static String labs = 'Labs';

  static String myProviders = 'My Providers';
  static String locate_your = "Locate your ";
  static String confirm_location = "Confirm Location";

  static String strDevice = 'Devices';

  static String strGlucometerValue = 'mg/dL';
  static String strValue = 'Value';
  static String strMemo = 'Memo (50)';
  static String strTimeTaken = 'Time taken';
  static String strSugarLevel = 'sugarLevel';
  static String strTimeIntake = 'Time of Intake';

  static String strTemperature = 'Temperature';
  static String strTemperatureValue = 'F';
  static String strTemperatureUnit = 'celcius';
  static String strTempParams = 'temperature';

  static String strWeight = 'Weight';
  static String strWeightValue = 'kg';
  static String strWeightParam = 'weight';
  static String strWeightUnit = 'kgs';

  static String strOxygenSaturation = 'Oxygen Saturation';
  static String strOxygenValue = '%spo2';
  static String strOxygenParams = 'oxygenSaturation';
  static String strOxygenUnits = '%sp02';
  static String strPulseRate = 'pulseRate';
  static String strPulseUnit = 'bpm';

  static String strPulse = 'Pulse';
  static String strPulseValue = 'PR bpm';

  static String strSystolicPressure = 'Systolic Pressure';
  static String strDiastolicPressure = 'Diastolic Pressure';
  static String strBPParams = 'systolic';
  static String strBPUNits = 'mmHg';
  static String strDiastolicParams = 'diastolic';

  static String strPressureValue = 'mmHg';
  static String strSysPulseValue = 'p/min';

  static String strErrorStringForDevices = 'Normal reading ranges between';

  static String strDoctorsEmpty = 'Please Enter Doctors Name';
  static String strFileEmpty = 'Please Enter File Name';
  static String strLabEmpty = 'Please Enter Lab Name';
  static String strIDEmpty = 'Please Select ID';
    static String strMemoEmpty = 'Please Enter Memo';


  static String strSugarLevelEmpty = 'Please Enter Sugar Level';

  static String strSystolicsEmpty = 'Please Enter Systolic Pressure';
  static String strDiastolicEmpty = 'Please Enter Diastolic Pressure';
  static String strPulseEmpty = 'Please Enter Pulse Value';

  static String strtemperatureEmpty = 'Please Enter Temperature Value';
  static String strWeightEmpty = 'Please Enter Weight ';

  static String strOxugenSaturationEmpty =
      'Please Enter Oxygen Saturation Value';

  //From senthil

  static String mobile_number = "Mobile Number";
  static String primary_number = "Same as primary number";
  static String name = "Name";
  static String relationship = "Relationship";
  static String email_address_optional = "Emai Address (Optional)";
  static String gender = "Gender";
  static String blood_group = "Blood Group";
  static String blood_range = "+";
  static String date_of_birth = "Date of Birth";
  static String user_linking = 'user_linking';

  static String add = 'Add';
  static String save = 'Save';
  static String update = 'Update';
  static String send_otp = "Send OTP";

  static String verify_otp = "Verify OTP";
  static String add_family_otp = "Add Family OTP";

  static String delink_alert = "Are you sure you want to Remove/De-Link?";
  static String my_family = 'MyFamily';
  static String user_update = 'Profile Update';

  static String all_fields = 'Please fill all the fields';

  static String view_insurance = 'View Insurance';

  static String view_hospital = 'View Hospital';

  static String my_family_title = 'My Family';

  static String insurance = 'Insurance';

  static String add_providers = 'Add Providers';

  static String preferred_providers =
      'We allow only one preferred provider for a user. To remove your preference, please set another Provider as Preferred.';

  static String app_name = "myFHB";
  static String preferred_providers_descrip =
      "Do you want to ser this as preferred. Previous preferred will be updated";

  static String all_fields_mandatory = 'Please fill all Mandatory fields';

  static String mobile_numberWithStar = "Mobile Number*";
  static String relationshipWithStar = "Relationship*";
  static String genderWithStar = "Gender*";
  static String blood_groupWithStar = "Blood Group*";
  static String blood_rangeWithStar = "RH Type*";
  static String date_of_birthWithStar = "Date of Birth*";
  static String firstNameWithStar = "FirstName*";
  static String middleNameWithStar = "MiddleName*";
  static String lastNameWithStar = "LastName*";

  //===========================================//

  static String strOperationSignUp = 'signUp';

  static String detecting_the_devices = 'Detecting the devices....';
  static String not_finding_devices =
      'We could not find the device you are looking for. Would you like to choose the device?';
  static String reading_digits = 'Reading the digits from your image';

  //===========================================//
  /**
   * Edited by parvathi on 26 march 2020 for implemting SI based on country
   */

  static String firstName = "FirstName";
  static String middleName = "MiddleName";
  static String lastName = "LastName";

  static String KEY_COUNTRYCODE = 'CountryCode';
  static String KEY_COUNTRYNAME = 'CountryName';

  static String KEY_COUNTRYMETRICS = 'CountryMetrics';

  static String STR_RHTYPE='Rh type';


  static final CommonConstants _instance = new CommonConstants.internal();
  static CountryMetrics countryMetrics;
  static UnitsMesurements unitsMeasurements;

  factory CommonConstants() => _instance;

  Future<CountryMetrics> getCountryMetrics() async {
    if (countryMetrics != null) return countryMetrics;
    countryMetrics = await setCountryMetrics();
    return countryMetrics;
  }

  CommonConstants.internal();

  Future<CountryMetrics> setCountryMetrics() async {
    var db = new DatabaseHelper();
    CountryMetrics countryMetrics = await db.getCustomer(
        PreferenceUtil.getIntValue(CommonConstants.KEY_COUNTRYCODE));

    return countryMetrics;
  }

  Future<UnitsMesurements> getValuesForUnit(String units) async {
    var db = new DatabaseHelper();

    unitsMeasurements = await db.getMeasurementsBasedOnUnits(units);

    

    return unitsMeasurements;
  }

  String get bpSPUNIT => countryMetrics.bpSPUnit;
  String get bpDPUNIT => countryMetrics.bpDPUnit;
  String get bpPulseUNIT => countryMetrics.bpPulseUnit;
  String get glucometerUNIT => countryMetrics.glucometerUnit;
  String get poOxySatUNIT => countryMetrics.poOxySatUnit;
  String get poPulseUNIT => countryMetrics.poPulseUnit;
  String get tempUNIT => countryMetrics.tempUnit;
  String get weightUNIT => countryMetrics.weightUnit;
}

class ImageUrlUtils {
  static String avatarImg = 'assets/user/avatar.png';
  static String backImg = 'assets/icons/back.png';
  static String bookmarkedImg = 'assets/providers/bookmarked.png';
  static String markerImg = 'assets/providers/marker.png';
  static String fileImg = 'assets/providers/file.png';
  static String locationImg = 'assets/providers/location.png';
  static String otpVerifyImg = 'assets/icons/otp_icon.png';
  static String photoImg = 'assets/user/avatar.png';
}

class GoogleApiKey {
  static String place_key = CommonUtil.GOOGLE_PLACE_API_KEY;
}
