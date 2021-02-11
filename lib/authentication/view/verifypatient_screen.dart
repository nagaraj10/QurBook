import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/model/patientverify_model.dart';
import 'package:myfhb/authentication/model/resend_otp_model.dart';
import 'package:myfhb/authentication/model/verifyotp_model.dart';
import 'package:myfhb/authentication/view/authentication_validator.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:myfhb/authentication/view/verify_arguments.dart';
import 'package:myfhb/authentication/view_model/patientauth_view_model.dart';
import 'package:myfhb/authentication/model/patientverify_model.dart'
    as OtpModel;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/my_family/models/relationships.dart';
import 'package:myfhb/src/model/Authentication/UserModel.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/model/Authentication/DeviceInfoSucess.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert';
import 'dart:io';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/authentication/model/resend_otp_model.dart'
    as ResendModel;
import 'package:myfhb/src/ui/Dashboard.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/authentication/model/patientlogin_model.dart'
    as loginModel;

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
      this.dataForResendOtp});

  final String PhoneNumber;
  final String from;
  final String fName;
  final String mName;
  final String lName;
  final RelationsShipModel relationship;
  final bool isPrimaryNoSelected;
  final bool userConfirm;
  final String userId;
  Map<String, dynamic> dataForResendOtp;
  @override
  _VerifyPatientState createState() => _VerifyPatientState();
}

class _VerifyPatientState extends State<VerifyPatient> {
  final OtpController = TextEditingController();
  ApiBaseHelper apiBaseHelper = new ApiBaseHelper();
  var isLoading = false;
  bool _autoValidateBool = false;
  var _OtpKey = GlobalKey<FormState>();
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
  FlutterToast toast = new FlutterToast();
  var from;
  int numberOfTimesResendTapped = 0;
  bool enableResendButton = true;
  bool disableResendButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    from = widget.from;
    authViewModel = new AuthViewModel();
    if (widget.userConfirm) {
      _resendOtpDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                      Text(getNumber()),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          _resetTextFields(strOtp, strOtpHint, OtpController),
                        ],
                      ),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          _resendOtpDetails();
                        },
                        child: from ==
                                strFromSignUp //*this has to be change with strFromSignUp
                            ? Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  strresendOtp,
                                  style: TextStyle(
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Container(),
                      ),
                      (widget.dataForResendOtp != null ||
                              from == strFromVerifyFamilyMember)
                          ? _getResendForSignIN()
                          : Container(),
                      SizedBox(height: 10),
                      _resetButton(),
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
      final num = widget.PhoneNumber.replaceRange(0,
          widget.PhoneNumber.length - 4, 'x' * (widget.PhoneNumber.length - 4));
      return strOtpText + num;
    }
  }

  Widget _getResendForSignIN() {
    return enableResendButton
        ? InkWell(
            onTap: () {
              _startTimer();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.bottomRight,
              child: Text(
                strresendOtp,
                style: TextStyle(
                    color: Color(CommonUtil().getMyPrimaryColor()),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ))
        : Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.bottomRight,
            child: Text(
              strresendOtp,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          );
  }

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
    Map<String, String> data = {"phoneNumber": widget.PhoneNumber};
    if (numberOfTimesResendTapped < 3) {
      _updateResendButton();
      Future.delayed(Duration(minutes: 1), () {
        _updateResendButton();
      });
      if (from == strFromVerifyFamilyMember) {
        ResendOtpModel response =
            await authViewModel.resendOtpForAddingFamilyMember(data);
        _checkOtpResponse(response);
      } else {
        loginModel.PatientLogIn response =
            await authViewModel.loginPatient(widget.dataForResendOtp);
        _loginOTPSent(response);
      }
    } else if (numberOfTimesResendTapped == 3) {
      _updateResendButtonAfterBufferTime();
      Future.delayed(const Duration(minutes: 15), () {
        _updateResendButtonAfterBufferTime(resetCount: true);
      });
      if (from == strFromVerifyFamilyMember) {
        ResendOtpModel response =
            await authViewModel.resendOtpForAddingFamilyMember(data);
        _checkOtpResponse(response);
      } else {
        loginModel.PatientLogIn response =
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
          controller: controller,
          decoration: InputDecoration(
              labelText: title,
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
          strVerify,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  _verifyDetails() async {
    FocusScope.of(context).unfocus();
    if (_OtpKey.currentState.validate()) {
      _OtpKey.currentState.save();
      LoaderClass.showLoadingDialog(context);
      if (from == strFromSignUp) {
        PatientSignupOtp logInModel = new PatientSignupOtp(
          verificationCode: OtpController.text,
          userName: widget.PhoneNumber,
          source: strSource,
          userId: widget.userConfirm
              ? widget.userId
              : await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
        );
        Map<String, dynamic> map = logInModel.toJson();
        OtpModel.PatientSignupOtp response =
            await authViewModel.verifyPatient(map);
        print(response.toString());
        _checkResponse(response);
      } else if (from == strFromVerifyFamilyMember) {
        VerifyOTPModel params = VerifyOTPModel(
            phoneNumber: widget.PhoneNumber,
            verificationCode: OtpController.text);
        AddFamilyOTPResponse response =
            await authViewModel.verifyMyOTP(params.toJson());
        if (response.isSuccess) {
          //? this might be change
          toast.getToast('User added successfully', Colors.green);
          //Navigator.pop(context);
          LoaderClass.hideLoadingDialog(context);
          Navigator.pushNamed(context, router.rt_AddFamilyUserInfo,
                  arguments: AddFamilyUserInfoArguments(
                      fromClass: CommonConstants.add_family,
                      enteredFirstName: widget.fName,
                      enteredMiddleName: widget.mName,
                      enteredLastName: widget.lName,
                      relationShip: widget.relationship,
                      isPrimaryNoSelected: widget.isPrimaryNoSelected,
                      addFamilyUserInfo:
                          response.result != null ? response.result : null))
              .then((value) {
            Navigator.pop(context);
          });
        } else {
          //something went wrong.
          //Navigator.pop(context);
          LoaderClass.hideLoadingDialog(context);
          toast.getToast(response.message, Colors.red);
          Navigator.pop(context);
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
        PatientSignupOtp logInModel = new PatientSignupOtp(
          verificationCode: OtpController.text,
          userName: widget.PhoneNumber,
          source: strSource,
        );
        Map<String, dynamic> map = logInModel.toJson();
        OtpModel.PatientSignupOtp response = await authViewModel.verifyOtp(map);
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
      toast.getToast(response.message, Colors.red);
    }
  }

  _resendOtpDetails() async {
    ResendOtpModel logInModel = new ResendOtpModel(
      userName: widget.PhoneNumber,
      source: strSource,
      userId: widget.userConfirm
          ? widget.userId
          : await PreferenceUtil.getStringValue(strKeyConfirmUserToken),
    );
    Map<String, dynamic> map = logInModel.toJson();
    ResendModel.ResendOtpModel response = await authViewModel.resendOtp(map);
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
    decodesstring =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    saveuser.auth_token = decodesstring;
    if (widget.from == strFromSignUp) {
      if (widget.userConfirm) {
        userId = widget.userId;
      } else {
        userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
      }

      saveuser.userId = userId;
      print(userId);
      PreferenceUtil.saveString(Constants.MOB_NUM, widget.PhoneNumber)
          .then((onValue) {});
      PreferenceUtil.saveString(Constants.KEY_USERID, userId)
          .then((onValue) {});
      PreferenceUtil.save(strUserDetails, saveuser);
      authToken = decodesstring;
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      final token = await _firebaseMessaging.getToken();
      CommonUtil()
          .sendDeviceToken(userId, '', user_mobile_no, token, true)
          .then((value) {
        if (value != null) {
          Future.delayed(Duration(seconds: 3), () {
            LoaderClass.hideLoadingDialog(context);
            PageNavigator.goToPermanent(context, router.rt_Dashboard);
          });
        } else {
          LoaderClass.hideLoadingDialog(context);
          new FHBBasicWidget().showDialogWithTwoButtons(context, () {
            PageNavigator.goToPermanent(context, router.rt_Dashboard);
          }, value.message, strConfirmDialog);
        }
      });
    } else {
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
          .sendDeviceToken(userId, saveuser.email, user_mobile_no, token, true)
          .then((value) {
        if (value != null) {
          Future.delayed(Duration(seconds: 3), () {
            LoaderClass.hideLoadingDialog(context);
            PageNavigator.goToPermanent(context, router.rt_Dashboard);
          });
        } else {
          LoaderClass.hideLoadingDialog(context);
          new FHBBasicWidget().showDialogWithTwoButtons(context, () {
            PageNavigator.goToPermanent(context, router.rt_Dashboard);
          }, value.message, strConfirmDialog);
        }
      });
    }

    // redirecting to dashboard screen using userid
  }

  Future<DeviceInfoSucess> sendDeviceToken(String userId, String email,
      String user_mobile_no, String deviceId) async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    final token = await _firebaseMessaging.getToken();
    print('$strFirebaseToken $token');
    Map<String, dynamic> deviceInfo = new Map();
    Map<String, dynamic> user = new Map();
    Map<String, dynamic> jsonData = new Map();
    user[strid] = userId;
    deviceInfo[struser] = user;
    deviceInfo[strphoneNumber] = user_mobile_no;
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
    var params = json.encode(jsonData);
    print(params.toString());
    final response =
        await apiBaseHelper.postDeviceId(strDevvice_Info, params, true);
    return DeviceInfoSucess.fromJson(response);
  }
}
