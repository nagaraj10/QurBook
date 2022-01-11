import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/ui/authentication/OtpVerifyScreen.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class SignUpScreen extends StatefulWidget {
  final String enteredMobNumber;
  final String selectedCountryCode;
  final String selectedCountry;

  const SignUpScreen(
      {Key key,
      @required this.enteredMobNumber,
      @required this.selectedCountryCode,
      @required this.selectedCountry})
      : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final double circleRadius = 100.0.h;
  final double circleBorderWidth = 2.0;

  LoginBloc _loginBloc;
  TextEditingController phoneNumber,
      name,
      email,
      firstName,
      middleName,
      lastName;
  String strErrorMsg = '';
  String dropDownValue = 'Male';
  PickedFile imageURI;
  @override
  void initState() {
    super.initState();

    _loginBloc = LoginBloc();
    phoneNumber = new TextEditingController(
        text: '+' + widget.selectedCountryCode + ' ' + widget.enteredMobNumber);
    name = new TextEditingController(text: '');
    email = new TextEditingController(text: '');
    firstName = new TextEditingController(text: '');
    middleName = new TextEditingController(text: '');
    lastName = new TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: SingleChildScrollView(
            child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.topCenter,
          children: <Widget>[
            SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(top: 200, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          enabled: false,
                          controller: phoneNumber,
                          decoration: InputDecoration(
                              hintText: CommonConstants.mobile_number,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey[200].withOpacity(0.5)))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: firstName,
                          decoration: InputDecoration(
                              hintText: CommonConstants.firstName,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey[200].withOpacity(0.5)))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: middleName,
                          decoration: InputDecoration(
                              hintText: CommonConstants.middleName,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey[200].withOpacity(0.5)))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: lastName,
                          decoration: InputDecoration(
                              hintText: CommonConstants.lastName,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey[200].withOpacity(0.5)))),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(5), child: genderDropDown()),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                              hintText: variable.strEmailOpt,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey[200].withOpacity(0.5)))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0.h),
                  Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 200),
                      margin: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(new CommonUtil().getMyPrimaryColor()),
                          borderRadius: BorderRadius.circular(10)),
                      child: FlatButton(
                          onPressed: () {
                            createUser();
                          },
                          child: Text(
                            CommonConstants.send_otp,
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
            )),
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: circleRadius / 2.0),
                  child: Container(
                    color: Color(new CommonUtil().getMyPrimaryColor()),
                    height: 160.0.h,
                  ),
                ),
                Container(
                  width: circleRadius,
                  height: circleRadius,
                  decoration: ShapeDecoration(
                      shape: CircleBorder(), color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(circleBorderWidth),
                    child: InkWell(
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageURI != null
                                    ? FileImage(File(imageURI.path))
                                    : AssetImage(variable.icon_fhb))),
                      ),
                      onTap: () {
                        saveMediaDialog(context);
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        )));
  }

  Widget genderDropDown() {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropDownValue,
      icon: Icon(Icons.expand_more),
      iconSize: 24.0.sp,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 1.0.h,
        color: Colors.grey,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropDownValue = newValue;
        });
      },
      items: variable.genderList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void createUser() {
    if (doValidation()) {
      _loginBloc
          .createUser(
              '+' + widget.selectedCountryCode,
              widget.enteredMobNumber,
              email.text,
              dropDownValue,
              firstName.text,
              '',
              '',
              '',
              File(imageURI.path),
              middleName.text,
              lastName.text)
          .then((onValue) {
        PreferenceUtil.saveInt(CommonConstants.KEY_COUNTRYCODE,
            int.parse(widget.selectedCountryCode));
        PreferenceUtil.saveString(Constants.MOB_NUM, widget.enteredMobNumber)
            .then((onValue) {
          PreferenceUtil.saveString(
                  Constants.COUNTRY_CODE, widget.selectedCountry)
              .then((onValue) {});
        });
        PreferenceUtil.saveString(
            CommonConstants.KEY_COUNTRYNAME, widget.selectedCountry);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return OtpVerifyScreen(
                enteredMobNumber: widget.enteredMobNumber,
                selectedCountryCode: widget.selectedCountryCode,
                fromSignIn: false,
                fromSignUp: true,
                forEmailVerify: false,
              );
            },
          ),
        );
      });
    } else {
      showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text(variable.strAPP_NAME),
                content: new Text(strErrorMsg),
              ));
    }
  }

  bool doValidation() {
    bool isValid = false;

    if (phoneNumber.text == '') {
      isValid = false;
      strErrorMsg = variable.strEnterMobileNum;
    } else if (firstName.text == '') {
      isValid = false;
      strErrorMsg = variable.strEnterFirstname;
    } else if (lastName.text == '') {
      isValid = false;
      strErrorMsg = variable.strEnterLastName;
    } else {
      isValid = true;
    }

    return isValid;
  }

  saveMediaDialog(BuildContext cont) {
    return showDialog<void>(
      context: cont,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: Text(variable.makeAChoice),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(variable.Gallery),
                      onTap: () {
                        Navigator.pop(context);

                        var image = ImagePicker.platform
                            .pickImage(source: ImageSource.gallery);
                        image.then((value) {
                          imageURI = value;

                          (cont as Element).markNeedsBuild();
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    GestureDetector(
                      child: Text(variable.Camera),
                      onTap: () {
                        Navigator.pop(context);

                        var image = ImagePicker.platform
                            .pickImage(source: ImageSource.camera);
                        image.then((value) {
                          imageURI = value;

                          (cont as Element).markNeedsBuild();
                        });
                      },
                    ),
                  ],
                ),
              ));
        });
      },
    );
  }

  Future getImageFromCamera() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    imageURI = image;
  }

  Future getImageFromGallery() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    imageURI = image;
  }
}
