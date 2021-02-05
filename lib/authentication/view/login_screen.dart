import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/authentication/model/patientlogin_model.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/view/authentication_validator.dart';
import 'package:myfhb/authentication/view/forgotpassword_screen.dart';
import 'package:myfhb/authentication/view/signup_screen.dart';
import 'package:myfhb/authentication/view/verify_arguments.dart';
import 'package:myfhb/authentication/view/verifypatient_screen.dart';
import 'package:myfhb/authentication/view_model/patientauth_view_model.dart';
import 'package:myfhb/authentication/model/patientlogin_model.dart'
    as loginModel;
import 'package:myfhb/authentication/widgets/country_code_picker.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/model/Authentication/UserModel.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class PatientSignInScreen extends StatefulWidget {
  @override
  _PatientSignInScreenState createState() => _PatientSignInScreenState();
}

class _PatientSignInScreenState extends State<PatientSignInScreen> {
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode(strinitialMobileLabel);
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false;
  var _loginKey = GlobalKey<FormState>();
  bool _autoValidateBool = false;
  AuthViewModel authViewModel;
  FlutterToast toast = new FlutterToast();
  String decodesstring;
  UserModel saveuser = UserModel();
  String user_mobile_no;
  String id_token_string;
  Map<String, dynamic> dataForResendOtp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authViewModel = new AuthViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Form(
        key: _loginKey,
        child: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .1),
                      AssetImageWidget(
                        icon: myFHB_logo,
                        height: 120,
                        width: 120,
                      ),
                      SizedBox(height: 20),
                      Text(strPhoneandPass),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          _loginTextFields(
                            TextFormField(
                              autovalidate: _autoValidateBool,
                              decoration: InputDecoration(
                                prefixIcon: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 100, minWidth: 50),
                                  child: CountryCodePickerPage(
                                      onValuePicked: (Country country) =>
                                          setState(() =>
                                              _selectedDialogCountry = country),
                                      selectedDialogCountry:
                                          _selectedDialogCountry),
                                ),
                                hintText: strNewPhoneHint,
                                labelText: strNumberHint,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                    )),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Color(CommonUtil().getMyPrimaryColor()),
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
                          SizedBox(height: 10),
                          _loginTextFields(
                            TextFormField(
                              autovalidate: _autoValidateBool,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: strPassword,
                                labelText: strPassword,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                    )),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(CommonUtil().getMyPrimaryColor()),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgotPasswordScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(strForgotTxt,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      SizedBox(height: 10),
                      _loginsavebutton(),
                      SizedBox(height: height * .015),
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
    );
  }

  Widget _gotoregistertap() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PatientSignUpScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              strNeedAcoount,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              strSignUpTxt,
              style: TextStyle(
                  color: Color(CommonUtil().getMyPrimaryColor()),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  _savepatientdetails() async {
    FocusScope.of(context).unfocus();
    if (_loginKey.currentState.validate()) {
      _loginKey.currentState.save();
      LoaderClass.showLoadingDialog(context);
      PatientLogIn logInModel = new PatientLogIn(
        userName:
            '${strPlusSymbol}${_selectedDialogCountry.phoneCode}${numberController.text}',
        password: passwordController.text,
        source: strSource,
      );
      Map<String, dynamic> map = logInModel.toJson();
      loginModel.PatientLogIn response = await authViewModel.loginPatient(map);
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
                        '${strPlusSymbol}${_selectedDialogCountry.phoneCode}${numberController.text}',
                    from: strFromLogin,
                    userConfirm: false,
                    dataForResendOtp: dataForResendOtp,
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
    return InkWell(
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
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
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
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
//                  Color(0xff138fcf),
//                  Color(0xff138fcf),
                  Color(new CommonUtil().getMyPrimaryColor()),
                  Color(new CommonUtil().getMyGredientColor())
                ])),
        child: Text(
          strSignInText,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _checkifItsGuest(PatientLogIn response) async {
    if (response.isSuccess) {
      decodesstring =
          await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
      saveuser.auth_token = decodesstring;
      bool isSkipMFA = parseJwtPayLoad(decodesstring)[strToken][strIsSkipMFA];
      print(isSkipMFA);
      if (isSkipMFA) {
        String userId = parseJwtPayLoad(decodesstring)[strToken][strUserId];
        saveuser.userId = userId;
        id_token_string = parseJwtPayLoad(decodesstring)[strToken]
            [strProviderPayLoad][strIdToken];
        var id_tokens = parseJwtPayLoad(id_token_string);
        print(id_tokens);
        user_mobile_no = id_tokens[strphonenumber];
        print(id_tokens[strphonenumber]);
        saveuser.family_name = id_tokens[strFamilyName];
        print(id_tokens[strFamilyName]);
        saveuser.phone_number = id_tokens[strphonenumber];
        String ph = id_tokens[strphonenumber];
        print(id_tokens[strphonenumber]);
        saveuser.given_name = id_tokens[strGivenName];
        print(id_tokens[strGivenName]);
        saveuser.email = id_tokens[stremail];
        print(id_tokens[stremail]);
        PreferenceUtil.saveString(Constants.MOB_NUM, user_mobile_no)
            .then((onValue) {});
        PreferenceUtil.saveString(Constants.KEY_EMAIL, saveuser.email)
            .then((onValue) {});
        PreferenceUtil.saveString(Constants.KEY_AUTHTOKEN, decodesstring)
            .then((onValue) {});
        print(decodesstring);
        PreferenceUtil.saveString(Constants.KEY_USERID_MAIN, userId)
            .then((onValue) {});
        PreferenceUtil.saveString(Constants.KEY_USERID, userId)
            .then((onValue) {});
        PreferenceUtil.save(strUserDetails, saveuser);
        authToken = decodesstring;
        FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        final token = await _firebaseMessaging.getToken();
        CommonUtil()
            .sendDeviceToken(
                userId, saveuser.email, user_mobile_no, token, true)
            .then((value) {
          LoaderClass.hideLoadingDialog(context);
          if (value != null) {
            Future.delayed(Duration(seconds: 3), () {
              PageNavigator.goToPermanent(context, router.rt_Dashboard);
            });
          } else {
            new FHBBasicWidget().showDialogWithTwoButtons(context, () {
              PageNavigator.goToPermanent(context, router.rt_Dashboard);
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
