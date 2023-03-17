import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/authentication/model/Country.dart';
import '../constants/constants.dart';
import '../model/forgot_password_model.dart';
import 'authentication_validator.dart';
import 'confirm_password_screen.dart';
import 'login_screen.dart';
import '../view_model/patientauth_view_model.dart';
import '../model/forgot_password_model.dart' as forgotPasswordModel;
import '../../constants/fhb_constants.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../widgets/country_code_picker.dart';
import '../../common/CommonUtil.dart';
import '../../constants/variable_constant.dart';
import '../../src/ui/loader_class.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Country _selectedDialogCountry = Country.fromCode(CommonUtil.REGION_CODE);
  final mobileController = TextEditingController();
  bool _autoValidateBool = false;
  FlutterToast toast = FlutterToast();
  AuthViewModel authViewModel;
  final _ForgetPassKey = GlobalKey<FormState>();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    authViewModel = AuthViewModel();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Forgot Password Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = 1.sh;
    return Scaffold(
      body: Form(
        key: _ForgetPassKey,
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
                          strOtpShowText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Column(
                          children: [
                            _resettextfields(
                                strPhoneNumber, strPhoneHint, mobileController),
                          ],
                        ),
                        SizedBox(height: 10.0.h),
                        _resetbutton(),
                        SizedBox(height: height * .015),
                        Text(
                          CommonUtil.isUSRegion()?strUSsupportEmail:strINsupportEmail,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.0.sp),
                        ),
                        // RichText(
                        //   softWrap: true,
                        //   text: TextSpan(
                        //     text:
                        //         'If OTP is not received within 5mins, please contact to support at ',
                        //     style: TextStyle(color: Colors.black, fontSize: 15.0.sp),
                        //     children: [
                        //       TextSpan(
                        //           text: 'support@qurhealth.in',
                        //           style: TextStyle(
                        //               color: Colors.blue,
                        //               fontSize: 15.0.sp,
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
      ),
    );
  }

  Widget _resettextfields(
      String title, String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: TextFormField(
          textCapitalization: TextCapitalization.sentences,
          maxLength: 10,
          style: TextStyle(
            fontSize: 16.0.sp,
          ),
          autovalidate: _autoValidateBool,
          obscureText: isPassword,
          controller: controller,
          decoration: InputDecoration(
              counterText: "",
              prefixIcon: Container(
                constraints: BoxConstraints(
                  maxWidth: 50.0.w,
                  minWidth: 50.0.w,
                ),
                child: CountryCodePickerPage(
                  selectedCountry: _selectedDialogCountry,
                  onValuePicked: (country) => setState(
                    () => _selectedDialogCountry = country,
                  ),
                ),
              ),
              labelText: title,
              hintText: strPhoneHint,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(CommonUtil().getMyPrimaryColor()),
                  )),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
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
              style: TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10.0.w,
            ),
            Text(
              strSignIn,
              style: TextStyle(
                  color: Color(CommonUtil().getMyPrimaryColor()),
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resetbutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            FocusScope.of(context).unfocus();
            if (_ForgetPassKey.currentState.validate()) {
              _ForgetPassKey.currentState.save();
              LoaderClass.showLoadingDialog(context);
              var logInModel = PatientForgotPasswordModel(
                //userName: mobileController.text,
                userName:
                    '${_selectedDialogCountry.phoneCode}${mobileController.text}',
                source: strSource,
              );
              final map = logInModel.toJson();
              final response = await authViewModel.resetPassword(map);
              _checkResponse(response);
            } else {
              setState(() {
                _autoValidateBool = true;
              });
            }
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
                gradient: LinearGradient(end: Alignment.centerRight, colors: [
//                  Color(0xff138fcf),
//                  Color(0xff138fcf),
                  Color(CommonUtil().getMyPrimaryColor()),
                  Color(CommonUtil().getMyGredientColor())
                ])),
            child: Text(
              strResetButton,
              style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  _checkResponse(PatientForgotPasswordModel response) {
    LoaderClass.hideLoadingDialog(context);
    if (response.isSuccess) {
      toast.getToast(response.message, Colors.lightBlue);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(
                    //userName: mobileController.text,
                    userName:
                        '${_selectedDialogCountry.phoneCode}${mobileController.text}',
                    isVirtualNumber: response?.result?.isVirtualNumber ?? false,
                  )));
    } else {
      toast.getToast(response.message, Colors.red);
    }
  }
}
