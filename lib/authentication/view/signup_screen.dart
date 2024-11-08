import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';

import '../../common/CommonUtil.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/variable_constant.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../main.dart';
import '../../src/ui/loader_class.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/app_primary_button.dart';
import '../constants/constants.dart';
import '../model/Country.dart';
import '../model/patientlogin_model.dart';
import '../model/patientsignup_model.dart';
import '../view_model/patientauth_view_model.dart';
import '../widgets/country_code_picker.dart';
import 'authentication_validator.dart';
import 'login_screen.dart';
import 'verifypatient_screen.dart';

class PatientSignUpScreen extends StatefulWidget {
  PatientSignUpScreen(
      {this.flag = 0,
      this.signInValidationModel,
      this.selDialogCountry,
      this.mobNo});

  final int flag;
  final SignInValidationModel? signInValidationModel;
  final Country? selDialogCountry;
  final String? mobNo;

  @override
  _PatientSignUpScreenState createState() => _PatientSignUpScreenState();
}

class _PatientSignUpScreenState extends State<PatientSignUpScreen> {
  final firstNameController = TextEditingController();
  final lastNamController = TextEditingController();
  final mobileNoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isLoading = false;
  bool _autoValidateBool = false;
  FlutterToast toast = FlutterToast();
  final _SignupKey = GlobalKey<FormState>();
  List<UserContactCollection3>? userCollection;
  AuthViewModel? authViewModel;
  var checkedValue = true;
  Country _selectedDialogCountry = Country.fromCode(CommonUtil.REGION_CODE);

  bool _isHidden = true;
  bool _isConfirmPwdHidden = true;

  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBASignupScreen);
    authViewModel = AuthViewModel();
    userCollection = [];
    onInit();
  }

  onInit() {
    try {
      _selectedDialogCountry =
          (widget.selDialogCountry ?? Country.fromCode(CommonUtil.REGION_CODE));
      mobileNoController.text = CommonUtil().validString(widget.mobNo ?? "");
      if (widget.flag == 1) {
        firstNameController.text = CommonUtil()
            .validString(widget.signInValidationModel?.result?.firstName ?? "");
        lastNamController.text = CommonUtil()
            .validString(widget.signInValidationModel?.result?.lastName ?? "");
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = 1.sh;
    return Scaffold(
      body: Form(
        key: _SignupKey,
        child: Theme(
          data: Theme.of(context).copyWith(
            primaryColor: mAppThemeProvider.primaryColor,
          ),
          child: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: CommonUtil().isTablet! ? 50 : 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .1),
                        AssetImageWidget(
                          icon: myFHB_logo,
                          height: 120.0.h,
                          width: 120.0.h,
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        if (widget.flag == 1) ...{
                          Text(
                            widget.signInValidationModel?.result != null &&
                                    widget.signInValidationModel?.result
                                            ?.firstName !=
                                        null &&
                                    widget.signInValidationModel?.result
                                            ?.firstName !=
                                        ''
                                ? 'Hey, ${toBeginningOfSentenceCase((widget.signInValidationModel?.result?.firstName ?? ""))}'
                                : '',
                            style: TextStyle(
                              fontSize: CommonUtil().isTablet!
                                  ? Constants.tabFontTitle
                                  : Constants.mobileFontTitle,
                              color: mAppThemeProvider.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                        },
                        if (widget.flag == 1) ...{
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 17.0.sp,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: '$strSignUpYourProvider ',
                                ),
                                TextSpan(
                                  text:
                                      '${widget.signInValidationModel?.result?.providerName ?? ''} ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '$strSignUpProviderHasInvitedYouto ${CommonUtil.isUSRegion() ? strQurHome : strAPP_NAME}',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.0.h,
                          ),
                        },
                        Text(
                          widget.flag == 0
                              ? strSignUpText
                              : strSignUpFinishText,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                          ),
                        ),
                        SizedBox(
                          height: 5.0.h,
                        ),
                        Column(
                          children: [
                            if (widget.flag == 0) ...{
                              _signupTextFields(
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    hintText: strFirstNameHint,
                                    labelText: strFirstNameHint,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: mAppThemeProvider.primaryColor,
                                        )),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: mAppThemeProvider.primaryColor,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                  ),
                                  controller: firstNameController,
                                  autovalidateMode: _autoValidateBool
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  validator: (value) {
                                    return AuthenticationValidator()
                                        .charValidation(
                                            value!,
                                            patternChar as String,
                                            strPleaseEnterFirstname);
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                              SizedBox(height: 10.0.h),
                              _signupTextFields(
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                  ),
                                  autovalidateMode: _autoValidateBool
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  decoration: InputDecoration(
                                    hintText: strLastNameHint,
                                    labelText: strLastNameHint,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: mAppThemeProvider.primaryColor,
                                        )),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: mAppThemeProvider.primaryColor,
                                      ),
                                    ),
                                  ),
                                  controller: lastNamController,
                                  validator: (value) {
                                    return AuthenticationValidator()
                                        .charValidation(
                                            value!,
                                            patternChar as String,
                                            strEnterLastNamee);
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                              SizedBox(height: 10.0.h),
                              _signupTextFields(
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                  ),
                                  autovalidateMode: _autoValidateBool
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  decoration: InputDecoration(
                                    hintText: strNewPhoneHint,
                                    labelText: strNumberHint,
                                    counterText: "",
                                    prefixIcon: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 75.0.w,
                                        minWidth: 75.0.w,
                                      ),
                                      child: CountryCodePickerPage(
                                        selectedCountry: _selectedDialogCountry,
                                        isFromAuthenticationScreen: true,
                                        onValuePicked: (country) => setState(
                                          () =>
                                              _selectedDialogCountry = country,
                                        ),
                                        isEnabled: BASE_URL != prodUSURL,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: mAppThemeProvider.primaryColor,
                                        )),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: mAppThemeProvider.primaryColor,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    return AuthenticationValidator()
                                        .phoneValidation(
                                            value!,
                                            patternPhoneNew as String,
                                            strPhoneCantEmpty);
                                  },
                                  controller: mobileNoController,
                                  maxLength: 10,
                                  onSaved: (value) {},
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(height: 10.0.h),
                            },
                            _signupTextFields(
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                                autovalidateMode: _autoValidateBool
                                    ? AutovalidateMode.always
                                    : AutovalidateMode.disabled,
                                decoration: InputDecoration(
                                  hintText: CommonUtil.isUSRegion()
                                      ? strUSEmailHintText
                                      : strEmailHintText,
                                  hintStyle: TextStyle(
                                      color: CommonUtil.isUSRegion()
                                          ? Colors.grey
                                          : null),
                                  labelText: strEmailHint,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: mAppThemeProvider.primaryColor,
                                      )),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: mAppThemeProvider.primaryColor,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                validator: (value) {
                                  return CommonUtil.toCheckEmailValidiation(
                                      value,
                                      patternEmail as String,
                                      strEmailValidText);
                                },
                                onSaved: (value) {},
                              ),
                            ),
                            SizedBox(height: 10.0.h),
                            _signupTextFields(
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                                autovalidateMode: _autoValidateBool
                                    ? AutovalidateMode.always
                                    : AutovalidateMode.disabled,
                                obscureText: _isHidden,
                                decoration: InputDecoration(
                                  hintText: strNewPasswordHintTxt,
                                  labelText: strNewPasswordHintTxt,
                                  suffix: InkWell(
                                    onTap: _togglePasswordView,
                                    child: Icon(
                                      _isHidden
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 18,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: mAppThemeProvider.primaryColor,
                                      )),
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: mAppThemeProvider.primaryColor,
                                    ),
                                  ),
                                ),
                                controller: passwordController,
                                validator: (value) {
                                  return AuthenticationValidator()
                                      .passwordValidation(
                                          value!,
                                          patternPassword as String,
                                          strPassCantEmpty);
                                },
                              ),
                            ),
                            SizedBox(height: 10.0.h),
                            _signupTextFields(
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                                autovalidateMode: _autoValidateBool
                                    ? AutovalidateMode.always
                                    : AutovalidateMode.disabled,
                                obscureText: _isConfirmPwdHidden,
                                decoration: InputDecoration(
                                  hintText: strConfirmationPassword,
                                  labelText: strConfirmationPassword,
                                  suffix: InkWell(
                                    onTap: _toggleConfirmPasswordView,
                                    child: Icon(
                                      _isConfirmPwdHidden
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 18,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: mAppThemeProvider.primaryColor,
                                      )),
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: mAppThemeProvider.primaryColor,
                                    ),
                                  ),
                                ),
                                controller: confirmPasswordController,
                                validator: (value) {
                                  if ((value != null) &&
                                      ((value ?? "").trim().isEmpty)) {
                                    return strPassCantEmpty;
                                  } else if (value !=
                                      passwordController.text
                                          .toString()
                                          .trim()) {
                                    return strConfirmPasswordCheck;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        _termsAndCondtionsView(),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        _saveUser(),
                        _accountToSign(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isConfirmPwdHidden = !_isConfirmPwdHidden;
    });
  }

  Widget _saveUser() => Align(
        child: AppPrimaryButton(
          onTap: () {
            AuthenticationValidator().checkNetwork().then((intenet) {
              if (intenet != null && intenet) {
                checkedValue
                    ? null
                    : FlutterToast().getToast(
                        'Please accept terms and conditions', Colors.black54);
                _savePatientDetails();
              } else {
                toast.getToast(strNetworkIssue, Colors.red);
              }
            });
          },
          text: strSignup,
        ),
      );

  _savePatientDetails() async {
    FocusScope.of(context).unfocus();
    userCollection!.clear();
    userCollection = [];
    if (_SignupKey.currentState!.validate() && checkedValue) {
      _SignupKey.currentState!.save();
      LoaderClass.showLoadingDialog(context);
      var user3 = UserContactCollection3();
      user3.phoneNumber =
          '${_selectedDialogCountry.phoneCode}${mobileNoController.text.trim()}';
      user3.email = emailController.text.trim();
      user3.isPrimary = true;
      userCollection!.add(user3);
      var patientSignUp = PatientSignUp();
      patientSignUp.firstName = firstNameController.text.trim();
      patientSignUp.lastName = lastNamController.text.trim();
      patientSignUp.source = strSource;
      patientSignUp.password = passwordController.text;
      final postMediaData = Map<String, dynamic>();
      postMediaData[strfirstName] = firstNameController.text.trim();
      postMediaData[strlastName] = lastNamController.text.trim();
      postMediaData[strsource] = strSource;
      postMediaData[strpassword] = passwordController.text.trim();
      postMediaData[struserContactCollection3] = userCollection!.toList();
      final response = await authViewModel!.registerPatient(postMediaData);
      print(response.toString());
      _checkResponse(response);
    } else {
      setState(() {
        _autoValidateBool = true;
      });
    }
  }

  _checkResponse(PatientSignUp response) {
    print(response.toJson().toString());
    LoaderClass.hideLoadingDialog(context);
    if (response.isSuccess!) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyPatient(
            PhoneNumber:
                '${_selectedDialogCountry.phoneCode}${mobileNoController.text.trim()}',
            from: strFromSignUp,
            userConfirm: false,
            fromSignUp: true,
            emailId: emailController.text.trim(),
            pwd: passwordController.text.trim().toString(),
          ),
        ),
      );
    } else {
      toast.getToastWithBuildContext(response.message!, Colors.red, context);
    }
  }

  Widget _accountToSign() {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            strAccount,
            style: TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10.0.w,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PatientSignInScreen()));
            },
            child: Text(
              strLoginText,
              style: TextStyle(
                  color: mAppThemeProvider.primaryColor,
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signupTextFields(Widget textFormField) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2), child: textFormField);
  }

  Widget _termsAndCondtionsView() {
    return Row(
      children: [
        Checkbox(
          activeColor: mAppThemeProvider.primaryColor,
          checkColor: Colors.white,
          value: checkedValue,
          onChanged: (newValue) {
            setState(() {
              checkedValue = newValue!;
            });
          },
        ),
        Flexible(
          child: Wrap(
            children: [
              Text('By signing up, I agree with Qurhealth\'s ',
                  style: TextStyle(color: Colors.black)),
              InkWell(
                onTap: () {
                  CommonUtil().openWebViewNew(
                      Constants.terms_of_service,
                      CommonUtil.isUSRegion()
                          ? variable.file_terms_us
                          : variable.file_terms,
                      true);
                },
                child: Text(
                  'T&C',
                  style: TextStyle(
                    color: mAppThemeProvider.primaryColor,
                  ),
                ),
              ),
              Text(' and '),
              InkWell(
                onTap: () {
                  CommonUtil().openWebViewNew(
                      Constants.privacy_policy,
                      CommonUtil.isUSRegion()
                          ? variable.file_privacy_us
                          : variable.file_privacy,
                      true);
                },
                child: Text(
                  'Privacy Policy ',
                  style: TextStyle(
                    color: mAppThemeProvider.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
