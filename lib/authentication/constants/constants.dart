//Strings used in PatientLogin
import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

const String struserName = 'userName';
const String strpassword = 'password';
const String strsource = 'source';
const String struser = 'user';
const String strDeviceTokenId = 'deviceTokenId';
const String strDeviceInfo = 'deviceInfo';
const String strPlatformCode = 'platformCode';
const String strIOSPLT = 'IOSPLT';
const String strANDPLT = 'ANDPLT';
const String strDevvice_Info = 'device-info';

//Strings used in PatientSignup
const String strfirstName = 'firstName';
const String strlastName = 'lastName';
const String strdateofBirth = 'dateOfBirth';
const String struserContactCollection3 = 'userContactCollection3';
const String strphoneNumberType = 'phoneNumberType';
const String strphoneNumber = 'phoneNumber';
const String stremail = 'email';
const String strisPrimary = 'isPrimary';
const String strisActive = 'isActive';
const String strcreatedOn = 'createdOn';
const String strid = 'id';
const String strverificationCode = 'verificationCode';
const String strFromSignUp = 'AfterSignup';
const String strFromVerifyFamilyMember = 'VerifyFamilyMember';

//Strings used in welcome message corp user
const String welcome = 'Welcome!';
const String corporate = 'Corporate';
const String qurhealthSolutions = 'QurHealth Solutions';
const String membership = 'Membership';
const String platinum = 'Platinum';
const String getStarted = 'Let\'s Get Started';
const String longDescription =
    'Membership for Qurbook app\nThat brings you the best-in-class health ecosystem partners for all your healthcare needs.';
const String careEmployees =
    'Cares for its employees and\ntheir family\'s health\n&\nHas offered you the';

//Strings used in VerifyPatient
const String strSource = 'myFHBMobile';
const String strVerify = 'Verify';
const String strOtp = 'One Time Password';
const String strOtpHint = 'One Time Password Here';
const String strOtpText =
    'Enter One Time Password below which we sent to your mobile number ';

const String strOtpTextVirtual = ' and to your mail id';

const String strOtpTextForFamilyMember =
    'Please enter the One Time Password received to ';
const String mobileNumber = "'s mobile number ";

//Strings used in VerifyPatient
const String strAccount = 'Already have an account ?';
const String strSignIn = 'Sign in';
const String strPhoneType = 'df61aa82-6bbf-4f09-a48a-b535ae579960';
const String strSignup = 'Sign up';
const String strPassword = 'Password';
const String strEmailValidText = 'Please Enter Valid Email';
const String strSignUpText = 'Sign up with a new account';
const String strFirstNameHint = 'First Name';
const String strEnterName = 'Please Enter Name';
const String strLastNameHint = 'Last Name';
const String strEnterLastNamee = 'Please Enter Last Name';
const String strPhoneHint = '12125551234';
const String strNewPhoneHint = '2125551234';
const String strNumberHint = 'Phone number';
const String strDobHint = 'MM/DD/YYYY';
const String strDobHintText = 'Date of Birth';
const String strEnterDob = 'Please Enter Dateofbirth';
const String strEmailHintText = 'name@host.com';
const String strEmailHint = 'Email';
const String strEnterOtpp = 'One Time Password must be 6 digits';

//Strings used in ForgotPasswordScreen
const String strResetButton = 'Reset my password';
const String strBackTo = 'Back to ?';
const String strPhoneNumberr = 'Phone Number';
const String strOtpShowText =
    'Enter the registered mobile number to change the password';

//Strings used in SignInScreen
const String strSignInText = 'Sign In';
const String strReviewPay = 'Review & Pay';
const String strRetryPay = 'Retry Payment';
const String strFreePlan = 'Confirm Subscription';
const String strForgotTxt = 'Forgot Password ?';
const String strPassCantEmpty = 'Please Enter Valid Password';
const String strSignUpTxt = 'SignUp';
const String strPhoneCantEmpty = 'Please Enter Valid Phone Number';
//const String strPhoneandPass = 'Sign in with your phone number and password';
const String strPhoneandPass = 'Sign in with your phone number';
const String strEmailCantEmpty = 'Please Enter Valid Email';
const String strPhoneValidText = 'Please Enter Valid Phone Number';
const String strUserNameCantEmpty = 'Please Enter Valid User Name';
const String strUserNameValid = 'Please Enter Username in lowercase';
const String strOtpCantEmpty = 'Please Enter Valid One Time Password';
const String strValidOtp = 'One Time Password should have six characters';
const String strPasswordMultiChecks =
    'Password should one special character, number, lowercase and uppercase alphabets';
const String strConfirmPasswordText = 'New and confirm password should be same';
const String strPasswordCheck = 'Password should more than six characters';
const String strNeedAcoount = 'Sign up with a new account';
const String strFromLogin = 'AfterLogin';

//Strings used in SignAuthService
const String strfetchString = 'Could not fetch . HTTP Status Code';
const String c_content_type_key = 'Content-Type';
const String c_content_type_val = 'application/json';
const String c_auth_key = 'Authorization';
const String myFHB_logo = 'assets/launcher/myfhb.png';
const String noMoreActivity = 'assets/no_more_activity.png';
const String strSignUpEndpoint = 'register-user';
const String strSignEndpoint = 'login';
const String strUserVerifyEndpoint = 'confirm-user';
const String strOtpVerifyEndpoint = 'auth/verify-otp';
const String strUserOtpVerifyEndpoint = 'user-relationship/verify-otp';
const String qr_refer_friend = '/user/refer-friend';
const String strResult = 'result';
const String strmessage = 'message';
const String strIsSuccess = 'isSuccess';
const String strStatus = 'status';
const String strBearer = 'Bearer';
const String strWentWrong = 'Something went Wrong';
const String strResendConfirmCode = 'resend-confirm-code';
const String strResendGenerateOTP = 'user-relationship/generate-otp';
const String strAdditionalInstructions = 'Additional Instructions';
const String noMoreActivites = 'No more activites for the day';
const String strDeleteAccountOtpVerifyEndpoint = 'user/verify-otp';
const String noMoreAlert = 'No more alerts for the day';
const String noAlert = 'No Alerts';

//tickets
const String ticketCreatedSuccessfully = 'Ticket Created Successfully';

//Strings used in ChangePassword
const String strChangePasswordText =
    'One Time Password has been sent to the registered mobile number, enter it below to change the password';

const String strChangePasswordTextVirtual =
    'One Time Password has been sent to the registered mobile number and to your mail id, enter it below to change the password';

const String strChangeButtonText = 'Change Password';
const String strCodeHintText = 'One Time Password';
const String strNewPasswordHintTxt = 'New Password';
const String strNewPasswordAgainHintText = 'Enter New Password Again';
const String strOldPasswordHintTxt = 'Old Password';

//Strings used for Validations
const String strKeyConfirmUserToken = 'confirm_usertoken';
const String strKeyChangeUserService = 'change-password';
const String strKeyConfirmUserNumber = 'confirm_usernumber';
const String strKeyVerifyOtpToken = 'verify_otptoken';
const String strKeyConfirmUserService = 'confirm_userservice';
const String strKeyVerifyOtpService = 'verify_otpservice';
const String strKeyForgotPassword = 'forgot-password';
const String strKeyConfirmForgotPassword = 'confirm-forgot-password';
const String strKeyVerifyFamilyMemberEP = 'user-relationship/verify-otp';
const Pattern patternPhone = r'^(?:[+0][19])?[0-9]{10,11}$';
const Pattern patternPhoneNew = r'(^[0-9]{10}$)';
const Pattern patternOtp = r'(^[0-9]{6}$)';
const Pattern patternChar = r'^[a-zA-Z_ ]+$';
const Pattern patternPassword =
    r'^((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,20})';
const Pattern patternEmail =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
const Pattern patternEmailAdress =
    '[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+(?!.*?\.\.)[^@]+';
//Strings used in OtpScreenVerify
const String strToken = 'token';
const String strUserId = 'userId';
const String strIsVirtualNumberUser = 'isVirtualNumberUser';
const String strUserName = 'userName';
const String strProviderPayLoad = 'providerPayload';
const String strIdToken = 'IdToken';
const String strphonenumber = 'phone_number';
const String strConfirmDialog = 'Confirmation Dialog';
const String strUserDetails = 'user_details';
const String strAuthToken = 'auth_token';
const String struserID = 'userID';
const String strFamilyName = 'family_name';
const String strGivenName = 'given_name';
const String strUser = 'user';
const String strFirebaseToken = 'Firebase Token from Login Page';
const String strNetworkIssue = 'Please Check Network Connection';
const String strresendOtp = 'Resend One Time Password';
const String strVerifyCall = 'Confirm via Call';
const String strOrText = 'OR';
const String strOtpNotReceived =
    'Didn\'t receive the One Time Password ? Retry in ';
const String strCallDirect =
    'Please call from your registered mobile number to a phone number below. Thank you for your understanding';
const String strSOSCallDirect =
    'Redirecting to make an outgoing call to SOS hotline. Please ensure you have an active sim installed on your phone.';
const String primaryNumber = 'Primary Number';
const String accept = 'Accept';
const String dismiss = 'Dismiss';
const String alternateNumber = 'Alternate Number';

//Strings used in ChangePassword
const String strNewPassword = 'newPassword';
const String strOldPassword = 'oldPassword';

const String strCare = 'Care';
const String strDiet = 'Diet';
const String strMyPlan = 'MyPlan';
const String strBundle = 'BUND';
const String strMembership = 'MEMB';

const String strProviderCare = 'ProviderCare';
const String strFreeCare = 'FreeCare';
const String strDeepLink = 'DeepLink';

const String strProviderDiet = 'ProviderDiet';
const String strFreeDiet = 'FreeDiet';

const String strAddPlan = 'Add Plan';

const String CARE_COORDINATOR_STRING = "'s (Care Coordinator)";

const String strNewChatLabel = 'New Chat';

const String strLabelNoFamily = 'No data available';

//labels for country code picker page
const String strinitialMobileLabel = '91';
const String strPlusSymbol = '+';
const String strSearchCountry = 'Search here...';
const String strSearchCountryLabel = 'Search your phone code';
const String strIndianPhoneCode = 'IN';

const String strContextId = 'contextId';
const String strIsSkipMFA = 'isSkipMFA';
const String strINsupportEmail =
    'If One Time Password is not received within 5mins, please contact support at support@qurhealth.in';

const String strUSsupportEmail =
    'If One Time Password is not received within 5mins, please contact support at support@qurhealth.com';

const String strEmptyWebView = 'Plan summary will be available soon';

const String strNoPlansCheckFree =
    'No plans found. Please check All Free Plans tab';

const String strCallMyCC = 'Call my CC';

const String strSurvey = 'Survey';

//show icons for alerts

const String MISSED_MAND_ACTIVITES = 'assets/icons/missed_mad_activities.png';
const String MISSED_MEDICATION_ALERTS =
    'assets/icons/missed_medication_alerts.png';
const String RULE_BASED_ALERTS = 'assets/icons/rule_based_alerts.png';
const String SYMPTOMS_ALERTS = 'assets/icons/symptomsAlert.png';
const String VITAL_ALERTS = 'assets/icons/vital_alerts.png';

const String CODE_MAND = 'MANDACTIVITY';
const String CODE_VITAL = 'VITALS';
const String CODE_MEDI = 'MEDICATION';
const String CODE_RULE = 'RULEALERT';
const String CODE_SYM = 'SYMPTOM';

//login and signup refinement
const String strProceed = 'Proceed';
const String strSignInValidationEndpoint = 'user/login/validation?phoneNumber=';
const String strEnterPass = 'Enter your password';
const String strCreateAccount = 'Create Account';
const String strCheckValidNumber = 'Please check the number or create a new account';



void openEmail({String sub = 'App Feedback', String body = ''}) async {
  final params = Uri(
    scheme: 'mailto',
    path: 'support@qurhealth.in',
    query: 'subject=$sub&body=$body', //add subject and body here
  );

  final url = params.toString();
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

int getMyMeetingID() {
  int min = 100000; //min and max values act as your 6 digit range
  int max = 999999;
  var randomizer = new Random();
  var rNum = min + randomizer.nextInt(max - min);

  return rNum;
}
