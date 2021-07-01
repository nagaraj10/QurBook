import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../bloc/add_family_otp_bloc.dart';
import '../models/add_family_otp_arguments.dart';
import '../models/add_family_otp_response.dart';
import '../../add_family_user_info/models/add_family_user_info_arguments.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_parameters.dart' as parameters;
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../my_family/bloc/FamilyListBloc.dart';
import '../../src/utils/alert.dart';
import '../../widgets/GradientAppBar.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class AddFamilyOTPScreen extends StatefulWidget {
  AddFamilyOTPArguments arguments;

  AddFamilyOTPScreen({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return AddFamilyOTPScreenState();
  }
}

class AddFamilyOTPScreenState extends State<AddFamilyOTPScreen> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  TextEditingController currController = TextEditingController();

  AddFamilyOTPBloc _addFamilyOTPBloc;

  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Add Family OTP Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  void initState() {
    mInitialTime = DateTime.now();
    PreferenceUtil.init();

    super.initState();
    currController = controller1;
    _addFamilyOTPBloc = AddFamilyOTPBloc();
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      Padding(
        padding: EdgeInsets.only(
          left: 0.0.w,
          right: 2.0.w,
        ),
        child: Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          right: 2.0.w,
          left: 2.0.w,
        ),
        child: Container(
          alignment: Alignment.center,
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            enabled: false,
            controller: controller1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0.sp,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          right: 2.0.w,
          left: 2.0.w,
        ),
        child: Container(
          alignment: Alignment.center,
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            controller: controller2,
            enabled: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0.sp,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          right: 2.0.w,
          left: 2.0.w,
        ),
        child: Container(
          alignment: Alignment.center,
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            controller: controller3,
            textAlign: TextAlign.center,
            enabled: false,
            style: TextStyle(
              fontSize: 16.0.sp,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          right: 2.0.w,
          left: 2.0.w,
        ),
        child: Container(
          alignment: Alignment.center,
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller4,
            enabled: false,
            style: TextStyle(
              fontSize: 16.0.sp,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: 2.0.w,
          right: 0.0.w,
        ),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          title: Text(
            variable.strOTPVerification,
            style: TextStyle(
              fontSize: 18.0.sp,
            ),
          ),
        ),
        key: scaffold_state,
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 40.0.h,
              ),
              child: Text(
                toBeginningOfSentenceCase(
                    '${widget.arguments.enteredFirstName} ${widget.arguments.enteredMiddleName} ${widget.arguments.enteredLastName}'),
                style: TextStyle(
                  color: Color(CommonUtil().getMyPrimaryColor()),
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0.sp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10.0.h,
              ),
              child: Text(
                variable.strEnterOtp,
                style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0.sp,
                ),
              ),
            ),
            Expanded(
              child: Image.asset(
                variable.strOtpIcon,
                width: 70.0.h,
                height: 70.0.h,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                children: <Widget>[
                  GridView.count(
                    crossAxisCount: 6,
                    crossAxisSpacing: 10,
                    shrinkWrap: true,
                    primary: false,
                    children: List<Container>.generate(
                      6,
                      (index) => Container(
                        constraints: BoxConstraints(maxWidth: 20.0.w),
                        child: widgetList[index],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Text(
                    variable.strdidtReceive,
                    style: TextStyle(
                      fontSize: 13.0.sp,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  FlatButton(
                    onPressed: () {
                      generateOtp(widget.arguments.selectedCountryCode,
                          widget.arguments.enteredMobNumber);
                    },
                    child: Text(
                      variable.strResendCode,
                      style: TextStyle(
                          //color: Colors.deepPurple[300],
                          color: Color(CommonUtil().getMyPrimaryColor()),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, top: 8, right: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numOne);
                              },
                              child: getNumberWidet(variable.numOne),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numTwo);
                              },
                              child: getNumberWidet(variable.numTwo),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numThree);
                              },
                              child: getNumberWidet(variable.numThree),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 4, right: 8, bottom: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numFour);
                              },
                              child: getNumberWidet(variable.numFour),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numFive);
                              },
                              child: getNumberWidet(variable.numFive),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numSix);
                              },
                              child: getNumberWidet(variable.numSix),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 4, right: 8, bottom: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numSeven);
                              },
                              child: getNumberWidet(variable.numSeven),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numEight);
                              },
                              child: getNumberWidet(variable.numEight),
                            ),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numNine);
                              },
                              child: getNumberWidet(variable.numNine),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, top: 4, right: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MaterialButton(
                                onPressed: () {
                                  deleteText();
                                },
                                child: Icon(
                                  Icons.backspace,
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor()),
                                  size: 24.0.sp,
                                )),
                            MaterialButton(
                              onPressed: () {
                                inputTextToField(variable.numZero);
                              },
                              child: getNumberWidet(variable.numZero),
                            ),
                            //submitButton(_otpVerifyBloc)
                            MaterialButton(
                              onPressed: () {
                                if (controller1.text.isNotEmpty &&
                                    controller2.text.isNotEmpty &&
                                    controller3.text.isNotEmpty &&
                                    controller4.text.isNotEmpty) {
                                  final otp =
                                      '${controller1.text}${controller2.text}${controller3.text}${controller4.text}';
                                  _addFamilyOTPBloc.fromClass =
                                      CommonConstants.add_family_otp;
                                  _addFamilyOTPBloc
                                      .verifyAddFamilyOtp(
                                          widget.arguments.enteredMobNumber,
                                          widget.arguments.selectedCountryCode,
                                          otp)
                                      .then(checkOTPResponse);
                                } else {
                                  Alert.displayAlertPlain(context,
                                      title: variable.strError,
                                      content: CommonConstants.all_fields);
                                }
                                //matchOtp();
                              },
                              child: Icon(
                                Icons.done,
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                size: 24.0.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
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

    //Edit fifth textField
    else if (currController == controller5) {
      controller5.text = str;
      currController = controller5;
    }

    //Edit sixth textField
    else if (currController == controller6) {
      controller6.text = str;
      currController = controller6;
    }
  }

  void deleteText() {
    if (currController.text.isEmpty) {
    } else {
      currController.text = '';
      currController = controller4;
      return;
    }

    if (currController == controller1) {
      controller1.text = '';
    } else if (currController == controller2) {
      controller1.text = '';
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = '';
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = '';
      currController = controller3;
    } else if (currController == controller5) {
      controller4.text = '';
      currController = controller4;
    } else if (currController == controller6) {
      controller5.text = '';
      currController = controller5;
    }
  }

  void matchOtp() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(variable.strSuccessfully),
            content: Text(variable.strOTPMatched),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.check,
                    size: 24.0.sp,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void checkOTPResponse(AddFamilyOTPResponse addFamilyOTPResponse) {
    if (addFamilyOTPResponse.isSuccess) {
      Alert.displayConfirmation(
        context,
        title: variable.strSucess,
        content: variable.strFamilySucess,
        onPressedConfirm: () {
          Navigator.pushNamed(context, router.rt_AddFamilyUserInfo,
                  arguments: AddFamilyUserInfoArguments(
                      fromClass: CommonConstants.add_family,
                      enteredFirstName: widget.arguments.enteredFirstName,
                      enteredMiddleName: widget.arguments.enteredMiddleName,
                      enteredLastName: widget.arguments.enteredLastName,
                      relationShip: widget.arguments.relationShip,
                      isPrimaryNoSelected: widget.arguments.isPrimaryNoSelected,
                      addFamilyUserInfo: addFamilyOTPResponse.result ?? ''))
              .then((value) {});
        },
      );
    } else {
      Alert.displayAlertPlain(context,
          title: variable.strError, content: 'Error Adding Family member');
    }
  }

  void generateOtp(String selectedCountryCode, String enteredMobNumber) {
    var _familyListBloc = FamilyListBloc();

    final signInData = {};
    signInData[variable.strCountryCode] = '+$selectedCountryCode';
    signInData[variable.strPhoneNumber] = enteredMobNumber;
    signInData[variable.strisPrimaryUser] =
        widget.arguments.isPrimaryNoSelected;
    signInData[variable.strFirstName] = widget.arguments.enteredFirstName;
    signInData[variable.strMiddleName] =
        widget.arguments.enteredMiddleName.isNotEmpty
            ? widget.arguments.enteredMiddleName
            : '';
    signInData[variable.strLastName] = widget.arguments.enteredLastName;
    signInData[variable.strRelation] = widget.arguments.relationShip.id;
    signInData[variable.strOperation] = CommonConstants.user_linking;

    signInData[parameters.strSourceId] = parameters.strSrcIdVal;
    signInData[parameters.strEntityId] = parameters.strEntityIdVal;
    signInData[parameters.strRoleId] = parameters.strRoleIdVal;
    final jsonString = convert.jsonEncode(signInData);

    if (widget.arguments.isPrimaryNoSelected) {
      _familyListBloc
          .postUserLinkingForPrimaryNo(jsonString)
          .then((addFamilyOTPResponse) {
        if (addFamilyOTPResponse.isSuccess) {
          FHBBasicWidget()
              .showInSnackBar('New Family has been added', scaffold_state);
        } else {
          FHBBasicWidget()
              .showInSnackBar('Error Adding Family member', scaffold_state);
        }
      });
    } else {
      _familyListBloc.postUserLinking(jsonString).then((userLinking) {
        if (userLinking.success && userLinking.status == 200) {
          FHBBasicWidget().showInSnackBar(userLinking.message, scaffold_state);
        } else {
          FHBBasicWidget().showInSnackBar(userLinking.message, scaffold_state);
        }
      });
    }
  }

  Widget getNumberWidet(String text) {
    return Text(text,
        style: TextStyle(fontSize: 22.0.sp, fontWeight: FontWeight.w400),
        textAlign: TextAlign.center);
  }
}
