library fhb_constants;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:myfhb/common/CommonUtil.dart';

String BASE_URL = CommonUtil.BASE_URL_FROM_RES;

const String APP_NAME = 'myFHB';
const String MOB_NUM = 'Mobile number';
const String ENTER_MOB_NUM = 'Enter your mobile number';
const String SignInOtpText = 'We will send you an one time password';
const String OtpScreenText = 'Please enter the verification code sent to';
const String SUBMIT = 'Submit';
const String MOB_NUM_EMPTY = 'Mobile number empty';
const String LOGIN_SUCCESS = 'Login Success';
const String MYFamily = 'My Family';
const String MyProviders = 'My Providers';
const String Feedback = 'Feedback';
const String Settings = 'App settings';
const String FAQ = 'FAQ';
const String RateUs = 'Rate us';
const String SOURCE_NAME = 'tridentApp';
const String KEY_METADATA = 'metadata';
const String NotificationData = 'NotificationData';
const String KEY_CATEGORYNAME = 'categoryName';
const String KEY_CATEGORYID = 'categoryID';
const String KEY_CATEGORYLIST = 'categoryList';
const String KEY_PROFILE = 'profile';
const String KEY_USERID = 'userID';
const String KEY_AUTHTOKEN = 'authToken';
const String KEY_FAMILYMEMBERID = 'familyMemberId';
const String KEY_IDDOCSCATEGORYTYPE = 'idDocsCategoryType';
const String KEY_MEDIADATA = 'mediaData';
const String KEY_COMPLETE_DATA = 'complete_data';
const String IS_CATEGORYNAME_DEVICES = 'Choose Device';
const String KEY_DEVICENAME = 'Device Name';
const String STR_GLUCOMETER = 'Glucometer';
const String STR_THERMOMETER = 'Thermometer';
const String STR_BP_MONITOR = 'BP Monitor';
const String STR_WEIGHING_SCALE = 'Weighing Scale';
const String STR_PULSE_OXIMETER = 'Pulse Oximeter';
const String STR_PRESCRIPTION = 'Prescription';
const String STR_DEVICES = 'Devices';
const String STR_LABREPORT = 'Lab Report';
const String STR_MEDICALREPORT = 'Medical Report';
const String STR_BILLS = 'Bills';
const String STR_IDDOCS = 'ID Docs';
const String STR_OTHERS = 'Others';
const String STR_VOICERECORDS = 'Voice Records';
const String STR_CLAIMSRECORD = 'Claim Records';
const String STR_FEEDBACK = 'Feedback';
const String STR_WEARABLES = 'Wearable';
const String STR_TELEHEALTH = 'Telehealth';
const String STR_HOSPITALDOCUMENT = 'Hospital Documents';

const String KEY_LANGUAGE = 'languageList';

const String STR_VOICE_NOTES = 'Voice Notes';
const String KEY_USERID_MAIN = 'mainUserUD';
const String KEY_PROFILE_MAIN = 'profileMain';
const String KEY_SEARCHED_LIST = 'searchedList';
const String KEY_SEARCHED_CATEGORY = 'searchedCategory';
const String terms_of_service = 'Terms of use';
const String privacy_policy = 'Privacy policy';
const String help_support = 'Help and support';
const String STR_MSG_SIGNUP = 'Please signup and then try again';
const String STR_MSG_SIGNUP1 = 'Please signup then try again';
const String STR_VERIFY_OTP =
    'Please complete your registration process, by generating and verifying the OTP';
const String STR_VERIFY_USER =
    'Please complete your Sign Up process, by generating and verifying the OTP';
const String KEY_VOICE_ID = 'Category_ID_VOICE';
const String STR_OTPMISMATCHED =
    'Requested operation forbidden. OTP Mismatched';
const String STR_OTPMISMATCHED_STRING = 'OTP Mismatched';
const String KEY_INTRO_SLIDER = 'keyIntroSlider';
const String STR_FEEDBACKS = 'Feedback';
const String KEY_PREFERRED_DOCTOR = 'prefered doctor';
const String KEY_PREFERRED_HOSPITAL = 'prefered hospital';
const String KEY_PREFERRED_LAB = 'prefered lab';
const String CURRENT_THEME = 'App Theme';
const String stop_detecting = 'StopDetecting';
const String allowDeviceRecognition = 'allowDeviceRecognition';
const String allowDigitRecognition = 'allowDigitRecognition';

const String audioFileType = 'audio/mp3';
const String MSG_VERIFYEMAIL_VERIFIED =
    'Email is already verified by other user.';
const String MSG_VERIFYEMAIL_SUCCESS =
    'Verification code have been sent to the email';
const String COUNTRY_CODE = 'CountryCode';
const String MSG_EMAIL_OTP_VERIFIED = 'Verified';
const String PROFILE_EMAIL = 'Email';
const String KEY_PROFILE_BANNER = 'profileBanner';
const String KEY_PROFILE_IMAGE = 'profileImage';

const String KEY_DASHBOARD_BANNER = 'dashboardBanner';
const String MSG_NO_CAMERA_VOICERECORDS = 'No Camera Option Available for';
const String INTRO_SLIDE_TITLE_1 = 'Click ‘n’ Store';
const String INTRO_SLIDE_DESC_1 =
    ' You are just a click away from a healthy family! Start capturing medical records and readings at the touch of a button. ';
const String INTRO_SLIDE_TITLE_2 = 'Quick ‘n’ Safe';
const String INTRO_SLIDE_DESC_2 =
    'Go paperless! Save your Family Health records in a secured digital vault.  ';
const String INTRO_SLIDE_TITLE_3 = 'Tap ‘n’ Talk';
const String INTRO_SLIDE_DESC_3 =
    'Maya, an intelligent virtual health assistant, with conversational capabilities, sets up pill reminders, doctor appointments, among other smart tasks. ';
const String INTRO_SLIDE_TITLE_4 = 'Add ‘n’ Tag';
const String INTRO_SLIDE_DESC_4 =
    'Add your doctors and get personalized private consultations.';
const String INTRO_SLIDE_TITLE_5 = 'Share ‘n’ Care ';
const String INTRO_SLIDE_DESC_5 =
    'Securily and Privately share your medical records with your family,  doctors and caregivers';
const String KEY_SHOWCASE_DASHBOARD = 'KEY_SHOWCASE_DASHBOARD';
const String KEY_SHOWCASE_HOMESCREEN = 'KEY_SHOWCASE_HOMESCREEN';
const String KeyShowIntroScreens = 'KeyShowIntroScreens';

const String KEY_SHOWCASE_CAMERASCREEN = 'KEY_SHOWCASE_CAMERASCREEN';

const String KEY_SHOWCASE_Plan = 'KEY_SHOWCASE_Plan';
const String KEY_SHOWCASE_MyPlan = 'KEY_SHOWCASE_MyPlan';
const String KEY_SHOWCASE_Regimen = 'KEY_SHOWCASE_Regimen';
const String KEY_SHOWCASE_Symptom = 'KEY_SHOWCASE_Symptom';
const String KEY_SHOWCASE_hospitalList = 'KEY_SHOWCASE_hospitalList';

const String KEY_SHOWCASE_MAYA = 'KEY_SHOWCASE_MAYA';
const String STR_OTPMISMATCHEDFOREMAIL = 'Verification Code Mismatched';
const String STR_UN_AUTH_USER = 'STR_UN_AUTH_USER';
const String KEY_SHOWCASE_SWITCH_PROFILE = 'KEY_SHOWCASE_SWITCH_PROFILE';
const String CAMERA_DESC = 'Start capturing health records right away!';
const String CAMERA_TITLE = 'Camera';
const String VOICE_DESC = 'Add personal voice notes to your records';
const String VOICE_TITLE = 'Voice Record';
const String GALLERY_DESC =
    'And those health records from gallery, you can import them!';
const String GALLERY_TITLE = 'Gallery';
const String ATTACH_DESC =
    'You can pick health records from phone file storage as well';
const String ATTACH_TITLE = 'Attachments';
const String MULTI_IMG_DESC =
    'You can also switch from single to multiple capture and vice versa';
const String MULTI_IMG_TITLE = 'Multiple Images';
const String SWITCH_CATEGORY_DESC =
    'You can switch categories even while you capture health records';
const String SWITCH_CATEGORY_TITLE = 'Switch Category';
const String KEY_CATEGORYLIST_VISIBLE = 'categoryListDisplay';
const String MAYA_TITLE = 'Maya';
const String MAYA_DESC =
    'Hey there\! I am Maya, Your personalized voice based health assistant';
const String PROVIDERS_DESC = 'Manage all your healthcare providers from here';
const String PROVIDERS_TITLE = 'My Providers';
const String FAMILY_DESC = 'View and manage your family members profile';
const String FAMILY_TITLE = 'My Family';
const String RECORDS_DESC = 'You can get to view all your health records';
const String RECORDS_TITLE = 'My Records';
const String NO_DATA_DASHBOARD =
    'Personalize the environment. \n Upload your favorite cover image..';
const String NO_DATA_DOCTOR =
    'Hey, Doctor\'s directory looks empty !! \n Add them now.';
const String NO_DATA_HOSPITAL =
    'Hello, Hospital listing looks empty !! \n Add it now.';
const String NO_DATA_LAB =
    'Hey, You may need Labs contact coordinates !! \n Add it now.';
const String NO_DATA_FAMIY =
    'Looks like you haven\'t added your family members. \n Add them right away.';
const String NO_DATA_FAMIY_CLONE =
    'Looks like you haven\'t added your family members.';
const String NO_DATA_SCHEDULES =
    'Never miss any schedule. \n Add it to your calendar and get notified.';
const String NO_DATA_PRESCRIPTION =
    'Don\'t want to type? \n Take a picture or upload from gallery \nto add prescriptions.';
const String NO_DATA_DEVICES =
    'Click \'n\' go (or) tell \"Sheela\" \nand it will record for you.';
const String NO_DATA_LAB_REPORT = 'Upload your report or click \'n\' go';
const String NO_DATA_MEDICAL_REPORT =
    'Sure! Upload your medical reports \n or click \'n\' go';
const String NO_DATA_BILLS =
    'Have medical bills in your wallet?? \n Upload them now and go paperless !!';
const String NO_ID_DOCS =
    'Click the camera icon or upload ID document from gallery';
const String NO_VOICE_RECRODS =
    'Just add personal voice notes \nto your medical records.';
const String NO_DATA_OTHERS =
    'Ofcourse! Add files here to store any other medical records';
const String COVER_IMG_DESC = 'Add style. \nTap here to add your favorite DP.';
const String COVER_IMG_TITLE = 'Cover Image';
const String HospitalDescription =
    'Choose your Hospital and Tap to see the QurPlans offered by them';
const String SubscribeDescription =
    'Tap on Subscribe button to enroll for the QurPlan and complete Payment Process';
const String MyPlanCard =
    'View the list of QurPlans that you’ve Subscribed and Tap on the Plan name for more Details';
const String SubscribedPlans = 'Subscribed Plans';
const String Subscribe = 'Subscribe';
const String GoToRegimentDescription =
    'Tap here to see your updated Regimen for each Plan’s subscription';
const String SymptomsDescription = 'Tap here to view Symptoms list';
const String DailyScheduleDescription = 'Tap here to set your Daily Schedule';
const String Schedule = 'Schedule';
const String LogActivity = 'Log Activity';
const String CardTap =
    'Tap on the card or Tick mark on it to mark your activity accomplishment';
const String Symptoms = 'Symptoms';
const String LogSymptoms = 'Log Symptoms';
const String symptomCardTap =
    'Tap on the card or Tick mark on it to log your Symptoms';
const String DailyRegimen = 'Daily Regimen';
const String HospitalSelection = 'Hospital Selection';
//Prefrence key for family and provider
const String KEY_FAMILYMEMBER = 'familymember';
const String KEY_PROVIDER = 'provider';

const String STR_NO_CONNECTIVITY = 'No Internet connection';
const String STR_OTP_FIELD = 'Please enter a valid OTP';
const String STR_ERROR_LOADING_DATA = 'Unable To Load Data,Please Try Again';
const String STR_ERROR_LOADING_IMAGE = 'Unable To Load Image,Please Try Again';

const String KEY_FAMILYREL = 'keyFamilyrel';
//const String Auth_token='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb3VudHJ5Q29kZSI6Iis5MSIsImV4cGlyeURhdGUiOjE1OTQ0OTI1OTI1MjYsInJvbGVJZCI6IjhmNDVmNDQyLTY4NWEtNGI4Yi04NmU3LWI5M2U2OWQ4MDk2ZCIsInNlc3Npb25EYXRlIjoxNTk0NDg4OTkyNTI2LCJzZXNzaW9uUm9sZXMiOiI4ZjQ1ZjQ0Mi02ODVhLTRiOGItODZlNy1iOTNlNjlkODA5NmQiLCJzb3VyY2VJbmZvIjp7InN1YlNvdXJjZUlkIjoiMjRlMTViZTMtOTY5NS00NGY3LTgyMjktMzRmZjRlZjgxMzk2IiwiZW50aXR5SWQiOiI5MmJkYzdiMS1kNTAwLTQ5MDEtYmZlOC04ZTE5YTA5ZmZhZDQiLCJyb2xlSWQiOiI4ZjQ1ZjQ0Mi02ODVhLTRiOGItODZlNy1iOTNlNjlkODA5NmQiLCJpc0RldmljZSI6ZmFsc2UsImRldmljZUlkIjoiIn0sInN1YmplY3QiOiI5MTc2MTE3ODc4IiwidXNlcklkIjoiYmRlMTQwZGItMGZmYy00YmU2LWI0YzAtNWU0NGI5ZjU0NTM1IiwiaWF0IjoxNTk0NDg4OTkyLCJleHAiOjE1OTgwODg5OTIsImF1ZCI6ImUxMzAxOWE0LTE0NDYtNDQxYi04YWYxLTcyYzQwYzcyNTU0OCIsImlzcyI6IkZIQiIsImp0aSI6ImE0ZTQ4MzY3LTM0M2EtNDIzNC1hYjEyLTgzMzEyMTZkZDUyYSJ9.qqSTMlm5UQKJ5vrCMQQ2NiPCM9lU8-5OStHAj1Q2Vfk';
//const String Auth_token_slots='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb3VudHJ5Q29kZSI6Iis5MSIsImV4cGlyeURhdGUiOjE1OTQ1MjkzNzMzNDAsInJvbGVJZCI6IjhmNDVmNDQyLTY4NWEtNGI4Yi04NmU3LWI5M2U2OWQ4MDk2ZCIsInNlc3Npb25EYXRlIjoxNTk0NTI1NzczMzQwLCJzZXNzaW9uUm9sZXMiOiI4ZjQ1ZjQ0Mi02ODVhLTRiOGItODZlNy1iOTNlNjlkODA5NmQiLCJzb3VyY2VJbmZvIjp7InN1YlNvdXJjZUlkIjoiMjRlMTViZTMtOTY5NS00NGY3LTgyMjktMzRmZjRlZjgxMzk2IiwiZW50aXR5SWQiOiI5MmJkYzdiMS1kNTAwLTQ5MDEtYmZlOC04ZTE5YTA5ZmZhZDQiLCJyb2xlSWQiOiI4ZjQ1ZjQ0Mi02ODVhLTRiOGItODZlNy1iOTNlNjlkODA5NmQiLCJpc0RldmljZSI6ZmFsc2UsImRldmljZUlkIjoiIn0sInN1YmplY3QiOiI5ODQwOTcyMjc1IiwidXNlcklkIjoiYWQ1ZDJkMzctNGVhZi00ZDkxLTk5ZTgtYTA3ODgxZDcyNjQ5IiwiaWF0IjoxNTk0NTI1NzczLCJleHAiOjE1OTgxMjU3NzMsImF1ZCI6ImUxMzAxOWE0LTE0NDYtNDQxYi04YWYxLTcyYzQwYzcyNTU0OCIsImlzcyI6IkZIQiIsImp0aSI6ImExNDUxMzNlLTA4NTctNGQyMi1iNTAwLWY3MjEyMDlmNmI5YiJ9.MGP2eiAC4pYgMsHzFig1nowJObJ9TSfjPLbuRJVQciw';
const String ADD_NEW_FAMILY_MEMBER = 'Add new family member';

const String keyDoctor = 'doctor';
const String keyHospital = 'hospital';
const String keyLab = 'laboratory';
const String keyFamily = 'keyFamilyrel';
const String keyTheme = 'my_theme';
const String keyPriColor = 'pri_color';
const String keyGreyColor = 'gre_color';
const String keyMayaAsset = 'maya_asset';
const String keyAudioFile = 'audioFile';
const String Self = 'Self';
const String Delink = 'Delink';
const String Please_Wait = 'Please Wait';
const String parentToChild = 'parentToChild';
const String DeLink = 'De-Link';
const String Error = 'Error';
const String Success = 'Success';
const String Otp_Verification = 'Otp Verification';
const String Resend_Code = 'Resend Code';
const String Receive_OTP = 'Didn\'t receive the OTP?';
const String enter_otp = 'Please enter the received OTP';
const String Successfully = 'Successfully';
const String OTP_Matched = 'Otp matched successfully';
const String Family_Member_Added =
    'Your family member has been added successfully';
const String VerifyEmail = 'Tap to verify Email address';
const String otp_assets = 'assets/icons/otp_icon.png';
const String planDownload = 'assets/icons/planDownload.png';

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

//ICONS LINK
const String NOTES_ICON_LINK = "assets/icons/notes.png";
const String RECORDS_ICON_LINK = "assets/navicons/my_records.png";
const String VOICE_ICON_LINK = "assets/icons/voice-notes.png";
const String DEVICE_ICON_LINK = "assets/navicons/reading.png";

const String AddAppointment = 'Add Appointment';
const String HospitalName = 'Hospital Name';
const String hopspitalEmpty = 'Hospital name can\'t be empty';
const String DoctorName = 'Doctor\'s Name';
const String DoctorNameEmpty = 'Doctor name can\'t be empty';
const String AppointmentDateTime = 'Appointment Date & Time';
const String WrongTime = 'wrong time picked';
const String Reason = 'Reason';
const String Save = 'Save';

const String keyDetectedClass = 'detectedClass';

const String userID = 'aa9cc3d2-46ab-4759-b993-f28483be087e';
const String AuthToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6eyJQcm92aWRlclBheWxvYWQiOnsiaWRfdG9rZW4iOiJleUpyYVdRaU9pSkhkVXhWUWxCT2IwUmNMMVZLVFVkelMxQnlTM0JKUzA1bmVHWk5hRVV5ZWtkclZqUlNUa3hXU2xWTGN6MGlMQ0poYkdjaU9pSlNVekkxTmlKOS5leUpoZEY5b1lYTm9Jam9pVkUweGNGOHpUbWxQZFdGU1RXcGhkbWhVWWpkbVVTSXNJbk4xWWlJNklqa3hZMlEwTURSakxURmlNR1F0TkRabFppMWlPV1JsTFdVME9HVXdaakV3TldZMk9TSXNJbVZ0WVdsc1gzWmxjbWxtYVdWa0lqcG1ZV3h6WlN3aVltbHlkR2hrWVhSbElqb2lNRFJjTHpFMlhDOHhPVGcwSWl3aWFYTnpJam9pYUhSMGNITTZYQzljTDJOdloyNXBkRzh0YVdSd0xuVnpMV1ZoYzNRdE1TNWhiV0Y2YjI1aGQzTXVZMjl0WEM5MWN5MWxZWE4wTFRGZmRHOUtVbmhhT1d0S0lpd2ljR2h2Ym1WZmJuVnRZbVZ5WDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpWTI5bmJtbDBienAxYzJWeWJtRnRaU0k2SWpreFkyUTBNRFJqTFRGaU1HUXRORFpsWmkxaU9XUmxMV1UwT0dVd1pqRXdOV1kyT1NJc0ltZHBkbVZ1WDI1aGJXVWlPaUpTWVhacGJtUnlZVzRpTENKaGRXUWlPaUl4TUdka01YUnNjV2htWm5BM09HeHNOV05xWm5WbWRHSTFOaUlzSW1WMlpXNTBYMmxrSWpvaU1XUXhZMkZrWkRjdFltWTRaQzAwTjJaa0xXRTVPVEV0TnpaaU16YzVaRFUyWkRGaklpd2lkRzlyWlc1ZmRYTmxJam9pYVdRaUxDSmhkWFJvWDNScGJXVWlPakUxT1RjME56RTVORGtzSW5Cb2IyNWxYMjUxYldKbGNpSTZJaXM1TVRrNE5EQTVOekl5TnpVaUxDSmxlSEFpT2pFMU9UYzBOelUxTkRrc0ltbGhkQ0k2TVRVNU56UTNNVGswT1N3aVptRnRhV3g1WDI1aGJXVWlPaUpRWlhKMWJXRnNJaXdpWlcxaGFXd2lPaUp5WVhacGJtRXVjR2RBWjIxaGFXd3VZMjl0SW4wLlE2bUFlTmZUZXY5SnZjVk9iWFQ2Y2tLOXd5OF95V1plTUR1ZnRrWDlEQU5hRk92TUNtOVBub0xXbzY0VEZPeTNWU093RXlIOTVXZVRqbW4zVkg2bm9JV09aOHJhWG9iOWFPR0ItcjVKOGVKcV91RjEwUEZmUmVPa2lEajBVa19rZzhWSmlOMHVtVDlBOGJXaEI4Y2YtYUVBSDVnb004blNQMUp1WWpwLTBlQWJyVm1xWWFvRzYzX1lPZW5yUm1UaWJCSERKNGxrMS1JX2xtVGE0NXRzR3Rod29BcklidGFjVEZCYXhVRl90ZnBzaTU1dkJsTUpycFNlQTYzSXNWOXgzUHhiRVpfMU1NTmRCbkFLZ1Z2REZENTN0N2JHb0FlNnBmWlZBY09fVHhlOW1GM3QtbHJiWU4wV2FTOWROUzItNjhHdTVMV1RjaF9iZG9UQkZpVzJndyIsImFjY2Vzc190b2tlbiI6ImV5SnJhV1FpT2lKNVlXNWFia2N3Y1V4UlpubG5SbHd2VjFKalRuaE5ZMDFIUjBoT05FcGtSSGhDYUZacVdGSkpibEZYWnowaUxDSmhiR2NpT2lKU1V6STFOaUo5LmV5SnpkV0lpT2lJNU1XTmtOREEwWXkweFlqQmtMVFEyWldZdFlqbGtaUzFsTkRobE1HWXhNRFZtTmpraUxDSmxkbVZ1ZEY5cFpDSTZJakZrTVdOaFpHUTNMV0ptT0dRdE5EZG1aQzFoT1RreExUYzJZak0zT1dRMU5tUXhZeUlzSW5SdmEyVnVYM1Z6WlNJNkltRmpZMlZ6Y3lJc0luTmpiM0JsSWpvaVlYZHpMbU52WjI1cGRHOHVjMmxuYm1sdUxuVnpaWEl1WVdSdGFXNGdjR2h2Ym1VZ2IzQmxibWxrSUhCeWIyWnBiR1VnWlcxaGFXd2lMQ0poZFhSb1gzUnBiV1VpT2pFMU9UYzBOekU1TkRrc0ltbHpjeUk2SW1oMGRIQnpPbHd2WEM5amIyZHVhWFJ2TFdsa2NDNTFjeTFsWVhOMExURXVZVzFoZW05dVlYZHpMbU52YlZ3dmRYTXRaV0Z6ZEMweFgzUnZTbEo0V2psclNpSXNJbVY0Y0NJNk1UVTVOelEzTlRVME9Td2lhV0YwSWpveE5UazNORGN4T1RRNUxDSjJaWEp6YVc5dUlqb3lMQ0pxZEdraU9pSXdPVE01TXpsaU1pMHpZVEppTFRRd1l6Z3RPVFJrTXkxaE4yTTFNak5oTlRnM09EVWlMQ0pqYkdsbGJuUmZhV1FpT2lJeE1HZGtNWFJzY1dobVpuQTNPR3hzTldOcVpuVm1kR0kxTmlJc0luVnpaWEp1WVcxbElqb2lPVEZqWkRRd05HTXRNV0l3WkMwME5tVm1MV0k1WkdVdFpUUTRaVEJtTVRBMVpqWTVJbjAuVjY2UmVkZF9iQXl1TFkxNG13bEZFVWJOODFNeTVtVlFheENwZjlCNDBZbFVIUlYtVjFvcDVjeF9BekhyQTVLWXhiUEhOUHJWaEZta080TVFDQWZmdGNUMHRobHI2bEp6UkpnYmlOMFdBcU9qT0t4a292T2FTV0NfdzJDZmxKRXpqSk1PYjI2Um9yUE5Tdms4eTRqOENFX3pNbTJwVjFWVUE0bmFEUnVIY2ZQOU5OZ2VVcGVfZFBGREJhZlZjWml5TDZuZGFDeVdjMU9xbGRhbU9ycld6RVljaThXRktPd2Jzd3RRekZVZjFSRHV0WEVzZnhuU2t3dDgxWnVpMEpQUGNMVVNGdm5OejJzYUpkel85N1MwMUlmNXFSZFRTUlQ2Wmg0RlltQnJFcFQzZHlIRnNkbVlLVmdHeHVQN3hXb1ItZlI0ZWFsMWJkZVkycTVuZ0lFb193IiwicmVmcmVzaF90b2tlbiI6ImV5SmpkSGtpT2lKS1YxUWlMQ0psYm1NaU9pSkJNalUyUjBOTklpd2lZV3huSWpvaVVsTkJMVTlCUlZBaWZRLmdPNDNXZ29oWWFQaWppMDVmdEk0N21HWVhkbFN1bktEVnpzU1lGb1A1dGFuOUV4MndJWGJXY1hjd2VRZGYzSHNuZXVSMVhxRWo5Ry1lOTVoZE9pM2Zka0gzSDQzQzI0OFBlYTkxSjZZN0J2Q3Rrdjc4WjhBUWRPMDcyLUtGaTZNZlhjVzhUcUtIVGhGRmMwa3JtUS1tQVRfSl80ZmVZU2IwOWpMTWtmS3R2dXVGOUhVRG1hYlQtTlBiOGZqUDg5eWtZRC1OY05NdFcwVzJPbGdBTFR2WUFUeGRWcTBlMmtiWGdTaXRGQ013OEN0TVBoVzEwSGRpVXV2YllwTDM2cjV0X1VQaWNNMy1MLVBKRGpJR0wzQlZObldqdjZwR0RNWTcwbUFHbEozblo3VjJYMU4wOC1UTk5Jd1Z5UE1XX2tSU1RoQ1lEdld1N01EOEVQU3psRVpzQS42VExXUXRydHZ4cW16aXVVLjFvcFZRZzRKM2ZpNFNkbDJWU19WUzlOZklJS0RCRnpXaG1ybTFmN0Zsd1FZOFE0RjNDc1FYZ2tXWk9BLTE5MG1TNWg3clpXN0lvUFlFYjVITVhhSGtmVXM1cEpBNG5MTTdYTlhHTGFRZ0VWYnJNYjdZa3VDck1IY3VFUmU1V3pCd2RQSWN2aGZyZW5uRnJ2ZUc0amdlS0xET2FWd0xYQkJsSy12T3lrNzJubDM4Q0ZrRUJ3Z3FfZWJLdzNpNVRlRjU3eG9OQWxxbWdVaUpFeFZlNHA5NGRPdkVwMXhhMmV6aXFsNkhHRFUzeWQzUHlYcHNENm1rR1VjdHl3UG9HaG13eE92UXVGQTR0VVZ6ZVgyXzJfQzFzSUZOQVBLdFpMRExYaEd4Qk1Kc1dOOVFGbjFkQmtacGJjWVc2LVNPX2VoeGZoaXRaNTRVZWxXVjU0OEhEX3lnU25DTzZ4a1VORXRYT0tHODcxY2NmQTBMZ0pBVDEzQWlzRmNycjVNUjEyV1lRb203SV9iNmk4a2g5NE5hQ0g2b0ZtWmMzRHlvUGJyY19MQUV1S0ZyV2Y4RklhSGlSSTlSWjA3MUJpLWtlVjJaeG9qUlBRZ0JEMzNXTXVBT01NejNZOFRyWUZJQnV4VGhoYUJha3pwODdVZUlCX1dIVWNDR1QtbXBmbEJNaE9YVlMyT1hGMnJZRkh0c1QtUU12Qi1VU3dhXzdnZDAzenNWSEdvb1lkVjNBRlR5aUNFa2UwWGI2a3p5cnlMMXE2a3ZBWTJILXBpd2p3MWdCSmVYNnJHVk43WFBucHBHNjlzQURwaWdkZnhLOWc0OG1XOVBWYTZhNlg4NGlmbU5qWmZGam1md0N6bzlzNEE2ay1XVEhaRW9vN1AxYXdGb1JIY1FwRDI4TU9td0dtVlFfZXRZZ2VTYjdReDh2X2paV3FsNFdPUUFjVGktYUQ3MElKQzVia1hpWmozM1V4UnctcFdVRzI5VURhY1ZPRVlHOFplMU02VlNobXAxZmt4TnBiRzc0b2Y0ZzBZaHRZWXVvWFR2RkUteUNjYlJyaHU1eGJBU1pUSnVyZjZzalJNNWxyYVU2cHdFQ016NlB6NV9WMnJjWTNqZDlVU2VyQWRQR2N1R1hEMHRDUW91eXBZT0xaYjFyVkZHODNKUHdTWnY0UGY0N2VJaEItTFhVMi1halY2U3FnWUVrcGhZRTVOT1E3MHA4VnRsYTAyUWNSdlQ3WjZJRG1yLXFTdTVzQTRCWms0UDhNOXpCNjBJNlp3b3RPdmV6Tm9fY2JoREZDNUVCUzlTMWo3cGxYTjZaS3pyZm9QeUxCZ19nQkM4SXFIeGVocFhwcW1Zc1VzN3paNzRMYUhZWG92QXdNNDNuRVAwZ1JIM2o0bHZMS3QzR2p0Unl0TVN5WWx0eHNCMzI2SUJ0TFdPV1lxZ0ttRThOTTJiQWxQV1N3a09Zcm5VUmxuLUtuYlVWQy1ubU1vdkRqUTcydDNJYzVwSEFHSlNDRHV4bDhLMVIxMFZDbW9iTHRIbnZHUWZnb0Q4N2tqaHNDeGo5ZXRqQlB4Zl9LbEI5M19FQTJZU0R3OTJkVndIYjFyQ291ak1ScVhPVnJwSmV0aThlVmxVRlM4ejhIZWVoUTYtZVJvQjR3Yjl4S0VJYm9RY2FicF9iYzJVc0RhRGw2MC1uVTQzZ29wV2tXTHlQWTh3UEZBa3NKbENTT0xwNjlESnJSS2l4emRWUm41RFhUSDZsVlBMM0J6dEdXeldOakV6LU9xX0JmNzRrZTM2NV9kOG05NkktclRNYW9fZzVUVk9DS082NGN3VFFITi1qQV9pYXYyUU9melA4OFczNHN3cDlfQmxJRS00VFZPR0FoTVFvdy5tdUtoWllvdHVHRlI0bXR4a3FoMU1nIiwiZXhwaXJlc19pbiI6MzYwMCwidG9rZW5fdHlwZSI6IkJlYXJlciJ9LCJjb3VudHJ5Q29kZSI6Iis5MSIsImV4cGlyeURhdGUiOjE1OTg0NzE5NDk2NDQsInJvbGVJZCI6IjhmNDVmNDQyLTY4NWEtNGI4Yi04NmU3LWI5M2U2OWQ4MDk2ZCIsInNlc3Npb25EYXRlIjoxNTk3NDcxOTQ5NjQ0LCJzZXNzaW9uUm9sZXMiOiI4ZjQ1ZjQ0Mi02ODVhLTRiOGItODZlNy1iOTNlNjlkODA5NmQiLCJzb3VyY2VJbmZvIjp7InN1YlNvdXJjZUlkIjoiMjRlMTViZTMtOTY5NS00NGY3LTgyMjktMzRmZjRlZjgxMzk2IiwiZW50aXR5SWQiOiI5MmJkYzdiMS1kNTAwLTQ5MDEtYmZlOC04ZTE5YTA5ZmZhZDQiLCJyb2xlSWQiOiI4ZjQ1ZjQ0Mi02ODVhLTRiOGItODZlNy1iOTNlNjlkODA5NmQiLCJpc0RldmljZSI6ZmFsc2UsImRldmljZUlkIjpudWxsfSwic3ViamVjdCI6InJhdmluYS5wZ0BnbWFpbC5jb20iLCJ1c2VySWQiOiIyMzY1YTE5Ni1jYWM1LTQxNmItYmMwNS04ZWNiODE1MjAxZTEiLCJwaG9uZU51bWJlciI6Ijk4NDA5NzIyNzUifSwiaWF0IjoxNTk3NDcxOTQ5fQ.AsTrmWNw2J4helzAuyY6K_p2hf2QIP7_CgWMOTl7giY';
const String countryCode = '91';
const String mobileNumber = '9176117878';

//for security purposesf

const String STR_NOTES = 'Notes';
const String STR_ONLY_ONE = 'Can attach only one record';

//ICON for Device Reading widgets

const String Devices_BP = 'assets/devices/bp_m.png';
const String Devices_GL = 'assets/devices/gulco.png';
const String Devices_OxY = 'assets/devices/pulse_oxim.png';
const String Devices_THM = 'assets/devices/fever.png';
const String Devices_WS = 'assets/devices/weight.png';

const String Devices_BP_Tool = 'assets/devices/bp_tool.png';
const String Devices_GL_Tool = 'assets/devices/gulcose_tool.png';
const String Devices_OxY_Tool = 'assets/devices/spo2_tool.png';
const String Devices_THM_Tool = 'assets/devices/temperature_tool.png';
const String Devices_WS_Tool = 'assets/devices/weight_tool.png';

const String audioFileAACType = '.aac';
const String audioFileTypeAppStream = 'application/octet-stream';

const String SHAREECORD = 'sharerecord/';
const String KEY_DEVICEINFO = 'deviceInfo';
const String KEY_EMAIL = 'email';

//For Google Fit Integration
const String asgurduserID = '49cdc4be-afd9-419e-b3f9-1bd35207c74f';

const String activateGF = "activateGF"; // activate googleFit
const String activateHK = "activateHK"; // activate appleHealth
const String isFirstTym = "FirsTym";
const String isHealthFirstTime =
    "HealthFirstTime"; // Activating HealthKit For First Time
const String bpMon = "bpMon";
const String glMon = "GLMon";
const String oxyMon = "OxyMon";
const String thMon = "THMon";
const String wsMon = "WSMon";

//// Check Internet connectivity
const String failed_wifi = "Failed to get Wifi Name";
const String failed_wifi_bssid = "Failed to get Wifi BSSID";
const String failed_wifi_ip = "Failed to get Wifi IP";
const String wifi_connected = "Wifi connected";
const String data_connected = "Mobile data connected";
const String no_internet_conn = "No internet connection";
const String failed_get_conn = "Failed to get connectivity.";
const String failed_get_connectivity = "Failed to get internet connectivity.";
const String NOT_FILE_IMAGE = "Something went wrong";
const String TRY_AGAIN = "Please try again or report the issue to support";
const String EXIT_APP = "Exit app";
const String EXIT_APP_TO_EXIT = "Are you sure to exit app?";
const String CANCEL = "CANCEL";
const String YES = "YES";
const String CHAT = "Chats";

const String KEY_FAMILYMEMBERNEW = 'familymembernew';
const String CONSULTING = 'CONSULTING';
const String HealthOrg = 'Health Organization';
const String HEALTH_RECORDIDS = 'healthRecordIds';
const String INR = 'INR ';
const String FREE = 'FREE';
const String LAST_RECEIVED = 'Last Received: ';
const String DATE_FORMAT = 'dd MMM kk:mm';
const String NOTHING_SEND = 'Nothing to send';
const String PHONE_NUMBER = 'phoneNumber';
const String EMAIL = 'email';
const String FIRST_NAME = 'firstName';
const String LAST_NAME = 'lastName';

const String STR_MESSAGES = 'messages';
const String STR_ID_FROM = 'idFrom';
const String STR_ID_TO = 'idTo';
const String STR_TIME_STAMP = 'timestamp';
const String STR_CONTENT = 'content';
const String STR_TYPE = 'type';
const String STR_CHAT_LIST = 'chat_list';
const String STR_USER_LIST = 'user_list';
const String STR_NICK_NAME = 'nickname';
const String STR_PHOTO_URL = 'photoUrl';
const String STR_ID = 'id';
const String STR_CREATED_AT = 'createdAt';
const String STR_LAST_MESSAGE = 'lastMessage';
const String STR_IS_READ_COUNT = 'isReadCount';
const String STR_IS_MUTED = 'isMuted';
const String STR_USERS = 'users';
const String STR_CHATTING_WITH = 'chattingWith';
const String STR_META_ID = 'metaId';
const String STR_PUSH_TOKEN = 'pushToken';
const String STR_MIP_MAP_LAUNCHER = '@mipmap/ic_launcher';
const String STR_HTTPS = 'https';
const String STR_FILE = 'File';

const String STR_JPG = '.jpg';
const String STR_JPEG = '.jpeg';
const String STR_PNG = '.png';
const String STR_PDF = '.pdf';
const String STR_AAC = '.aac';

const String STR_MY_PROVIDERS = 'My Providers';
const String STR_MY_VERIFIED = 'Verified';
const String STR_NOT_VERIFIED = 'Not Verified';
const String STR_SUCCESS = 'success';
const String STR_FAILED = 'failed';
const String STR_DONE = 'Done';

const String STR_LATEST_VALUE = 'Latest Value';

const String STR_HEALTHORG_HOSPID = '67240f46-65dc-41e0-b03f-cc4e4433ee6e';
const String STR_HEALTHORG_LABID = '34c16c83-2ae6-40e4-9643-5d929eb135e4';

const String SHEELA_LANG = 'sheela_lang';
const String STR_FAMILY_ADD_MSG =
    'Your doctor will reach the appointee through your app (name) since the user does not have MyFHB app downloaded';

const String MSG_NO_VOICERECORDS = 'Voice record cannot be added for';
const String KEY_USERID_BOOK = 'userID_BOOK';
const String ERR_MSG_RECORD_CREATE =
    'Unable to save the information as the server rejected the message. Please contact Support';

const String STR_USER_PROFILE_SETTING_ALREADY =
    'User Profile Setting is already exists for this User.';
const String STR_ARE_SURE = 'Are you sure?';
const String STR_SURE_CANCEL_PAY = 'Do you want to cancel the payment';
const String STR_UPDATE_AVAIL = 'New Update Available';
const String STR_UPDATE_CONTENT =
    'There is a newer version of app available please update it now.';
const String STR_UPDATE_NOW = 'Update Now';
const String STR_LATER = 'Later';
const String STR_FIREBASE_REMOTE_KEY = 'force_update_current_version_myfhb';
const String STR_FIREBASE_REMOTE_KEY_IOS =
    'force_update_current_version_myfhb_ios';
const String STR_IS_FORCE = 'is_force_update_myfhb';
const String STR_IS_FORCE_IOS = 'is_force_update_myfhb_ios';

const APP_STORE_URL = 'https://apps.apple.com/in/app/qurbook/id1526444520';
const PLAY_STORE_URL =
    'https://play.google.com/store/apps/details?id=com.ventechsolutions.myFHB';

const String STR_HOS_ID = 'Hospital IDs';
const String STR_OTHER_ID = 'Other IDs';
const String STR_INSURE_ID = 'Insurance IDs';
const String noRegimentData =
    'No Regiments data available for the selected date';
const String noRegimentScheduleData =
    'No Activities data available for the selected date';
const String noRegimentSymptomsData =
    'No Symptoms data available for the selected date';
const String plansForFamily =
    'Regimen plans are not available for family members';
const String mplansForFamily = 'Plans are not available for family members';
const String categoriesForFamily =
    'Categories are not available for family members';
const String searchTextFirst =
    'Use the search option to enter a Hospital name or its location that offer care plans for you to subscribe';
const String searchTextSecond =
    'Choose Qurhealth as your provider to subscribe to care plans for free';
const String okButton = 'OK';
const String saveButton = 'Save';
const String select = 'Select';
const String scheduled = 'Activities';
const String symptoms = 'Symptoms';
const String scheduleTitle = 'Daily Schedule';
const String planActivities = 'Plan Activities';
const String planSymptoms = 'Plan Symptoms';
const String undo = 'Undo';
const String filter = 'Filter';
const String allActivities = 'All Activities';
const String missedActivities = 'Missed Activities';

const strJpgDot = '.jpg';
const strJpegDot = '.jpeg';
const strPdfDot = '.pdf';
const strPngDot = '.png';

const strJpg = 'jpg';
const strPdf = 'pdf';
const strPng = 'png';

const strGallery = 'photo';
const strVideo = 'video';
const strFiles = 'file';
const strAudio = 'audio';

const strYourQurplans = 'Care Plans';
const strNoQurplans = 'Care Plans';
const strPlansActive = ' Plans active';
const strYourRegimen = 'Regimen';
const strNoPlansAdded = 'No plans added';
const strActivitiesDue = ' missed activities today';
const strVitals = 'Vitals';
const strVitalsDevice = 'Devices available';
const strVitalsNoDevice = 'No devices available';
const strSymptomsCheckIn = 'Symptoms';
const strYourFamily = 'Family';
const strNoFamily = 'No family members added';
const strFamilyActive = 'Family members';
const strYourProviders = 'Providers';
const strNoProvider = 'No providers added';
const strProviderActive = 'Providers';
const strHowVideos = 'Help';
const strNoVideos = 'No videos available';
const strVideosAvailable = 'videos available';
const strChatWithUs = 'Chat with us';
const strChatAvailable = ' is available';
const strChatNotAvailable = 'No care provider assigned';
const strMyDashboard = 'Dashboard';
const String strSheelaG = 'Sheela G';
const String strAppointment = 'Appointments';
const String strNiceDay = 'Have a nice day';
const String strRegimen = 'Regimen';
const String strDevices = 'Devices';
const String strPlans = 'Hospitals';
const String strMyPlans = 'My Care Plans';
const String strCarePlans = 'Care Plans';

const strUploading = 'Uploading...';
const strSubscribe = 'Subscribe';
const strUnSubscribe = 'UnSubscribe';
const strSubscribed = 'Subscribed';
const strSelectedPlan = 'Selected Plan - ';
const strSelectedPlans = 'Selected Plan(s) - ';
const strSelectPlan = 'Select a Plan';
const strSelectPlans = 'Select your Plan(s)';
const strIsFromSubscibe = 'fromSubscribe';
const strIsRenew = 'Renew';
const goToRegimen = 'Go to Regimen';
const symptomsError = 'Data for Symptoms cannot be entered for future dates';
const activitiesError =
    'Data for future events can be entered only 15 minutes prior to the event time';
const tickInfo = 'Please tap on the check mark to log the activity';

const searchHospitals = 'Search Hospitals';

const strQurhealth = 'QurHealth';

const strCovidFree = 'Choose your FREE CARE PLANS';

const strDiseasesImage = 'https://qurplan.com/assets/icons/diseases/';
const strSVG = '.svg';
const strAllPlans = 'All Plans';

FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();
var mInitialTime;

Future<void> fbaLog({String eveName, dynamic eveParams}) async {
  try {
    await _firebaseAnalytics.logEvent(
        name: eveName ?? 'qurbook_ns_event',
        parameters: eveParams ??
            {
              'eventTime': '${DateTime.now()}',
              'navigationPage': 'Appointment page',
              'ns_type': 'appointment_list'
            });
  } catch (e) {
    print(e);
  }
}
