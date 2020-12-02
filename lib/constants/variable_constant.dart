import 'dart:convert';

import 'package:flutter/services.dart';

const String strAPP_NAME = 'MyFHB';
const String strAppPackage = 'com.globalmantrainnovations.myfhb';
const String strHealthRecordChannel = 'Health Record channel';

//For class add_family_otp
//web service call
const String strSrcName = 'sourceName';
const String strCountryCode = 'countryCode';
const String strPhoneNumber = 'phoneNumber';
const String strOTP = 'otp';
const String strOperation = 'operation';

const String strVerifyOtp = 'Verifying OTP';
const String strOTPVerification = 'Otp Verification';
const String strEnterOtp = 'Please enter the received OTP';

const String strOtpIcon = 'assets/icons/otp_icon.png';

const String numOne = '1';
const String numTwo = '2';
const String numThree = '3';
const String numFour = '4';
const String numFive = '5';
const String numSix = '6';
const String numSeven = '7';
const String numEight = '8';
const String numNine = '9';
const String numZero = '0';

const String strError = 'Error';
const String strSuccessfully = 'Successfully';
const String strOTPMatched = 'Otp matched successfully.';
const String strSucess = 'Success';
const String strFamilySucess = 'Your family member has been added successfully';
const String strisPrimaryUser = 'isPrimaryUser';
const String strFirstName = 'firstName';
const String strMiddleName = 'middleName';
const String strLastName = 'lastName';
const String strRelation = 'relation';

//for the class add_family_user_info
const String strFetchRoles = 'Fetching Custom Roles';
const String strFetchProfile = 'Fetching User Profile';
const String strUpdatingProfile = 'Updating Profile';
const String strUpdateUserRelation = 'Updating User Relationship';
const String strUpdatedSelfProfile = 'Updating Self Profile';
const String strVerifyingMail = 'Verifying Mail';

List<String> bloodGroupArray = ['A', 'B', 'AB', 'O', 'UnKnown'];
List<String> genderArray = ['Male', 'Female', 'Others'];
List<String> bloodRangeArray = ['+ve', '-ve', 'UnKnown'];

const String Self = 'Self';
const String Delink = 'Delink';
const String Please_Wait = 'Please Wait';
const String parentToChild = 'parentToChild';
const String DeLink = 'De-Link';
const String Error = 'Error';
const String Success = 'Success';
const String Otp_Verification = 'Otp Verification';
const String enter_otp = 'Please enter the received OTP';
const String Successfully = 'Successfully';
const String OTP_Matched = 'Otp matched successfully';
const String Family_Member_Added =
    'Your family member has been added successfully';
const String VerifyEmail = 'Tap to verify Email address';

const String Family_Detail_Route = '/my-family-detail-screen';
const String addFamilyUserInfo = '/add-family-user-info';
const String addFamilyOtpScreen = '/add-family-otp-screen';
const String search_providers = '/search-providers';

const String enterFirstName = 'Enter First Name';
const String enterLastName = 'Enter Last Name';
const String selectGender = 'Select Gender';
const String selectDOB = 'Select DOB';
const String selectRHType = 'Select Rh type';
const String selectBloodGroup = 'Select Blood group';

const String makeAChoice = 'Make a Choice!';
const String Gallery = 'Gallery';
const String Camera = 'Camera';
const String Associated_Member = 'Associated Member';
const String Switch_User = 'Switch User';
const String Set_as_Preferred = 'Set as Preferred';

const String Add = 'Add';
const String Update = 'Update';
const String Cancel = 'Cancel';
const String add_providers = 'add_providers';
const String choose_address = 'Please choose the address';
const String cancer_speciality = 'Cancer Speciality Hospital';
const String apollo_email = 'apollo@sample.com';
const String preferred_descrip =
    'We allow only one preferred provider for a user. To remove your preference, please set another Provider as Preferred.';

//for the class add_provider
const String strAddingDoctors = 'Adding doctors';
const String strAddingHospital = 'Adding Hospitals';
const String strAddingLab = 'Adding laboratory';

const String strUpdatingDoctor = 'Updating doctor';
const String strUpdatingHospital = 'Updating Hospital';
const String strUpdatingLab = 'Updating Laboratory';

const String strAssociateMember = 'Associated Member';
const String strName = 'name';
const String strSpecialization = 'specialization';
const String strDescription = 'description';
const String strCity = 'city';
const String strState = 'state';
const String strPhoneNumbers = 'phoneNumbers';
const String strEmail = 'email';
const String strIsUserDefined = 'isUserDefined';
const String straddressLine1 = 'addressLine1';
const String straddressLine2 = 'addressLine2';
const String strzipCode = 'zipCode';
const String strbranch = 'branch';
const String strwebsite = 'website';
const String strgoogleMapUrl = 'googleMapUrl';
const String strLatitude = 'latitude';
const String strLongitute = 'longitude';

const String strCallDoctors = 'doctors/';
const String strCallHospital = 'hospitals/';
const String strCallLab = 'laboratories/';

//ForIcons

const String icon_fhb = 'assets/launcher/myfhb.png';
const String icon_attach = 'assets/icons/attach.png';
const String icon_maya = 'assets/maya/maya_us.png';
const String icon_wifi = 'assets/icons/wifi.png';
const String icon_mayaMain = 'assets/maya/maya_us_main.png';
const String icon_faq = 'assets/navicons/faq.png';
const String icon_feedback = 'assets/navicons/feedback.png';
const String icon_term = 'assets/settings/terms.png';
const String icon_privacy = 'assets/settings/privacy.png';
const String icon_record_fav = 'assets/icons/record_fav.png';
const String icon_record_fav_active = 'assets/icons/record_fav_active.png';
const String icon_record_switch = 'assets/icons/record_switch.png';
const String icon_edit = 'assets/icons/record_edit.png';
const String icon_download = 'assets/icons/record_download.png';
const String icon_delete = 'assets/icons/record_delete.png';
const String icon_stetho = 'assets/icons/stetho.png';
const String icon_otp = 'assets/icons/otp_icon.png';
const String icon_multi = 'assets/icons/img_multi.png';
const String icon_image_single = 'assets/icons/img_single.png';
const String icon_digit_reco = 'assets/settings/digit_recognition.png';
const String icon_device_recon = 'assets/settings/device_recognition.png';
const String icon_provider = 'assets/navicons/my_providers.png';
const String icon_records = 'assets/navicons/records.png';
const String icon_chat = 'assets/navicons/chat.png';
const String icon_digit_googleFit = 'assets/settings/googlefit.png';
const String icon_th = 'assets/navicons/th.png';
const String icon_home = 'assets/navicons/home.png';
const String icon_schedule = 'assets/navicons/schedule.png';
const String icon_profile = 'assets/navicons/ic_profile_two.png';
const String icon_more = 'assets/navicons/more.png';

//For Apple Health Settings Info
const String apple_health_settings_info = 'assets/settings/health.jpg';
const String strUnderstood = 'Understood';

//for File
const String file_privacy = 'assets/help_docs/myfhb_privacy_policy.html';
const String file_img_jpg = 'image/jpg';
const String file_img_png = 'image/png';
const String file_img_all = 'image/*';
const String file_audio_mp = 'audio/mp3';
const String file_terms = 'assets/help_docs/myfhb_terms_of_use.html';
const String file_faq = 'assets/help_docs/myfhb_faq.html';

//for Family Font
const String font_poppins = 'Poppins';
const String font_roboto = 'Roboto';

//for class bookmark_record
const String strBookmarkRecord = 'bookmark record';

//for feedback
const String strChat = 'Chat';
const String strFeedBack = 'Feedback';
const String strFeedbackExp =
    'We would like to hear from you on your experience with MyFHB';
const String strAttachImage = 'Attach Image';
const String strAddVoice = 'Add Voice';
const String strcategoryInfo = 'categoryInfo';
const String strmediaTypeInfo = 'mediaTypeInfo';
const String strfeedback = 'feedback';
const String strmemoText = 'memoText';
const String strisDraft = 'isDraft';
const String strsourceName = 'sourceName';
const String strmemoTextRaw = 'memoTextRaw';
const String strfileName = 'fileName';
const String strmetaInfo = 'metaInfo';
const String strmediaMetaId = 'mediaMetaId';
const String strFeedbackEmpty = 'Feedback should not be empty';

//for feedback success
const String strFeedThank = 'Thank  you for your feedback';

//for global search
const String strSearching = 'Searching';
const String strNoInternet = 'No internet connection';
const String strBackOnline = 'back to online';
const String strNoConnection = 'no connection';
const String strve = 've';

//for audioWidget

List<String> assetSample = [
  'assets/samples/sample.aac',
  'assets/samples/sample.mp3',
  'assets/samples/sample.opus',
  'assets/samples/sample.caf',
  'assets/samples/sample.mp3',
  'assets/samples/sample.ogg',
  'assets/samples/sample.wav',
];

//for Menu Screen

List<String> mayaAssets = [
  'assets/maya/maya_us_main',
  'assets/maya/maya_india_main',
  'assets/maya/maya_africa_main',
  'assets/maya/maya_arab_main',
];

List<int> myThemes = [
  0xff015eea,
  0xffcf4791,
  0xff0483df,
  0xff118c94,
  0xff17a597,
];

List<int> myGradient = [
  0xff00c0fa,
  0xfffab273,
  0xff01bbd4,
  0xff0cbcb6,
  0xff84ce6b
];

const String strSettings = 'Settings';
const String strHelp = 'Help and support';
const String strPrivacy = 'Privacy policy';
const String strRateus = 'Rate us';
const String strMaya = 'Sheela';
const String strMAYA = 'SHEELA';

const String strColorPalete = 'Color palette';

// for my family

const String strFetchFamily = 'Fetching family details';
const String strPostUserLink = 'posting user link';
const String strPostuserDelink = 'posting user delink';
const String strSomethingWrong = 'Oops, something went wrong';
const String strAddFamily = 'Add new family member';
const String strNoFamily = 'No family members added yet';
const String strrelatedTo = 'relatedTo';
const String strrelationshipType = 'relationshipType';
const String strparentToChild = 'parentToChild';

//for myFamilyDetails
const String strDateYear = '"yyyy-MM-dd"';
const String strFetchingHealth = 'Getting Health Report';
const String strFetchCategory = 'Fetching Category';
const String strNodata = 'No Data Available';
const String strValidThru = 'Valid thru - ';

//for myProviders

const String strFetchMedicalPrefernces = 'Fetching preferences';

//for myFHB Webview
const String strtexthtml = 'text/html';
const String strUtf = 'utf-8';

//for notification
const String strNotifications = 'Notifications';
const String strNoNotification = 'No notifications';

//for Record Detail
const String strDeletingRecords = 'Deleting Records';
const String strAddVoiceNote = 'Add voice note';
const String strDownloadStart = 'Download Started';
const String strFilesDownloaded = 'All Files are downloaded, view in Gallery';
const String strFilesView = 'File downloaded, view in Gallery';
const String strFileDownloaded = 'File downloaded';
const String strFilesErrorDownload = 'Error in File download.';
const String strAfter = 'After';
const String strDateFormatDay = 'dd/MM/yyyy';

const String stAudioPath = 'myFHB/Audio';
const String strDateOfVisit = 'Date of visit: ';

//for Add remainder
List<String> selectedInterval = ['Day', 'Week', 'Month'];
const String strUpdateRemainder = 'Update Reminder';
const String strAddRemainder = 'Add Reminder';
const String strTitle = 'Title';
const String strTitleEmpty = 'Title can\'t be Empty';
const String strNote = 'Notes';
const String strNoteEmpty = 'Notes can\'t be Empty';
const String strRemindMe = 'Remind me';
const String strRepeatedInterval = 'Repeated interval';
const String strDaily = 'Daily';
const String strWeekly = 'Weekly';
const String strMonthly = 'Monthly';
const String strremainder = 'reminders';
const String strSunday = 'Sunday';
const String strMonday = 'Monday';
const String strTuesday = 'Tuesday';
const String strWednesday = 'Wednesday';
const String strThursday = 'Thursday';
const String strFriday = 'Friday';
const String strSaturday = 'Saturday';
const String strPM = 'PM';
const String strDay = 'Day';
const String strWeek = 'Week';
const String strMonth = 'Month';
const String strUpate = 'Update';
const String strSave = 'Save';
const String strFormatEE = 'EEEE';

//for my appointments
const String strDr = 'Dr.';
const String strLoadWait = 'Loading...';

//for my remainder
const String dateFormatMMY = 'E d MMM, yyyy';

//for my schedules
const String strAppointments = 'Appointments';
const String strRemainders = 'Reminders';

// for search providers

const String strGetDoctorsList = 'Getting Doctor List';
const String strGetDoctorById = 'Getting Doctor by Id';

const String strGetHospitalList = 'getting Hospital List';
const String strGetHospitalById = 'Getting Hospital by Id';

const String strGetLabList = 'Getting Laboratory List';
const String strGetLabById = 'Getting laboratoty by Id';

const String strSearch = 'Search';
const String strNoLoadtabls = 'Unable To load Tabs';

const String strSignUp = 'Sign Up';
const String strCreateuser = 'Creating User';
const String strSignOut = 'Signing Out';

const String strVerifyingOtp = 'Verifying OTP';
const String strGeneratingOtp = 'Generating OTP';

const String strGettingCategory = 'Getting Category List';
const String strGettingHealthRecords = 'Getting Health Records';
const String strSubmitting = 'Submitting ';
const String strSavingImg = 'Saving Image';
const String strMoveData = 'Moving data';
const String strUpdateData = 'Updating Data';
const String strgetMediaTypes = 'Getting Media Types';
const String strGetProfileData = 'Getting ProfileData';

String authToken;

const String straccept = 'accept';
const String strContentType = 'Content-Type';
const String strAuthorization = 'Authorization';
const String strAcceptVal = 'application/json';
const String strcntVal = 'multipart/form-data';
const String strcontenttype = 'content-type';

const String strErrComm =
    'Error occured while Communication with Server with StatusCode :';
const String strauthorization = 'authorization';
const String strMessage = 'Message';
const String strlogInDeviceOthr = 'Logged into other Device';

//string for netwrok error

const String err_comm = 'Error During Communication: ';
const String err_invalid_req = 'Invalid Request:';
const String err_unauthorized = 'Unauthorised:';
const String err_invalid_input = 'Invalid Input:';

//for audio record screen

const String strStartTime = '00:00';
const String strDatems = 'mm:ss';
const String strenUs = 'en_US';
const String strStartrecord = 'Start Recording';
const String strStopRecord = 'Stop Recording';
const String strVoiceRecord = 'Voice Record';

// for otp Verify screen
const String strOtpVerification = 'OTP Verification';
const String strPlsEnterotpReceived = 'Please enter the OTP received';
const String strEnterotpReceived = 'Enter the OTP received at';
const String strdidtReceive = 'Didn\'t receive the OTP?';
const String strResendCode = 'Resend Code';
const String strAgree = 'By completing Sign Up, you agree to our ';
const String strTermService = 'Terms of Service';
const String strAnd = ' and ';
const String strPrivacyPolicy = 'Privacy Policy';

// for signIn

const String strwelcome = 'Welcome';
const String strgetStart = 'Get started with myFHB';
const String strNext = 'NEXT';

// for Sign Up
const String strMobileNum = 'Mobile Number';
const String strEmailOpt = 'Email address';
const String strSendOtp = 'Send OTP';
const String strEmailAddress = 'Email address';

List<String> genderList = ['Male', 'Female', 'Others'];
const String strEnterMobileNum = 'Enter MobileNumber';
const String strEnterFirstname = 'Enter First Name';
const String strEnterLastName = 'Enter LastName';

const voice_platform = const MethodChannel('flutter.native/voiceIntent');
const version_platform = const MethodChannel('flutter.native/versioncode');
const tts_platform = const MethodChannel('flutter.native/textToSpeech');
const security = const MethodChannel('flutter.native/security');
const String strWaitLoading = 'wait! Its loading';

const String _wordsFromMaya = 'waiting for maya to speak';
const String strhiMaya = 'Hi Sheela Ji';
const String strtts = 'textToSpeech';
const String strtapToSpeak = 'Tap to Speak';

const String strspeakAssistant = 'speakWithVoiceAssistant';
const String strdevice = 'device';

const String strIntromaya = 'Hi, I am Sheela your voice health assistant.';
const String strTapMaya = 'Tap me and invoke. Lets converse';
const String strpdf = 'pdf';
const String strCropper = 'Cropper';
const String strCropping = 'cropping...';

List<String> documentList = ['Hospital IDS', 'Insurance IDs', 'Other IDs'];
const String strFalse = 'false';
const String strSkip = 'Skip';
const String strImgNtClear = 'Image not clear';

//for device screen
const String strGlucUnit = 'mgdl';
const String strbfood = 'Before Food';
const String strafood = 'After Food';
const String strpulseUnit = '%spo2';
const String strpulse = 'pulse';
const String strbpunit = 'mmHg';
const String strbpdp = 'dp';

const String strBefore = 'Before';
const String strNo = 'No';

const String strdflit = 'assets/device_detection.tflite';
const String file_device = "assets/devicelabels.txt";
const String strOthers = 'Others';
const String strDeviceFound = 'We find the device is';
const String strChoose = 'Choose';
const String strYES = 'YES';
const String strNO = 'NO';
const String strConfirm = 'Confirm';

const String strBP = 'BP';
const String strWS = 'WS';
const String strDT = 'DT';
const String strPO = 'PO';
const String strGL = 'GL';

const String strBPMonitor = 'BP Monitor';
const String strWeighingScale = 'Weighing Scale';
const String strThermo = 'Thermometer';

const String strtrue = 'true';
const String strAllowDigit = 'Allow digit recognition';
const String strScanDevices = 'scans for the values from device images';
const String strAllowDevice = 'Allow device recognition';
const String strScanAuto = 'scans and auto-detects devices';

//for healthKit and googleFit activation and sync
const String strGoogleFit = "Google Fit";
const String strAllowGoogle = "Allow app to recieve data from google Fit";
const String strHealthKit = "Apple Health";
const String strAllowHealth = "Allow app to recieve data from Apple Health";
const String strAddDevice = 'Tap to add device widgets to your home screen';

//for homescreen and dashboard
const String strMyInfo = 'My Info';
const String strMyFamily = 'My Family';
const String strMyProvider = 'My Provider';
const String strExtImg = '.png';
const String strTelehealth = 'TeleHealth';
const String strMyRecords = 'My Records';
const String strhome = 'Home';
const String strSchedule = 'Schedules';
const String strProfile = 'Profile';
const String strMore = 'More';
const String strClose = 'Close';

//introslider

List<String> slideIcons = [
  'assets/slide_icons/slide1.png',
  'assets/slide_icons/slide2.png',
  'assets/slide_icons/slide3.png',
  'assets/slide_icons/slide4.png',
  'assets/slide_icons/slide5.png'
];
const String strDONE = 'DONE';
const String strSKIP = 'SKIP';

const String strSearchRecords = 'Search your records';
const String strOK = 'OK';
const String strCANCEL = 'CANCEL';
const String strOKAY = 'OKAY';
const String strValidPhoneNumber = 'Enter a valid mobile number';
const String strGetAppVersion = 'getAppVersion';
const String strSecure = 'secureMe';
const String strpop = 'SystemNavigator.pop';
const String strFailed = 'Failed to Invoke: ';

const String strformateedAddress = 'formateedAddress';
const String strformateedPhoneNumber = 'formateedPhoneNumber';
const String st_pausedplayer = 'paused player';

const String strNoData = 'No data Available';
const String strViewPDF = 'View PDF';
const String strLogout = 'Logout';
const String strLogoutMsg =
    'Stay Healthy.. See you Soon. \nSheela will be waiting to serve you.';
const String strYes = 'Yes';
const String strRelaoding = 'Reloading';
const String strStartNow = 'Start now';
const String strAccounts = 'Accounts';
const String strDevices = 'Devices';

const String strLauncher = '@mipmap/ic_launcher';

const String video_splash = 'assets/video/splash_video.mp4';
const String strRs = 'Rs';

//webcognito
const source = 'myFHB';
const sourceCode = "e13019a4-1446-441b-8af1-72c40c725548";
const entityCode = "28858877-4710-4dd3-899f-0efe0e9255db";
const roleCode = "285bbe41-3030-4b0e-b914-00e404a77032";
const redirecturl = 'http://localhost:4200/callback?code=';
const String strNoDoctordata = 'No Doctor List Available';
const String strNoHospitaldata = 'No Hospital List Available';
const String strNoAppointments = 'No Appoinments Available';

const String strNoDataAvailable = 'Unable To load';
const String strHealthOrganizationName = 'healthOrganizationName';

const String EMAIL_REGEXP =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{​​​​​|}​​​​​~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

const String c_chat_with_whatsapp = 'Chat with Us';
const String c_chat_with_whatsapp_begin_conv = 'Hi';
const String c_qurhealth_helpline = '919566200555';
const String icon_whatsapp = 'assets/icons/ic_whatsapp.png';

//decode code
Map<String, dynamic> parseJwtPayLoad(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }
  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }
  return payloadMap;
}

Map<String, dynamic> parseSignUpJwtPayLoad(String token) {
  final payload = _decodeBase64(token);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }
  return payloadMap;
}

Map<String, dynamic> parseJwtHeader(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }
  final payload = _decodeBase64(parts[0]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }
  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');
  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }
  return utf8.decode(base64Url.decode(output));
}
