import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/ui/authentication/OtpVerifyScreen.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

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
  final double circleRadius = 100.0;
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
  File imageURI;
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
              icon: Icon(Icons.arrow_back_ios),
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
              // height: MediaQuery.of(context).size.height,
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
                              hintText: 'Mobile Number',
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey[200].withOpacity(0.5)))),
                        ),
                      ),
                      /*   Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: name,
                          decoration: InputDecoration(
                              hintText: 'Name',
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey[200].withOpacity(0.5)))),
                        ),
                      ),*/
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
                              hintText: 'Email address (optional)',
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey[200].withOpacity(0.5)))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
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
                            'Send OTP',
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
                    height: 160.0,
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
                                    ? FileImage(imageURI)
                                    : AssetImage('assets/launcher/myfhb.png')

                                /* NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/a/a0/Bill_Gates_2018.jpg',
                                ) */
                                )),
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
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropDownValue = newValue;
        });
      },
      items: <String>['Male', 'Female', 'Others']
          .map<DropdownMenuItem<String>>((String value) {
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
              imageURI,
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
        /*   Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return OtpVerifyScreen(
                enteredMobNumber: widget.enteredMobNumber,
                selectedCountryCode: widget.selectedCountryCode,
                fromSignIn: false,
              );
            },
          ),
        ); */

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return OtpVerifyScreen(
                enteredMobNumber: widget.enteredMobNumber,
                selectedCountryCode: widget.selectedCountryCode,
                fromSignIn: false,
                forEmailVerify: false,
              );
            },
          ),
        );
      });
    } else {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("MyFHB"),
            content: new Text(strErrorMsg),
          ));
    }
  }

  bool doValidation() {
    bool isValid = false;

    if (phoneNumber.text == '') {
      isValid = false;
      strErrorMsg = 'Enter MobileNumber';
    } /*else if (name.text == '') {
      isValid = false;
      strErrorMsg = 'Enter Name';
    }*/
    else if (firstName.text == '') {
      isValid = false;
      strErrorMsg = 'Enter First Name';
    } /*else if (middleName.text == '') {
      isValid = false;
      strErrorMsg = 'Enter Middle Name';
    } */
    else if (lastName.text == '') {
      isValid = false;
      strErrorMsg = 'Enter LastName';
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
              title: Text('Make a Choice!'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text('Gallery'),
                      onTap: () {
                        Navigator.pop(context);

                        var image =
                            ImagePicker.pickImage(source: ImageSource.gallery);
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
                      child: Text('Camera'),
                      onTap: () {
                        Navigator.pop(context);

                        var image =
                            ImagePicker.pickImage(source: ImageSource.camera);
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
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    imageURI = image;
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageURI = image;
  }
}
