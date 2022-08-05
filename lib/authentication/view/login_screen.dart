import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import '../model/patientlogin_model.dart';
import '../constants/constants.dart';
import 'authentication_validator.dart';
import 'forgotpassword_screen.dart';
import 'signup_screen.dart';
import 'verify_arguments.dart';
import 'verifypatient_screen.dart';
import '../view_model/patientauth_view_model.dart';
import '../model/patientlogin_model.dart' as loginModel;
import '../../constants/fhb_constants.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../widgets/country_code_picker.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_parameters.dart' as parameters;
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart';
import '../../src/model/Authentication/UserModel.dart';
import '../../src/ui/loader_class.dart';
import '../../src/utils/PageNavigator.dart';
import '../../constants/fhb_constants.dart' as Constants;

class PatientSignInScreen extends StatefulWidget {
  @override
  _PatientSignInScreenState createState() => _PatientSignInScreenState();
}

class _PatientSignInScreenState extends State<PatientSignInScreen> {
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByIsoCode(CommonUtil.REGION_CODE);
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false;
  final _loginKey = GlobalKey<FormState>();
  bool _autoValidateBool = false;
  AuthViewModel authViewModel;
  FlutterToast toast = FlutterToast();
  String decodesstring;
  UserModel saveuser = UserModel();
  String user_mobile_no;
  String id_token_string;
  Map<String, dynamic> dataForResendOtp;
  //CommonUtil commonUtil = new CommonUtil();
  bool _isHidden = true;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    authViewModel = AuthViewModel();
    /* try {
      commonUtil.versionCheck(context);
    } catch (e) {
    }*/
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Login Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = 1.sh;
    return Scaffold(
      body: Form(
        key: _loginKey,
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
                  padding: EdgeInsets.symmetric(
                      horizontal: CommonUtil().isTablet ? 50 : 20),
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
                        SizedBox(height: 20.0.h),
                        Text(
                          strPhoneandPass,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Column(
                          children: [
                            _loginTextFields(
                              TextFormField(
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                                autovalidate: _autoValidateBool,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  counterText: "",
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
                                  hintText: strNewPhoneHint,
                                  labelText: strNumberHint,
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
                                      )),
                                ),
                                validator: (value) {
                                  return AuthenticationValidator()
                                      .phoneValidation(value, patternPhoneNew,
                                          strPhoneCantEmpty);
                                },
                                controller: numberController,
                                onSaved: (value) {},
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(height: 10.0.h),
                            _loginTextFields(
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
                                      .loginPasswordValidation(value,
                                          patternPassword, strPassCantEmpty);
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()));
                            },
                            child: Text(strForgotTxt,
                                style: TextStyle(
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        _loginsavebutton(),
                        SizedBox(height: 10.0.h),
                        _gotoregistertap(),
                      ],
                    ),
                  ),
                ),
                /* Positioned(
                top: 40,
                left: 0,
              ),*/
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

  Widget _gotoregistertap() {
    return Container(
      padding: EdgeInsets.all(15.0.sp),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            strNeedAcoount,
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
                      builder: (context) => PatientSignUpScreen()));
            },
            child: Text(
              strSignUpTxt,
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

  _savepatientdetails() async {
    FocusScope.of(context).unfocus();
    if (_loginKey.currentState.validate()) {
      _loginKey.currentState.save();
      LoaderClass.showLoadingDialog(context);
      var logInModel = PatientLogIn(
        userName:
            '$strPlusSymbol${_selectedDialogCountry.phoneCode}${numberController.text}',
        password: passwordController.text,
        source: strSource,
      );
      final map = logInModel.toJson();
      final response = await authViewModel.loginPatient(map);
      //print(response.toString());
      dataForResendOtp = map;
      //_checkResponse(response);
      _checkifItsGuest(response);
    } else {
      setState(() {
        _autoValidateBool = true;
      });
    }
  }

  _checkResponse(PatientLogIn response) {
    //print(response.toJson().toString());
    if (response.isSuccess) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyPatient(
                    PhoneNumber:
                        '$strPlusSymbol${_selectedDialogCountry.phoneCode}${numberController.text}',
                    from: strFromLogin,
                    userConfirm: false,
                    dataForResendOtp: dataForResendOtp,
                    forFamilyMember: false,
                  )));
    } else {
      if (response.message == 'User is not confirmed.') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyPatient(
                      PhoneNumber: response.diagnostics.errorData.userName,
                      from: strFromSignUp,
                      userConfirm: true,
                      userId: response.diagnostics.errorData.userId,
                      forFamilyMember: false,
                    )));
      } else {
        toast.getToast(response.message, Colors.red);
      }
    }
  }

  Widget _loginTextFields(Widget textFormField) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2), child: textFormField);
  }

  Widget _loginsavebutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            AuthenticationValidator().checkNetwork().then((intenet) {
              if (intenet != null && intenet) {
                _savepatientdetails();
              } else {
                toast.getToast(strNetworkIssue, Colors.red);
              }
            });
          },
          child: Container(
            padding:
                EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 15.0.sp),
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
                gradient: LinearGradient(end: Alignment.centerRight, colors: [
//                  Color(0xff138fcf),
//                  Color(0xff138fcf),
                  Color(CommonUtil().getMyPrimaryColor()),
                  Color(CommonUtil().getMyGredientColor())
                ])),
            child: Text(
              strSignInText,
              style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _checkifItsGuest(PatientLogIn response) async {
    if (response.isSuccess) {
      decodesstring = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
      saveuser.auth_token = decodesstring;
      final bool isSkipMFA =
          parseJwtPayLoad(decodesstring)[strToken][strIsSkipMFA];
      print(isSkipMFA);
      if (isSkipMFA) {
        final String userId =
            parseJwtPayLoad(decodesstring)[strToken][strUserId];
        saveuser.userId = userId;
        id_token_string = parseJwtPayLoad(decodesstring)[strToken]
            [strProviderPayLoad][strIdToken];
        final idTokens = parseJwtPayLoad(id_token_string);
        print(idTokens);
        user_mobile_no = idTokens[strphonenumber];
        print(idTokens[strphonenumber]);
        saveuser.family_name = idTokens[strFamilyName];
        print(idTokens[strFamilyName]);
        saveuser.phone_number = idTokens[strphonenumber];
        final String ph = idTokens[strphonenumber];
        print(idTokens[strphonenumber]);
        saveuser.given_name = idTokens[strGivenName];
        print(idTokens[strGivenName]);
        saveuser.email = idTokens[stremail];
        print(idTokens[stremail]);
        await PreferenceUtil.saveString(Constants.MOB_NUM, user_mobile_no)
            .then((onValue) {});
        await PreferenceUtil.saveString(Constants.KEY_EMAIL, saveuser.email)
            .then((onValue) {});
        await PreferenceUtil.saveString(Constants.KEY_AUTHTOKEN, decodesstring)
            .then((onValue) {});
        print(decodesstring);
        await PreferenceUtil.saveString(Constants.KEY_USERID_MAIN, userId)
            .then((onValue) {});
        await PreferenceUtil.saveString(Constants.KEY_USERID, userId)
            .then((onValue) {});
        PreferenceUtil.save(strUserDetails, saveuser);
        authToken = decodesstring;
        final _firebaseMessaging = FirebaseMessaging.instance;
        var token = await _firebaseMessaging.getToken();
        await CommonUtil()
            .sendDeviceToken(
                userId, saveuser.email, user_mobile_no, token, true)
            .then((value) {
          LoaderClass.hideLoadingDialog(context);
          if (value != null) {
            Future.delayed(Duration(seconds: 3), () {
              PageNavigator.goToPermanent(context, router.rt_Landing);
            });
          } else {
            FHBBasicWidget().showDialogWithTwoButtons(context, () {
              PageNavigator.goToPermanent(context, router.rt_Landing);
            }, value.message, strConfirmDialog);
          }
        });
        // openHomeScreenOrProfile(userDetails, doctorId);
      } else {
        LoaderClass.hideLoadingDialog(context);
        _checkResponse(response);
      }
    } else {
      LoaderClass.hideLoadingDialog(context);
      _checkResponse(response);
    }
  }
}
