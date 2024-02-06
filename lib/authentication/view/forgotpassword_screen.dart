import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';

import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/variable_constant.dart';
import '../../src/ui/loader_class.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/app_primary_button.dart';
import '../constants/constants.dart';
import '../model/Country.dart';
import '../model/forgot_password_model.dart';
import '../view_model/patientauth_view_model.dart';
import '../widgets/country_code_picker.dart';
import 'authentication_validator.dart';
import 'confirm_password_screen.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Country _selectedDialogCountry = Country.fromCode(CommonUtil.REGION_CODE);
  final mobileController = TextEditingController();
  bool _autoValidateBool = false;
  FlutterToast toast = FlutterToast();
  late AuthViewModel authViewModel;
  final _ForgetPassKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authViewModel = AuthViewModel();
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
                        SizedBox(height: 20.0.h),
                        _resetbutton(),
                        SizedBox(height: 20.0.h),
                        _backbutton(),
                        SizedBox(height: height * .015),
                        Text(
                          CommonUtil.isUSRegion()
                              ? strUSsupportEmail
                              : strINsupportEmail,
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
          autovalidateMode: _autoValidateBool
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          obscureText: isPassword,
          controller: controller,
          decoration: InputDecoration(
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
                    () => _selectedDialogCountry = country,
                  ),
                  isEnabled: (BASE_URL != prodUSURL),
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
            return AuthenticationValidator().phoneValidation(
                value!, patternPhoneNew as String, strPhoneCantEmpty);
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
              strLoginText,
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

  Widget _commonForgotPasswordButton(String textString, Function()? onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
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
                  Color(CommonUtil().getMyPrimaryColor()),
                  Color(CommonUtil().getMyGredientColor())
                ])),
            child: Text(
              textString,
              style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _backbutton() {
    return AppPrimaryButton(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
      },
      text: strBackText,
      isSecondaryButton: true,
    );
  }

  Widget _resetbutton() {
    return AppPrimaryButton(
      text: strResetButton,
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (_ForgetPassKey.currentState!.validate()) {
          _ForgetPassKey.currentState!.save();
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
    );
  }

  _checkResponse(PatientForgotPasswordModel response) {
    LoaderClass.hideLoadingDialog(context);
    if (response.isSuccess!) {
      toast.getToast(response.message!, Colors.lightBlue);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(
                    //userName: mobileController.text,
                    userName:
                        '${_selectedDialogCountry.phoneCode}${mobileController.text}',
                    isVirtualNumber: response.result?.isVirtualNumber ?? false,
                  )));
    } else {
      toast.getToast(response.message!, Colors.red);
    }
  }
}
