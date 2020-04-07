import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/add_family_user_info/bloc/add_family_user_info_bloc.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

import '../../common/CommonConstants.dart';

class AddFamilyUserInfoScreen extends StatefulWidget {
  AddFamilyUserInfoArguments arguments;

  AddFamilyUserInfoScreen({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return AddFamilyUserInfoScreenState();
  }
}

class AddFamilyUserInfoScreenState extends State<AddFamilyUserInfoScreen> {
  final mobileNoController = TextEditingController();
  FocusNode mobileNoFocus = FocusNode();

  final nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();

  final relationShipController = TextEditingController();
  FocusNode relationShipFocus = FocusNode();

  final emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();

  final genderController = TextEditingController();
  FocusNode genderFocus = FocusNode();

  final bloodGroupController = TextEditingController();
  FocusNode bloodGroupFocus = FocusNode();

  final dateOfBirthController = TextEditingController();
  FocusNode dateOfBirthFocus = FocusNode();

  AddFamilyUserInfoBloc addFamilyUserInfoBloc;
  bool isCalled = false;
  RelationShipResponseList relationShipResponseList;
  RelationShip selectedRelationShip;

  DateTime dateTime = DateTime.now();
  MyProfile myProfile;

  List<int> fetchedProfileData;

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

  String selectedBloodGroup;
  String selectedBloodRange;

  List<String> genderArray = ['male', 'female', 'others'];
  String selectedGender;

  bool updateProfile = false;
  bool firstTym = true;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final firstNameController = TextEditingController();
  FocusNode firstNameFocus = FocusNode();

  final middleNameController = TextEditingController();
  FocusNode middleNameFocus = FocusNode();

  final lastNameController = TextEditingController();
  FocusNode lastNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    addFamilyUserInfoBloc = new AddFamilyUserInfoBloc();
    addFamilyUserInfoBloc.getCustomRoles().then((value) {
      setState(() {
        relationShipResponseList = value;
      });

      if (widget.arguments.fromClass == CommonConstants.my_family) {
        for (var i = 0; i < value.relationShipAry.length; i++) {
          if (value.relationShipAry[i].roleName ==
              widget.arguments.sharedbyme.linkedData.roleName) {
            selectedRelationShip = value.relationShipAry[i];
          }
        }
      }
    });

    if (widget.arguments.fromClass == CommonConstants.my_family) {
      addFamilyUserInfoBloc.userId = widget.arguments.sharedbyme.profileData
          .id; //widget.arguments.addFamilyUserInfo.id;

      if (widget.arguments.sharedbyme.profileData.isVirtualUser) {
        MyProfile myProf = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
        mobileNoController.text = myProf.response.data.generalInfo.phoneNumber;
        emailController.text = myProf.response.data.generalInfo.email;
      } else {
        mobileNoController.text =
            widget.arguments.sharedbyme.profileData.phoneNumber;
        emailController.text = widget.arguments.sharedbyme.profileData.email;
      }

      firstNameController.text =
          widget.arguments.sharedbyme.profileData.qualifiedFullName.firstName;
      middleNameController.text =
          widget.arguments.sharedbyme.profileData.qualifiedFullName.middleName;
      lastNameController.text =
          widget.arguments.sharedbyme.profileData.qualifiedFullName.lastName;

      if (widget.arguments.sharedbyme.profileData.bloodGroup != null &&
          widget.arguments.sharedbyme.profileData.bloodGroup != "null") {
        selectedBloodGroup = widget.arguments.sharedbyme.profileData.bloodGroup;

        renameBloodGroup(selectedBloodGroup);
      }

      if (widget.arguments.sharedbyme.profileData.gender != null) {
        selectedGender = widget.arguments.sharedbyme.profileData.gender;
      }

      if (widget.arguments.sharedbyme.profileData.dateOfBirth != null) {
        List<String> list = widget.arguments.sharedbyme.profileData.dateOfBirth
            .split("T"); //by space" " the string need to splited

        dateOfBirthController.text = list[0];
      }
    } else if (widget.arguments.fromClass == CommonConstants.user_update) {
      updateProfile = true;
      addFamilyUserInfoBloc.userId = widget.arguments.sharedbyme.profileData
          .id; //widget.arguments.addFamilyUserInfo.id;

      if (widget.arguments.sharedbyme.profileData.isVirtualUser) {
        MyProfile myProf = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
        mobileNoController.text = myProf.response.data.generalInfo.phoneNumber;
        emailController.text = myProf.response.data.generalInfo.email;
      } else {
        mobileNoController.text =
            widget.arguments.sharedbyme.profileData.phoneNumber;
        emailController.text = widget.arguments.sharedbyme.profileData.email;
      }

      nameController.text = widget.arguments.sharedbyme.profileData.name;

      if (widget.arguments.sharedbyme.profileData.bloodGroup != null &&
          widget.arguments.sharedbyme.profileData.bloodGroup != "null") {
        selectedBloodGroup = widget.arguments.sharedbyme.profileData.bloodGroup;

        renameBloodGroup(selectedBloodGroup);
      } else {}

      if (widget.arguments.sharedbyme.profileData.gender != null) {
        selectedGender = widget.arguments.sharedbyme.profileData.gender;
      }

      if (widget.arguments.sharedbyme.profileData.dateOfBirth != null) {
        List<String> list = widget.arguments.sharedbyme.profileData.dateOfBirth
            .split("T"); //by space" " the string need to splited

        dateOfBirthController.text = list[0];
        if (firstTym) {
          firstTym = false;
          setState(() {
            fetchedProfileData = widget
                .arguments.sharedbyme.profileData.profilePicThumbnail.data;
          });
        }
      }
    } else {
      addFamilyUserInfoBloc.userId = widget.arguments.addFamilyUserInfo
          .id; //widget.arguments.addFamilyUserInfo.id;

      addFamilyUserInfoBloc.getMyProfileInfo().then((value) {
        myProfile = value;

        if (widget.arguments.isPrimaryNoSelected) {
          MyProfile myProf =
              PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
          mobileNoController.text =
              myProf.response.data.generalInfo.phoneNumber;
          emailController.text = myProf.response.data.generalInfo.email;
        } else {
          mobileNoController.text = value.response.data.generalInfo.phoneNumber;
          emailController.text = value.response.data.generalInfo.email;
        }

        firstNameController.text = widget.arguments.enteredFirstName;
        middleNameController.text = widget.arguments.enteredMiddleName;
        lastNameController.text = widget.arguments.enteredLastName;

        relationShipController.text = widget.arguments.relationShip.roleName;

        selectedBloodGroup = value.response.data.generalInfo.bloodGroup == null
            ? null
            : value.response.data.generalInfo.bloodGroup;

        selectedGender = value.response.data.generalInfo.gender == null
            ? null
            : value.response.data.generalInfo.gender;
        dateOfBirthController.text =
            value.response.data.generalInfo.dateOfBirth;

        if (firstTym) {
          firstTym = false;
          setState(() {
            fetchedProfileData = widget
                .arguments.sharedbyme.profileData.profilePicThumbnail.data;
          });
        }
      });
    }
  }

  void renameBloodGroup(String selectedBloodGroupClone) {
    var bloodGroupSplitName = selectedBloodGroupClone.split('_');

    for (String bloodGroup in bloodGroupArray) {
//      var bloodgroupClone = bloodGroup.split(' ');
      if (bloodGroupSplitName[0] == bloodGroup) {
        selectedBloodGroup = bloodGroup;
      }
    }

    for (String bloodRange in bloodRangeArray) {
//      var eachBloodGroup;

//      if (bloodGroupSplitName.length > 2) {
//        eachBloodGroup = bloodGroupSplitName[1] +
//            " " +
//            bloodGroupSplitName[2] +
//            " " +
//            bloodGroupSplitName[3];
//      } else {
//        eachBloodGroup = bloodGroupSplitName[1];
//      }

      if (bloodGroupSplitName[1] == bloodRange) {
        selectedBloodRange = bloodRange;
      }
    }
  }

  getUserProfileData() async {
    MyProfileBloc _myProfileBloc = new MyProfileBloc();

    _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      print('Inside getUserProfileData' + profileData.toString());
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
          .then((value) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

        Navigator.popUntil(context, (Route<dynamic> route) {
          bool shouldPop = false;
          if (route.settings.name == '/user_accounts') {
            shouldPop = true;
          }
          return shouldPop;
        });
      });
    });
  }

  /*  getUserProfileData() async {
    MyProfileBloc _myProfileBloc = new MyProfileBloc();

    _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      print('Inside dashboard' + profileData.toString());
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
          .then((value) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

        Navigator.popUntil(context, (Route<dynamic> route) {
          bool shouldPop = false;
          if (route.settings.name == '/user_accounts') {
            shouldPop = true;
          }
          return shouldPop;
        });
      });
    });
  }
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
          child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(
                  arguments: widget.arguments,
                  fromClass: widget.arguments.fromClass,
                  expandedHeight: 200,
                  profileData:
                      (widget.arguments.fromClass == CommonConstants.my_family)
                          ? widget.arguments.sharedbyme.profileData
                                      .profilePicThumbnail !=
                                  null
                              ? widget.arguments.sharedbyme.profileData
                                  .profilePicThumbnail.data
                              : null
                          : fetchedProfileData),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 50),
                  _showMobileNoTextField(),
//                  _showNameTextField(),
                  _showFirstNameTextField(),
                  _showMiddleNameTextField(),
                  _showLastNameTextField(),
                  widget.arguments.fromClass == CommonConstants.my_family
                      ? relationShipResponseList != null
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                getRelationshipDetails(relationShipResponseList)
                              ],
                            )
                          : Container()
                      : widget.arguments.fromClass ==
                              CommonConstants.user_update
                          ? new Container()
                          : _showRelationShipTextField(),
                  _showEmailAddTextField(),
                  Row(
                    children: <Widget>[getGenderDetails()],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[getBloodGroupDetails()],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[getBloodRangeDetails()],
                  ),
                  _showDateOfBirthTextField(),
                  _showSaveButton()
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  // 1
  Widget _showMobileNoTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          enabled: false,
          cursorColor: Theme.of(context).primaryColor,
          controller: mobileNoController,
          maxLines: 1,
          enableInteractiveSelection: false,
          keyboardType: TextInputType.text,
          focusNode: mobileNoFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(nameFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.mobile_number,
            hintText: CommonConstants.mobile_number,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  // 2
  Widget _showNameTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: nameController,
          maxLines: 1,
          enabled: (widget.arguments.fromClass == CommonConstants.my_family ||
                  widget.arguments.fromClass == CommonConstants.user_update)
              ? true
              : false,
          keyboardType: TextInputType.text,
//          focusNode: nameFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(relationShipFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.name,
            hintText: CommonConstants.name,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  // 3
  Widget _showRelationShipTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: relationShipController,
          maxLines: 1,
          enabled: widget.arguments.fromClass == CommonConstants.my_family
              ? true
              : false,
          keyboardType: TextInputType.text,
//          focusNode: relationShipFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(emailFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.relationship,
            hintText: CommonConstants.relationship,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  // 4
  Widget _showEmailAddTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: emailController,
          maxLines: 1,
          enabled: widget.arguments.fromClass == CommonConstants.user_update
              ? true
              : false,
          keyboardType: TextInputType.text,
//          focusNode: emailFocus,
          autofocus: false,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(genderFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.email_address_optional,
            hintText: CommonConstants.email_address_optional,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  // 5
  Widget _showGenderTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: genderController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          focusNode: genderFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(bloodGroupFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.gender,
            hintText: CommonConstants.gender,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  // 6
  Widget _showBloodGroupTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: bloodGroupController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          focusNode: bloodGroupFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(dateOfBirthFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.blood_group,
            hintText: CommonConstants.blood_group,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  // 7
  Widget _showDateOfBirthTextField() {
    return GestureDetector(
      onTap: dateOfBirthTapped,
      child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: TextField(
            cursorColor: Theme.of(context).primaryColor,
            controller: dateOfBirthController,
            maxLines: 1,
            autofocus: false,
            readOnly: true,
            keyboardType: TextInputType.text,
//          focusNode: dateOfBirthFocus,
            textInputAction: TextInputAction.done,
            onSubmitted: (term) {
              dateOfBirthFocus.unfocus();
            },
            style: new TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: ColorUtils.blackcolor),
            decoration: InputDecoration(
              suffixIcon: new IconButton(
                icon: new Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDate(context);
                },
              ),
              labelText: CommonConstants.date_of_birth,
              hintText: CommonConstants.date_of_birth,
              labelStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.myFamilyGreyColor),
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: ColorUtils.myFamilyGreyColor,
                fontWeight: FontWeight.w400,
              ),
              border: new UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
            ),
          )),
    );
  }

  Widget _showSaveButton() {
    final GestureDetector addButtonWithGesture = new GestureDetector(
      onTap: _saveBtnTapped,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            width: 150,
            height: 40.0,
            decoration: new BoxDecoration(
              color: Color(new CommonUtil().getMyPrimaryColor()),
              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color.fromARGB(15, 0, 0, 0),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: new Center(
              child: new Text(
                (widget.arguments.fromClass == CommonConstants.my_family ||
                        widget.arguments.fromClass ==
                            CommonConstants.user_update)
                    ? CommonConstants.update
                    : CommonConstants.save,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: addButtonWithGesture);
  }

  Widget getAllCustomRoles() {
    Widget familyWidget;

    return StreamBuilder<ApiResponse<RelationShipResponseList>>(
      stream: addFamilyUserInfoBloc.relationShipStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<RelationShipResponseList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
//              familyWidget = Center(
//                  child: SizedBox(
//                child: CircularProgressIndicator(),
//                width: 30,
//                height: 30,
//              ));
              break;

            case Status.ERROR:
              familyWidget = Center(
                  child: Text('Oops, something went wrong',
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              isCalled = true;

              relationShipResponseList = snapshot.data.data;

              if (widget.arguments.fromClass == CommonConstants.my_family) {
                for (var i = 0;
                    i < snapshot.data.data.relationShipAry.length;
                    i++) {
                  if (snapshot.data.data.relationShipAry[i].roleName ==
                      widget.arguments.sharedbyme.linkedData.roleName) {
                    selectedRelationShip =
                        snapshot.data.data.relationShipAry[i];
                  }
                }
              }

              familyWidget = getRelationshipDetails(snapshot.data.data);
              break;
          }
        } else {
          familyWidget = Container(
            width: 100,
            height: 100,
          );
          return familyWidget;
        }
      },
    );
  }

  Widget getRelationshipDetails(RelationShipResponseList data) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.relationship),
                value: selectedRelationShip,
                items: data.relationShipAry.map((relationShipDetail) {
                  return DropdownMenuItem(
                    child: new Text(relationShipDetail.roleName,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: ColorUtils.blackcolor)),
                    value: relationShipDetail,
                  );
                }).toList(),
                onChanged: (RelationShip newValue) {
                  setState(() {
                    selectedRelationShip = newValue;
                  });
                },
              )));
    });
  }

  Widget getBloodGroupDetails() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.blood_group),
                value: selectedBloodGroup,
                items: bloodGroupArray.map((eachBloodGroup) {
                  return DropdownMenuItem(
                    child: new Text(eachBloodGroup,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: ColorUtils.blackcolor)),
                    value: eachBloodGroup,
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    selectedBloodGroup = newValue;
                  });
                },
              )));
    });
  }

  Widget getBloodRangeDetails() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.blood_range),
                value: selectedBloodRange,
                items: bloodRangeArray.map((eachBloodGroup) {
                  return DropdownMenuItem(
                    child: new Text(eachBloodGroup,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: ColorUtils.blackcolor)),
                    value: eachBloodGroup,
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    selectedBloodRange = newValue;
                  });
                },
              )));
    });
  }

  Widget getGenderDetails() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.gender),
                value: selectedGender,
                items: genderArray.map((eachGender) {
                  return DropdownMenuItem(
                    child: new Text(eachGender,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: ColorUtils.blackcolor)),
                    value: eachGender,
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
              )));
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1940, 01),
        lastDate: DateTime.now());

    if (picked != null) {
      setState(() {
        dateTime = picked ?? dateTime;
        dateOfBirthController.text =
            FHBUtils().getFormattedDateOnly(dateTime.toString());
      });
    }
  }

  /*  void _saveBtnTapped() {
    addFamilyUserInfoBloc.name = nameController.text;
    addFamilyUserInfoBloc.email = emailController.text;
    addFamilyUserInfoBloc.gender = selectedGender;
    addFamilyUserInfoBloc.dateOfBirth = dateOfBirthController.text;
    addFamilyUserInfoBloc.bloodGroup =
        selectedBloodGroup != null ? selectedBloodGroup : '';

    addFamilyUserInfoBloc.profilePic = MySliverAppBar.imageURI;

    if (widget.arguments.fromClass == CommonConstants.my_family) {
      addFamilyUserInfoBloc.relationship = selectedRelationShip.roleName;
      addFamilyUserInfoBloc.userId = widget.arguments.sharedbyme.profileData.id;
      addFamilyUserInfoBloc.phoneNo =
          widget.arguments.sharedbyme.profileData.phoneNumber;

      if (nameController.text.length > 0 &&
          emailController.text.length > 0 &&
          mobileNoController.text.length > 0 &&
          selectedGender.length > 0 &&
          dateOfBirthController.text.length > 0 &&
          selectedBloodGroup.length > 0 &&
          selectedRelationShip.roleName.length > 0) {
        CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait'); //

        var signInData = {};
        signInData['countryCode'] =
            widget.arguments.sharedbyme.profileData.countryCode;
        signInData['phoneNumber'] =
            widget.arguments.sharedbyme.profileData.phoneNumber;
        signInData['nickName'] = nameController.text;
        signInData['relation'] = selectedRelationShip.id;
        var jsonString = convert.jsonEncode(signInData);

        addFamilyUserInfoBloc.relationshipJsonString = jsonString;

        // 1
        addFamilyUserInfoBloc.updateUserRelationShip().then((value) {
          if (value.success && value.status == 200) {
            // 2
            addFamilyUserInfoBloc.updateUserProfile().then((value) {
              if (value.success && value.status == 200) {
                MySliverAppBar.imageURI = null;
                fetchedProfileData = null;

                Navigator.popUntil(context, (Route<dynamic> route) {
                  bool shouldPop = false;
                  if (route.settings.name == '/user_accounts') {
                    shouldPop = true;
                  }
                  return shouldPop;
                });
              }
            });
          }
        });
      } else {
        Alert.displayAlertPlain(context,
            title: "Error", content: CommonConstants.all_fields);
      }
    } else if (widget.arguments.fromClass == CommonConstants.user_update) {
      addFamilyUserInfoBloc.updateSelfProfile().then((value) {
        if (value.success && value.status == 200) {
          getUserProfileData();
        }
      });
    } else {
      addFamilyUserInfoBloc.userId = widget.arguments.addFamilyUserInfo.id;
      addFamilyUserInfoBloc.phoneNo = mobileNoController.text;
      addFamilyUserInfoBloc.relationship = relationShipController.text;

      if (nameController.text.length > 0 &&
          emailController.text.length > 0 &&
          mobileNoController.text.length > 0 &&
          selectedGender.length > 0 &&
          dateOfBirthController.text.length > 0 &&
          selectedBloodGroup.length > 0 &&
          relationShipController.text.length > 0) {
        CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait'); //

        addFamilyUserInfoBloc.updateUserProfile().then((value) {
          if (value.success && value.status == 200) {
            MySliverAppBar.imageURI = null;
            fetchedProfileData = null;

            Navigator.popUntil(context, (Route<dynamic> route) {
              bool shouldPop = false;
              if (route.settings.name == '/user_accounts') {
                // Hide Loading
//                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
//                    .pop();
                shouldPop = true;
              }
              return shouldPop;
            });
          }
        });
      } else {
        Alert.displayAlertPlain(context,
            title: "Error", content: CommonConstants.all_fields);
      }
    }
  }
 */

  void _saveBtnTapped() {
    addFamilyUserInfoBloc.name = firstNameController.text;
    addFamilyUserInfoBloc.email = emailController.text;
    addFamilyUserInfoBloc.gender = selectedGender;
    addFamilyUserInfoBloc.dateOfBirth = dateOfBirthController.text;

    if (selectedBloodGroup != null && selectedBloodRange != null) {
      addFamilyUserInfoBloc.bloodGroup =
          selectedBloodGroup + '_' + selectedBloodRange;
    }

    addFamilyUserInfoBloc.profilePic = MySliverAppBar.imageURI;

    if (widget.arguments.fromClass == CommonConstants.my_family) {
      addFamilyUserInfoBloc.relationship = selectedRelationShip.roleName;
      addFamilyUserInfoBloc.userId = widget.arguments.sharedbyme.profileData.id;
      addFamilyUserInfoBloc.phoneNo =
          widget.arguments.sharedbyme.profileData.phoneNumber;

      if (firstNameController.text.length > 0 &&
          lastNameController.text.length > 0 &&
          emailController.text.length > 0 &&
          mobileNoController.text.length > 0 &&
          selectedGender.length > 0 &&
          dateOfBirthController.text.length > 0 &&
          selectedBloodGroup.length > 0 &&
          selectedBloodRange.length > 0 &&
          selectedRelationShip.roleName.length > 0) {
        CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait'); //

        var signInData = {};
        signInData['countryCode'] =
            widget.arguments.sharedbyme.profileData.countryCode;
        signInData['phoneNumber'] =
            widget.arguments.sharedbyme.profileData.phoneNumber;
        signInData['firstName'] = firstNameController.text;
        signInData['middleName'] = middleNameController.text.length == 0
            ? ''
            : middleNameController.text;
        signInData['lastName'] = lastNameController.text;
        signInData['relation'] = selectedRelationShip.id;
        var jsonString = convert.jsonEncode(signInData);

        addFamilyUserInfoBloc.relationshipJsonString = jsonString;

        // 1
        addFamilyUserInfoBloc.updateUserRelationShip().then((value) {
          if (value.success && value.status == 200) {
            // 2
            addFamilyUserInfoBloc.updateUserProfile().then((value) {
              if (value.success && value.status == 200) {
                MySliverAppBar.imageURI = null;
                fetchedProfileData = null;

                Navigator.popUntil(context, (Route<dynamic> route) {
                  bool shouldPop = false;
                  if (route.settings.name == '/user_accounts') {
                    shouldPop = true;
                  }
                  return shouldPop;
                });
              }
            });
          }
        });
      } else {
        Alert.displayAlertPlain(context,
            title: "Error", content: CommonConstants.all_fields);
      }
    } else if (widget.arguments.fromClass == CommonConstants.user_update) {
      CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait');

      addFamilyUserInfoBloc.updateSelfProfile().then((value) {
        if (value.success && value.status == 200) {
          getUserProfileData();
        } else {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

          Navigator.popUntil(context, (Route<dynamic> route) {
            bool shouldPop = false;
            if (route.settings.name == '/user_accounts') {
              shouldPop = true;
            }
            return shouldPop;
          });
        }
      });
    } else {
      addFamilyUserInfoBloc.userId = widget.arguments.addFamilyUserInfo.id;
      addFamilyUserInfoBloc.phoneNo = mobileNoController.text;
      addFamilyUserInfoBloc.relationship = relationShipController.text;

      if (firstNameController.text.length > 0 &&
          emailController.text.length > 0 &&
          mobileNoController.text.length > 0 &&
          selectedGender.length > 0 &&
          dateOfBirthController.text.length > 0 &&
          selectedBloodGroup.length > 0 &&
          selectedBloodRange.length > 0 &&
          relationShipController.text.length > 0) {
        CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait'); //

        addFamilyUserInfoBloc.updateUserProfile().then((value) {
          if (value.success && value.status == 200) {
            MySliverAppBar.imageURI = null;
            fetchedProfileData = null;

            Navigator.popUntil(context, (Route<dynamic> route) {
              bool shouldPop = false;
              if (route.settings.name == '/user_accounts') {
                // Hide Loading
//                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
//                    .pop();
                shouldPop = true;
              }
              return shouldPop;
            });
          }
        });
      } else {
        Alert.displayAlertPlain(context,
            title: "Error", content: CommonConstants.all_fields);
      }
    }
  }

  void dateOfBirthTapped() {
    _selectDate(context);
  }

  Widget _showFirstNameTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: firstNameController,
          maxLines: 1,
          enabled: (widget.arguments.fromClass == CommonConstants.my_family ||
                  widget.arguments.fromClass == CommonConstants.user_update)
              ? true
              : false,
          keyboardType: TextInputType.text,
//          focusNode: nameFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(middleNameFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.firstName,
            hintText: CommonConstants.firstName,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  Widget _showMiddleNameTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: middleNameController,
          maxLines: 1,
          enabled: (widget.arguments.fromClass == CommonConstants.my_family ||
                  widget.arguments.fromClass == CommonConstants.user_update)
              ? true
              : false,
          keyboardType: TextInputType.text,
//          focusNode: nameFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(lastNameFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.middleName,
            hintText: CommonConstants.middleName,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  Widget _showLastNameTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: lastNameController,
          maxLines: 1,
          enabled: (widget.arguments.fromClass == CommonConstants.my_family ||
                  widget.arguments.fromClass == CommonConstants.user_update)
              ? true
              : false,
          keyboardType: TextInputType.text,
//          focusNode: nameFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(relationShipFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.lastName,
            hintText: CommonConstants.lastName,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  static File imageURI;
  List<int> profileData;

  final AddFamilyUserInfoArguments arguments;
  final String fromClass;

  MySliverAppBar(
      {@required this.expandedHeight,
      this.profileData,
      this.fromClass,
      this.arguments});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        CachedNetworkImage(
            imageUrl: Constants.BASEURL_COVERIMAGE, fit: BoxFit.cover),
        /*  Image.network(
          "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          fit: BoxFit.cover,
        ), */

        Positioned(
          left: 25,
          top: 25,
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: ClipOval(
              child:
                  /*  Image.network(
              "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
              fit: BoxFit.cover, 
                  CachedNetworkImage(
                imageUrl: Constants.BASEURL_COVERIMAGE,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              )*/
                  Container(
                color: Colors.white,
                height: 50,
                width: 50,
              ),
            ),
          ),
        ),
        Positioned(
          top: (expandedHeight - 50) - shrinkOffset,
          left: 24, //MediaQuery.of(context).size.width / 4,
          child: InkWell(
              onTap: () {
                saveMediaDialog(context);
              },
              child: Opacity(
                opacity: (1 - shrinkOffset / expandedHeight),
                child: ClipOval(
                    child: profileData != null && imageURI == null
                        ? Image.memory(Uint8List.fromList(profileData),
                            fit: BoxFit.cover, width: 100, height: 100)
                        : imageURI == null
                            ? Container(
                                width: 100,
                                height: 100,
                                color: ColorUtils.lightPrimaryColor,
                              )
                            : Image.file(imageURI,
                                width: 100, height: 100, fit: BoxFit.cover)),
              )),
        ),
      ],
    );
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

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
