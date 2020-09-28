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
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';

class PatientSignInScreen extends StatefulWidget {
  @override
  _PatientSignInScreenState createState() => _PatientSignInScreenState();
}

class _PatientSignInScreenState extends State<PatientSignInScreen> {
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false;
  var _loginKey = GlobalKey<FormState>();
  bool _autoValidateBool = false;
  AuthViewModel authViewModel;
  FlutterToast toast = new FlutterToast();
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
                                hintText: strPhoneHint,
                                labelText: strNumberHint,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(0xff138fcf),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                return AuthenticationValidator()
                                    .phoneValidation(
                                        value, patternPhone, strPhoneCantEmpty);
                              },
                              controller: numberController,
                              onSaved: (value) {},
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(0xff138fcf),
                                  ),
                                ),
                              ),
                              controller: passwordController,
                              validator: (value) {
                                return AuthenticationValidator()
                                    .passwordValidation(value, patternPassword,
                                        strPassCantEmpty);
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
                  color: Color(0xff138fcf),
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
      PatientLogIn logInModel = new PatientLogIn(
        userName: numberController.text,
        password: passwordController.text,
        source: strSource,
      );
      Map<String, dynamic> map = logInModel.toJson();
      loginModel.PatientLogIn response = await authViewModel.loginPatient(map);
      print(response.toString());
      _checkResponse(response);
    } else {
      setState(() {
        _autoValidateBool = true;
      });
    }
  }

  _checkResponse(PatientLogIn response) {
    if (response.isSuccess) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyPatient(
                    PhoneNumber: numberController.text,
                    from: strFromLogin,
                  )));
    } else {
      toast.getToast(response.message, Colors.red);
    }
  }

  Widget _loginTextFields(TextFormField textFormField) {
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
                  Color(0xff138fcf),
                  Color(0xff138fcf),
                ])),
        child: Text(
          strSignInText,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
