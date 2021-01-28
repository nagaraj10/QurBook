import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/model/forgot_password_model.dart';
import 'package:myfhb/authentication/view/authentication_validator.dart';
import 'package:myfhb/authentication/view/confirm_password_screen.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:myfhb/authentication/view_model/patientauth_view_model.dart';
import 'package:myfhb/authentication/model/forgot_password_model.dart'
    as forgotPasswordModel;
import 'package:myfhb/authentication/widgets/country_code_picker.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode(strinitialMobileLabel);
  final mobileController = TextEditingController();
  bool _autoValidateBool = false;
  FlutterToast toast = new FlutterToast();
  AuthViewModel authViewModel;
  var _ForgetPassKey = GlobalKey<FormState>();
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
        key: _ForgetPassKey,
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
                      Text(strOtpShowText),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          _resettextfields(
                              strPhoneNumber, strPhoneHint, mobileController),
                        ],
                      ),
                      SizedBox(height: 10),
                      _resetbutton(),
                      SizedBox(height: height * .015),
                      Text(strsupportEmail,style: TextStyle(fontSize: 13),),
                      // RichText(
                      //   softWrap: true,
                      //   text: TextSpan(
                      //     text:
                      //         'If OTP is not received within 5mins, please contact to support at ',
                      //     style: TextStyle(color: Colors.black, fontSize: 15),
                      //     children: [
                      //       TextSpan(
                      //           text: 'docsupport@qurhealth.in',
                      //           style: TextStyle(
                      //               color: Colors.blue,
                      //               fontSize: 15,
                      //               fontWeight: FontWeight.w500),
                      //           recognizer: TapGestureRecognizer()
                      //             ..onTap = () {
                                    
                      //             }),
                      //     ],
                      //   ),
                      // ),
                      // _gotosignintap(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resettextfields(
      String title, String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: TextFormField(
          autovalidate: _autoValidateBool,
          obscureText: isPassword,
          controller: controller,
          decoration: InputDecoration(
              prefixIcon: Container(
                constraints: BoxConstraints(maxWidth: 100, minWidth: 50),
                child: CountryCodePickerPage(
                    onValuePicked: (Country country) =>
                        setState(() => _selectedDialogCountry = country),
                    selectedDialogCountry: _selectedDialogCountry),
              ),
              labelText: title,
              hintText: strPhoneHint,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Color(CommonUtil().getMyPrimaryColor()),
                  )),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.deepPurple,
                ),
              )),
          validator: (value) {
            return AuthenticationValidator()
                .phoneValidation(value, patternPhoneNew, strPhoneCantEmpty);
          },
          keyboardType: TextInputType.number,
        ));
  }

  Widget _gotosignintap() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PatientSignInScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              strBackTo,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              strSignIn,
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

  Widget _resetbutton() {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (_ForgetPassKey.currentState.validate()) {
          _ForgetPassKey.currentState.save();
          PatientForgotPasswordModel logInModel =
              new PatientForgotPasswordModel(
            //userName: mobileController.text,
            userName:
                '${strPlusSymbol}${_selectedDialogCountry.phoneCode}${mobileController.text}',
            source: strSource,
          );
          Map<String, dynamic> map = logInModel.toJson();
          forgotPasswordModel.PatientForgotPasswordModel response =
              await authViewModel.resetPassword(map);
          _checkResponse(response);
        } else {
          setState(() {
            _autoValidateBool = true;
          });
        }
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
          strResetButton,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  _checkResponse(PatientForgotPasswordModel response) {
    if (response.isSuccess) {
      toast.getToast(response.message, Colors.lightBlue);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(
                    //userName: mobileController.text,
                    userName:
                        '${strPlusSymbol}${_selectedDialogCountry.phoneCode}${mobileController.text}',
                  )));
    } else {
      toast.getToast(response.message, Colors.red);
    }
  }
}
