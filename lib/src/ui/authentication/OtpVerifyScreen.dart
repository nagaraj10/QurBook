
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import 'package:myfhb/add_family_user_info/bloc/add_family_user_info_bloc.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/firebase_analytics_service.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/myfhb_weview/myfhb_webview.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/Authentication/OTPResponse.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/blocs/Authentication/OTPVerifyBloc.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String? enteredMobNumber;
  final String? selectedCountryCode;
  final bool? fromSignIn;
  final bool? fromSignUp;
  final bool? forEmailVerify;

  const OtpVerifyScreen(
      {Key? key,
      required this.enteredMobNumber,
      required this.selectedCountryCode,
      this.fromSignIn,
      this.fromSignUp,
      this.forEmailVerify})
      : super(key: key);

  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  TextEditingController controller1 = TextEditingController(text: '');
  TextEditingController controller2 = TextEditingController(text: '');
  TextEditingController controller3 = TextEditingController(text: '');
  TextEditingController controller4 = TextEditingController(text: '');
  TextEditingController currController = TextEditingController(text: '');

  late OTPVerifyBloc _otpVerifyBloc;
  late AddFamilyUserInfoBloc addFamilyUserInfoBloc;

  GlobalKey<ScaffoldMessengerState> scaffold_state = GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
  }

  @override
  void initState() {
    PreferenceUtil.init();

    super.initState();
    currController = controller1;
    _otpVerifyBloc = OTPVerifyBloc();
    addFamilyUserInfoBloc = AddFamilyUserInfoBloc();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 0.0, right: 2.0),
        child: Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
            alignment: Alignment.center,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              enabled: false,
              controller: controller1,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0.sp, color: Colors.black),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            controller: controller2,
            autofocus: false,
            enabled: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0.sp, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            controller: controller3,
            textAlign: TextAlign.center,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 16.0.sp, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller4,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 16.0.sp, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 2.0, right: 0.0),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        title: Text(variable.strOTPVerification,
            style: TextStyle(fontSize: 18.0.sp)),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      key: scaffold_state,
      body: Column(
        children: <Widget>[
          !widget.forEmailVerify!
              ? Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    variable.strEnterOtp,
                    style: TextStyle(
                        color: Colors.black38, fontWeight: FontWeight.w500),
                  ),
                )
              : Container(
                  height: 10.0.h,
                ),
          widget.forEmailVerify! || widget.fromSignIn!
              ? Expanded(
                  child: ImageIcon(
                    AssetImage(variable.icon_otp),
                    size: 70.0.sp,
                    color: Color(CommonUtil().getMyPrimaryColor()),
                  ),
                )
              : SizedBox(height: 0.0.h),
          widget.forEmailVerify!
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        variable.strEnterotpReceived,
                        style: TextStyle(
                            color: Colors.black38, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        PreferenceUtil.getStringValue(
                                    Constants.PROFILE_EMAIL) !=
                                null
                            ? PreferenceUtil.getStringValue(
                                Constants.PROFILE_EMAIL)!
                            : '',
                        style: TextStyle(
                            color: Colors.black38, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  height: 0.0.h,
                  width: 0.0.h,
                ),
          Expanded(
              flex: 2,
              child: ListView(children: <Widget>[
                GridView.count(
                    crossAxisCount: 6,
                    crossAxisSpacing: 10,
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    children: List<Container>.generate(
                        6,
                        (int index) => Container(
                              constraints: BoxConstraints(maxWidth: 20.0.w),
                              child: widgetList[index],
                            ))),
                SizedBox(height: 20.0.h),
                Text(
                  variable.strdidtReceive,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.0.sp,
                    color: Colors.grey,
                  ),
                ),
                FlatButtonWidget(
                  bgColor: Colors.transparent,
                  isSelected: true,
                  onPress: () {
                    FHBUtils().check().then((intenet) {
                      if (intenet != null && intenet) {
                        if (widget.forEmailVerify!) {
                          verifyOTPFromEmai();
                        } else {
                          generateOtp(
                              _otpVerifyBloc,
                              widget.selectedCountryCode,
                              widget.enteredMobNumber);
                        }
                      } else {
                        FHBBasicWidget().showInSnackBar(
                            Constants.STR_NO_CONNECTIVITY, scaffold_state);
                      }
                    });
                  },
                  title: variable.strResendCode,
                  titleColor: Color(CommonUtil().getMyPrimaryColor()),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 20.0.h)
              ])),
          !widget.fromSignIn! && !widget.forEmailVerify!
              ? Expanded(child: acceptanceWidget())
              : SizedBox(height: 0.0.h),
          Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8.0, right: 8.0, bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numOne);
                              },
                              child: Text(variable.numOne,
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numTwo);
                              },
                              child: Text(variable.numTwo,
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numThree);
                              },
                              child: Text(variable.numThree,
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numFour);
                              },
                              child: Text(variable.numFour,
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numFive);
                              },
                              child: Text(variable.numFive,
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numSix);
                              },
                              child: Text(variable.numSix,
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numSeven);
                              },
                              child: Text(variable.numSeven,
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numEight);
                              },
                              child: Text(variable.numEight,
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numNine);
                              },
                              child: Text(variable.numNine,
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                                onPressed: () {
                                  deleteText();
                                },
                                child: Icon(
                                  Icons.backspace,
                                  color: Color(
                                      CommonUtil().getMyPrimaryColor()),
                                )),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numZero);
                              },
                              child: Text(variable.numZero,
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center),
                            ),
                            //submitButton(_otpVerifyBloc)
                            MaterialButton(
                              onPressed: () {
                                if (controller1.text != '' &&
                                    controller2.text != '' &&
                                    controller3.text != '' &&
                                    controller4.text != '') {
                                  String otp = controller1.text +
                                      controller2.text +
                                      controller3.text +
                                      controller4.text;

                                  FHBUtils().check().then((intenet) {
                                    if (intenet != null && intenet) {
                                      if (widget.forEmailVerify!) {
                                        _otpVerifyBloc
                                            .verifyOTPFromEmail(otp)
                                            .then((value) {
                                          if (value!.success! &&
                                              value.message ==
                                                  Constants
                                                      .MSG_EMAIL_OTP_VERIFIED) {
                                            updateProfile();
                                          } else {
                                            FHBBasicWidget().showInSnackBar(
                                                value.message!, scaffold_state);
                                          }
                                        });
                                      } else {
                                        _otpVerifyBloc
                                            .verifyOtp(
                                                widget.enteredMobNumber,
                                                widget.selectedCountryCode!,
                                                otp,
                                                widget.fromSignIn!)
                                            .then((otpResponse) {
                                          checkOTPResponse(otpResponse!);
                                        });
                                      }
                                    } else {
                                      FHBBasicWidget().showInSnackBar(
                                          Constants.STR_NO_CONNECTIVITY,
                                          scaffold_state);
                                    }
                                  });
                                } else {
                                  FHBBasicWidget().showInSnackBar(
                                      Constants.STR_OTP_FIELD, scaffold_state);
                                }
                                //matchOtp();
                              },
                              child: Icon(Icons.done,
                                  color: Color(
                                      CommonUtil().getMyPrimaryColor())),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )

              //flex: 40,
              ),
        ],
      ),
    );
  }

  Widget submitButton(OTPVerifyBloc _otpVerifyBloc) {
    return StreamBuilder(
      stream: _otpVerifyBloc.submitCheck,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(minWidth: 220, maxWidth: double.infinity),
          child: MaterialButton(
              child: Icon(Icons.done,
                  color: Color(CommonUtil().getMyPrimaryColor())),
              onPressed: //snapshot.hasData ? bloc.submit : null,
                  () {
                String otp = controller1.text +
                    controller2.text +
                    controller3.text +
                    controller4.text;

                if (widget.forEmailVerify!) {
                  _otpVerifyBloc.verifyOTPFromEmail(otp).then((value) {
                    if (value!.success! &&
                        value.message == Constants.MSG_EMAIL_OTP_VERIFIED) {
                      updateProfile();
                    } else {
                      FHBBasicWidget()
                          .showInSnackBar(value.message!, scaffold_state);
                    }
                  });
                } else {
                  _otpVerifyBloc
                      .verifyOtp(widget.enteredMobNumber,
                          widget.selectedCountryCode!, otp, widget.fromSignIn!)
                      .then((otpResponse) {
                    checkOTPResponse(otpResponse!);
                  });
                }
              }),
        );
      },
    );
  }

  void inputTextToField(String str) {
    //Edit first textField
    if (currController == controller1) {
      controller1.text = str;
      currController = controller2;
    }

    //Edit second textField
    else if (currController == controller2) {
      controller2.text = str;
      currController = controller3;
    }

    //Edit third textField
    else if (currController == controller3) {
      controller3.text = str;
      currController = controller4;
    }

    //Edit fourth textField
    else if (currController == controller4) {
      controller4.text = str;
      currController = controller4;
    }
  }

  void deleteText() {
    if (currController.text.length == 0) {
    } else {
      currController.text = "";
      currController = controller4;
      return;
    }

    if (currController == controller1) {
      controller1.text = "";
    } else if (currController == controller2) {
      controller1.text = "";
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = "";
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = "";
      currController = controller3;
    }
  }

  void matchOtp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(variable.strSuccessfully),
            content: Text(variable.strOTPMatched),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void verifyOTP() {}

  void moveToDashboardScreen() {
    var firebase = FirebaseAnalyticsService();
    firebase.setUserId(PreferenceUtil.getStringValue(KEY_USERID_MAIN));
    if (widget.fromSignUp != null && widget.fromSignUp!) {
      PreferenceUtil.isCorpUserWelcomeMessageDialogShown(false);
    } else {
      PreferenceUtil.isCorpUserWelcomeMessageDialogShown(true);
    }
    PageNavigator.goToPermanent(context, router.rt_Landing);
  }

  void checkOTPResponse(OTPResponse otpResponse) {
    if (otpResponse.message == Constants.STR_OTPMISMATCHED) {
      FHBBasicWidget()
          .showInSnackBar(Constants.STR_OTPMISMATCHED_STRING, scaffold_state);
    } else {
      PreferenceUtil.saveString(
              Constants.KEY_USERID_MAIN, otpResponse.response!.id!)
          .then((onValue) {
        PreferenceUtil.saveString(Constants.KEY_USERID, otpResponse.response!.id!)
            .then((onValue) {
          PreferenceUtil.saveString(
                  Constants.KEY_AUTHTOKEN, otpResponse.response!.authToken!)
              .then((onValue) {
            PreferenceUtil.saveString(
                    Constants.MOB_NUM, otpResponse.response!.phoneNumber!)
                .then((onValue) {
              PreferenceUtil.saveString(
                      Constants.COUNTRY_CODE, widget.selectedCountryCode!)
                  .then((onValue) {
                PreferenceUtil.saveInt(CommonConstants.KEY_COUNTRYCODE,
                        int.parse(widget.selectedCountryCode!))
                    .then((value) {
                  moveToDashboardScreen();
                });
              });
            });
          });
        });
      });
    }
  }

  void generateOtp(
      OTPVerifyBloc bloc, String? selectedCountryCode, String? enteredMobNumber) {
    bloc
        .generateOTP(widget.enteredMobNumber, widget.selectedCountryCode!,
            widget.fromSignIn!)
        .then((onValue) {
      FHBBasicWidget().showInSnackBar(onValue!.message!, scaffold_state);
    });
  }

  void verifyOTPFromEmai() {
    addFamilyUserInfoBloc.verifyEmail().then((value) {
      FHBBasicWidget().showInSnackBar(value!.message!, scaffold_state);
    });
  }

  acceptanceWidget() {
    TextStyle defaultStyle = TextStyle(
        color: Colors.black,
        fontFamily: variable.font_poppins,
        fontSize: 14.0.sp);
    TextStyle linkStyle = TextStyle(
        color: Color(CommonUtil().getMyPrimaryColor()),
        fontFamily: variable.font_poppins,
        fontSize: 14.0.sp);
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 40, left: 40),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: defaultStyle,
            children: <TextSpan>[
              TextSpan(text: variable.strAgree),
              TextSpan(
                  text: variable.strTermService,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      openWebView(Constants.terms_of_service,
                          CommonUtil.isUSRegion()?variable.file_terms_us:variable.file_terms, true);
                    }),
              TextSpan(text: variable.strAnd),
              TextSpan(
                  text: variable.strPrivacyPolicy,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      openWebView(Constants.privacy_policy,
                          CommonUtil.isUSRegion()?variable.file_privacy_us:variable.file_privacy, true);
                    }),
            ],
          ),
        ));
  }

  void openWebView(String title, String url, bool isLocal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MyFhbWebView(
            title: title, selectedUrl: url, isLocalAsset: isLocal)));
  }

  void updateProfile() {
    MyProfileBloc _myProfileBloc = MyProfileBloc();

    _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
          .then((value) {
        Navigator.of(context).pop();
      });
    });
  }
}
