import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/common/CommonConstants.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  //MyProfileBloc _myProfileBloc;

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
    var mobile = TextEditingController();
    var name = TextEditingController();
    var email = TextEditingController();
    var gender = TextEditingController();
    var bloodGroup = TextEditingController();
    var dob = TextEditingController();

    var firstName = TextEditingController();
    var middleName = TextEditingController();
    var lastName = TextEditingController();

    mobile.text = data.generalInfo.phoneNumber;
    name.text = data.generalInfo.name;
    email.text = data.generalInfo.email;
    gender.text = data.generalInfo.gender;
    bloodGroup.text = data.generalInfo.bloodGroup;
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
                      hintStyle: TextStyle(fontSize: 12)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: name,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: 'Name', hintStyle: TextStyle(fontSize: 12)),
                ),
              ),
               Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: firstName,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: CommonConstants.firstName,
                      hintStyle: TextStyle(fontSize: 12)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: middleName,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: CommonConstants.middleName,
                      hintStyle: TextStyle(fontSize: 12)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: lastName,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: CommonConstants.lastName,
                      hintStyle: TextStyle(fontSize: 12)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: email,
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    hintStyle: TextStyle(fontSize: 12),
                    //suffix: Text('Tap to verify')
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: gender,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: 'Gender', hintStyle: TextStyle(fontSize: 12)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: bloodGroup,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: 'Blood Group',
                      hintStyle: TextStyle(fontSize: 12)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: dob,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: 'Date of Birth',
                      hintStyle: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ));
  }
}
