import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_user_info/bloc/add_family_user_info_bloc.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/RelationShip.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/my_providers/models/ProfilePicThumbnail.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/authentication/OtpVerifyScreen.dart';
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
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
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
  List<RelationShip> relationShipResponseList;
  RelationShip selectedRelationShip;

  DateTime dateTime = DateTime.now();
  MyProfile myProfile;

  List<int> fetchedProfileData;

  String selectedBloodGroup;
  String selectedBloodRange;

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

  var cntrlr_addr_one = TextEditingController();
  var cntrlr_addr_two = TextEditingController();
  var cntrlr_addr_city = TextEditingController();
  var cntrlr_addr_state = TextEditingController();
  var cntrlr_addr_zip = TextEditingController();

  String strErrorMsg = '';
  CommonUtil commonUtil = new CommonUtil();

  String dateofBirthStr;
  File imageURI;

  final double circleRadius = 100.0;
  final double circleBorderWidth = 2.0;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    PaintingBinding.instance.imageCache.clear();

    addFamilyUserInfoBloc = new AddFamilyUserInfoBloc();

    if (PreferenceUtil.getFamilyRelationship(Constants.KEY_FAMILYREL) != null) {
      setState(() {
        relationShipResponseList =
            PreferenceUtil.getFamilyRelationship(Constants.KEY_FAMILYREL);
        getSelectedRelation();
      });
    } else {
      addFamilyUserInfoBloc.getCustomRoles().then((value) {
        setState(() {
          relationShipResponseList = value.relationShipAry;

          PreferenceUtil.saveRelationshipArray(
              Constants.KEY_FAMILYREL, value.relationShipAry);
          getSelectedRelation();
        });
      });
    }

    if (widget.arguments.fromClass == CommonConstants.my_family) {
      for (var i = 0; i < relationShipResponseList.length; i++) {
        if (relationShipResponseList[i].roleName ==
            widget.arguments.sharedbyme.linkedData.roleName) {
          selectedRelationShip = relationShipResponseList[i];
        }
      }
    }
    String profilebanner =
        PreferenceUtil.getStringValue(Constants.KEY_PROFILE_BANNER);
    if (profilebanner != null) {
      MySliverAppBar.imageURIProfile = File(profilebanner);
    }

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

      if (widget.arguments.sharedbyme.profileData.qualifiedFullName != null) {
        firstNameController.text = widget.arguments.sharedbyme.profileData
                    .qualifiedFullName.firstName !=
                null
            ? widget
                .arguments.sharedbyme.profileData.qualifiedFullName.firstName
            : '';
        middleNameController.text = widget.arguments.sharedbyme.profileData
                    .qualifiedFullName.middleName !=
                null
            ? widget
                .arguments.sharedbyme.profileData.qualifiedFullName.middleName
            : '';
        lastNameController.text = widget.arguments.sharedbyme.profileData
                    .qualifiedFullName.lastName !=
                null
            ? widget.arguments.sharedbyme.profileData.qualifiedFullName.lastName
            : '';
      } else {
        firstNameController.text = '';
      }
      if (commonUtil.checkIfStringisNull(
          widget.arguments.sharedbyme.profileData.bloodGroup)) {
        selectedBloodGroup = widget.arguments.sharedbyme.profileData.bloodGroup;

        renameBloodGroup(selectedBloodGroup);
      } else {
        selectedBloodGroup = null;
        selectedBloodRange = null;
      }

      if (widget.arguments.sharedbyme.profileData.gender != null) {
        selectedGender = widget.arguments.sharedbyme.profileData.gender;
      }

      if (widget.arguments.sharedbyme.profileData.dateOfBirth != null) {
        dateofBirthStr = new FHBUtils().getFormattedDateForUserBirth(
            widget.arguments.sharedbyme.profileData.dateOfBirth);
        dateOfBirthController.text = new FHBUtils().getFormattedDateOnlyNew(
            widget.arguments.sharedbyme.profileData.dateOfBirth);
      }
    } else if (widget.arguments.fromClass == CommonConstants.user_update) {
      updateProfile = true;
      addFamilyUserInfoBloc.userId = widget.arguments.sharedbyme.profileData
          .id; //widget.arguments.addFamilyUserInfo.id;

      if (widget.arguments.sharedbyme.profileData.isVirtualUser != null) {
        MyProfile myProf = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
        mobileNoController.text = myProf.response.data.generalInfo.phoneNumber;
        emailController.text = myProf.response.data.generalInfo.email;
      } else {
        mobileNoController.text =
            widget.arguments.sharedbyme.profileData.phoneNumber;
        emailController.text = widget.arguments.sharedbyme.profileData.email;
      }
      if (widget.arguments.sharedbyme.profileData.qualifiedFullName != null) {
        firstNameController.text = widget.arguments.sharedbyme.profileData
                    .qualifiedFullName.firstName !=
                null
            ? widget
                .arguments.sharedbyme.profileData.qualifiedFullName.firstName
            : '';
        middleNameController.text = widget.arguments.sharedbyme.profileData
                    .qualifiedFullName.middleName !=
                null
            ? widget
                .arguments.sharedbyme.profileData.qualifiedFullName.middleName
            : '';
        lastNameController.text = widget.arguments.sharedbyme.profileData
                    .qualifiedFullName.lastName !=
                null
            ? widget.arguments.sharedbyme.profileData.qualifiedFullName.lastName
            : '';
      }

      if (commonUtil.checkIfStringisNull(
          widget.arguments.sharedbyme.profileData.bloodGroup)) {
        selectedBloodGroup = widget.arguments.sharedbyme.profileData.bloodGroup;

        renameBloodGroup(selectedBloodGroup);
      } else {
        selectedBloodGroup = null;
        selectedBloodRange = null;
      }

      if (widget.arguments.sharedbyme.profileData.gender != null) {
        selectedGender = widget.arguments.sharedbyme.profileData.gender;
      }

      if (widget.arguments.sharedbyme.profileData.dateOfBirth != null) {
        List<String> list = widget.arguments.sharedbyme.profileData.dateOfBirth
            .split("T"); //by space" " the string need to splited

        // dateOfBirthController.text = list[0];
        dateofBirthStr = new FHBUtils().getFormattedDateForUserBirth(
            widget.arguments.sharedbyme.profileData.dateOfBirth);
        dateOfBirthController.text = new FHBUtils().getFormattedDateOnlyNew(
            widget.arguments.sharedbyme.profileData.dateOfBirth);
      }
      if (firstTym) {
        firstTym = false;
        setState(() {
          fetchedProfileData = widget
                      .arguments.sharedbyme.profileData.profilePicThumbnail !=
                  null
              ? widget.arguments.sharedbyme.profileData.profilePicThumbnail.data
              : null;
        });
      }
    } else {
      addFamilyUserInfoBloc.userId = widget.arguments.addFamilyUserInfo.id;
      addFamilyUserInfoBloc.getMyProfileInfo().then((value) {
        myProfile = value;

        if (widget.arguments.isPrimaryNoSelected) {
          MyProfile myProf =
              PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
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

        if (commonUtil
            .checkIfStringisNull(value.response.data.generalInfo.bloodGroup)) {
          selectedBloodGroup = value.response.data.generalInfo.bloodGroup;

          renameBloodGroup(selectedBloodGroup);
        } else {
          selectedBloodGroup = null;
          selectedBloodRange = null;
        }
        selectedGender = value.response.data.generalInfo.gender == null
            ? null
            : value.response.data.generalInfo.gender;

        dateofBirthStr = value.response.data.generalInfo.dateOfBirth != null
            ? new FHBUtils().getFormattedDateForUserBirth(
                value.response.data.generalInfo.dateOfBirth)
            : '';
        dateOfBirthController.text =
            value.response.data.generalInfo.dateOfBirth != null
                ? new FHBUtils().getFormattedDateOnlyNew(
                    value.response.data.generalInfo.dateOfBirth)
                : '';

        if (firstTym) {
          firstTym = false;
          setState(() {
            if (widget.arguments.sharedbyme != null) {
              if (widget.arguments.sharedbyme.profileData != null) {
                fetchedProfileData = widget
                    .arguments.sharedbyme.profileData.profilePicThumbnail.data;
              }
            }
          });
        }
      });
    }
  }

  void renameBloodGroup(String selectedBloodGroupClone) {
    if (selectedBloodGroupClone != null) {
      var bloodGroupSplitName = selectedBloodGroupClone.split('_');
      try {
        if (bloodGroupSplitName.length > 1) {
          for (String bloodGroup in variable.bloodGroupArray) {
            if (bloodGroupSplitName[0] == bloodGroup) {
              selectedBloodGroup = bloodGroup;
            }
          }

          for (String bloodRange in variable.bloodRangeArray) {
            if (bloodGroupSplitName[1] == bloodRange) {
              selectedBloodRange = bloodRange;
            }
          }
        } else {
          var bloodGroupSplitName = selectedBloodGroupClone.split(' ');
          if (bloodGroupSplitName.length > 1) {
            for (String bloodGroup in variable.bloodGroupArray) {
              if (bloodGroupSplitName[0] == bloodGroup) {
                selectedBloodGroup = bloodGroup;
              }

              for (String bloodRange in variable.bloodRangeArray) {
                if (bloodGroupSplitName[1] == bloodRange) {
                  selectedBloodRange = bloodRange;
                }
              }
            }
          } else {
            selectedBloodGroup = null;
            selectedBloodRange = null;
          }
        }
      } catch (e) {
        selectedBloodGroup = null;
        selectedBloodRange = null;
      }
    }
  }

  getUserProfileData() async {
    MyProfileBloc _myProfileBloc = new MyProfileBloc();
    FamilyListBloc _familyListBloc = new FamilyListBloc();

    _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
          .then((value) {
        _familyListBloc.getFamilyMembersList().then((value) {
          PreferenceUtil.saveFamilyData(
                  Constants.KEY_FAMILYMEMBER, value.response.data)
              .then((value) {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            Navigator.popUntil(context, (Route<dynamic> route) {
              bool shouldPop = false;
              if (route.settings.name == router.rt_UserAccounts) {
                shouldPop = true;
              }
              return shouldPop;
            });
          });
        });
      });
    });
  }

  Widget showProfileImage() {
    if (widget.arguments.fromClass == CommonConstants.add_family) {
      return imageURI != null
          ? Container(
              decoration: imageURI != null
                  ? BoxDecoration(
                      image: DecorationImage(
                          image: new FileImage(imageURI), fit: BoxFit.cover))
                  : BoxDecoration(color: Colors.white))
          : Center(
              child: Text(
                widget.arguments.enteredFirstName != null
                    ? widget.arguments.enteredFirstName[0].toUpperCase()
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
    } else {
      if (imageURI == null) {
        if (widget.arguments.sharedbyme.profileData.profilePicThumbnailURL !=
            null) {
          return Image.network(
            widget.arguments.sharedbyme.profileData.profilePicThumbnailURL,
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          );
        } else {
          return Center(
            child: Text(
              widget.arguments.sharedbyme.profileData.qualifiedFullName
                          .firstName !=
                      null
                  ? widget.arguments.sharedbyme.profileData.qualifiedFullName
                      .firstName[0]
                      .toUpperCase()
                  : '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          );
        }
      } else {
        return Container(
            decoration: imageURI != null
                ? BoxDecoration(
                    image: DecorationImage(
                        image: new FileImage(imageURI), fit: BoxFit.cover))
                : BoxDecoration(color: Colors.white));
      }
    }
  }

  Widget getProfilePicWidget(ProfilePicThumbnail profilePicThumbnail) {
    return profilePicThumbnail != null
        ? Image.memory(
            Uint8List.fromList(profilePicThumbnail.data),
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          )
        : Container(
            color: Color(fhbColors.bgColorContainer),
            height: 30,
            width: 30,
          );
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
                      child: Text(variable.Camera),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      key: scaffold_state,
      body: SingleChildScrollView(
        child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.topCenter,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: circleRadius / 2.0),
                          child: Container(
                            color: Color(new CommonUtil().getMyPrimaryColor()),
                            height: 160.0,
                            child: Stack(
                                fit: StackFit.expand,
                                overflow: Overflow.visible,
                                children: [
                                  Container(
                                    color: Colors.black.withOpacity(0.2),
                                  )
                                ]),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Container(
                              width: circleRadius,
                              height: circleRadius,
                              decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  color: Color(
                                      new CommonUtil().getMyPrimaryColor())),
                              child: Padding(
                                padding: EdgeInsets.all(circleBorderWidth),
                                child: InkWell(
                                  child: ClipOval(child: showProfileImage()),
                                  onTap: () {
                                    saveMediaDialog(context);
                                  },
                                ),
                              ),
                            )),
                      ],
                    ),
                    _showMobileNoTextField(),
                    _showFirstNameTextField(),
                    _showMiddleNameTextField(),
                    _showLastNameTextField(),
                    widget.arguments.fromClass == CommonConstants.my_family
                        ? relationShipResponseList != null
                            ? Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  getRelationshipDetails(
                                      relationShipResponseList)
                                ],
                              )
                            : getAllCustomRoles()
                        : widget.arguments.fromClass ==
                                CommonConstants.user_update
                            ? new Container()
                            : _showRelationShipTextField(),
                    _showEmailAddTextField(),
                    Row(
                      children: <Widget>[getGenderDetails()],
                    ),
                    Row(
                      children: <Widget>[
                        getBloodGroupDetails(),
                        getBloodRangeDetails()
                      ],
                    ),
                    _showDateOfBirthTextField(),
                    _userAddressInfo(),
                    _showSaveButton()
                  ])
            ]),
      ),
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
            labelText: CommonConstants.mobile_numberWithStar,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
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
          ),
          // widget.arguments.fromClass == CommonConstants.user_update
          //     ? ((widget.arguments.sharedbyme.profileData.isEmailVerified ==
          //                     null &&
          //                 widget.arguments.sharedbyme.profileData.email !=
          //                     '') ||
          //             (widget.arguments.sharedbyme.profileData
          //                         .isEmailVerified ==
          //                     false &&
          //                 widget.arguments.sharedbyme.profileData.email != ''))
          //         ? GestureDetector(
          //             child: Text(variable.VerifyEmail,
          //                 style: TextStyle(
          //                     fontSize: 13.0,
          //                     fontWeight: FontWeight.w400,
          //                     color:
          //                         Color(new CommonUtil().getMyPrimaryColor()))),
          //             onTap: () {
          //               new FHBUtils().check().then((intenet) {
          //                 if (intenet != null && intenet) {
          //                   verifyEmail();
          //                 } else {
          //                   new FHBBasicWidget().showInSnackBar(
          //                       Constants.STR_NO_CONNECTIVITY, scaffold_state);
          //                 }
          //               });
          //             },
          //           )
          //         : Text('')
          //     : Text('')
        ],
      ),
    );
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
              labelText: CommonConstants.date_of_birthWithStar,
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

  Widget _userAddressInfo() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              controller: cntrlr_addr_one,
              enabled: true,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 12),
                labelText: CommonConstants.addr_line_1,
              ),
              validator: (res) {
                return (res.isEmpty || res == null)
                    ? 'Address line1 can\'t be empty'
                    : null;
              },
            ),
            TextFormField(
              controller: cntrlr_addr_two,
              enabled: true,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 12),
                labelText: CommonConstants.addr_line_2,
              ),
            ),
            TextFormField(
              controller: cntrlr_addr_city,
              enabled: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 12),
                labelText: CommonConstants.addr_city,
              ),
              validator: (res) {
                return (res.isEmpty || res == null)
                    ? 'City can\'t be empty'
                    : null;
              },
            ),
            TextFormField(
              controller: cntrlr_addr_state,
              enabled: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 12),
                labelText: CommonConstants.addr_state,
              ),
              validator: (res) {
                return (res.isEmpty || res == null)
                    ? 'State can\'t be empty'
                    : null;
              },
            ),
            TextFormField(
              controller: cntrlr_addr_zip,
              enabled: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 12),
                labelText: CommonConstants.addr_zip,
              ),
              validator: (res) {
                return (res.isEmpty || res == null)
                    ? 'Zip can\'t be empty'
                    : null;
              },
            ),
          ],
        ),
      ),
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
              break;

            case Status.ERROR:
              familyWidget = Center(
                  child: Text(Constants.STR_ERROR_LOADING_DATA,
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              isCalled = true;

              relationShipResponseList = snapshot.data.data.relationShipAry;

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

              familyWidget =
                  getRelationshipDetails(snapshot.data.data.relationShipAry);
              break;
          }
        } else {
          familyWidget = Container(
            width: 100,
            height: 100,
          );
        }

        return familyWidget;
      },
    );
  }

  Widget getRelationshipDetails(List<RelationShip> data) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.relationship),
                value:
                    selectedRelationShip != null ? selectedRelationShip : null,
                items: data.map((relationShipDetail) {
                  return DropdownMenuItem(
                    child: new Text(relationShipDetail.roleName,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: ColorUtils.blackcolor)),
                    value:
                        relationShipDetail != null ? relationShipDetail : null,
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
              width: MediaQuery.of(context).size.width / 2 - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.blood_groupWithStar),
                value: selectedBloodGroup,
                items: variable.bloodGroupArray.map((eachBloodGroup) {
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
              width: MediaQuery.of(context).size.width / 2 - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.blood_rangeWithStar),
                value: selectedBloodRange,
                items: variable.bloodRangeArray.map((eachBloodGroup) {
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
                hint: Text(CommonConstants.genderWithStar),
                value: selectedGender != null
                    ? selectedGender.toLowerCase() != null
                        ? toBeginningOfSentenceCase(
                            selectedGender.toLowerCase())
                        : selectedGender
                    : selectedGender,
                items: variable.genderArray.map((eachGender) {
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

        dateofBirthStr =
            new FHBUtils().getFormattedDateForUserBirth(dateTime.toString());
        dateOfBirthController.text =
            new FHBUtils().getFormattedDateOnlyNew(dateTime.toString());
      });
    }
  }

  void _saveBtnTapped() {
    new FHBUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        //address fields validation
        if (_formkey.currentState.validate()) {
          addFamilyUserInfoBloc.name = firstNameController.text;
          addFamilyUserInfoBloc.email = emailController.text;
          addFamilyUserInfoBloc.gender =
              toBeginningOfSentenceCase(selectedGender.toLowerCase());
          addFamilyUserInfoBloc.dateOfBirth = dateofBirthStr;

          if (selectedBloodGroup != null && selectedBloodRange != null) {
            addFamilyUserInfoBloc.bloodGroup =
                selectedBloodGroup + ' ' + selectedBloodRange;
          }

          addFamilyUserInfoBloc.profilePic = imageURI;

          addFamilyUserInfoBloc.firstName = firstNameController.text;
          addFamilyUserInfoBloc.middleName = middleNameController.text;
          addFamilyUserInfoBloc.lastName = lastNameController.text;

          addFamilyUserInfoBloc.profileBanner = MySliverAppBar.imageURIProfile;

          FamilyListBloc _familyListBloc = new FamilyListBloc();

          if (widget.arguments.fromClass == CommonConstants.my_family) {
            addFamilyUserInfoBloc.relationship = selectedRelationShip.roleName;
            addFamilyUserInfoBloc.userId =
                widget.arguments.sharedbyme.profileData.id;
            addFamilyUserInfoBloc.phoneNo = mobileNoController.text;

            if (doValidation()) {
              if (addFamilyUserInfoBloc.profileBanner != null) {
                PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
                    addFamilyUserInfoBloc.profileBanner.path);
              }
              CommonUtil.showLoadingDialog(
                  context, _keyLoader, variable.Please_Wait); //

              var signInData = {};
              signInData[variable.strCountryCode] =
                  widget.arguments.sharedbyme.profileData.countryCode;
              signInData[variable.strPhoneNumber] = mobileNoController.text;
              signInData[variable.strFirstName] = firstNameController.text;
              signInData[variable.strMiddleName] =
                  middleNameController.text.length == 0
                      ? ''
                      : middleNameController.text;
              signInData[variable.strLastName] = lastNameController.text;
              signInData[variable.strRelation] = selectedRelationShip.id;
              var jsonString = convert.jsonEncode(signInData);
              print(jsonString);

              addFamilyUserInfoBloc.relationshipJsonString = jsonString;

              // 1
              addFamilyUserInfoBloc.updateUserRelationShip().then((value) {
                if (value.success && value.status == 200) {
                  // 2
                  addFamilyUserInfoBloc.updateUserProfile().then((value) {
                    if (value.success && value.status == 200) {
                      _familyListBloc.getFamilyMembersList().then((value) {
                        PreferenceUtil.saveFamilyData(
                                Constants.KEY_FAMILYMEMBER, value.response.data)
                            .then((value) {
                          //saveProfileImage();
                          MySliverAppBar.imageURI = null;
                          fetchedProfileData = null;
                          imageURI = null;

                          Navigator.popUntil(context, (Route<dynamic> route) {
                            bool shouldPop = false;
                            if (route.settings.name == router.rt_UserAccounts) {
                              shouldPop = true;
                            }
                            return shouldPop;
                          });
                        });
                      });
                    }
                  });
                }
              });
            } else {
              Alert.displayAlertPlain(context,
                  title: variable.strError,
                  content: CommonConstants.all_fields_mandatory);
            }
          } else if (widget.arguments.fromClass ==
              CommonConstants.user_update) {
            if (doValidation()) {
              CommonUtil.showLoadingDialog(
                  context, _keyLoader, variable.Please_Wait);

              addFamilyUserInfoBloc.updateSelfProfile().then((value) {
                if (value != null && value.success && value.status == 200) {
                  saveProfileImage();
                  getUserProfileData();
                } else {
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                      .pop();

                  Navigator.popUntil(context, (Route<dynamic> route) {
                    bool shouldPop = false;
                    if (route.settings.name == router.rt_UserAccounts) {
                      shouldPop = true;
                    }
                    return shouldPop;
                  });
                }
              });
            } else {
              showDialog(
                  context: context,
                  child: new AlertDialog(
                    title: new Text(variable.strAPP_NAME),
                    content: new Text(strErrorMsg),
                  ));
            }
          } else {
            addFamilyUserInfoBloc.userId =
                widget.arguments.addFamilyUserInfo.id;
            addFamilyUserInfoBloc.phoneNo = mobileNoController.text;
            addFamilyUserInfoBloc.relationship = relationShipController.text;

            if (doValidation()) {
              if (addFamilyUserInfoBloc.profileBanner != null) {
                PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
                    addFamilyUserInfoBloc.profileBanner.path);
              }
              CommonUtil.showLoadingDialog(
                  context, _keyLoader, variable.Please_Wait); //

              addFamilyUserInfoBloc.updateUserProfile().then((value) {
                if (value.success && value.status == 200) {
                  _familyListBloc.getFamilyMembersList().then((value) {
                    PreferenceUtil.saveFamilyData(
                            Constants.KEY_FAMILYMEMBER, value.response.data)
                        .then((value) {
                      //saveProfileImage();
                      MySliverAppBar.imageURI = null;
                      fetchedProfileData = null;
                      imageURI = null;

                      Navigator.popUntil(context, (Route<dynamic> route) {
                        bool shouldPop = false;
                        if (route.settings.name == router.rt_UserAccounts) {
                          shouldPop = true;
                        }
                        return shouldPop;
                      });
                    });
                  });
                }
              });
            } else {
              Alert.displayAlertPlain(context,
                  title: variable.Error,
                  content: CommonConstants.all_fields_mandatory);
            }
          }
        }
      } else {
        new FHBBasicWidget()
            .showInSnackBar(Constants.STR_NO_CONNECTIVITY, scaffold_state);
      }
    });
  }

  void saveProfileImage() async {
    if (addFamilyUserInfoBloc.profileBanner != null) {
      await PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
          addFamilyUserInfoBloc.profileBanner.path);
    }
    if (addFamilyUserInfoBloc.profilePic != null) {
      await PreferenceUtil.saveString(
          Constants.KEY_PROFILE_IMAGE, addFamilyUserInfoBloc.profilePic.path);
    }
  }

  bool doValidation() {
    bool isValid = false;

    if (firstNameController.text == '') {
      isValid = false;
      strErrorMsg = variable.enterFirstName;
    } else if (lastNameController.text == '') {
      isValid = false;
      strErrorMsg = variable.enterLastName;
    } else if (selectedGender.length == 0) {
      isValid = false;
      strErrorMsg = variable.selectGender;
    } else if (dateOfBirthController.text.length == 0) {
      isValid = false;
      strErrorMsg = variable.selectDOB;
    } else {
      isValid = true;
    }

    if (selectedBloodGroup != null) {
      if (selectedBloodRange == null) {
        isValid = false;
        strErrorMsg = variable.selectRHType;
      } else {
        addFamilyUserInfoBloc.bloodGroup =
            selectedBloodGroup + '_' + selectedBloodRange;
      }
    } else {
      isValid = false;
      strErrorMsg = variable.selectBloodGroup;
    }

    return isValid;
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
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(middleNameFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.firstNameWithStar,
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
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(relationShipFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.lastNameWithStar,
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

  void verifyEmail() {
    addFamilyUserInfoBloc.verifyEmail().then((value) {
      if (value.success &&
          value.message.contains(Constants.MSG_VERIFYEMAIL_VERIFIED)) {
        new FHBBasicWidget().showInSnackBar(value.message, scaffold_state);
      } else {
        PreferenceUtil.saveString(
            Constants.PROFILE_EMAIL, emailController.text);

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
            .then((value) {
          Navigator.popUntil(context, (Route<dynamic> route) {
            bool shouldPop = false;
            if (route.settings.name == router.rt_UserAccounts) {
              shouldPop = true;
            }
            return shouldPop;
          });
        });
      }
    });
  }

  void getSelectedRelation() {
    if (widget.arguments.fromClass == CommonConstants.my_family) {
      for (var i = 0; i < relationShipResponseList.length; i++) {
        if (relationShipResponseList[i].roleName ==
            widget.arguments.sharedbyme.linkedData.roleName) {
          selectedRelationShip = relationShipResponseList[i];
        }
      }
    }
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  static File imageURI;
  static File imageURIProfile;

  List<int> profileData;

  bool imageSet = false;

  final AddFamilyUserInfoArguments arguments;
  final String fromClass;

  MySliverAppBar({
    @required this.expandedHeight,
    this.profileData,
    this.fromClass,
    this.arguments,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        InkWell(
            onTap: () {
              saveMediaDialog(context, false);
            },
            child: imageURIProfile != null
                ? Image.file(imageURIProfile,
                    fit: BoxFit.cover, width: 100, height: 100)
                : Container(
                    color: Colors.black.withOpacity(0.2),
                  )),
        Positioned(
          left: 25,
          top: 25,
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: ClipOval(
              child: Container(
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
                saveMediaDialog(context, true);
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

  saveMediaDialog(BuildContext cont, bool isProfileImage) {
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
                        var image =
                            ImagePicker.pickImage(source: ImageSource.gallery);
                        image.then((value) {
                          if (isProfileImage) {
                            imageURI = value;
                          } else {
                            imageURIProfile = value;
                            imageSet = true;
                          }

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

                        var image =
                            ImagePicker.pickImage(source: ImageSource.camera);
                        image.then((value) {
                          if (isProfileImage)
                            imageURI = value;
                          else {
                            imageURIProfile = value;
                            imageSet = true;
                          }
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
