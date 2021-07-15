//Strings used in PatientLogin
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

//Strings used in VerifyPatient
const String strSource = "myFHBMobile";
const String strVerify = 'Verify';
const String strOtp = 'OTP';
const String strOtpHint = 'OTP Here';
const String strOtpText =
    'Enter OTP below which we sent to your mobile number ';
const String strOtpTextForFamilyMember = 'Please enter the OTP received to ';
const String mobileNumber = "'s mobile number ";

//Strings used in VerifyPatient
const String strAccount = 'Already have an account ?';
const String strSignIn = 'Sign in';
const String strPhoneType = "df61aa82-6bbf-4f09-a48a-b535ae579960";
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
const String strEnterOtpp = 'Otp must be 6 digits';

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
const String strPhoneandPass = 'Sign in with your phone number and password';
const String strEmailCantEmpty = 'Please Enter Valid Email';
const String strPhoneValidText = 'Please Enter Valid Phone Number';
const String strUserNameCantEmpty = 'Please Enter Valid User Name';
const String strUserNameValid = 'Please Enter Username in lowercase';
const String strOtpCantEmpty = 'Please Enter Valid OTP';
const String strValidOtp = 'Otp should have six characters';
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
const String strSignUpEndpoint = 'register-user';
const String strSignEndpoint = 'login';
const String strUserVerifyEndpoint = 'confirm-user';
const String strOtpVerifyEndpoint = 'auth/verify-otp';
const String strUserOtpVerifyEndpoint = 'user-relationship/verify-otp';
const String qr_refer_friend = "/user/refer-friend";
const String strResult = "result";
const String strmessage = "message";
const String strIsSuccess = 'isSuccess';
const String strStatus = "status";
const String strBearer = 'Bearer';
const String strWentWrong = 'Something went Wrong';
const String strResendConfirmCode = 'resend-confirm-code';
const String strResendGenerateOTP = 'user-relationship/generate-otp';

//Strings used in ChangePassword
const String strChangePasswordText =
    'OTP has been sent to the registered mobile number, enter it below to change the password';
const String strChangeButtonText = 'Change Password';
const String strCodeHintText = 'Otp';
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
final Pattern patternPhone = r'^(?:[+0][19])?[0-9]{10,11}$';
final Pattern patternPhoneNew = r'(^[0-9]{10}$)';
final Pattern patternOtp = r'(^[0-9]{6}$)';
final Pattern patternChar = r'^[a-zA-Z_ ]+$';
final Pattern patternPassword =
    r'^((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,20})';
final Pattern patternEmail =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

//Strings used in OtpScreenVerify
const String strToken = 'token';
const String strUserId = 'userId';
const String strUserName = 'userName';
const String strProviderPayLoad = 'providerPayload';
const String strIdToken = 'IdToken';
const String strphonenumber = 'phone_number';
const String strConfirmDialog = 'Confirmation Dialog';
const String strUserDetails = "user_details";
const String strAuthToken = "auth_token";
const String struserID = "userID";
const String strFamilyName = 'family_name';
const String strGivenName = 'given_name';
const String strUser = "user";
const String strFirebaseToken = 'Firebase Token from Login Page';
const String strNetworkIssue = 'Please Check Network Connection';
const String strresendOtp = 'Resend OTP';
const String strVerifyCall = 'Confirm via Call';
const String strOrText = 'OR';
const String strOtpNotReceived =
    'Didn\'t receive the OTP ? Retry in ';
const String strCallDirect =
    'Please call from your registered mobile number to a phone number below. Thank you for your understanding';
const String primaryNumber = 'Primary Number';
const String alternateNumber = 'Alternate Number';

//Strings used in ChangePassword
const String strNewPassword = 'newPassword';
const String strOldPassword = 'oldPassword';

const String strCare = 'Care';
const String strDiet = 'Diet';
const String strMyPlan = 'MyPlan';

//labels for country code picker page
const String strinitialMobileLabel = '91';
const String strPlusSymbol = '+';
const String strSearchCountry = 'Search here...';
const String strSearchCountryLabel = 'Search your phone code';
const String strIndianPhoneCode = 'IN';

const String strContextId = 'contextId';
const String strIsSkipMFA = 'isSkipMFA';
const String strsupportEmail =
    'If OTP is not received within 5mins, please contact to support at support@qurhealth.in';

const String strEmptyWebView = 'Plan summary will be available soon';

void openEmail({String sub = 'App Feedback', String body = ''}) async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'support@qurhealth.in',
    query: 'subject=$sub&body=$body', //add subject and body here
  );

  var url = params.toString();
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
