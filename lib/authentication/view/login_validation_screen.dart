import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';

import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart';
import '../../src/model/Authentication/UserModel.dart';
import '../../src/ui/loader_class.dart';
import '../../src/utils/PageNavigator.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/app_primary_button.dart';
import '../constants/constants.dart';
import '../model/Country.dart';
import '../model/patientlogin_model.dart';
import '../view_model/patientauth_view_model.dart';
import 'authentication_validator.dart';
import 'forgotpassword_screen.dart';
import 'verifypatient_screen.dart';

class PatientSignInValidationScreen extends StatefulWidget {
  PatientSignInValidationScreen(
      {this.flag = 0,
      this.signInValidationModel,
      this.selDialogCountry,
      this.mobNo});

  final int flag;
  final SignInValidationModel? signInValidationModel;
  final Country? selDialogCountry;
  final String? mobNo;

  @override
  _PatientSignInValidationScreenState createState() =>
      _PatientSignInValidationScreenState();
}

class _PatientSignInValidationScreenState
    extends State<PatientSignInValidationScreen> {
  Country _selectedDialogCountry = Country.fromCode(CommonUtil.REGION_CODE);
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false;
  final _loginKey = GlobalKey<FormState>();
  bool _autoValidateBool = false;
  late AuthViewModel authViewModel;
  FlutterToast toast = FlutterToast();
  String? decodesstring;
  UserModel saveuser = UserModel();
  String? user_mobile_no;
  String? id_token_string;
  Map<String, dynamic>? dataForResendOtp;
  bool _isHidden = true;
  bool? isVirtualNumber = false;

  @override
  void initState() {
    super.initState();
    authViewModel = AuthViewModel();
    onInit();
  }

  onInit() {
    try {
      _selectedDialogCountry =
          (widget.selDialogCountry ?? Country.fromCode(CommonUtil.REGION_CODE));
      numberController.text = CommonUtil().validString(widget.mobNo ?? "");
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = 1.sh;
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
                        if (widget.flag == 0) ...{
                          Text(
                            widget.signInValidationModel?.result != null &&
                                    widget.signInValidationModel?.result
                                            ?.firstName !=
                                        null &&
                                    widget.signInValidationModel?.result
                                            ?.firstName !=
                                        ''
                                ? 'Hey, ${toBeginningOfSentenceCase((widget.signInValidationModel?.result?.firstName ?? ""))}'
                                : '',
                            style: TextStyle(
                              fontSize: CommonUtil().isTablet!
                                  ? Constants.tabFontTitle
                                  : Constants.mobileFontTitle,
                              color: Color(CommonUtil().getMyPrimaryColor()),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 10.0.h),
                          Text(
                            widget.signInValidationModel?.result != null &&
                                    widget.signInValidationModel?.result
                                            ?.firstName !=
                                        null &&
                                    widget.signInValidationModel?.result
                                            ?.firstName !=
                                        ''
                                ? '${_selectedDialogCountry.phoneCode} ${numberController.text}'
                                : '',
                            style: TextStyle(
                              fontSize: CommonUtil().isTablet!
                                  ? Constants.tabHeader2
                                  : Constants.mobileHeader2,
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 30.0.h),
                        },
                        Column(
                          children: [
                            if (widget.flag == 0) ...{
                              _loginTextFields(
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
                                    contentPadding: EdgeInsets.only(
                                      left: 25,
                                      right: 20,
                                      top: 20,
                                      bottom: 20,
                                    ),
                                    hintText: strEnterPass,
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
                                        .loginPasswordValidation(
                                            value!,
                                            patternPassword as String,
                                            strPassCantEmpty);
                                  },
                                ),
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
                                          /*decoration: TextDecoration.underline,
                                          decorationColor: Color(CommonUtil().getMyPrimaryColor()),*/
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            },
                          ],
                        ),
                        SizedBox(height: 20.0.h),
                        if (widget.flag == 0) ...{
                          AppPrimaryButton(
                            text: strLoginText,
                            onTap: () {
                              AuthenticationValidator()
                                  .checkNetwork()
                                  .then((intenet) {
                                if (intenet != null && intenet) {
                                  _savepatientdetails();
                                } else {
                                  toast.getToast(strNetworkIssue, Colors.red);
                                }
                              });
                            },
                          )
                        },
                        SizedBox(height: 20.0.h),
                        _loginBackButton(),
                        SizedBox(height: 20.0.h),
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

  _savepatientdetails() async {
    FocusScope.of(context).unfocus();
    if (_loginKey.currentState!.validate()) {
      _loginKey.currentState!.save();
      LoaderClass.showLoadingDialog(context);
      var logInModel = PatientLogIn(
        userName: '${_selectedDialogCountry.phoneCode}${numberController.text}',
        password: passwordController.text,
        source: strSource,
      );
      final map = logInModel.toJson();
      final response = await authViewModel.loginPatient(map);
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
    if (response.isSuccess!) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyPatient(
                    PhoneNumber:
                        '${_selectedDialogCountry.phoneCode}${numberController.text}',
                    from: strFromLogin,
                    userConfirm: false,
                    dataForResendOtp: dataForResendOtp,
                    forFamilyMember: false,
                    isVirtualNumber: isVirtualNumber,
                  )));
    } else {
      if (response.message == 'User is not confirmed.') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyPatient(
                      PhoneNumber: response.diagnostics!.errorData!.userName,
                      from: strFromSignUp,
                      userConfirm: true,
                      userId: response.diagnostics!.errorData!.userId,
                      forFamilyMember: false,
                      isVirtualNumber: isVirtualNumber,
                    )));
      } else {
        toast.getToast(response.message!, Colors.red);
      }
    }
  }

  Widget _loginTextFields(Widget textFormField) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2), child: textFormField);
  }

  Widget _loginBackButton() => AppPrimaryButton(
        text: strBackText,
        onTap: () => Navigator.of(context).pop(),
        isSecondaryButton: true,
      );

  void _checkifItsGuest(PatientLogIn response) async {
    if (response.isSuccess!) {
      decodesstring = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
      saveuser.auth_token = decodesstring;
      final bool isSkipMFA =
          parseJwtPayLoad(decodesstring ?? '')[strToken][strIsSkipMFA];
      isVirtualNumber =
          parseJwtPayLoad(decodesstring!)[strToken][strIsVirtualNumberUser];
      print(isSkipMFA);
      if (isSkipMFA) {
        final String userId =
            parseJwtPayLoad(decodesstring ?? '')[strToken][strUserId];

        saveuser.userId = userId;
        id_token_string = parseJwtPayLoad(decodesstring ?? '')[strToken]
            [strProviderPayLoad][strIdToken];
        final idTokens = parseJwtPayLoad(id_token_string ?? '');
        print(idTokens);
        user_mobile_no = idTokens[strphonenumber];
        print(idTokens[strphonenumber]);
        saveuser.family_name = idTokens[strFamilyName];
        print(idTokens[strFamilyName]);
        saveuser.phone_number = idTokens[strphonenumber];
        final String? ph = idTokens[strphonenumber];
        print(idTokens[strphonenumber]);
        saveuser.given_name = idTokens[strGivenName];
        print(idTokens[strGivenName]);
        saveuser.email = idTokens[stremail];
        print(idTokens[stremail]);
        await PreferenceUtil.saveString(Constants.MOB_NUM, user_mobile_no!)
            .then((onValue) {});
        await PreferenceUtil.saveString(
                Constants.KEY_EMAIL, saveuser.email ?? '')
            .then((onValue) {});
        await PreferenceUtil.saveString(Constants.KEY_AUTHTOKEN, decodesstring!)
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
        print('tokenavailable: ' + token.toString());
        await CommonUtil()
            .sendDeviceToken(userId, saveuser.email, user_mobile_no,
                token ?? 'NOT AVAILABLE', true)
            .then((value) {
          LoaderClass.hideLoadingDialog(context);
          if (value != null) {
            Future.delayed(Duration(seconds: 3), () {
              PageNavigator.goToPermanent(context, router.rt_Landing);
            });
          } else {
            FHBBasicWidget().showDialogWithTwoButtons(context, () {
              PageNavigator.goToPermanent(context, router.rt_Landing);
            }, value.message!, strConfirmDialog);
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
