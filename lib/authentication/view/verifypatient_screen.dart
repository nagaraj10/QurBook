import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import '../../add_family_otp/models/add_family_otp_response.dart';
import '../../add_family_user_info/models/add_family_user_info_arguments.dart';
import '../constants/constants.dart';
import '../model/patientverify_model.dart';
import '../model/resend_otp_model.dart';
import '../model/verifyotp_model.dart';
import 'authentication_validator.dart';
import 'login_screen.dart';
import 'verify_arguments.dart';
import '../view_model/patientauth_view_model.dart';
import '../model/patientverify_model.dart' as OtpModel;
import '../../src/utils/screenutils/size_extensions.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../my_family/models/relationships.dart';
import '../../src/model/Authentication/UserModel.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/variable_constant.dart';
import '../../src/model/Authentication/DeviceInfoSucess.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import 'dart:convert';
import 'dart:io';
import '../../constants/router_variable.dart' as router;
import '../model/resend_otp_model.dart' as ResendModel;
import '../../src/ui/Dashboard.dart';
import '../../src/ui/loader_class.dart';
import '../../src/utils/PageNavigator.dart';
import '../model/patientlogin_model.dart' as loginModel;
import '../../constants/fhb_constants.dart' as con;
import '../view_model/otp_view_model.dart';
import 'package:provider/provider.dart';
import '../../widgets/RaisedGradientButton.dart';
import 'or_divider.dart';

class VerifyPatient extends StatefulWidget {
  VerifyPatient(
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
      this.emailId});

  final String PhoneNumber;
  final String from;
  final String fName;
  final String mName;
  final String lName;
  final RelationsShipModel relationship;
  final bool isPrimaryNoSelected;
  final bool userConfirm;
  final String userId;
  final String emailId;
  Map<String, dynamic> dataForResendOtp;
  @override
  _VerifyPatientState createState() => _VerifyPatientState();
}

class _VerifyPatientState extends State<VerifyPatient> {
  final OtpController = TextEditingController();
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  var isLoading = false;
  bool _autoValidateBool = false;
  final _OtpKey = GlobalKey<FormState>();
  AuthViewModel authViewModel;
  UserModel saveuser = UserModel();
  String authcode = '';
  String last_name;
  String first_name;
  String special;
  String AuthToken;
  Image doctor_image;
  String decodesstring;
  String id_token_string;
  String family_name;
  String username;
  String doctor_id;
  String user_mobile_no;
  var token1;
  String token2;
  FlutterToast toast = FlutterToast();
  var from;
  int numberOfTimesResendTapped = 0;
  bool enableResendButton = true;
  bool disableResendButton = false;
  OtpViewModel otpViewModel;

  @override
  void initState() {
    con.mInitialTime = DateTime.now();
    super.initState();
    from = widget.from;
    authViewModel = AuthViewModel();
    if (widget.userConfirm) {
      _resendOtpDetails();
    }
    Provider.of<OtpViewModel>(context, listen: false)?.startTimer();
  }

  @override
  void dispose() {
    otpViewModel?.stopTimer();
    otpViewModel?.stopOTPTimer();
    super.dispose();
    con.fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Verify Patient Screen',
      'screenSessionTime':
          '${DateTime.now().difference(con.mInitialTime).inSeconds} secs'
    });
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
                      Column(
                        children: [
                          _resetTextFields(strOtp, strOtpHint, OtpController),
                        ],
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
                                      text: otpViewModel.timeForResend,
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
                        visible: otpViewModel.timerSeconds == 0,
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
                                  width: 200.0.w,
                                  onPressed: otpViewModel.timerSeconds == 0
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
                            Visibility(
                              visible: from != strFromVerifyFamilyMember,
                              child: OrDivider(),
                            ),
                            Visibility(
                              visible: from != strFromVerifyFamilyMember,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedGradientButton(
                                    gradient: LinearGradient(colors: [
                                      Color(CommonUtil().getMyPrimaryColor()),
                                      Color(CommonUtil().getMyGredientColor()),
                                    ]),
                                    width: 200.0.w,
                                    onPressed: otpViewModel.timerSeconds == 0
                                        ? () {
                                            otpViewModel?.stopOTPTimer();
                                            otpViewModel.confirmViaCall(
                                              phoneNumber:
                                                  widget.PhoneNumber ?? '',
                                              onOtpReceived: (otpCode) {
                                                _verifyDetails(
                                                  otpCode: otpCode,
                                                );
                                              },
                                            );
                                          }
                                        : null,
                                    child: Text(
                                      strVerifyCall,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
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
      return strOtpTextForFamilyMember + widget.fName + mobileNumber;
    } else {
      var num = widget.PhoneNumber.replaceRange(0,
          widget.PhoneNumber.length - 4, 'x' * (widget.PhoneNumber.length - 4));
      return strOtpText + num;
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
    if (response.isSuccess) {
      toast.getToast('OTP sent successfully', Colors.green);
    } else {
      if (response.message != null) {
        toast.getToast(response.message, Colors.red);
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
    final data = <String, String>{'phoneNumber': widget.PhoneNumber};
    if (numberOfTimesResendTapped < 3) {
      _updateResendButton();
      Future.delayed(Duration(minutes: 1), _updateResendButton);
      if (from == strFromVerifyFamilyMember) {
        var response = await authViewModel.resendOtpForAddingFamilyMember(data);
        _checkOtpResponse(response);
      } else {
        var response =
            await authViewModel.loginPatient(widget.dataForResendOtp);
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
            await authViewModel.loginPatient(widget.dataForResendOtp);
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
          keyboardType: TextInputType.number,
          autovalidate: _autoValidateBool,
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
                .phoneOtpValidation(value, patternOtp, strEnterOtpp);
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

  _verifyDetails({String otpCode}) async {
    FocusScope.of(context).unfocus();
    var otpToVerify = otpCode ?? OtpController.text;
    if (otpCode != null || _OtpKey.currentState.validate()) {
      if (otpCode == null) {
        _OtpKey.currentState.save();
      }
      LoaderClass.showLoadingDialog(context);
      if (from == strFromSignUp) {
        final logInModel = PatientSignupOtp(
          verificationCode: otpToVerify,
          userName: widget.PhoneNumber,
          source: strSource,
          userId: widget.userConfirm
              ? widget.userId
              : PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
        );
        var map = logInModel.toJson();
        var response = await authViewModel.verifyPatient(map);
        print(response.toString());
        _checkResponse(response);
      } else if (from == strFromVerifyFamilyMember) {
        final params = VerifyOTPModel(
            phoneNumber: widget.PhoneNumber, verificationCode: otpToVerify);
        var response = await authViewModel.verifyMyOTP(params.toJson());
        if (response.isSuccess) {
          //? this might be change
          toast.getToast('User added successfully', Colors.green);
          //Navigator.pop(context);
          LoaderClass.hideLoadingDialog(context);
          await Navigator.pushNamed(context, router.rt_AddFamilyUserInfo,
                  arguments: AddFamilyUserInfoArguments(
                      fromClass: CommonConstants.add_family,
                      enteredFirstName: widget.fName,
                      enteredMiddleName: widget.mName,
                      enteredLastName: widget.lName,
                      relationShip: widget.relationship,
                      isPrimaryNoSelected: widget.isPrimaryNoSelected,
                      addFamilyUserInfo: response.result ?? null))
              .then((value) {
            Navigator.pop(context);
          });
        } else {
          //something went wrong.
          //Navigator.pop(context);
          LoaderClass.hideLoadingDialog(context);
          toast.getToast(response.message, Colors.red);
          //Navigator.pop(context);
          // setState(() {
          //   from = strFromSignUp;
          // });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => VerifyPatient(
          //       PhoneNumber: widget.PhoneNumber,
          //       from: strFromSignUp,
          //     ),
          //   ),
          // ).then((value) => Navigator.pop(context));
        }
      } else {
        var logInModel = PatientSignupOtp(
          verificationCode: otpToVerify,
          userName: widget.PhoneNumber,
          source: strSource,
        );
        final map = logInModel.toJson();
        final response = await authViewModel.verifyOtp(map);
        print(response.toString());
        _checkResponse(response);
      }
    } else {
      setState(() {
        _autoValidateBool = true;
      });
    }
  }

  _checkResponse(PatientSignupOtp response) {
    if (response.isSuccess) {
      _getPatientDetails();
    } else {
      LoaderClass.hideLoadingDialog(context);
      if (response?.message?.contains('expired') ?? false) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PatientSignInScreen(),
          ),
          (route) => false,
        );
      }
      toast.getToast(response.message, Colors.red);
    }
  }

  _resendOtpDetails() async {
    var logInModel = ResendOtpModel(
      userName: widget.PhoneNumber,
      source: strSource,
      userId: widget.userConfirm
          ? widget.userId
          : PreferenceUtil.getStringValue(strKeyConfirmUserToken),
    );
    final map = logInModel.toJson();
    var response = await authViewModel.resendOtp(map);
    _checkOtpResponse(response);
  }

  _checkOtpResponse(ResendOtpModel response) {
    if (response.isSuccess) {
      toast.getToast('OTP sent successfully', Colors.green);
    } else {
      if (response.message != null) {
        toast.getToast(response.message, Colors.red);
      }
    }
  }

  Future<String> _getPatientDetails() async {
    String userId;
    decodesstring = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    saveuser.auth_token = decodesstring;
    try {
      var apiBaseHelper = ApiBaseHelper();
      final res = apiBaseHelper.updateLastVisited();
    } catch (e) {}
    if (widget.from == strFromSignUp) {
      if (widget.userConfirm) {
        userId = widget.userId;
      } else {
        userId = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      }

      saveuser.userId = userId;
      print(userId);
      await PreferenceUtil.saveString(Constants.MOB_NUM, widget.PhoneNumber)
          .then((onValue) {});
      await PreferenceUtil.saveString(Constants.KEY_USERID, userId)
          .then((onValue) {});
      PreferenceUtil.save(strUserDetails, saveuser);
      authToken = decodesstring;
      final _firebaseMessaging = FirebaseMessaging.instance;
      var token = await _firebaseMessaging.getToken();
      await CommonUtil()
          .sendDeviceToken(
              userId, widget.emailId, widget.PhoneNumber, token, true)
          .then((value) {
        if (value != null) {
          Future.delayed(Duration(seconds: 3), () {
            LoaderClass.hideLoadingDialog(context);
            PageNavigator.goToPermanent(context, router.rt_Landing);
          });
        } else {
          LoaderClass.hideLoadingDialog(context);
          FHBBasicWidget().showDialogWithTwoButtons(context, () {
            PageNavigator.goToPermanent(context, router.rt_Landing);
          }, value.message, strConfirmDialog);
        }
      });
    } else {
      final String userId = parseJwtPayLoad(decodesstring)[strToken][strUserId];
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
          .sendDeviceToken(userId, saveuser.email, user_mobile_no, token, true)
          .then((value) {
        if (value != null) {
          Future.delayed(Duration(seconds: 3), () {
            LoaderClass.hideLoadingDialog(context);
            PageNavigator.goToPermanent(context, router.rt_Landing);
          });
        } else {
          LoaderClass.hideLoadingDialog(context);
          FHBBasicWidget().showDialogWithTwoButtons(context, () {
            PageNavigator.goToPermanent(context, router.rt_Landing);
          }, value.message, strConfirmDialog);
        }
      });
    }

    // redirecting to dashboard screen using userid
  }

  Future<DeviceInfoSucess> sendDeviceToken(
      String userId, String email, String userMobileNo, String deviceId) async {
    final _firebaseMessaging = FirebaseMessaging.instance;
    var token = await _firebaseMessaging.getToken();
    print('$strFirebaseToken $token');
    final Map<String, dynamic> deviceInfo = {};
    final Map<String, dynamic> user = {};
    var jsonData = Map<String, dynamic>();
    user[strid] = userId;
    deviceInfo[struser] = user;
    deviceInfo[strphoneNumber] = userMobileNo;
    deviceInfo[stremail] = email;
    deviceInfo[strisActive] = true;
    deviceInfo[strDeviceTokenId] = token;
    jsonData[strDeviceInfo] = deviceInfo;
    if (Platform.isIOS) {
      jsonData[strPlatformCode] = strIOSPLT;
    } else {
      jsonData[strPlatformCode] = strANDPLT;
    }
    print(jsonData.toString());
    final params = json.encode(jsonData);
    print(params.toString());
    var response =
        await apiBaseHelper.postDeviceId(strDevvice_Info, params, true);
    return DeviceInfoSucess.fromJson(response);
  }
}
