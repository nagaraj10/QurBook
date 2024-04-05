import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../common/CommonUtil.dart';
import '../../main.dart';
import '../../src/ui/loader_class.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/app_primary_button.dart';
import '../constants/constants.dart';
import '../model/confirm_password_model.dart';
import '../view_model/otp_view_model.dart';
import '../view_model/patientauth_view_model.dart';
import 'authentication_validator.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({this.userName, this.isVirtualNumber = false});

  String? userName;
  bool isVirtualNumber;

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with CodeAutoFill {
  final CodeController = TextEditingController();
  final NewPasswordController = TextEditingController();
  final NewPasswordAgainController = TextEditingController();
  var isLoading = false;
  FlutterToast toast = FlutterToast();
  final _ChangePasswordKey = GlobalKey<FormState>();
  final _otpKey = GlobalKey<FormState>();
  bool _autoValidateBool = false;
  late AuthViewModel authViewModel;
  bool _isHidden = true;
  bool _isHiddenSecondary = true;
  OtpViewModel? otpViewModel;

  @override
  void initState() {
    super.initState();
    listenForCode();
    SmsAutoFill().listenForCode;
    authViewModel = AuthViewModel();
    Provider.of<OtpViewModel>(context, listen: false).startTimer();
  }

  @override
  void dispose() {
    cancel();
    unregisterListener();
    super.dispose();
    otpViewModel?.stopTimer();
    otpViewModel?.stopOTPTimer();
  }

  @override
  void codeUpdated() {
    setState(() {
      CodeController.text = code!;
    });
  }

  @override
  Widget build(BuildContext context) {
    otpViewModel = Provider.of<OtpViewModel>(context);
    var height = 1.sh;
    return Scaffold(
      body: Container(
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
                    Text(
                      (widget.isVirtualNumber)
                          ? strChangePasswordTextVirtual
                          : strChangePasswordText,
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
                        Form(
                          key: _otpKey,
                          child: _changepasswordTextFields(
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                fontSize: 16.0.sp,
                              ),
                              decoration: InputDecoration(
                                hintText: strCodeHintText,
                                labelText: strCodeHintText,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: mAppThemeProvider.primaryColor,
                                    )),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color:
                                        mAppThemeProvider.primaryColor,
                                  ),
                                ),
                              ),
                              controller: CodeController,
                              autovalidateMode: _autoValidateBool
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                              validator: (value) {
                                return AuthenticationValidator()
                                    .phoneOtpValidation(value!,
                                        patternOtp as String, strEnterOtpp);
                              },
                              onSaved: (value) {},
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        Form(
                          key: _ChangePasswordKey,
                          child: Column(
                            children: [
                              _changepasswordTextFields(
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: mAppThemeProvider.primaryColor,
                                      ),
                                    ),
                                    errorMaxLines: 2,
                                  ),
                                  validator: (value) {
                                    return AuthenticationValidator()
                                        .passwordValidation(
                                            value!,
                                            patternPassword as String,
                                            strPassCantEmpty);
                                  },
                                  controller: NewPasswordController,
                                  onSaved: (value) {},
                                ),
                              ),
                              SizedBox(height: 10.0.h),
                              _changepasswordTextFields(
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                  ),
                                  autovalidateMode: _autoValidateBool
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  obscureText: _isHiddenSecondary,
                                  decoration: InputDecoration(
                                    hintText: strNewPasswordAgainHintText,
                                    labelText: strNewPasswordAgainHintText,
                                    suffix: InkWell(
                                      onTap: _togglePasswordViewSecodary,
                                      child: Icon(
                                        _isHiddenSecondary
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 18,
                                      ),
                                    ),
                                    errorMaxLines: 2,
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
                                  controller: NewPasswordAgainController,
                                  validator: (value) {
                                    return AuthenticationValidator()
                                        .confirmPasswordValidation(
                                            NewPasswordController.text,
                                            value,
                                            patternPassword as String,
                                            strPassCantEmpty);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0.h,
                    ),
                    _changePassword(),
                    SizedBox(
                      height: 20.0.h,
                    ),
                    _backbutton(),
                    SizedBox(height: 10.0.h),
                    Visibility(
                      visible: CommonUtil.REGION_CODE == 'IN',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text: strOtpNotReceived,
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: otpViewModel!.timeForResend,
                                      style: TextStyle(
                                        color: mAppThemeProvider.primaryColor,
                                        fontSize: 15.0.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0.h),
                    Visibility(
                        visible: otpViewModel!.timerSeconds == 0,
                        child: AppPrimaryButton(
                          text: strVerifyCall,
                          isSecondaryButton: true,
                          onTap: otpViewModel!.timerSeconds == 0
                              ? () {
                                  if (_ChangePasswordKey.currentState!
                                      .validate()) {
                                    otpViewModel?.stopOTPTimer();
                                    otpViewModel!.confirmViaCall(
                                      phoneNumber: widget.userName ?? '',
                                      onOtpReceived: (otpCode) {
                                        _verifyDetails(
                                          otpCode: otpCode,
                                        );
                                      },
                                    );
                                  }
                                }
                              : () {},
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _togglePasswordViewSecodary() {
    setState(() {
      _isHiddenSecondary = !_isHiddenSecondary;
    });
  }

  Widget _backbutton() {
    return AppPrimaryButton(
      text: strBackText,
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
      },
      isSecondaryButton: true,
    );
  }

  Widget _commonConfirmPasswordButton(String textString, Function()? onTap) {
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
                  mAppThemeProvider.primaryColor,
                  mAppThemeProvider.gradientColor
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

  Widget _changePassword() {
    return AppPrimaryButton(
      onTap: () {
        _verifyDetails();
      },
      text: strChangeButtonText,
    );
  }

  _verifyDetails({String? otpCode}) async {
    FocusScope.of(context).unfocus();
    if (otpCode != null ||
        (_ChangePasswordKey.currentState!.validate() &&
            _otpKey.currentState!.validate())) {
      if (otpCode == null) {
        _ChangePasswordKey.currentState!.save();
      } else {
        _otpKey.currentState!.save();
        _ChangePasswordKey.currentState!.save();
      }
      LoaderClass.showLoadingDialog(context);
      var logInModel = PatientConfirmPasswordModel(
        verificationCode: otpCode ?? CodeController.text,
        userName: widget.userName,
        source: strSource,
        password: NewPasswordController.text,
      );
      var map = logInModel.toJson();
      final response = await authViewModel.confirmPassword(map);
      print(response.toString());
      _checkResponse(response);
    } else {
      setState(() {
        _autoValidateBool = true;
      });
    }
  }

  _checkResponse(PatientConfirmPasswordModel response) {
    LoaderClass.hideLoadingDialog(context);
    if (response.isSuccess!) {
      toast.getToast(response.message!, Colors.lightBlue);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PatientSignInScreen()),
          (route) => false);
    } else {
      toast.getToast(response.message!, Colors.red);
    }
  }

  Widget _changepasswordTextFields(TextFormField textFormField) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2), child: textFormField);
  }
}
