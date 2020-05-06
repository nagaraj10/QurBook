import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/add_family_otp/bloc/add_family_otp_bloc.dart';
import 'package:myfhb/add_family_otp/models/add_family_otp_arguments.dart';
import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/src/blocs/Authentication/OTPVerifyBloc.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'dart:convert' as convert;

class AddFamilyOTPScreen extends StatefulWidget {
  AddFamilyOTPArguments arguments;

  AddFamilyOTPScreen({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return AddFamilyOTPScreenState();
  }
}

class AddFamilyOTPScreenState extends State<AddFamilyOTPScreen> {
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController currController = new TextEditingController();

  AddFamilyOTPBloc _addFamilyOTPBloc;

  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();

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
    _addFamilyOTPBloc = AddFamilyOTPBloc();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 0.0, right: 2.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
            //width: 10,
            alignment: Alignment.center,
            /*   decoration: new BoxDecoration(
              //color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border(
                  top: BorderSide.none,
                  left: BorderSide.none,
                  right: BorderSide.none,
                  bottom: BorderSide(color: Colors.deepPurple, width: 1.0)
                  //width: 1.0,
                  //color: Colors.deepPurple.withOpacity(0.5)
                  ),
              //borderRadius: new BorderRadius.circular(4.0)
            ), */
            child: new TextField(
              //obscureText: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              enabled: false,
              controller: controller1,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          /*  decoration: new BoxDecoration(
            //color: Color.fromRGBO(0, 0, 0, 0.1),
            border: new Border(
                top: BorderSide.none,
                left: BorderSide.none,
                right: BorderSide.none,
                bottom: BorderSide(color: Colors.deepPurple, width: 1.0)
                //width: 1.0,
                //color: Colors.deepPurple.withOpacity(0.5)
                ),
            //borderRadius: new BorderRadius.circular(4.0)
          ), */
          child: new TextField(
            //obscureText: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            controller: controller2,
            autofocus: false,
            enabled: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          /* decoration: new BoxDecoration(
            //color: Color.fromRGBO(0, 0, 0, 0.1),
            border: new Border(
                top: BorderSide.none,
                left: BorderSide.none,
                right: BorderSide.none,
                bottom: BorderSide(color: Colors.deepPurple, width: 1.0)
                //width: 1.0,
                //color: Colors.deepPurple.withOpacity(0.5)
                ),
            //borderRadius: new BorderRadius.circular(4.0)
          ), */
          child: new TextField(
            //obscureText: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            controller: controller3,
            textAlign: TextAlign.center,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 14.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          /*  decoration: new BoxDecoration(
            //color: Color.fromRGBO(0, 0, 0, 0.1),
            border: new Border(
                top: BorderSide.none,
                left: BorderSide.none,
                right: BorderSide.none,
                bottom: BorderSide(color: Colors.deepPurple, width: 1.0)
                //width: 1.0,
                //color: Colors.deepPurple.withOpacity(0.5)
                ),
            //borderRadius: new BorderRadius.circular(4.0)
          ), */
          child: new TextField(
            //obscureText: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller4,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 14.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 2.0, right: 0.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
    ];

    return Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          title: Text('Otp Verification', style: TextStyle(fontSize: 18)),
        ),
        key: scaffold_state,
        body: Center(
            child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                widget.arguments.enteredFirstName +
                    " " +
                    widget.arguments.enteredMiddleName +
                    " " +
                    widget.arguments.enteredLastName,
                style: TextStyle(
                    color: Color(new CommonUtil().getMyPrimaryColor()),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Please type the verification number',
                style: TextStyle(
                    color: Colors.black38, fontWeight: FontWeight.w400),
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/icons/otp_icon.png',
                width: 80,
                height: 80,
              ),
            ),
            Expanded(
                flex: 2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GridView.count(
                          crossAxisCount: 6,
                          crossAxisSpacing: 10,
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          children: List<Container>.generate(
                              6,
                              (int index) => Container(
                                    constraints: BoxConstraints(maxWidth: 20),
                                    child: widgetList[index],
                                  ))),
                      SizedBox(height: 20),
                      Text(
                        'Didn\'t receive the OTP?',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      FlatButton(
                          onPressed: () {
                            generateOtp(widget.arguments.selectedCountryCode,
                                widget.arguments.enteredMobNumber);
                          },
                          child: Text(
                            'Resend Code',
                            style: TextStyle(
                                //color: Colors.deepPurple[300],
                                color:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                fontWeight: FontWeight.w600),
                          )),
                      SizedBox(height: 20)
                    ])),
            Expanded(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.1),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 8.0, right: 8.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("1");
                                },
                                child: Text("1",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("2");
                                },
                                child: Text("2",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("3");
                                },
                                child: Text("3",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("4");
                                },
                                child: Text("4",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("5");
                                },
                                child: Text("5",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("6");
                                },
                                child: Text("6",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("7");
                                },
                                child: Text("7",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("8");
                                },
                                child: Text("8",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("9");
                                },
                                child: Text("9",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
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
                                        new CommonUtil().getMyPrimaryColor()),
                                  )),
                              MaterialButton(
                                onPressed: () {
                                  inputTextToField("0");
                                },
                                child: Text("0",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                              ),
                              //submitButton(_otpVerifyBloc)
                              MaterialButton(
                                onPressed: () {
                                  if (controller1.text.length > 0 &&
                                      controller2.text.length > 0 &&
                                      controller3.text.length > 0 &&
                                      controller4.text.length > 0) {
                                    String otp = controller1.text +
                                        controller2.text +
                                        controller3.text +
                                        controller4.text;
                                    _addFamilyOTPBloc.fromClass =
                                        CommonConstants.add_family_otp;
                                    _addFamilyOTPBloc
                                        .verifyAddFamilyOtp(
                                            widget.arguments.enteredMobNumber,
                                            widget
                                                .arguments.selectedCountryCode,
                                            otp)
                                        .then((otpResponse) {
                                      checkOTPResponse(otpResponse);
                                    });
                                  } else {
                                    Alert.displayAlertPlain(context,
                                        title: "Error",
                                        content: CommonConstants.all_fields);
                                  }
                                  //matchOtp();
                                },
                                child: Icon(
                                  Icons.done,
                                  color: Color(
                                      new CommonUtil().getMyPrimaryColor()),
                                ),
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
        )));
  }

  //  Widget submitButton(OTPVerifyBloc _otpVerifyBloc) {
  //    return StreamBuilder(
  //      stream: _otpVerifyBloc.submitCheck,
  //      builder: (context, snapshot) {
  //        return Container(
  //          padding: EdgeInsets.all(20),
  //          constraints: BoxConstraints(minWidth: 220, maxWidth: double.infinity),
  //          child: MaterialButton(
  //              child: Icon(Icons.done, color: Colors.deepPurple),
  //              onPressed: //snapshot.hasData ? bloc.submit : null,
  //                  () {
  //                String otp = controller1.text +
  //                    controller2.text +
  //                    controller3.text +
  //                    controller4.text;
  //                _otpVerifyBloc
  //                    .verifyOtp(widget.arguments.enteredMobNumber,
  //                        widget.arguments.selectedCountryCode, otp)
  //                    .then((otpResponse) {
  //                  checkOTPResponse(otpResponse);
  //                });
  //              }),
  //        );
  //      },
  //    );
  //  }

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
            title: Text("Successfully"),
            content: Text("Otp matched successfully."),
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

  void checkOTPResponse(AddFamilyOTPResponse addFamilyOTPResponse) {
    if (addFamilyOTPResponse.success && addFamilyOTPResponse.status == 200) {
      Alert.displayConfirmation(
        context,
        title: "Success",
        content: "Your family member has been added successfully",
        onPressedConfirm: () {
          Navigator.pushNamed(context, '/add_family_user_info',
                  arguments: AddFamilyUserInfoArguments(
                      enteredFirstName: widget.arguments.enteredFirstName,
                      enteredMiddleName: widget.arguments.enteredMiddleName,
                      enteredLastName: widget.arguments.enteredLastName,
                      relationShip: widget.arguments.relationShip,
                      isPrimaryNoSelected: widget.arguments.isPrimaryNoSelected,
                      addFamilyUserInfo: addFamilyOTPResponse.response.data))
              .then((value) {
            // Navigator.of(context).pop();
            //Navigator.of(context).pop(true);
          });
        },
      );
    } else {
      Alert.displayAlertPlain(context,
          title: "Error", content: addFamilyOTPResponse.message);
    }
  }

  void generateOtp(String selectedCountryCode, String enteredMobNumber) {
    FamilyListBloc _familyListBloc = new FamilyListBloc();

    var signInData = {};
    signInData['countryCode'] = "+" + selectedCountryCode;
    signInData['phoneNumber'] = enteredMobNumber;
    signInData['isPrimaryUser'] = widget.arguments.isPrimaryNoSelected;
    signInData['firstName'] = widget.arguments.enteredFirstName;
    signInData['middleName'] = widget.arguments.enteredMiddleName.length > 0
        ? widget.arguments.enteredMiddleName
        : '';
    signInData['lastName'] = widget.arguments.enteredLastName;
    signInData['relation'] = widget.arguments.relationShip.id;

    var jsonString = convert.jsonEncode(signInData);

    if (widget.arguments.isPrimaryNoSelected) {
      _familyListBloc
          .postUserLinkingForPrimaryNo(jsonString)
          .then((addFamilyOTPResponse) {
        if (addFamilyOTPResponse.success &&
            addFamilyOTPResponse.status == 200) {
          new FHBBasicWidget()
              .showInSnackBar(addFamilyOTPResponse.message, scaffold_state);
        } else {
          new FHBBasicWidget()
              .showInSnackBar(addFamilyOTPResponse.message, scaffold_state);
        }
      });
    } else {
      _familyListBloc.postUserLinking(jsonString).then((userLinking) {
        if (userLinking.success && userLinking.status == 200) {
          new FHBBasicWidget()
              .showInSnackBar(userLinking.message, scaffold_state);
        } else {
          new FHBBasicWidget()
              .showInSnackBar(userLinking.message, scaffold_state);
        }
      });
    }
  }
}
