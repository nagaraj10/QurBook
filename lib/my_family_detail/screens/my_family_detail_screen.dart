import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_user_info/bloc/add_family_user_info_bloc.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/my_family_detail/models/my_family_detail_arguments.dart';
import 'package:myfhb/my_family_detail_view/models/my_family_detail_view_arguments.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class MyFamilyDetailScreen extends StatefulWidget {
  MyFamilyDetailArguments arguments;

  MyFamilyDetailScreen({this.arguments});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyFamilyDetailScreenState();
  }
}

class MyFamilyDetailScreenState extends State<MyFamilyDetailScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  static File imageURI;
  final double expandedHeight = 170;
  List<int> profileData;

  var mobileNoController = TextEditingController();
  FocusNode mobileNoFocus = FocusNode();

  var nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();

  var firstNameController = TextEditingController();
  FocusNode firstNameFocus = FocusNode();

  var middleNameController = TextEditingController();
  FocusNode middleNameFocus = FocusNode();

  var lastNameController = TextEditingController();
  FocusNode lastNameFocus = FocusNode();

  var relationShipController = TextEditingController();
  FocusNode relationShipFocus = FocusNode();

  var emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();

  var genderController = TextEditingController();
  FocusNode genderFocus = FocusNode();

  var bloodGroupController = TextEditingController();
  FocusNode bloodGroupFocus = FocusNode();

  var bloodRangeController = TextEditingController();
  FocusNode bloodRangeFocus = FocusNode();

  var dateOfBirthController = TextEditingController();
  FocusNode dateOfBirthFocus = FocusNode();

  RelationShipResponseList relationShipResponseList;
  RelationShip selectedRelationShip;

  DateTime dateTime = DateTime.now();
  MyProfile myProfile;
  bool isCalled = false;

  List<int> fetchedProfileData;

  AddFamilyUserInfoBloc addFamilyUserInfoBloc;

  List<String> bloodGroupArray = ['A', 'B', 'AB', 'O', 'Unknown'];

  List<String> bloodRangeArray = ['+ve', '-ve', 'Unknown'];

  String selectedBloodGroup;
  String selectedBloodRange;

  List<String> genderArray = ['Male', 'Female', 'Others'];
  String selectedGender;

  @override
  void initState() {
    super.initState();

    setState(() {
      _currentPage = widget.arguments.currentPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            CommonConstants.my_family_title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, '/add_family_user_info',
                          arguments: AddFamilyUserInfoArguments(
                              sharedbyme: widget
                                  .arguments.profilesSharedByMe[_currentPage],
                              fromClass: CommonConstants.my_family))
                      .then((value) {});
                })
          ]),
      body: PageView(
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          controller: PageController(
              initialPage: _currentPage,
              keepPage: false,
              viewportFraction: 1.0),
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: buildMyFamilDetailPages()),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildPageIndicator(),
      ),
    );
  }

  List<Widget> buildMyFamilDetailPages() {
    final children = <Widget>[];

    for (int i = 0; i < widget.arguments.profilesSharedByMe.length; i++) {
      children.add(_showPageData(widget.arguments.profilesSharedByMe[i]));
    }
    return children;
  }

  Widget _showPageData(Sharedbyme sharedbyme) {
    nameController = TextEditingController(text: '');
    nameFocus = FocusNode();

    firstNameController = TextEditingController(text: '');
    firstNameFocus = FocusNode();

    middleNameController = TextEditingController(text: '');
    middleNameFocus = FocusNode();

    lastNameController = TextEditingController(text: '');
    lastNameFocus = FocusNode();

    mobileNoController = TextEditingController(text: '');
    mobileNoFocus = FocusNode();

    emailController = TextEditingController(text: '');
    emailFocus = FocusNode();

    dateOfBirthController = TextEditingController(text: '');
    dateOfBirthFocus = FocusNode();

    genderController = TextEditingController(text: '');
    genderFocus = FocusNode();

    bloodGroupController = TextEditingController(text: '');
    bloodGroupFocus = FocusNode();

    bloodRangeController = TextEditingController(text: '');
    bloodRangeFocus = FocusNode();

    relationShipController = TextEditingController(text: '');
    relationShipFocus = FocusNode();

    if (sharedbyme.profileData.qualifiedFullName != null) {
      firstNameController.text =
          sharedbyme.profileData.qualifiedFullName.firstName;
      middleNameController.text =
          sharedbyme.profileData.qualifiedFullName.middleName;
      lastNameController.text =
          sharedbyme.profileData.qualifiedFullName.lastName;
    } else {
      firstNameController.text = sharedbyme.profileData.name;
      middleNameController.text = '';
      lastNameController.text = '';
    }

    if (sharedbyme.profileData.isVirtualUser) {
      MyProfile myProf = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
      mobileNoController.text = myProf.response.data.generalInfo.phoneNumber;
      emailController.text = myProf.response.data.generalInfo.email;
    } else {
      mobileNoController.text = sharedbyme.profileData.phoneNumber;
      emailController.text = sharedbyme.profileData.email;
    }

    if (sharedbyme.profileData.bloodGroup != null &&
        sharedbyme.profileData.bloodGroup != "null") {
//      bloodGroupController.text = sharedbyme.profileData.bloodGroup;

      renameBloodGroup(sharedbyme.profileData.bloodGroup);
    }

    if (sharedbyme.profileData.gender != null) {
      genderController.text = toBeginningOfSentenceCase(
          sharedbyme.profileData.gender.toLowerCase());
    }

    if (sharedbyme.linkedData.roleName != null) {
      relationShipController.text = sharedbyme.linkedData.roleName;
    }

    if (sharedbyme.profileData.dateOfBirth != null) {
      /*  List<String> list = sharedbyme.profileData.dateOfBirth
          .split("T"); */ //by space" " the string need to splited

      dateOfBirthController.text = new FHBUtils()
          .getFormattedDateOnlyNew(sharedbyme.profileData.dateOfBirth);
    }

    String profilebanner =
        PreferenceUtil.getStringValue(Constants.KEY_PROFILE_BANNER);
    //print('profilebanner $profilebanner');

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
              color: Color(CommonUtil().getMyPrimaryColor()),
              height: expandedHeight,
              child: Stack(
                fit: StackFit.expand,
                overflow: Overflow.visible,
                children: [
                  profilebanner != null
                      ? Image.file(File(profilebanner),
                          fit: BoxFit.cover, width: 100, height: 100)
                      : Container(
                          color: Colors.black.withOpacity(0.2),
                        ),
                  Positioned(
                      top: expandedHeight - 50,
                      left: 24, //MediaQuery.of(context).size.width / 4,
                      child: InkWell(
                          onTap: () {},
                          child: Opacity(
                              opacity: 1,
                              child: ClipOval(
                                child: sharedbyme
                                            .profileData.profilePicThumbnail !=
                                        null
                                    ? Image.memory(
                                        Uint8List.fromList(sharedbyme
                                            .profileData
                                            .profilePicThumbnail
                                            .data),
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100)
                                    : Container(
                                        width: 100,
                                        height: 100,
                                        color: Color(new CommonUtil()
                                            .getMyPrimaryColor()),
                                        child: Center(
                                          child: Text(
                                            sharedbyme.linkedData.nickName[0]
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 60.0,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ),
                                      ),
                              )))),
                ],
              )),
          SizedBox(height: 50),
          _showMobileNoTextField(),
          _showFirstNameTextField(),
          _showMiddleNameTextField(),
          _showLastNameTextField(),
          _showRelationShipTextField(),
          _showEmailAddTextField(),
          _showGenderTextField(),
          Row(
            children: <Widget>[
              _showBloodGroupTextField(),
              _showBloodRangeTextField(),
            ],
          ),
          _showDateOfBirthTextField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _showViewInsuranceButton(sharedbyme),
              ),
              Expanded(
                flex: 1,
                child: _showViewHospitalButton(sharedbyme),
              )
            ],
          ),
          SizedBox(height: 20),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: _buildPageIndicator(),
//          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.arguments.profilesSharedByMe.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? Color(new CommonUtil().getMyPrimaryColor())
            : ColorUtils.greycolor,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  void renameBloodGroup(String selectedBloodGroupClone) {
    print('selectedBloodGroupClone renameBloodGroup' + selectedBloodGroupClone);
    if (selectedBloodGroupClone != null) {
      var bloodGroupSplitName = selectedBloodGroupClone.split('_');

      try {
        if (bloodGroupSplitName.length > 1) {
          for (String bloodGroup in bloodGroupArray) {
//      var bloodgroupClone = bloodGroup.split(' ');
            if (bloodGroupSplitName[0] == bloodGroup) {
              selectedBloodGroup = bloodGroup;
              bloodGroupController.text = selectedBloodGroup;
            }
          }

          for (String bloodRange in bloodRangeArray) {
            if (bloodGroupSplitName[1] == bloodRange) {
              selectedBloodRange = bloodRange;
              bloodRangeController.text = selectedBloodRange;
            }
          }
        } else {
          var bloodGroupSplitName = selectedBloodGroupClone.split(' ');
          if (bloodGroupSplitName.length > 1) {
            for (String bloodGroup in bloodGroupArray) {
//      var bloodgroupClone = bloodGroup.split(' ');
              if (bloodGroupSplitName[0] == bloodGroup) {
                selectedBloodGroup = bloodGroup;
                bloodGroupController.text = selectedBloodGroup;
              }

              for (String bloodRange in bloodRangeArray) {
                if (bloodGroupSplitName[1][0] == bloodRange) {
                  selectedBloodRange = bloodRange;
                  bloodRangeController.text = selectedBloodRange;
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
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 12.0,
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
          enabled: false,
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
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 12.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  Widget _showFirstNameTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: firstNameController,
          maxLines: 1,
          enabled: false,
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
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 12.0,
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
          enabled: false,
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
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 12.0,
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
          enabled: false,
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
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 12.0,
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
          enabled: false,
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
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 12.0,
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
          enabled: false,
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
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 12.0,
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
          enabled: false,
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
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 12.0,
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
        child: Container(
            width: MediaQuery.of(context).size.width / 2 - 40,
            child: TextField(
              cursorColor: Theme.of(context).primaryColor,
              controller: bloodGroupController,
              maxLines: 1,
              enabled: false,
              keyboardType: TextInputType.text,
              focusNode: bloodGroupFocus,
              textInputAction: TextInputAction.done,
              onSubmitted: (term) {
                FocusScope.of(context).requestFocus(bloodRangeFocus);
              },
              style: new TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: ColorUtils.blackcolor),
              decoration: InputDecoration(
                labelText: CommonConstants.blood_group,
                hintText: CommonConstants.blood_group,
                labelStyle: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.myFamilyGreyColor),
                hintStyle: TextStyle(
                  fontSize: 12.0,
                  color: ColorUtils.myFamilyGreyColor,
                  fontWeight: FontWeight.w400,
                ),
                border: new UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorUtils.myFamilyGreyColor)),
              ),
            )));
  }

  // 6
  Widget _showBloodRangeTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: Container(
            width: MediaQuery.of(context).size.width / 2 - 40,
            child: TextField(
              cursorColor: Theme.of(context).primaryColor,
              controller: bloodRangeController,
              maxLines: 1,
              enabled: false,
              keyboardType: TextInputType.text,
              focusNode: bloodRangeFocus,
              textInputAction: TextInputAction.done,
              onSubmitted: (term) {
                FocusScope.of(context).requestFocus(dateOfBirthFocus);
              },
              style: new TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: ColorUtils.blackcolor),
              decoration: InputDecoration(
                labelText: 'Rh type',
                hintText: 'Rh type',
                labelStyle: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.myFamilyGreyColor),
                hintStyle: TextStyle(
                  fontSize: 12.0,
                  color: ColorUtils.myFamilyGreyColor,
                  fontWeight: FontWeight.w400,
                ),
                border: new UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorUtils.myFamilyGreyColor)),
              ),
            )));
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
            enabled: false,
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
//                  _selectDate(context);
                },
              ),
              labelText: CommonConstants.date_of_birth,
              hintText: CommonConstants.date_of_birth,
              labelStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.myFamilyGreyColor),
              hintStyle: TextStyle(
                fontSize: 12.0,
                color: ColorUtils.myFamilyGreyColor,
                fontWeight: FontWeight.w400,
              ),
              border: new UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
            ),
          )),
    );
  }

  Widget _showViewInsuranceButton(Sharedbyme sharedbyme) {
    final GestureDetector viewInsuranceButtonWithGesture = new GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/my_family_detail_view_insurance',
            arguments:
                MyFamilyDetailViewArguments(index: 0, sharedbyme: sharedbyme));
      },
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
                CommonConstants.view_insurance,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return viewInsuranceButtonWithGesture;

    /* return new Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: viewInsuranceButtonWithGesture);*/
  }

  Widget _showViewHospitalButton(Sharedbyme sharedbyme) {
    final GestureDetector viewHospitalButtonWithGesture = new GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/my_family_detail_view_insurance',
            arguments:
                MyFamilyDetailViewArguments(index: 1, sharedbyme: sharedbyme));
      },
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
                CommonConstants.view_hospital,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return viewHospitalButtonWithGesture;
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

//              if (widget.arguments.fromClass == CommonConstants.my_family) {
//                for (var i = 0;
//                    i < snapshot.data.data.relationShipAry.length;
//                    i++) {
//                  if (snapshot.data.data.relationShipAry[i].roleName ==
//                      widget.arguments.sharedbyme.linkedData.roleName) {
//                    selectedRelationShip =
//                        snapshot.data.data.relationShipAry[i];
//                  }
//                }
//              }

              familyWidget = getRelationshipDetails(snapshot.data.data);
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
                value: selectedGender != null
                    ? toBeginningOfSentenceCase(selectedGender.toLowerCase())
                    : selectedGender,
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
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null) {
      setState(() {
        dateTime = picked ?? dateTime;
        dateOfBirthController.text =
            new DateFormat("yyyy-MM-dd").format(dateTime).toString();
      });
    }
  }

  void dateOfBirthTapped() {
    _selectDate(context);
  }
}
