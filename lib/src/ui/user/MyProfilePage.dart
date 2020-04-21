import 'package:flutter/material.dart';
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

  List<String> bloodGroupArray = [
    'A',
    'B',
    'O',
    'AB',
    'A1',
    'A2',
    'A1B',
    'A2B',
    'Others/ Not Known'
  ];

  List<String> bloodRangeArray = ['+', '-', 'Others/ Not Known'];

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
//      var bloodgroupClone = bloodGroup.split(' ');
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
//      var bloodgroupClone = bloodGroup.split(' ');
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

  /*  Widget getProfileDetail() {
    Widget profileWidget;
    return StreamBuilder<ApiResponse<MyProfile>>(
      stream: _myProfileBloc.myProfileInfoStream,
      builder: (context, AsyncSnapshot<ApiResponse<MyProfile>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              profileWidget = Center(
                  child: SizedBox(
                child: CircularProgressIndicator(),
                width: 30,
                height: 30,
              ));
              break;

            case Status.ERROR:
              profileWidget = Center(
                  child: Text('Oops, something went wrong',
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              profileWidget =
                  getProfileWidget(snapshot.data.data.response.data);
              //getMyFamilyMembers(snapshot.data.data.response.data);
              break;
          }
        } else {
          profileWidget = Container(
            width: 100,
            height: 100,
          );
        }
        return profileWidget;
      },
    );
  } */

  Widget getProfileWidget(MyProfileData data) {
    mobile.text = data.generalInfo.phoneNumber;
    name.text = data.generalInfo.name;
    email.text = data.generalInfo.email;
    gender.text = data.generalInfo.gender;
    renameBloodGroup(data.generalInfo.bloodGroup);
    dob.text = data.generalInfo.dateOfBirth;

    if (data.generalInfo.qualifiedFullName != null) {
      firstName.text = data.generalInfo.qualifiedFullName.firstName;
      middleName.text =
          (data.generalInfo.qualifiedFullName.middleName != null &&
                  data.generalInfo.qualifiedFullName.middleName != '')
              ? data.generalInfo.qualifiedFullName.middleName
              : '';
      lastName.text = data.generalInfo.qualifiedFullName.lastName;
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
                              hintText: 'Blood Range',
                              hintStyle: TextStyle(fontSize: 12),
                              labelText: 'Blood Range'),
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
