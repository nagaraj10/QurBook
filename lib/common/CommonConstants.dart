import 'CommonUtil.dart';
import 'PreferenceUtil.dart';
import '../database/model/CountryMetrics.dart';
import '../database/model/UnitsMesurement.dart';
import '../database/services/database_helper.dart';

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
  static const String categoryDescriptionNotes = 'Catcode013';
  static const String categoryDescriptionHospitalDocument = 'Catcode014';

  static const String CAT_JSON_GLUCOMETER = 'Catcode002_Typecode001';
  static const String CAT_JSON_BP_METER = 'Catcode002_Typecode002';
  static const String CAT_JSON_THERMOMETER = 'Catcode002_Typecode003';
  static const String CAT_JSON_WEIGHTING_SCALE = 'Catcode002_Typecode004';
  static const String CAT_JSON_OXIMETER = 'Catcode002_Typecode005';
  static const String CAT_JSON_PRESCRIPTION = 'Catcode001_Typecode001';
  static const String CAT_JSON_MEDICAL_REPORT = 'Catcode004_Typecode001';
  static const String CAT_JSON_LAB = 'Catcode003_Typecode001';
  static const String CAT_JSON_BILLS = 'Catcode005_Typecode001';
  static const String CAT_JSON_ID_DOC = 'Catcode006_Typecode001';
  static const String CAT_JSON_Voice = 'Catcode010_Typecode001';
  static const String CAT_JSON_OTHERS = 'Catcode007_Typecode001';
  static const String CAT_JSON_WEARABLES = 'Catcode008_Typecode001';
  static const String CAT_JSON_OTHERID = 'Catcode006_Typecode003';
  static const String CAT_JSON_INSURANCE = 'Catcode006_Typecode002';
  static const String CAT_JSON_FEEDBACK = 'Catcode009_Typecode001';
  static const String CAT_JSON_HOSPITAL = 'Catcode006_Typecode001';

  static String appVersion = 'default app version';
  static String serach_specific_list = 'Search Specific List';

  static const String STR_BP_MONITOR = 'Blood Pressure';
  static const String STR_GLUCOMETER = 'Glucometer';
  static const String STR_THERMOMETER = 'Thermometer';
  static const String STR_PULSE_OXIDOMETER = 'Pulse Oximeter';
  static const String STR_WEIGHING_SCALE = 'Weighing Scale';

  /// KeyWords tp save prefernce values,error dipslay
  static String keyDoctor = 'Doctors';
  static String keyHospital = 'Hospitals';
  static String keyLab = 'Lab';

  /// Following are the constants string used as hint text for the pop
  /// box that appears when a card is saved
  //static String strMessage = 'Message';
  static String strDateOfVisit = 'Date of visit *';
  static String strHospitalName = 'Hospital Name *';
  static String strHospitalNameWithoutStar = 'Hospital Name ';
  static String strFileName = 'File Name *';
  static String strDoctorsName = 'Doctor Name *';
  static String strSave = 'Save';
  static String strLabName = 'Lab Name *';

  /// STring for Signin the app
  static String strTrident = 'tridentApp';
  static String strOperationSignIN = 'signIn';
  static String strTridentValue = 'trident';

  static String searchPlaces = 'Search Places';
  static String comingSoon = 'Coming Soon';

  static String search = 'Search';

  static String fromClass = 'My Providers';

  static String doctors = 'Doctors';
  static String hospitals = 'Hospitals';
  static String labs = 'Labs';

  static String my_providers_plan = 'My Providers Plan';
  static String all_free_plans = 'All Free Plans';

  static String myProviders = 'My Providers';
  static String locate_your = 'Locate your ';
  static String confirm_location = 'Confirm Location';

  static String strGlucometerValue = 'mg/dL';
  static String strValue = 'Value';
  static String strMemo = 'Memo (500)';
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
  static String strWeightUnit = 'kg';

  static String strOxygenSaturation = 'Spo2';
  static String strOxygenValue = '%spo2';
  static String strOxygenParams = 'oxygenSaturation';
  static String strOxygenParamsName = 'spo2';
  static String strOxygenUnits = '%sp02';
  static String strOxygenUnitsName = '%';
  static String strPulseRate = 'pulseRate';
  static String strPulseUnit = 'PUL/min';

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
  static String strMemoCrossedLimit =
      'Memo length has crossed the limit of 500 characters';

  static String strSugarLevelEmpty = 'Please enter sugar level';
  static String strSugarFasting = 'Please select fasting';

  static String strSystolicsEmpty = 'Please enter systolic pressure';
  static String strDiastolicEmpty = 'Please enter diastolic pressure';
  static String strPulseEmpty = 'Please enter pulse value';

  static String strtemperatureEmpty = 'Please enter temperature value';
  static String strWeightEmpty = 'Please enter weight ';

  static String strOxugenSaturationEmpty =
      'Please Enter Oxygen Saturation Value';

  static String strExpDateEmpty = 'Please Enter Expiry Date';

  //for claims
  static String strBillNameEmpty = 'Please Enter Bill Name';
  static String strBillDateEmpty = 'Please Enter Bill Date';
  static String strClaimAmtEmpty = 'Please Enter Claim Amount';

  //From senthil

  static String add_family = 'Add Family';
  static String mobile_number = 'Mobile Number';
  static String primary_number = 'Same as primary number';
  static String name = 'Name';
  static String relationship = 'Relationship';
  static String email_address_optional = 'Emai Address';
  static String gender = 'Gender';
  static String blood_group = 'Blood Group';
  static String blood_range = '+';
  static String date_of_birth = 'Date of Birth';
  static String year_of_birth_with_star = 'Year of Birth\t*';
  static String year_of_birth = 'Year of Birth';
  static String user_linking = 'user_linking';

  static String height = 'Height(cm)';
  static String weight = 'Weight(kg)';

  static String add = 'Add';
  static String save = 'Save';
  static String ok = 'OK';
  static String update = 'Update';
  static String send_otp = 'Send One Time Password';

  static String verify_otp = 'Verify One Time Password';
  static String add_family_otp = 'Add Family One Time Password';

  static String delink_alert = 'Are you sure you want to Remove/De-Link?';
  static String my_family = 'MyFamily';
  static String user_update = 'Profile Update';

  static String all_fields = 'Please fill all the fields';

  static String profile_update_fail = 'unable to add Family member';

  static String view_insurance = 'View Insurance';

  static String view_hospital = 'View Hospital';

  static String my_family_title = 'My Family';

  static String insurance = 'Insurance';

  static String add_providers = 'Add Providers';

  static String preferred_providers =
      'We allow only one preferred provider for a user. To remove your preference, please set another Provider as Preferred.';

  static String app_name = 'myFHB';
  static String preferred_providers_descrip =
      'Do you want to ser this as preferred. Previous preferred will be updated';

  static String all_fields_mandatory = 'Please fill all Mandatory fields';

  static String mobile_numberWithStar = 'Mobile Number*';
  static String relationshipWithStar = 'Relationship*';
  static String genderWithStar = 'Gender*';
  static String blood_groupWithStar = 'Blood Group*';
  static String blood_rangeWithStar = 'RH Type*';
  static String date_of_birthWithStar = 'Date of Birth*';
  static String firstNameWithStar = 'FirstName*';
  static String emailWithStar = 'Email Address*';
  static String emailWithoutStar = 'Email Address';

  static String middleNameWithStar = 'MiddleName*';
  static String lastNameWithStar = 'LastName*';
  static String exprityDate = 'Expiry Date*';
  static String heightName = 'Height(cm)';
  static String weightName = 'Weight(kg)';

  static String heightNameFeetInd = 'Height(ft)';
  static String heightNameInchInd = 'Height(in)';
  static String weightNameUS = 'Weight(lb)';

  static String preferredLanguage = 'Preferred Language';
  static String tags = 'Tags';

  static String specialization = 'Specialization';
  static String hospitalName = 'Hospital Name';
  static String hospitalNameWithStar = 'Hospital Name *';

  //===========================================//

  static String strOperationSignUp = 'signUp';

  static String detecting_the_devices = 'Detecting the devices....';
  static String not_finding_devices =
      'We could not find the device you are looking for. Would you like to choose the device?';
  static String reading_digits = 'Reading the digits from your image';

  //===========================================//
  /// Edited by parvathi on 26 march 2020 for implemting SI based on country

  static String firstName = 'FirstName';
  static String middleName = 'MiddleName';
  static String lastName = 'LastName';

  static const String addr_line_1 = 'Address line 1';
  static const String addr_line_2 = 'Address line 2';
  static const String addr_city = 'City*';
  static const String addr_state = 'State*';
  static const String addr_zip = 'Zipcode';
  static const String addr_pin = 'Pincode';

  static const String corpname = 'Membership offered by';

  static String KEY_COUNTRYCODE = 'CountryCode';
  static String KEY_COUNTRYNAME = 'CountryName';

  static String KEY_COUNTRYMETRICS = 'CountryMetrics';

  static String STR_RHTYPE = 'Rh type';

  static String SEARCH_HOSPIT_ID = 'HOSPTL';
  static String SEARCH_CLINIC_ID = 'CLINIC';
  static String SEARCH_LAB_ID = 'LAB';

  static final CommonConstants _instance = CommonConstants.internal();
  static CountryMetrics countryMetrics;
  static UnitsMesurements unitsMeasurements;

  static const String strQueryString = '?';
  static const String strGetProfilePic = 'section=profilePicture';
  static const String strUserQuery = 'user/';
  static const String strMicAlertMsg =
      'The Mic is currently in use by another app. Please try later';

  /// Color for devices
  static var bpDarkColor = 0xff059192;
  static var bplightColor = 0xff39c5c2;

  static var GlucoDarkColor = 0xffb70a80;
  static var GlucolightColor = 0xffb70a80;

  static var ThermoDarkColor = 0xffd95523;
  static var ThermolightColor = 0xffed7142;

  static var pulseDarkColor = 0xff8600bd;
  static var pulselightColor = 0xffb000f8;

  static var weightDarkColor = 0xff1abadd;
  static var weightlightColor = 0xff3ed4f5;

  // String for claim
  static String strBillName = 'Bill Name *';
  static String strClaimType = 'Claim Type *';
  static String strBillDate = 'Bill Date *';
  static String strCaregiverApproved = 'Caregiver Associated Successfully';
  static String strCaregiverFailed = 'Caregiver Association Failed';
  static String strClaimAmt = 'Claim Amount';
  static String strClaimAmtWithStar = 'Claim Amount *';
  static String strFamilyMember = 'Family Member *';

  //QurHub
  static String wifiName = 'Wi-Fi Name';
  static String password = 'Password';
  static String connect = 'Connect';
  static String retry = 'Retry';
  static String hubId = 'Hub ID';
  static String nickName = 'Nick Name';

  //for ticket Validation

  static String ticketTitle = 'Please fill ticket title';
  static String ticketDesc = 'Please fill Description';
  static String ticketDoctor = 'Please Select Doctor';
  static String ticketHospital = 'Please Select Hospital';
  static String ticketModeOfService = 'Please Select mode of service';
  static String ticketFile = 'Please Attach Files';
  static String ticketDate = 'Please Select Preferred Date';
  static String ticketTime = 'Please Select Preferred Time';
  static String ticketCategory = 'Please Select Plan Category';

  static String ticketPackage = 'Please fill Package Name';

  factory CommonConstants() => _instance;

  static bool showNotificationdialog = true;

  Future<CountryMetrics> getCountryMetrics() async {
    if (countryMetrics != null) return countryMetrics;
    countryMetrics = await setCountryMetrics();
    return countryMetrics;
  }

  CommonConstants.internal();

  Future<CountryMetrics> setCountryMetrics() async {
    final db = DatabaseHelper();
    final countryMetrics = await db.getCustomer(
        PreferenceUtil.getIntValue(CommonConstants.KEY_COUNTRYCODE));

    return countryMetrics;
  }

  Future<UnitsMesurements> getValuesForUnit(String units, String range) async {
    final db = DatabaseHelper();

    unitsMeasurements =
        await db.getMeasurementsBasedOnUnits(units, range ?? '');
    //print(unitsMeasurements.maxValue.toString()+"MAX"+unitsMeasurements.minValue.toString()+" MIN"+ "unitsMeasurements*************");
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

  static const String strId = 'id';
  static const String strName = 'name';
  static const String strCode = 'code';
  static const String strSuccess = 'isSuccess';
  static const String strResult = 'result';
  static const String strCodePhone = 'PHNTYP';

  static const String strReferenceValue = 'reference-value';
  static const String strDataCodes = 'data-codes';
  static const String strSlash = '/';
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
