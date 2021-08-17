import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import '../model/patientsignup_model.dart';
import '../constants/constants.dart';
import 'authentication_validator.dart';
import 'login_screen.dart';
import 'verifypatient_screen.dart';
import '../view_model/patientauth_view_model.dart';
import '../model/patientsignup_model.dart' as signuplModel;
import '../../constants/fhb_constants.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../widgets/country_code_picker.dart';
import '../../common/CommonUtil.dart';
import '../../constants/variable_constant.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/variable_constant.dart' as variable;
import '../../src/ui/loader_class.dart';

class PatientSignUpScreen extends StatefulWidget {
  @override
  _PatientSignUpScreenState createState() => _PatientSignUpScreenState();
}

class _PatientSignUpScreenState extends State<PatientSignUpScreen> {
  final firstNameController = TextEditingController();
  final lastNamController = TextEditingController();
  final mobileNoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false;
  bool _autoValidateBool = false;
  FlutterToast toast = FlutterToast();
  final _SignupKey = GlobalKey<FormState>();
  List<UserContactCollection3> userCollection;
  AuthViewModel authViewModel;
  var checkedValue = true;
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode(strinitialMobileLabel);

  bool _isHidden = true;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();

    authViewModel = AuthViewModel();
    userCollection = List();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Signup Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = 1.sh;
    return Scaffold(
      body: Form(
        key: _SignupKey,
        child: Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Color(
              CommonUtil().getMyPrimaryColor(),
            ),
          ),
          child: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                        Text(
                          strSignUpText,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                          ),
                        ),
                        Column(
                          children: [
                            _signupTextFields(
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: strFirstNameHint,
                                  labelText: strFirstNameHint,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor()),
                                      )),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                                controller: firstNameController,
                                autovalidate: _autoValidateBool,
                                validator: (value) {
                                  return AuthenticationValidator()
                                      .charValidation(value, patternChar,
                                          strEnterFirstname);
                                },
                                onSaved: (value) {},
                              ),
                            ),
                            SizedBox(height: 10.0.h),
                            _signupTextFields(
                              TextFormField(
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                                autovalidate: _autoValidateBool,
                                decoration: InputDecoration(
                                  hintText: strLastNameHint,
                                  labelText: strLastNameHint,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor()),
                                      )),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                    ),
                                  ),
                                ),
                                controller: lastNamController,
                                validator: (value) {
                                  return AuthenticationValidator()
                                      .charValidation(value, patternChar,
                                          strEnterLastNamee);
                                },
                                onSaved: (value) {},
                              ),
                            ),
                            SizedBox(height: 10.0.h),
                            _signupTextFields(
                              TextFormField(
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                                autovalidate: _autoValidateBool,
                                decoration: InputDecoration(
                                  hintText: strNewPhoneHint,
                                  labelText: strNumberHint,
                                  prefixIcon: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 100.0.w, minWidth: 50.0.w),
                                    child: CountryCodePickerPage(
                                        onValuePicked: (country) => setState(
                                            () => _selectedDialogCountry =
                                                country),
                                        selectedDialogCountry:
                                            _selectedDialogCountry),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor()),
                                      )),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  return AuthenticationValidator()
                                      .phoneValidation(value, patternPhoneNew,
                                          strPhoneCantEmpty);
                                },
                                controller: mobileNoController,
                                onSaved: (value) {},
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(height: 10.0.h),
                            _signupTextFields(
                              TextFormField(
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                                autovalidate: _autoValidateBool,
                                decoration: InputDecoration(
                                  hintText: strEmailHintText,
                                  labelText: strEmailHint,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor()),
                                      )),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                validator: (value) {
                                  return AuthenticationValidator()
                                      .emailValidation(value, patternEmailAdress,
                                          strEmailValidText);
                                },
                                onSaved: (value) {},
                              ),
                            ),
                            SizedBox(height: 10.0.h),
                            _signupTextFields(
                              TextFormField(
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                                autovalidate: _autoValidateBool,
                                obscureText: _isHidden,
                                decoration: InputDecoration(
                                  hintText: strPassword,
                                  labelText: strPassword,
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
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor()),
                                      )),
                                  errorMaxLines: 2,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                    ),
                                  ),
                                ),
                                controller: passwordController,
                                validator: (value) {
                                  return AuthenticationValidator()
                                      .passwordValidation(value,
                                          patternPassword, strPassCantEmpty);
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

  Widget _saveUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
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
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 15.0.sp,
              horizontal: 15.0.sp,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(begin: Alignment.centerLeft, colors: [
//                  Color(0xff138fcf),
//                  Color(0xff138fcf),
                  Color(CommonUtil().getMyPrimaryColor()),
                  Color(CommonUtil().getMyGredientColor())
                ])),
            child: Text(
              strSignup,
              style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  _savePatientDetails() async {
    FocusScope.of(context).unfocus();
    userCollection.clear();
    userCollection = List();
    if (_SignupKey.currentState.validate() && checkedValue) {
      _SignupKey.currentState.save();
      LoaderClass.showLoadingDialog(context);
      var user3 = UserContactCollection3();
      user3.phoneNumber =
          '$strPlusSymbol${_selectedDialogCountry.phoneCode}${mobileNoController.text.trim()}';
      user3.email = emailController.text.trim();
      user3.isPrimary = true;
      userCollection.add(user3);
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
      postMediaData[struserContactCollection3] = userCollection.toList();
      final response = await authViewModel.registerPatient(postMediaData);
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
    if (response.isSuccess) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyPatient(
                    PhoneNumber:
                        '$strPlusSymbol${_selectedDialogCountry.phoneCode}${mobileNoController.text.trim()}',
                    from: strFromSignUp,
                    userConfirm: false,
                    emailId: emailController.text.trim(),
                  )));
    } else {
      toast.getToast(response.message, Colors.red);
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
              strSignIn,
              style: TextStyle(
                  color: Color(CommonUtil().getMyPrimaryColor()),
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
          activeColor: Color(CommonUtil().getMyPrimaryColor()),
          checkColor: Colors.white,
          value: checkedValue,
          onChanged: (newValue) {
            setState(() {
              checkedValue = newValue;
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
                      Constants.terms_of_service, variable.file_terms, true);
                },
                child: Text(
                  'T&C',
                  style: TextStyle(
                    color: Color(CommonUtil().getMyPrimaryColor()),
                  ),
                ),
              ),
              Text(' and '),
              InkWell(
                onTap: () {
                  CommonUtil().openWebViewNew(
                      Constants.privacy_policy, variable.file_privacy, true);
                },
                child: Text(
                  'Privacy Policy ',
                  style: TextStyle(
                    color: Color(CommonUtil().getMyPrimaryColor()),
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
