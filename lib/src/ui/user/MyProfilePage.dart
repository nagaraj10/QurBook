import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/add_family_user_info/bloc/add_family_user_info_bloc.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/ui/authentication/OtpVerifyScreen.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  //MyProfileBloc _myProfileBloc;

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

  List<String> bloodGroupArray = ['A', 'B', 'O', 'Others/ Not Known'];

  List<String> bloodRangeArray = ['+ ve', '- ve', 'Others/ Not Known'];

  @override
  void initState() {
    PreferenceUtil.init();
    super.initState();
    /* _myProfileBloc = new MyProfileBloc();
    _myProfileBloc.getMyProfileData().then((profileData) {
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData); 
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return getProfileDetailClone();
  }

  Widget getProfileDetailClone() {
    Widget profileWidget;

    MyProfile myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    print('profile data :${myProfile.response.data}');

    profileWidget = getProfileWidget(myProfile.response.data);

    return profileWidget;
  }

  void renameBloodGroup(String selectedBloodGroupClone) {
    print('selectedBloodGroupClone renameBloodGroup' + selectedBloodGroupClone);
    if (selectedBloodGroupClone != null) {
      var bloodGroupSplitName = selectedBloodGroupClone.split('_');

      if (bloodGroupSplitName.length > 1) {
        for (String bloodGroup in bloodGroupArray) {
          if (bloodGroupSplitName[0] == bloodGroup) {
            bloodGroupController.text = bloodGroup;
          }
        }

        for (String bloodRange in bloodRangeArray) {
          if (bloodGroupSplitName[1] == bloodRange) {
            bloodRangeController.text = bloodRange;
          }
        }
      } else {
        var bloodGroupSplitName = selectedBloodGroupClone.split(' ');
        if (bloodGroupSplitName.length > 1) {
          for (String bloodGroup in bloodGroupArray) {
            if (bloodGroupSplitName[0] == bloodGroup) {
              bloodGroupController.text = bloodGroup;
            }

            for (String bloodRange in bloodRangeArray) {
              if (bloodGroupSplitName[1][0] == bloodRange) {
                bloodRangeController.text = bloodRange;
                if (!bloodRangeController.text.contains('ve')) {
                  bloodRangeController.text = bloodRange + ' ve';
                }
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
      dob.text = data.generalInfo.dateOfBirth;
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
                      hintText: 'MobileNumber',
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: 'MobileNumber',
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
                        hintText: 'Email Address',
                        hintStyle: TextStyle(fontSize: 12),
                        labelText: 'Email Address',
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
                              child: Text('Tap to verify Email address',
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color(new CommonUtil()
                                          .getMyPrimaryColor())))),
                          onTap: () {
                            verifyEmail();
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
                    hintText: 'Gender',
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: 'Gender',
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
                              hintText: 'Blood Group',
                              hintStyle: TextStyle(fontSize: 12),
                              labelText: 'Blood Group'),
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
                              hintText: 'Rh type',
                              hintStyle: TextStyle(fontSize: 12),
                              labelText: 'Rh type'),
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
                      hintText: 'Date of Birth',
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: 'Date of Birth'),
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
      } else {
        PreferenceUtil.saveString(Constants.PROFILE_EMAIL, email.text);
        print(PreferenceUtil.getStringValue(Constants.MOB_NUM) + " NUMBER");

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
