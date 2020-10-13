import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/add_family_user_info/bloc/add_family_user_info_bloc.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';
import 'package:myfhb/src/ui/authentication/OtpVerifyScreen.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  //MyProfileBloc _myProfileBloc;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  FlutterToast toast = new FlutterToast();
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

  var cntrlr_addr_one = TextEditingController(text: '');
  var cntrlr_addr_two = TextEditingController(text: '');
  var cntrlr_addr_city = TextEditingController(text: '');
  var cntrlr_addr_state = TextEditingController(text: '');
  var cntrlr_addr_zip = TextEditingController(text: '');

  @override
  void initState() {
    PreferenceUtil.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffold_state, body: getProfileDetailClone());
  }

  /* Widget getProfileDetailClone() {
    Widget profileWidget;
    MyProfileModel myProfile;
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
      profileWidget = getProfileWidget(myProfile.result);
    } catch (e) {
      profileWidget = getProfileWidget(null);
    }

    return profileWidget;
  } */

  Widget getProfileDetailClone() {
    var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    return FutureBuilder<MyProfileModel>(
      future: addFamilyUserInfoRepository.getMyProfileInfoNew(userid),
      builder: (BuildContext context, AsyncSnapshot<MyProfileModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //* its done with fetching the data from remote
          if (snapshot.hasData && snapshot.data != null) {
            return getProfileWidget(snapshot.data.result);
          } else {
            //todo proper error msg to users
            toast.getToast('something went wrong!', Colors.red);
            return getProfileWidget(null);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //* its fetching the data from remote
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
                ),
                Text(
                  'Hey Please Hangon!\nprofile is loading.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        } else {
          toast.getToast('${snapshot.error.toString()}', Colors.red);
          return getProfileWidget(null);
        }
      },
    );
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
        var bloodGroupSplitName = selectedBloodGroupClone.split('');
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

  Widget getProfileWidget(MyProfileResult data) {
    if (data != null) {
      if (data.userContactCollection3 != null) {
        if (data.userContactCollection3.length > 0) {
          mobile.text = data.userContactCollection3[0].phoneNumber;
        }
      }
      if (data != null) {
        name.text = toBeginningOfSentenceCase(
            data.firstName.toLowerCase() + data.lastName.toLowerCase());
      }
      if (data.userContactCollection3 != null) {
        if (data.userContactCollection3.length > 0) {
          email.text = data.userContactCollection3[0].email;
        }
      }
      if (data.gender != null) {
        gender.text = toBeginningOfSentenceCase(data.gender.toLowerCase());
      }
      if (data.bloodGroup != null) {
        print('current blood group ${data?.bloodGroup}');
        bloodGroupController.text = data?.bloodGroup.split(' ')[0];
        bloodRangeController.text = data?.bloodGroup.split(' ')[1];
        //renameBloodGroup(data.bloodGroup);
      }
      if (data.dateOfBirth != null) {
        dob.text = new FHBUtils().getFormattedDateOnlyNew(data.dateOfBirth);
      }
      if (data != null) {
        firstName.text = data.firstName;
        middleName.text = (data.middleName != null && data.middleName != '')
            ? data.middleName
            : '';
        lastName.text = data.lastName;
      } else {
        firstName.text = data != null ? data.firstName + data.lastName : '';
        middleName.text = '';
        lastName.text = '';
      }

      if (data.userAddressCollection3 != null) {
        if (data.userAddressCollection3.length > 0) {
          cntrlr_addr_one.text = data.userAddressCollection3[0].addressLine1;
          cntrlr_addr_two.text = data.userAddressCollection3[0].addressLine2;
          cntrlr_addr_zip.text = data.userAddressCollection3[0].pincode;
          cntrlr_addr_city.text = data.userAddressCollection3[0].city?.name;
          cntrlr_addr_state.text = data.userAddressCollection3[0].state?.name;
        }
      }
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
                  // ((data.generalInfo.isEmailVerified == null &&
                  //             data.generalInfo.email != '') ||
                  //         (data.generalInfo.isEmailVerified == false &&
                  //             data.generalInfo.email != ''))
                  //     ? GestureDetector(
                  //         child: Padding(
                  //             padding: EdgeInsets.all(10),
                  //             child: Text(Constants.VerifyEmail,
                  //                 style: TextStyle(
                  //                     fontSize: 13.0,
                  //                     fontWeight: FontWeight.w400,
                  //                     color: Color(new CommonUtil()
                  //                         .getMyPrimaryColor())))),
                  //         onTap: () {
                  //           new FHBUtils().check().then((intenet) {
                  //             if (intenet != null && intenet) {
                  //               verifyEmail();
                  //             } else {
                  //               new FHBBasicWidget().showInSnackBar(
                  //                   Constants.STR_NO_CONNECTIVITY,
                  //                   scaffold_state);
                  //             }
                  //           });
                  //         },
                  //       )
                  //     : Text('')
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
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: cntrlr_addr_one,
                  enabled: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: CommonConstants.addr_line_1,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: cntrlr_addr_two,
                  enabled: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: CommonConstants.addr_line_2,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: cntrlr_addr_city,
                  enabled: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: CommonConstants.addr_city,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: cntrlr_addr_state,
                  enabled: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: CommonConstants.addr_state,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: cntrlr_addr_zip,
                  enabled: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: CommonConstants.addr_zip,
                  ),
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
