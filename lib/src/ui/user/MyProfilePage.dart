import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/add_family_user_info/bloc/add_family_user_info_bloc.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/model/user/MyProfileData.dart';
import 'package:myfhb/src/ui/authentication/OtpVerifyScreen.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;



class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  //MyProfileBloc _myProfileBloc;

  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  var mobile = TextEditingController();
  var name = TextEditingController();
  var email = TextEditingController();
  var gender = TextEditingController();
  var bloodGroupController = TextEditingController();
  var bloodRangeController = TextEditingController();

  var dob = TextEditingController();

  var firstName = TextEditingController();
  var middleName = TextEditingController();
  var lastName = TextEditingController();

  

  @override
  void initState() {
    PreferenceUtil.init();
    super.initState();
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffold_state, body: getProfileDetailClone());
  }

  Widget getProfileDetailClone() {
    Widget profileWidget;

    MyProfile myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
   
    profileWidget = getProfileWidget(myProfile.response.data);

    return profileWidget;
  }

  void renameBloodGroup(String selectedBloodGroupClone) {
    if (selectedBloodGroupClone != null) {
      var bloodGroupSplitName = selectedBloodGroupClone.split('_');

      if (bloodGroupSplitName.length > 1) {
        for (String bloodGroup in variable.bloodGroupArray) {
          if (bloodGroupSplitName[0] == bloodGroup) {
            bloodGroupController.text = bloodGroup;
          }
        }

        for (String bloodRange in variable.bloodRangeArray) {
          if (bloodGroupSplitName[1] == bloodRange) {
            bloodRangeController.text = bloodRange;
          }
        }
      } else {
        var bloodGroupSplitName = selectedBloodGroupClone.split(' ');
        if (bloodGroupSplitName.length > 1) {
          for (String bloodGroup in variable.bloodGroupArray) {
            if (bloodGroupSplitName[0] == bloodGroup) {
              bloodGroupController.text = bloodGroup;
            }

            for (String bloodRange in variable.bloodRangeArray) {
              if (bloodGroupSplitName[1][0] == bloodRange) {
                bloodRangeController.text = bloodRange;
            
              }
            }
          }
        } else {}
      }
    }
  }

  Widget getProfileWidget(MyProfileData data) {
    if (data.generalInfo.phoneNumber != null) {
      mobile.text = data.generalInfo.phoneNumber;
    }
    if (data.generalInfo.name != null) {
      name.text =
          toBeginningOfSentenceCase(data.generalInfo.name.toLowerCase());
    }
    if (data.generalInfo.email != null) {
      email.text = data.generalInfo.email;
    }
    if (data.generalInfo.gender != null) {
      gender.text =
          toBeginningOfSentenceCase(data.generalInfo.gender.toLowerCase());
    }
    if (data.generalInfo.bloodGroup != null) {
      renameBloodGroup(data.generalInfo.bloodGroup);
    }
    if (data.generalInfo.dateOfBirth != null) {
      
      dob.text = new FHBUtils().getFormattedDateOnlyNew(data.generalInfo.dateOfBirth);
    }
    if (data.generalInfo.qualifiedFullName != null) {
      firstName.text = data.generalInfo.qualifiedFullName.firstName;
      middleName.text =
          (data.generalInfo.qualifiedFullName.middleName != null &&
                  data.generalInfo.qualifiedFullName.middleName != '')
              ? data.generalInfo.qualifiedFullName.middleName
              : '';
      lastName.text = data.generalInfo.qualifiedFullName.lastName;
    } else {
      firstName.text =
          data.generalInfo.name != null ? data.generalInfo.name : '';
      middleName.text = '';
      lastName.text = '';
    }

    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: mobile,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: variable.strMobileNum,
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: variable.strMobileNum,
                    ),
                  )),

              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: firstName,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: CommonConstants.firstName,
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: CommonConstants.firstName,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: middleName,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: CommonConstants.middleName,
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: CommonConstants.middleName,
                    ),
                  )),
              // _showMiddleNameTextField(),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: lastName,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: CommonConstants.lastName,
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: CommonConstants.lastName,
                    ),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: email,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: variable.strEmailAddress,
                        hintStyle: TextStyle(fontSize: 12),
                        labelText: variable.strEmailAddress,
                        //suffix: Text('Tap to verify')
                      ),
                    ),
                  ),
                  ((data.generalInfo.isEmailVerified == null &&
                              data.generalInfo.email != '') ||
                          (data.generalInfo.isEmailVerified == false &&
                              data.generalInfo.email != ''))
                      ? GestureDetector(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(Constants.VerifyEmail,
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color(new CommonUtil()
                                          .getMyPrimaryColor())))),
                          onTap: () {
                            new FHBUtils().check().then((intenet) {
                            if (intenet != null && intenet) {
                              verifyEmail();
                            } else {
                              new FHBBasicWidget().showInSnackBar(
                                  Constants.STR_NO_CONNECTIVITY,
                                  scaffold_state);
                            }
                          });
                          },
                        )
                      : Text('')
                ],
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: gender,
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: CommonConstants.gender,
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: CommonConstants.gender,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 40,
                        child: TextField(
                          controller: bloodGroupController,
                          enabled: false,
                          decoration: InputDecoration(
                              hintText: CommonConstants.blood_group,
                              hintStyle: TextStyle(fontSize: 12),
                              labelText: CommonConstants.blood_group),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 40,
                        child: TextField(
                          controller: bloodRangeController,
                          enabled: false,
                          decoration: InputDecoration(
                              hintText: CommonConstants.STR_RHTYPE,
                              hintStyle: TextStyle(fontSize: 12),
                              labelText: CommonConstants.STR_RHTYPE),
                        ),
                      )),
                ],
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: dob,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: CommonConstants.date_of_birth,
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: CommonConstants.date_of_birth),
                ),
              ),
            ],
          ),
        ));
  }

  void verifyEmail() {
    AddFamilyUserInfoBloc addFamilyUserInfoBloc = new AddFamilyUserInfoBloc();
    addFamilyUserInfoBloc.verifyEmail().then((value) {
      if (value.success &&
          value.message.contains(Constants.MSG_VERIFYEMAIL_VERIFIED)) {
        new FHBBasicWidget().showInSnackBar(value.message, scaffold_state);
      } else {
        PreferenceUtil.saveString(Constants.PROFILE_EMAIL, email.text);

        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => OtpVerifyScreen(
                      enteredMobNumber:
                          PreferenceUtil.getStringValue(Constants.MOB_NUM),
                      selectedCountryCode: PreferenceUtil.getIntValue(
                              CommonConstants.KEY_COUNTRYCODE)
                          .toString(),
                      fromSignIn: true,
                      forEmailVerify: true,
                    )))
            .then((value) {});
      }
    });
  }
}
