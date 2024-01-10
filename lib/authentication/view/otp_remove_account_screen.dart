import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../my_family/models/relationships.dart';
import '../../src/model/Authentication/UserModel.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import '../../src/ui/loader_class.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/RaisedGradientButton.dart';
import '../constants/constants.dart';
import '../model/patientOTP_model.dart';
import '../model/patientlogin_model.dart' as loginModel;
import '../model/patientverify_model.dart';
import '../model/resend_otp_model.dart';
import '../view_model/otp_view_model.dart';
import '../view_model/patientauth_view_model.dart';
import 'authentication_validator.dart';
import 'login_screen.dart';

class OTPRemoveAccount extends StatefulWidget {
  OTPRemoveAccount(
      {this.PhoneNumber,
      this.from,
      this.fName,
      this.lName,
      this.mName,
      this.isPrimaryNoSelected,
      this.relationship,
      this.userConfirm,
      this.userId,
      this.dataForResendOtp,
      this.emailId,
      this.fromSignUp,
      this.forFamilyMember,
      this.isVirtualNumber = false});

  final String? PhoneNumber;
  final String? from;
  final String? fName;
  final String? mName;
  final String? lName;
  final RelationsShipModel? relationship;
  final bool? isPrimaryNoSelected;
  final bool? userConfirm;
  final bool? fromSignUp;
  final String? userId;
  final String? emailId;
  final bool? forFamilyMember;
  final bool? isVirtualNumber;
  Map<String, dynamic>? dataForResendOtp;

  @override
  _OTPRemoveAccountState createState() => _OTPRemoveAccountState();
}

class _OTPRemoveAccountState extends State<OTPRemoveAccount>
    with CodeAutoFill, WidgetsBindingObserver {
  final OtpController = TextEditingController();
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  var isLoading = false;
  bool _autoValidateBool = false;
  final _OtpKey = GlobalKey<FormState>();
  late AuthViewModel authViewModel;
  UserModel saveuser = UserModel();
  String authcode = '';
  String? last_name;
  String? first_name;
  String? special;
  String? AuthToken;
  Image? doctor_image;
  String? decodesstring;
  String? id_token_string;
  String? family_name;
  String? username;
  String? doctor_id;
  String? user_mobile_no;
  var token1;
  String? token2;
  FlutterToast toast = FlutterToast();
  var from;
  int numberOfTimesResendTapped = 0;
  bool enableResendButton = true;
  bool disableResendButton = false;
  OtpViewModel? otpViewModel;
  ValueNotifier otpNotifier = ValueNotifier(false);
  bool appIsInBackground = false;

  @override
  void initState() {
    super.initState();
    listenForCode();
    SmsAutoFill().listenForCode;
    from = widget.from;
    WidgetsBinding.instance!.addObserver(this);
    authViewModel = AuthViewModel();
    if (widget.userConfirm!) {
      _resendOtpDetails();
    }
    Provider.of<OtpViewModel>(context, listen: false).startTimer();
  }

  @override
  void dispose() {
    otpViewModel?.stopTimer();
    otpViewModel?.stopOTPTimer();
    cancel();
    unregisterListener();
    otpNotifier.value = false;
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (appIsInBackground && otpViewModel!.isDialogOpen) {
          appIsInBackground = false;
          otpViewModel!.updateDialogStatus(false);
          Get.back();
        }
        break;
      case AppLifecycleState.paused:
        appIsInBackground = true;
        break;
      default:
    }
    //print("the current state of the app is ${state.toString()}");
  }

  @override
  void codeUpdated() {
    setState(() {
      OtpController.text = code!;
    });
    if (OtpController.text != '') {
      otpNotifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    otpViewModel = Provider.of<OtpViewModel>(context);
    var height = 1.sh;
    return Scaffold(
      body: Form(
        key: _OtpKey,
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
                      SizedBox(height: height * .06),
                      Container(
                        margin: EdgeInsets.only(left: 10.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconWidget(
                              icon: Icons.arrow_back_ios,
                              colors: Colors.black,
                              size: 26.0.sp,
                              onTap: () {
                                try {
                                  if (Navigator.canPop(context)) {
                                    Get.back();
                                  }
                                } catch (e, stackTrace) {
                                  CommonUtil().appLogs(
                                      message: e, stackTrace: stackTrace);
                                  print(e);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * .04),
                      AssetImageWidget(
                        icon: myFHB_logo,
                        height: 120.0.h,
                        width: 120.0.h,
                      ),
                      SizedBox(height: 20.0.h),
                      Text(
                        getNumber(),
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      ValueListenableBuilder(
                        valueListenable: otpNotifier,
                        builder: (context, dynamic otpStatus, child) {
                          if (otpStatus) {
                            otpNotifier.value = false;
                            AuthenticationValidator()
                                .checkNetwork()
                                .then((intenet) {
                              if (intenet != null && intenet) {
                                _verifyDetails();
                              } else {
                                toast.getToast(strNetworkIssue, Colors.red);
                              }
                            });
                          }
                          return Column(
                            children: [
                              _resetTextFields(
                                  strOtp, strOtpHint, OtpController),
                            ],
                          );
                        },
                      ),
                      // (widget.dataForResendOtp != null ||
                      //         from == strFromVerifyFamilyMember)
                      //     ? _getResendForSignIN()
                      //     : Container(),
                      SizedBox(height: 10.0.h),
                      _resetButton(),
                      SizedBox(height: 10.0.h),
                      Row(
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
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor()),
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
                      Visibility(
                        visible: otpViewModel!.timerSeconds == 0,
                        child: Column(
                          children: [
                            SizedBox(height: 10.0.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedGradientButton(
                                  gradient: LinearGradient(colors: [
                                    Color(CommonUtil().getMyPrimaryColor()),
                                    Color(CommonUtil().getMyGredientColor()),
                                  ]),
                                  width: 280.0.w,
                                  onPressed: otpViewModel!.timerSeconds == 0
                                      ? () {
                                          otpViewModel?.stopOTPTimer();
                                          otpViewModel?.startTimer();
                                          if (from == strFromSignUp) {
                                            _resendOtpDetails();
                                          } else if (widget.dataForResendOtp !=
                                                  null ||
                                              from ==
                                                  strFromVerifyFamilyMember) {
                                            _startTimer();
                                          }
                                        }
                                      : null,
                                  child: Text(
                                    strresendOtp,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * .015),
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

  String getNumber() {
    if (from == strFromVerifyFamilyMember) {
      return strOtpTextForFamilyMember + widget.fName! + mobileNumber;
    } else {
      var num = widget.PhoneNumber!.replaceRange(
          0,
          widget.PhoneNumber!.length - 4,
          'x' * (widget.PhoneNumber!.length - 4));
      return (widget.isVirtualNumber ?? false)
          ? strOtpText + num + strOtpTextVirtual
          : strOtpText + num;
    }
  }

  // Widget _getResendForSignIN() {
  //   return enableResendButton
  //       ? InkWell(
  //           onTap: () {
  //             _startTimer();
  //           },
  //           child: Container(
  //             padding: EdgeInsets.symmetric(vertical: 5),
  //             alignment: Alignment.bottomRight,
  //             child: Text(
  //               strresendOtp,
  //               style: TextStyle(
  //                   color: Color(CommonUtil().getMyPrimaryColor()),
  //                   fontSize: 15.0.sp,
  //                   fontWeight: FontWeight.w600),
  //             ),
  //           ))
  //       : Container(
  //           padding: EdgeInsets.symmetric(vertical: 5),
  //           alignment: Alignment.bottomRight,
  //           child: Text(
  //             strresendOtp,
  //             style: TextStyle(
  //                 color: Colors.grey,
  //                 fontSize: 15.0.sp,
  //                 fontWeight: FontWeight.w600),
  //           ),
  //         );
  // }

  _loginOTPSent(loginModel.PatientLogIn response) {
    if (response.isSuccess!) {
      toast.getToast('One Time Password sent successfully', Colors.green);
    } else {
      if (response.message != null) {
        toast.getToast(response.message!, Colors.red);
      } else {
        toast.getToast('Something went wrong.Please try again', Colors.red);
      }
    }
  }

  _updateResendButton() {
    setState(() {
      enableResendButton = !enableResendButton;
    });
  }

  _updateResendButtonAfterBufferTime({bool resetCount = false}) {
    if (resetCount) numberOfTimesResendTapped = 0;
    disableResendButton = !disableResendButton;
    _updateResendButton();
  }

  _startTimer() async {
    numberOfTimesResendTapped++;
    final data = <String, String?>{'phoneNumber': widget.PhoneNumber};
    if (numberOfTimesResendTapped < 3) {
      _updateResendButton();
      Future.delayed(Duration(minutes: 1), _updateResendButton);
      if (from == strFromVerifyFamilyMember) {
        var response = await authViewModel.resendOtpForAddingFamilyMember(data);
        _checkOtpResponse(response);
      } else {
        var response =
            await authViewModel.loginPatient(widget.dataForResendOtp!);
        _loginOTPSent(response);
      }
    } else if (numberOfTimesResendTapped == 3) {
      _updateResendButtonAfterBufferTime();
      Future.delayed(const Duration(minutes: 15), () {
        _updateResendButtonAfterBufferTime(resetCount: true);
      });
      if (from == strFromVerifyFamilyMember) {
        var response = await authViewModel.resendOtpForAddingFamilyMember(data);
        _checkOtpResponse(response);
      } else {
        final response =
            await authViewModel.loginPatient(widget.dataForResendOtp!);
        _loginOTPSent(response);
      }
    }
  }

  Widget _resetTextFields(
      String title, String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: TextFormField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.number,
          autovalidateMode: _autoValidateBool
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          obscureText: isPassword,
          style: TextStyle(
            fontSize: 16.0.sp,
          ),
          controller: controller,
          decoration: InputDecoration(
              labelText: title,
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
                .phoneOtpValidation(value!, patternOtp as String, strEnterOtpp);
          },
        ));
  }

  Widget _resetButton() {
    return InkWell(
      onTap: () {
        AuthenticationValidator().checkNetwork().then((intenet) {
          if (intenet != null && intenet) {
            _verifyDetails();
          } else {
            toast.getToast(strNetworkIssue, Colors.red);
          }
        });
      },
      child: Container(
        width: 1.sw,
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
            gradient: LinearGradient(begin: Alignment.centerLeft, colors: [
//                  Color(0xff138fcf),
//                  Color(0xff138fcf),
              Color(CommonUtil().getMyPrimaryColor()),
              Color(CommonUtil().getMyGredientColor())
            ])),
        child: Text(
          strVerify,
          style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
        ),
      ),
    );
  }

  void moveToLoginPage() {
    PreferenceUtil.clearAllData().then(
      (value) {
        Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => PatientSignInScreen(),
          ),
          (route) => false,
        );
      },
    );
  }

  _verifyDetails({String? otpCode}) async {
    FocusScope.of(context).unfocus();
    var otpToVerify = otpCode ?? OtpController.text;
    if (otpCode != null || _OtpKey.currentState!.validate()) {
      if (otpCode == null) {
        _OtpKey.currentState!.save();
      }

      LoaderClass.showLoadingDialog(context);
      var logInModel = PatientOtpModel(
        verificationCode: otpToVerify,
        source: strSource,
      );
      final map = logInModel.toJson();
      final response = await authViewModel.verifyDeleteAccountOtp(map);
      print(response.toString());
      _checkResponse(response);
    } else {
      setState(() {
        _autoValidateBool = true;
      });
    }
  }

  _checkResponse(PatientSignupOtp response) {
    LoaderClass.hideLoadingDialog(context);

    if (response.isSuccess!) {
      // Account deleted
      toast.getToast(Constants.SUCCESSFULLY_DELETED, Colors.green);
      CommonUtil().logout(moveToLoginPage);
    } else {
      LoaderClass.hideLoadingDialog(context);
      if (response.message?.contains('expired') ?? false) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PatientSignInScreen(),
          ),
          (route) => false,
        );
      }
      toast.getToast(response.message!, Colors.red);
    }
  }

  _resendOtpDetails() async {
    var response = await authViewModel.getDeleteAccountOtp(isResend: true);
    if (response.isSuccess!) {
      toast.getToast(Constants.OTP_SUCCESS, Colors.green);
    } else {
      if (response.message != null) {
        toast.getToast(response.message!, Colors.red);
      }
    }
  }

  _checkOtpResponse(ResendOtpModel response) {
    if (response.isSuccess!) {
      toast.getToast(Constants.OTP_SUCCESS, Colors.green);
    } else {
      if (response.message != null) {
        toast.getToast(response.message!, Colors.red);
      }
    }
  }
}
