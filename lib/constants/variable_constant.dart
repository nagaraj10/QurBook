import 'dart:convert';

import 'package:flutter/services.dart';

const String strAPP_NAME = 'QurBook';
const String strAppPackage =
    'com.ventechsolutions.myFHB'; //'com.globalmantrainnovations.myfhb';
const String strHealthRecordChannel = 'Health Record channel';
const String iOSAppId = '1526444520';
const String iOSAppStoreLink =
    'https://apps.apple.com/in/app/qurbook/id1526444520';
//For class add_family_otp
//web service call
const String strSrcName = 'sourceName';
const String strCountryCode = 'countryCode';
const String strPhoneNumber = 'phoneNumber';
const String strOTP = 'otp';
const String strOperation = 'operation';

const String strVerifyOtp = 'Verifying One Time Password';
const String strOTPVerification = 'One Time Password Verification';
const String strEnterOtp = 'Please enter the received One Time Password';

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
const String strDisableTeleconsulting =
    "Provider that you selected hasn't enrolled for teleconsulting service, we will onboard your doctor shortly";
const String unPairingHub =
    'Unmapping your QurHub router will lose connection to all your mapped devices and you\'ll not be able to connect again. Are you sure you want to do this?';
const String unPairDevice = 'Are you sure you want to unpair the device?';
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

List<String> claimType = ['Pharmacy', 'Consultation', 'Lab fee'];

const String Self = 'Self';
const String Delink = 'Delink';
const String Please_Wait = 'Please Wait';
const String parentToChild = 'parentToChild';
const String stringUpdateCart = 'Update Cart';
const String DeLink = 'De-Link';
const String Error = 'Error';
const String Success = 'Success';
const String Otp_Verification = 'Otp Verification';
const String enter_otp = 'Please enter the received One Time Password';
const String Successfully = 'Successfully';
const String OTP_Matched = 'One Time Password matched successfully';
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
const String selectYOB = 'Enter year of birth';
const String selectDateOfBirth = 'Enter Date of birth';
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
const String bookAnAppointment = 'Book an appointment';
const String add_providers = 'add_providers';
const String choose_address = 'Please choose the address';
const String cancer_speciality = 'Cancer Speciality Hospital';
const String request_sent_successfully = 'Request sent successfully';
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

const String icon_camera_image = 'assets/icons/camera_image.png';
const String icon_sheela_queue = 'assets/icons/sheela_queue.gif';
const String icon_delete_image = 'assets/icons/delete_image.png';
const String icon_edit_image = 'assets/icons/edit.png';
const String icon_photo_image = 'assets/icons/photo_image.png';
const String icon_save_image = 'assets/icons/save_image.png';
const String icon_qurhome = 'assets/Qurhome/Qurhome.png';
const String icon_calendar = 'assets/Qurhome/calendar.png';
const String icon_device_scan_measure = 'assets/Qurhome/scan_search_device.gif';
const String icon_vitals_qurhome = 'assets/dashboard/vitals_qurhome.png';
const String icon_symptom_qurhome = 'assets/dashboard/symptom_qurhome.png';
const String icon_languageIntro = 'assets/IntroScreensImages/Intro01.png';
const String icon_qurplanIntro = 'assets/IntroScreensImages/Intro03.png';
const String icon_ReminderIntro = 'assets/IntroScreensImages/Intro05.png';
const String icon_SheelaIntro = 'assets/IntroScreensImages/Intro02.png';
const String icon_TrustedAnswerIntro = 'assets/IntroScreensImages/Intro04.png';
const String icon_StickPlanIntro = 'assets/IntroScreensImages/common.png';
const String icon_fhb = 'assets/launcher/myfhb.png';
const String icon_splash_logo = 'assets/launcher/myfhb.png';
const String icon_attach = 'assets/icons/attach.png';
const String icon_maya = 'assets/maya/maya_us_main.png';
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
const String icon_dateTime = 'assets/icons/datetime.svg';
const String icon_chooseDoctor = 'assets/icons/choose_doctor.svg';
const String icon_modeOfService = 'assets/icons/mode_of_service.svg';
const String icon_information = 'assets/icons/information.svg';
const String icon_otp = 'assets/icons/otp_icon.png';
const String icon_multi = 'assets/icons/img_multi.png';
const String icon_image_single = 'assets/icons/img_single.png';
const String icon_digit_reco = 'assets/settings/digit_recognition.png';
const String icon_device_recon = 'assets/settings/device_recognition.png';
const String icon_provider = 'assets/navicons/my_providers.png';
const String icon_orderHistory = 'assets/navicons/orderHistory.png';
const String icon_lock = 'assets/settings/unlock.png';
const String lock_icon = 'assets/lock_icon.png';
const String remove_user = 'assets/settings/remove_user.png';
const String icon_voice_cloning =
    'assets/settings/icon_voicecloning.png'; //path where voice clon icon is placed
const String icon_mic_icon =
    'assets/settings/mic_icon.png'; //path where voice clon icon is placed

const String icon_records = 'assets/navicons/records.png';
const String icon_chat = 'assets/navicons/chat.png';
const String icon_digit_googleFit = 'assets/settings/googlefit.png';
const String icon_th = 'assets/navicons/th.png';
const String icon_home = 'assets/navicons/home.png';
const String icon_schedule = 'assets/navicons/schedule.png';
const String icon_profile = 'assets/navicons/ic_profile_two.png';
const String icon_more = 'assets/navicons/more.png';
const String icon_no_internet = 'assets/no_internet.png';
const String icon_something_wrong = 'assets/something-wrong.png';
const String icon_refresh_dash = 'assets/icons/refresh_dash.png';
const String icon_appointment_regimen = 'assets/icons/appointment_regimen.png';
const String icon_undo = 'assets/icons/ic_undo.png';
const String icon_undo_reg = 'assets/icons/ic_undo_reg.png';
const String icon_view_eye = 'assets/icons/ic_view_eye.png';
const String icon_switch = 'assets/icons/icon_switch.png';

const String icon_ok = 'assets/icons/ic_ok.png';
const String icon_escalate = 'assets/icons/ic_escalate.png';
const String icon_call_cg = 'assets/icons/ic_call.png';
const String icon_discard = 'assets/icons/ic_discard.png';

//Dashboard
const String icon_call = 'assets/dashboard/call.svg';
const String icon_chat_dash = 'assets/dashboard/chat.svg';
const String icon_check_symptoms = 'assets/dashboard/check-symptoms.svg';
const String icon_how_to_use = 'assets/dashboard/how-to-use.svg';
const String icon_service = 'assets/dashboard/services_icon.svg';
const String icon_my_family = 'assets/dashboard/my-family.svg';
const String icon_qurhub = 'assets/dashboard/qurhub.svg';
const String icon_connected_device = 'assets/dashboard/connected_device.svg';
const String icon_qr_code = 'assets/icons/qr_code.png';
const String icon_my_family_menu = 'assets/dashboard/my-family-old.svg';
const String icon_my_health_regimen = 'assets/dashboard/my-health-regimen.svg';
const String icon_refer_friend_icon = 'assets/icons/refer_a_friend.png';
const String icon_report_icon = 'assets/icons/report_icon.png';
const String icon_help_support = 'assets/icons/help_support.png';
const String icon_dashboardCard = 'assets/Qurhome/QurhomeCard.svg';

const String icon_my_plan = 'assets/dashboard/my-plan.svg';
const String icon_my_providers = 'assets/dashboard/my-providers.svg';
const String icon_record_my_vitals = 'assets/dashboard/record-my-vitals.svg';
const String icon_logout = 'assets/icons/logout.svg';
const String icon_settings = 'assets/icons/settings.svg';
const String icon_modified = 'assets/icons/modified.svg';
const String icon_mandatory = 'assets/icons/mandatory.svg';
const String icon_language = 'assets/icons/language.png';
const String icon_claim = 'assets/icons/claim.svg';
const String icon_IndianFlag = 'assets/icons/India_flag.png';
const String icon_USAFlag = 'assets/icons/USA_flag.png';

//icons for troubleshooting
const String icon_tsFail = 'assets/icons/icon_ts_fail.png';
const String icon_tsSuccess = 'assets/icons/icon_ts_success.png';
const String icon_tsUncheck = 'assets/icons/icon_ts_uncheck.png';
const String icon_tsCheck = 'assets/icons/icon_ts_check.png';
const String icon_network = 'assets/icons/icon_network.png';
const String icon_location = 'assets/icons/icon_location.png';
const String icon_validity = 'assets/icons/icon_validity.png';
const String icon_compatibilty = 'assets/icons/icon_compatibility.png';
const String icon_camera = 'assets/devices/camera.png';

// Define a constant string representing the file path for the 'choose_lab.svg' icon
const String icon_choose_lab = 'assets/icons/choose_lab.svg';

// Define a constant string representing the file path for the 'ic_address.svg' icon
const String icon_address = 'assets/icons/ic_address.svg';

//string for troubleshooting
const String strAppCompatibilty = 'App compatibility';
const String strSDKCompatibilty = 'SDK compatibility';
const String strStorage = 'Storage';

const String strBluetooth = 'Bluetooth';
const String strCamera = 'Camera';
const String strMicrophone = 'Microphone';
const String strLocation = 'Location';
const String strCommunication = 'Communication And Network';
const String strConfirmUserValidity = 'Confirm User Validity';
const String strReloginMsg = 'Token Expired or Invalid.Please Relogin';
const String strRelogin = 'ReLogin';
const String strTroubleShooting = 'TroubleShooting';
const String strTroubleShoot = 'Troubleshoot';
const String strStartTest = 'Start Test';
const String strTestAgain = 'Test Again';
const String strRestart = 'Re-Login';

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
const String file_terms_us = 'assets/help_docs/myfhb_us_terms_of_use.html';
const String file_privacy_us = 'assets/help_docs/myfhb_us_privacy_policy.html';
const String voice_cloning_html = 'assets/voice_clone_terms_n_condition.html';
const String voice_transcript_html = 'assets/voice_transcript.html';

//for Family Font
const String font_poppins = 'Poppins';
const String font_roboto = 'Roboto';

//for class bookmark_record
const String strBookmarkRecord = 'bookmark record';

//lockscreen
const String strQurbookLocked = 'Qurbook is locked';
const String strUnlock = 'Unlock';
const String strLogin = 'Login';
const String strAuthenticationError = 'Authentication error';
const String strPleaseGoTo = 'Please go to';
const String strErrorAuthDescription =
    'screen to set your authentication or login again to reset your security settings';
const String strQurbookLockDescription =
    'For your security, you can only use Qurbook when its unlocked';

//for feedback
const String strChat = 'Chats';
const String strFeedBack = 'Feedback';
const String strFeedbackExp =
    'We would like to hear from you on your experience with QurBook';
const String strAttachImage = 'Attach Image';
const String strAddVoice = 'Add Voice';
const String strcategoryInfo = 'categoryInfo';
const String strmediaTypeInfo = 'mediaTypeInfo';
const String strfeedback = 'feedback';
const String strfeedBackCategoryId = 'feedBackCategoryId';
const String strmemoText = 'memoText';
const String strisDraft = 'isDraft';
const String strsourceName = 'sourceName';
const String strmemoTextRaw = 'memoTextRaw';
const String strfileName = 'fileName';
const String strmetaInfo = 'metaInfo';
const String strmediaMetaId = 'mediaMetaId';
const String strFeedbackEmpty = 'Feedback should not be empty';

//for feedback success
const String strFeedThank = 'Thanks for your feedback';

//for global search
const String strSearching = 'Searching';
const String strNoInternet = 'No internet connection';
const String strCheckConnection = 'Check your connection or try again';
const String strBackOnline = 'back to online';
const String strNoConnection = 'no connection';
const String strve = 've';
const String callAppLockFeatureMethod = "callAppLockFeatureMethod";
const String pushKitTokenMethod = "pushKitTokenMethod";
const String callLocalNotificationMethod = "callLocalNotificationMethod";

//new icons for menu
const String activity_non_adherance =
    'assets/settings/activity_non_adherance.png';
const String notification_preference =
    'assets/settings/notification_preference.png';
const String display_devices = 'assets/settings/display_devices.png';
const String unit_preference = 'assets/settings/unit_preference.png';

const String strApprovAdd = 'This provider addition needs approval';

//sheela respond by number
const zero = "zero";
const oneToNine = [
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine"
];
const tenToNinteen = [
  "ten",
  "eleven",
  "twelve",
  "thirteen",
  "fourteen",
  "fifteen",
  "sixteen",
  "seventeen",
  "eighteen",
  "nineteen"
];
const dozens = [
  "ten",
  "twenty",
  "thirty",
  "forty",
  "fifty",
  "sixty",
  "seventy",
  "eighty",
  "ninety"
];

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
  0xff5f0cf9,
  0xffcf4791,
  0xff0483df,
  0xff118c94,
  0xff17a597,
];

List<int> myGradient = [
  0xff9929ea,
  0xfffab273,
  0xff01bbd4,
  0xff0cbcb6,
  0xff84ce6b
];

const String strSettings = 'Settings';
const String strDexcomConnect = 'Dexcom Connect';
const String strReports = 'My Reports';
const String strMyOrders = 'My Orders';
const String strHelp = 'Help and support';
const String strPrivacy = 'Privacy policy';
const String strRateus = 'Rate us';
const String strMaya = 'Sheela';
const String strMAYA = 'SHEELA';
const String strMyClaims = 'My Claims';
String strCareGiverSettings = 'Caregiver Communication';
String strNotificationPreference = 'Notification preferences';

String strNonAdherenceSettings = 'Activity non-adherence reminder';
const String strMsgFromProvider = 'Message from provider';

const String strColorPalete = 'Color Palette';
const String strCareGiverCommunication = 'Caregiver communication';

const String strVitalsPreferences = 'Vitals Preferences';
const String strDisplayDevices = 'Choose Vitals';
const String strUnitPreferences = 'Unit Preferences';
const String strDisplayPreferences = 'Display Preferences';

const String strSheelaNotificationPref = 'Sheela Notification Preference';

const String strSkillsIntegration = 'Skills/Integration';
const String strAppThemes = 'App Themes';
const String strAppThemeClassic = 'Classic';
const String strAppThemeModern = 'Modern';
const String strIntegration = 'Integration';
const String strPrivacyAndSecurity = 'Privacy and Security';

// User account
const String strUserAccount = 'User Account';
const String strDeleteAccountTitle = 'Delete Account';
const String strDeleteAccountDes =
    'Are you sure, you want to delete the account?';
const String strNotRetrieveDataDes =
    "Please note that you'll not be able to retrieve any of your data further, Confirm delete";
const String strCancel = 'Cancel';

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
const String strDateYear = "yyyy-MM-dd";
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
const String strFileDownloadeding = 'File downloading';
const String strFilesErrorDownload = 'Error in File download.';
const String strAfter = 'After Meal';
const String strDateFormatDay = 'dd/MM/yyyy';
const String strUSDateFormatDay = 'MM/dd/yyyy';

const String stAudioPath = 'myFHB/Audio';
const String strDateOfVisit = 'Date of visit: ';
const String strCreatedDate = 'Created Date : ';

//for Add remainder
List<String?> selectedInterval = ['Day', 'Week', 'Month'];
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
const String strPurpose = 'Purpose';

//for my appointments
const String strDr = 'Dr.';
const String strLoadWait = 'Loading...';

//for my remainder
const String dateFormatMMY = 'E d MMM, yyyy';

//for my schedules
const String strAppointments = 'Appointments';
const String strRemainders = 'Reminders';
const String strQurhomeIdealDialogTitle = 'Touch anywhere on the grey area to dismiss this information.';
const String strQurhomeIdealDialogDescription = 'Touch the Sheela icon above to access the reminders';

//string added to set not on the remainder sheela dialog
const String strSheelaDialogNote =
    'Touch anywhere else to go back to the home screen';
// for search providers

const String strGetDoctorsList = 'Getting Doctor List';
const String strGetDoctorById = 'Getting Doctor by Id';

const String strGetHospitalList = 'getting Hospital List';
const String strGetHospitalById = 'Getting Hospital by Id';

const String strGetLabList = 'Getting Laboratory List';
const String strGetLabById = 'Getting laboratoty by Id';

const String strUnReadMessage = 'Unread Messages';

const String strSearch = 'Search';
const String strSearchByHosLoc = 'Search by Hospital/Location';
const String strNoLoadtabls = 'Unable To load Tabs';

const String strSignUp = 'Sign Up';
const String strCreateuser = 'Creating User';
const String strSignOut = 'Signing Out';

const String strVerifyingOtp = 'Verifying One Time Password';
const String strGeneratingOtp = 'Generating One Time Password';

const String strGettingCategory = 'Getting Category List';
const String strGettingHealthRecords = 'Getting Health Records';
const String strSubmitting = 'Submitting ';
const String strSavingImg = 'Saving Image';
const String strMoveData = 'Moving data';
const String strUpdateData = 'Updating Data';
const String strgetMediaTypes = 'Getting Media Types';
const String strGetProfileData = 'Getting ProfileData';

String? authToken;

const String straccept = 'accept';
const String strContentType = 'Content-Type';
const String strAuthorization = 'Authorization';
const String strAcceptVal = 'application/json';
const String strcntVal = 'multipart/form-data';
const String strcontenttype = 'content-type';

const String strErrComm =
    'Error occured while Communication with Server with StatusCode :';
const String strauthorization = 'authorization';
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
const String strOtpVerification = 'One Time Password Verification';
const String strPlsEnterotpReceived =
    'Please enter the One Time Password received';
const String strEnterotpReceived = 'Enter the One Time Password received at';
const String strdidtReceive = 'Didn\'t receive the One Time Password?';
const String strResendCode = 'Resend Code';
const String strAgree = 'By completing Sign Up, you agree to our ';
const String strTermService = 'Terms of Service';
const String strAnd = ' and ';
const String strPrivacyPolicy = 'Privacy Policy';

// for signIn

const String strwelcome = 'Welcome';
const String strgetStart = 'Get started with QurBook';
const String strNext = 'NEXT';

// for Sign Up
const String strMobileNum = 'Mobile Number';
const String strEmailOpt = 'Email address';
const String strSendOtp = 'Send One Time Password';
const String strEmailAddress = 'Email address';

List<String> genderList = ['Male', 'Female', 'Others'];
const String strEnterMobileNum = 'Enter MobileNumber';
const String strEnterFirstname = 'Enter First Name';
const String strEnterLastName = 'Enter LastName';

const voice_platform = MethodChannel('flutter.native/voiceIntent');
const version_platform = MethodChannel('flutter.native/versioncode');
const tts_platform = MethodChannel('flutter.native/textToSpeech');
const String strWaitLoading = 'wait! Its loading';

const String _wordsFromMaya = 'waiting for maya to speak';
const String strhiMaya = 'Hi Sheela';
const String strtts = 'textToSpeech';
const String strtapToSpeak = 'Tap to Speak';
const String requestSheelaForbp = 'Record my Blood pressure readings';
const String requestSheelaFortemperature = 'Record my Temperature';
const String requestSheelaForglucose = 'Record my Glucometer readings';
const String requestSheelaForpo = 'Record my Pulse oximeter readings';
const String requestSheelaForweight = 'Record my Weight';
const String strvalidateMicAvailablity = 'validateMicAvailability';
const String strQurbookSheela =
    'SHEELA'; // For lex to be done for seperation lex and rasa

const String strIntromaya = 'Hi, I am Sheela your voice health assistant.';
const String strTapMaya = 'Tap me and invoke. Lets converse';
const String strpdf = 'pdf';
const String strCropper = 'Cropper';
const String strCropping = 'cropping...';

List<String> documentList = ['Hospital IDS', 'Insurance IDs', 'Other IDs'];
const String strFalse = 'false';
const String strSkip = 'Skip';
const String strImgNtClear = 'Image not clear';

const String strRegimenRedirection = 'Redirecting to current date regimen in';
const String strViewPastDateRegimen = 'You are viewing past date regimen';
const String strViewFutureDateRegimen = 'You are viewing future date regimen';
const String stringViewTotalNumberOfActivites = 'Total Number of activities :';
//for device screen
const String strGlucUnit = 'mgdl';
const String strbfood = 'Before Food';
const String strafood = 'After Food';
const String strarandom = 'Random';
const String strpulseUnit = '%spo2';
const String strpulse = 'pulse';
const String strbpunit = 'mmHg';
const String strbpdp = 'dp';

const String strBefore = 'Before Meal';
const String strNo = 'No';

const String strdflit = 'assets/device_detection.tflite';
const String file_device = 'assets/devicelabels.txt';
const String strOthers = 'Others';
const String strDeviceFound = 'We find the device is';
const String strChoose = 'Choose';
const String strYES = 'YES';
const String strNO = 'NO';
const String strConfirm = 'Confirm';
const String strConfirmation = 'Confirmation';
const String strConfirmationVoiceCloneDisable =
    'Any applied voice sample will be revoked.\n\nAre you sure, you want to deactivate the voice cloning feature?';

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
const String strAllowBiometric = 'Enable app lock';
const String strEnableApplock =
    'Allow app lock with FaceID/FingerPrint or Passcode';
const String strAuthToUseApp = 'Please complete the authentication to proceed.';
const String strVoiceCloning =
    'Voice Cloning'; //String declared for voice cloning
const String strAllowVoiceCloning =
    'Allow voice cloning'; //String declared for Allow voice cloning
const String strSheelaDesc =
    'Sheela clones your voice for family member communication'; // descrption for voice cloning
const String strUseClonedVoice =
    'Use cloned voice'; //String declared for use cloned voice

const String strVoiceCloneNotSetByYourCaregiver =
    'Voice clone sample not set by your caregiver'; //String declared for VoiceCloneNotSetByYourCaregiver

const String strUseClonedVoiceDesc =
    'Option to allow using the cloned voice for sheela conversation'; //description for Usecloned Voice

const String strStatus = 'Status : ';
//Create common String for voice cloning text
const String strVoiceTerms = 'Accept And Continue';
const String strInActive = 'InActive';
const String strSubmit = 'Submit';
const String strFetchingList = 'Fetching List';
const String strVoiceCloningExistingMembersHeader =
    'Your cloned voice is in use for the following members:';
const String strVoiceCloningAddMembersHeader =
    'Choose the list of members, to apply the cloned voice';
const String strApproved = 'Approved'; //status text for approved
const String strDeclined = 'Declined'; //status text for declined
const String strReason = 'Reason : '; //status text for reason,include spacing

const String strSubVoice =
    'Submitted voice sample'; //String for voice submitted
const String strProVoice =
    'Processed voice sample'; //String for voice processed
const String strChangeVoice = 'Change voice sample'; //String for voice print

const String strStart = 'Start';
const String strDOS = 'Date of submission : ';
const String strDescStatus =
    'Your voice sample for voice cloning has been approved and being processed,and you will be notified once it has been processed';
const String strURLVoiceCloneStatus = 'voice-clone/status?';
const String strVoiceRevoke = 'voice-clone';
//for  googleFit activation and sync
const String strGoogleFit = 'Google fit';
const String strAllowGoogle = 'Allow app to recieve data from google Fit';
const String strAddDevice = 'Tap to add device widgets to your home screen';
const String strDefaultUI = 'Set QurHome as default UI';
const String strVoiceCloneIntro =
    'Activate the voice cloning \n feature  by clicking the button ,\n then read the displayed \n content  on the screen once the \n timer concludes to record your \n voice'; // Text for voice cloning introduction

//for homescreen and dashboard
const String strMyInfo = 'My Info';
const String strMyFamily = 'My Family';
const String strAdvancedRegimen = 'Advanced Regimen';
const String strConnectedDevices = 'Connected Devices';
const String strQurHome = 'QurHome';
const String strQurHomeinQurBook = 'QurHome in QurBook';
const String strAddNewDevice = 'Add New Device';
const String strQurHubIoTdevice = 'QurHub IoT device';
const String strCreateNewVirtualHub = 'Create New Virtual Hub';
const String strMyProvider = 'My Provider';
const String strMyPlans = 'My Plan';
const String strExtImg = '.png';
const String strTelehealth = 'TeleHealth';
const String strMyRecords = 'Health Records';
const String strhome = 'Home';
const String strSchedule = 'Schedules';
const String strProfile = 'Profile';
const String strMore = 'More';
const String strClose = 'Close';
const String strConnectBpMeter =
    'Please connect your BP device and start recording';
const String strConnectPulseMeter =
    'Please connect your pulse oximeter and start recording';
const String strConnectWeighingScale =
    'Please connect your weighing scale and start recording';
const String strConnectBGL =
    'Please connect your Blood Glucose test strips to the meter and start taking the readings';

// normal scan for all paired devices message
const String strDeviceScan =
    'Please turn on your device and start taking the readings';

//sheel live remiders
const String strSheelaLiveReminders = 'Sheela live reminders';

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
const String strpop = 'SystemNavigator.pop';
const String strDiscard = 'Discard';

const String strformateedAddress = 'formateedAddress';
const String strformateedPhoneNumber = 'formateedPhoneNumber';
const String st_pausedplayer = 'paused player';

const String strNoData = 'No data Available';
const String strViewPDF = 'View PDF';
const String strLogout = 'Logout';
const String strRefer_friend = 'Refer a Friend';
const String strLogoutMsg =
    'Stay Healthy.. See you Soon. \nSheela will be waiting to serve you.';
const String strYes = 'Yes';
const String strRelaoding = 'Reloading';
const String strSwitchingUser = 'Switching User';

const String strStartNow = 'Start now';
const String strAccounts = 'Accounts';
const String strDevices = 'Devices';

const String strLauncher = '@mipmap/ic_launcher';

const String video_splash = 'assets/video/splash_video.mp4';
const String strRs = 'Rs';
const String strDollar = '\$';

//webcognito
const source = 'QurBook';
const sourceCode = 'e13019a4-1446-441b-8af1-72c40c725548';
const entityCode = '28858877-4710-4dd3-899f-0efe0e9255db';
const roleCode = '285bbe41-3030-4b0e-b914-00e404a77032';
const redirecturl = 'http://localhost:4200/callback?code=';
const String strNoDoctordata = 'No Doctor List Available';
const String strNoHospitaldata = 'No Hospital List Available';
const String strNoAppointments = 'No Appoinments Available';
const String strNoPlans = 'No Plan List Available';
const String strNoPlansUS = 'Please contact your provider to add a care plan';
const String strNoActivities = 'No Activities Available';
const String strNoPackages = 'No Packages Available';
const String strNoReports =
    'Your reports are being generated. We\'ll populate here soon';

const String strNoDataAvailable = 'Unable To load';
const String strHealthOrganizationName = 'healthOrganizationName';

// const String EMAIL_REGEXP =
// //r"^[a-zA-Z0-9.a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
//     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{​​​​​|}​​​​​~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

const String c_chat_with_whatsapp_begin_conv = 'Hi';
const String c_qurhealth_helpline = '919566200555';
const String icon_whatsapp = 'assets/icons/ic_whatsapp.png';

const String strAdd = 'Add';
const String strSync = 'Syncing...';
const String vitalsSummary = 'Vitals Summary';

const String renewalLimit =
    'Renewal limit reached for this plan. Please try after few days';

const String alreadySubscribed =
    'You’ve already subscribed to the plan. Selecting this now will renew the plan';

//String for choose Units
const String str_Weight = 'Weight';
const String str_Pounds = 'Pounds';
const String str_Kilogram = 'Kilograms';

const String str_Height = 'Height';
const String str_Feet = 'Feet/Inches';
const String str_centi = 'Centimeters';

const String str_Temp = 'Temperature';
const String str_celesius = 'Celsius';
const String str_far = 'Fahrenheit';

//Reminders
//
const reminderMethodChannel = MethodChannel('flutter.native/reminder');
const navigateToSheelaReminderMethod = 'navigateToSheelaReminderMethod';
const notificationReceivedMethod = "notificationReceived";
const removeReminderMethod = 'removeReminder';
const navigateToRegimentMethod = 'navigateToRegiment';
const reponseToRemoteNotificationMethodChannel =
    MethodChannel('flutter.native.QurBook/notificationResponse');
const reponseToTriggerAppLockMethodChannel =
    MethodChannel('flutter.native.QurBook/appLockMethodChannel');
const reponseToTriggerPushKitTokenMethodChannel =
    MethodChannel('flutter.native.QurBook/pushKitTokenMethodChannel');
const responseToCallKitMethodChannel =
    MethodChannel('flutter.native.QurBook/callKitMethodChannel');
const notificationResponseMethod = 'notificationResponse';
const iOSMethodChannel = MethodChannel('flutter.native/iOS');
const getWifiDetailsMethod = 'getWifiDetails';
const listenToCallStatusMethod = 'listenToCallStatus';

// True Desk

const String strNoTicketsRaised = 'Tap on + icon to create Tickets';
const String strNoTicketTypesAvaliable = 'No Ticket Types Found !!';

// regimen appointment
const String strAppointmentRegimen = 'Appointment';
const String strSelfRegimen = 'Self';

//chat
const String icon_unread_chat = 'assets/icons/ic_unread_chat.png';

const String warning_icon = 'assets/warning_icon.png';

const String strNoMessage = 'No Messages';

const String strNoAttachments = 'No Attachments';

//QurHub
const String icon_qurhub_lock = 'assets/icons/lock.svg';
const String icon_qurhub_switch = 'assets/icons/switch.svg';
const String icon_qurhub_wifi = 'assets/icons/wifi.svg';

//Caregiver Setting
const String strAllowVitals = "Allow Vitals";
const String strAllowSymptoms = "Allow Symptoms";
const String strAllowAppointments = "Allow Appointments";
const String strAlert = 'Alert';
const String strAlerts = 'Alerts';
const String patient = 'Patient : ';

const String patientId = "patientId";
const String familyMemberId = "familyMemberId";

const String appointmentDetails = "Appointment Details";
const String appointmentSchedule = "Schedule";
const String appointmentInformation = "Appointment Information";
const String appointmentTestName = "Test Name";
const String appointmentAddress = "Address";
const String appointmentLabAddress = "Lab Address";
const String appointmentDescription = "Description";
const String appointmentPickupaddress = "Pick up address";
const String appointmentDropAddress = "Drop address";
const String appointmentSlot = "Slot";
const String appointmentHospitalName = "Hospital Name";
const String appointmentHospitalAddress = "Hospital Address";
const String strTransportation = "transportation";
const String strDoctorAppointment = "doctor appointment";
const String strLabAppointment = "lab appointment";
const String strHomeHealthVisit = "home health visit";
const String strHomecareService = "homecare service";
const String strGeneralHealth = "general health";
const String strOrderPrescription = "order prescription";
const String strCareDietPlan = "care/diet plan";
const String strHomecareServices = "homecare services";
const String strFoodDelivery = "food delivery";

const String strHealthPlan =
    "health plan"; // Define a constant string for health plan
const String strAmbulanceService =
    "ambulance service"; // Define a constant string for ambulance service
const String strOrderMedicine =
    "order medicine"; // Define a constant string for ordering medicine

const String strGetCityList = 'Getting City List';
const String strSelValidMsg = 'Please select a valid';
const String strLocationLink = "Location link";
const String strCentreVisit = 'Centre Visit';
const String strOnsite = 'Onsite';

const String strCompleted = 'Completed';

//for regimen
const String strRecordedAt = 'Recorded at';
const String strHasBeenRecordedBy = 'This has been recorded by ';
const String strHasBeenRecordedByAt = ' at';
const String strUndo = 'Undo';
const String strEdit = 'Edit';
const String strView = 'View';
const String strConfirms = 'Are you sure?';
const String strUpdateMsg = 'Do you want to update the changes';
const String strDecline = 'Declined';
const String strActivityYourHealthcareProvider =
    'This activity will be performed by your healthcare provider.';

const String strNotifiedonceItIsDone = 'You\'ll be notified once it is done.';

//For Alert
const String strEscalate = 'Escalate';
const String strCall = 'Call';

const String strTransportationRequestAccepted =
    'Transportation request accepted';
const String strTransportationRequestDeclined =
    'Transportation request declined';

const String strSentViaSheela = 'Sent via Sheela.';
const String strPairingMode = 'Pairing mode - ';
const String strConnectedOn = 'Connected on - ';
const String strDeviceID = 'Device ID - ';
const String strDeviceTypeConnectedDeviceScreen = 'Device Type - ';
const String strLTE = '4G LTE';
const String sheelaText = 'Sheela';

const String strAvailableServices = 'Available Services';
const String strAvailableBalance = 'Available balance';
const String strShowAvailableBenefits = 'Show available benefits';

const String strMembershipDiscount = 'Membership discount';
const String strBenefitHomecareService = 'Homecare Service';
const String strBenefitHomecareServices = 'Homecare Services';
const String strBenefitHealthPlan = 'Health Plan';
const String strBenefitHealthPlans = 'Health Plans';
const String strBenefitCareDietPlans = 'Care/Diet Plans';
const String strBenefitAmbulanceService = 'Ambulance Service';
const String strBenefitAmbulanceServices = 'Ambulance Services';
const String strBenefitTransportation = 'Transportation';
const String strBenefitOrderMedicine = 'Order Medicine';
const String strBenefitOrderMedicines = 'Order Medicines';
const String strBenefitMedicineOrdering = 'Medicine Ordering';
const String strBenefitLabAppointment = 'Lab Appointment';
const String strBenefitLabAppointments = 'Lab Appointments';
const String strBenefitDoctorAppointment = 'Doctor Appointment';
const String strBenefitDoctorAppointments = 'Doctor Appointments';
//decode code
Map<String, dynamic> parseJwtPayLoad(String token) {
  var parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }
  var payload = _decodeBase64(parts[1]);
  var payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }
  return payloadMap;
}

Map<String, dynamic> parseSignUpJwtPayLoad(String token) {
  var payload = _decodeBase64(token);
  var payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }
  return payloadMap;
}

Map<String, dynamic> parseJwtHeader(String token) {
  var parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }
  var payload = _decodeBase64(parts[0]);
  var payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }
  return payloadMap;
}

String _decodeBase64(String str) {
  var output = str.replaceAll('-', '+').replaceAll('_', '/');
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
