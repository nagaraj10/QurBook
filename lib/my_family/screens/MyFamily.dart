// ignore: file_names
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:myfhb/add_family_otp/models/add_family_otp_arguments.dart';
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
import 'package:myfhb/my_family/models/FamilyData.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/models/RelationShip.dart';
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/my_family_detail/models/my_family_detail_arguments.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class MyFamily extends StatefulWidget {
  @override
  _MyFamilyState createState() => _MyFamilyState();
}

class _MyFamilyState extends State<MyFamily> {
  FamilyListBloc _familyListBloc;

  var _selected = Country.IN;
  bool isPrimaryNoSelected = false;

  final mobileNoController = TextEditingController();
  FocusNode mobileNoFocus = FocusNode();

  final nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();

  final firstNameController = TextEditingController();
  FocusNode firstNameFocus = FocusNode();

  final middleNameController = TextEditingController();
  FocusNode middleNameFocus = FocusNode();

  final lastNameController = TextEditingController();
  FocusNode lastNameFocus = FocusNode();

  final relationShipController = TextEditingController();
  FocusNode relationShipFocus = FocusNode();

  bool isCalled = false;
  RelationShipResponseList relationShipResponseList;

  bool firstTym = true;

  // Option 2
  String selectedBloodGroup;
  RelationShip selectedRelationShip;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersList();
    _familyListBloc.getCustomRoles();

    PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffold_state,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            saveMediaDialog(context);
          },
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        ),
        body: getAllFamilyMembers());
  }

  Widget getAllFamilyMembers() {
    Widget familyWidget;

    return firstTym
        ? PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER) != null
            ? getMyFamilyMembers(
                PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER))
            : StreamBuilder<ApiResponse<FamilyMembersList>>(
                stream: _familyListBloc.familyMemberListStream,
                builder: (context,
                    AsyncSnapshot<ApiResponse<FamilyMembersList>> snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        familyWidget = Center(
                            child: SizedBox(
                          child: CircularProgressIndicator(
                            backgroundColor:
                                Color(CommonUtil().getMyPrimaryColor()),
                          ),
                          width: 30,
                          height: 30,
                        ));
                        break;

                      case Status.ERROR:
                        familyWidget = FHBBasicWidget.getRefreshContainerButton(
                            snapshot.data.message, () {
                          setState(() {});
                        });
                        break;

                      case Status.COMPLETED:
                        //rebuildFamilyBlock();
                        firstTym = false;
                        PreferenceUtil.saveFamilyData(
                            Constants.KEY_FAMILYMEMBER,
                            snapshot.data.data.response.data);

                        familyWidget = getMyFamilyMembers(
                            snapshot.data.data.response.data);
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
              )
        : getMyFamilyMembers(
            PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER));
  }

  Widget getMyFamilyMembers(FamilyData data) {
    return data != null
        ? data.sharedbyme.length > 0
            ? Container(
                color: const Color(fhbColors.bgColorContainer),
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 20),
                  itemBuilder: (c, i) => getCardWidgetForUser(
                      data.sharedbyme[i == 0 ? 0 : i - 1], i, data.sharedbyme),
                  itemCount: data.sharedbyme.length + 1,
                ))
            : Container(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      Constants.NO_DATA_FAMIY,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                color: Color(fhbColors.bgColorContainer),
              )
        : Container(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
                child:
                    Text(Constants.NO_DATA_FAMIY, textAlign: TextAlign.center),
              ),
            ),
            color: Color(fhbColors.bgColorContainer),
          );
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  Widget getCardWidgetForUser(
      Sharedbyme data, int position, List<Sharedbyme> profilesSharedByMeAry) {
    MyProfile myProfile;
    String fulName;
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
      fulName = myProfile.response.data.generalInfo.qualifiedFullName != null
          ? myProfile.response.data.generalInfo.qualifiedFullName.firstName +
              ' ' +
              myProfile.response.data.generalInfo.qualifiedFullName.lastName
          : '';
    } catch (e) {}

    return InkWell(
      onTap: () {
        if (position != 0) {
          Navigator.pushNamed(context, router.rt_FamilyDetailScreen,
                  arguments: MyFamilyDetailArguments(
                      profilesSharedByMe: profilesSharedByMeAry,
                      currentPage: position - 1))
              .then((value) {
            _familyListBloc.getFamilyMembersList().then((familyMembersList) {
              PreferenceUtil.saveFamilyData(
                  Constants.KEY_FAMILYMEMBER, familyMembersList.response.data);
            });
          });
        }
      },
      child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFe3e2e2),
                blurRadius: 16, // has the effect of softening the shadow
                spreadRadius: 2.0, // has the effect of extending the shadow
                offset: Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: position == 0
                    ? myProfile.response.data.generalInfo
                                .profilePicThumbnailURL ==
                            null
                        ? Container(
                            width: 60,
                            height: 60,
                            color: Color(fhbColors.bgColorContainer),
                            child: Center(
                              child: Text(
                                fulName != null ? fulName.toUpperCase() : '',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              ),
                            ),
                          )
                        : Image.network(
                            myProfile.response.data.generalInfo
                                .profilePicThumbnailURL,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          )
                    : data.profileData.profilePicThumbnailURL == null
                        ? Container(
                            width: 60,
                            height: 60,
                            color: Color(fhbColors.bgColorContainer),
                            child: Center(
                              child: Text(
                                data.profileData.qualifiedFullName.firstName !=
                                        null
                                    ? data.profileData.qualifiedFullName
                                        .firstName[0]
                                        .toUpperCase()
                                    : '',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              ),
                            ),
                          )
                        : Image.network(
                            data.profileData.profilePicThumbnailURL,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                // flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      position == 0
                          ? fulName != null
                              ? new CommonUtil()
                                  .titleCase(fulName.toLowerCase())
                              : ''
                          : data.profileData.qualifiedFullName.firstName != null
                              ? new CommonUtil().titleCase(data
                                      .profileData.qualifiedFullName.firstName +
                                  ' ' +
                                  data.profileData.qualifiedFullName.lastName)
                              : '',
                      style: TextStyle(fontWeight: FontWeight.w500),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      position == 0
                          ? myProfile.response.data.generalInfo.countryCode +
                              "-" +
                              myProfile.response.data.generalInfo.phoneNumber
                          : data.profileData.isVirtualUser != null
                              ? PreferenceUtil.getProfileData(
                                          Constants.KEY_PROFILE)
                                      .response
                                      .data
                                      .generalInfo
                                      .countryCode +
                                  "-" +
                                  PreferenceUtil.getProfileData(
                                          Constants.KEY_PROFILE)
                                      .response
                                      .data
                                      .generalInfo
                                      .phoneNumber
                              : data.profileData.phoneNumber != null
                                  ? data.profileData.countryCode +
                                      "-" +
                                      data.profileData.phoneNumber
                                  : '',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.greycolor1),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      position == 0
                          ? variable.Self
                          : data.linkedData.roleName != null
                              ? data.linkedData.roleName
                              : '',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(new CommonUtil().getMyPrimaryColor())),
                    ),
                  ],
                ),
              ),
              position != 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Alert.displayConfirmProceed(context,
                                title: variable.Delink,
                                content: CommonConstants.delink_alert,
                                onPressedConfirm: () {
                              new FHBUtils().check().then((intenet) {
                                if (intenet != null && intenet) {
                                  Navigator.pop(context);

                                  CommonUtil.showLoadingDialog(context,
                                      _keyLoader, variable.Please_Wait);

                                  var deLinkingData = {};
                                  deLinkingData[variable.strrelatedTo] =
                                      data.profileData.id;
                                  deLinkingData[variable.strrelationshipType] =
                                      variable.strparentToChild;
                                  var jsonString =
                                      convert.jsonEncode(deLinkingData);

                                  _familyListBloc
                                      .postUserDeLinking(jsonString)
                                      .then((userLinking) {
                                    if (userLinking.status == 200 &&
                                        userLinking.success) {
                                      // Reload
                                      _familyListBloc
                                          .getFamilyMembersList()
                                          .then((value) {
                                        if (value.status == 200 &&
                                            value.success) {
                                          Navigator.of(
                                                  _keyLoader.currentContext,
                                                  rootNavigator: true)
                                              .pop();
                                          PreferenceUtil.saveFamilyData(
                                                  Constants.KEY_FAMILYMEMBER,
                                                  value.response.data)
                                              .then((value) {
                                            rebuildFamilyBlock();
                                            setState(() {});
                                          });
                                        } else {
                                          Navigator.of(
                                                  _keyLoader.currentContext,
                                                  rootNavigator: true)
                                              .pop();
                                        }
                                      });
                                    } else {
                                      Navigator.of(_keyLoader.currentContext,
                                              rootNavigator: true)
                                          .pop();
                                    }
                                  });
                                } else {
                                  new FHBBasicWidget().showInSnackBar(
                                      Constants.STR_NO_CONNECTIVITY,
                                      scaffold_state);
                                }
                              });
                            }, onPressedCancel: () {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Color(
                                        new CommonUtil().getMyPrimaryColor()))),
                            child: Text(
                              variable.DeLink,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(
                                      new CommonUtil().getMyPrimaryColor())),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    )
                  : Container()
            ],
          )),
    );
  }

  saveMediaDialog(BuildContext context) {
    firstNameController.text = '';
    middleNameController.text = '';
    lastNameController.text = '';
    mobileNoController.text = '';
    isPrimaryNoSelected = false;
    selectedRelationShip = null;
    rebuildFamilyBlock();

    List<RelationShip> data =
        PreferenceUtil.getFamilyRelationship(Constants.keyFamily);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
            content: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                CountryPicker(
                                  nameTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  dialingCodeTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  dense: false,
                                  showFlag: false,
                                  //displays flag, true by default
                                  showDialingCode: true,
                                  //displays dialing code, false by default
                                  showName: false,
                                  //displays country name, true by default
                                  showCurrency: false,
                                  //eg. 'British pound'
                                  showCurrencyISO: false,
                                  //eg. 'GBP'
                                  onChanged: (Country country) {
                                    setState(() {
                                      _selected = country;
                                    });
                                  },
                                  selectedCountry: _selected,
                                ),
                                _ShowMobileNoTextField()
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isPrimaryNoSelected) {
                                          isPrimaryNoSelected = false;
                                          mobileNoController.text = '';
                                        } else {
                                          isPrimaryNoSelected = true;
                                          mobileNoController.text =
                                              PreferenceUtil.getStringValue(
                                                      Constants.MOB_NUM)
                                                  .replaceAll('+91', '');
                                        }
                                      });
                                    },
                                    child: Icon(
                                        isPrimaryNoSelected == true
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_unchecked,
                                        color: isPrimaryNoSelected == true
                                            ? Theme.of(context).primaryColor
                                            : ColorUtils.myFamilyGreyColor)),
                                SizedBox(width: 5),
                                Text(CommonConstants.primary_number,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.myFamilyGreyColor))
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                _showFirstNameTextField(),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                _showMiddleNameTextField(),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                _showLastNameTextField(),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                data != null
                                    ? getRelationshipDetails(data)
                                    : getAllCustomRoles()
                                //getRelationshipDetailsNew()
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _showOTPButton(),
                              ],
                            ),
                            SizedBox(height: 20),
                            // callAddFamilyStreamBuilder(),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
      },
    );
  }

  Widget getAllCustomRoles() {
    Widget familyWidget;

    return StreamBuilder<ApiResponse<RelationShipResponseList>>(
      stream: _familyListBloc.relationShipStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<RelationShipResponseList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              familyWidget = Center(
                  child: SizedBox(
                child: CircularProgressIndicator(),
                width: 30,
                height: 30,
              ));
              break;

            case Status.ERROR:
              familyWidget = Center(
                  child: Text(Constants.STR_ERROR_LOADING_DATA,
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              isCalled = true;
              PreferenceUtil.saveRelationshipArray(
                  Constants.KEY_FAMILYREL, snapshot.data.data.relationShipAry);
              relationShipResponseList = snapshot.data.data;

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
      return Expanded(
          flex: 8,
          child: DropdownButton(
            isExpanded: true,
            hint: Text(CommonConstants.relationshipWithStar),
            value: selectedRelationShip,
            items: data.map((relationShipDetail) {
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
          ));
    });
  }

  Widget _ShowMobileNoTextField() {
    return Expanded(
      child: new TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: mobileNoController,
          maxLines: 1,
          enabled: isPrimaryNoSelected ? false : true,
          keyboardType: TextInputType.text,
          focusNode: mobileNoFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            mobileNoFocus.unfocus();
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            hintText: CommonConstants.mobile_numberWithStar,
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
          )),
    );
  }

  Widget _ShowNameTextField() {
    return Expanded(
      child: new TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: nameController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          focusNode: nameFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            nameFocus.unfocus();
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            hintText: CommonConstants.name,
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
          )),
    );
  }

  Widget _showFirstNameTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Theme.of(context).primaryColor,
      controller: firstNameController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      focusNode: firstNameFocus,
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
    return Expanded(
        child: TextField(
      cursorColor: Theme.of(context).primaryColor,
      controller: middleNameController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      focusNode: middleNameFocus,
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
    return Expanded(
        child: TextField(
      cursorColor: Theme.of(context).primaryColor,
      controller: lastNameController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      focusNode: lastNameFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        lastNameFocus.unfocus();
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

  Widget _showOTPButton() {
    final GestureDetector addButtonWithGesture = new GestureDetector(
      onTap: _sendOTPBtnTapped,
      child: new Container(
        width: 130,
        height: 40.0,
        decoration: new BoxDecoration(
          color: Color(new CommonUtil().getMyPrimaryColor()),
          borderRadius: new BorderRadius.all(Radius.circular(2.0)),
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
            isPrimaryNoSelected == true
                ? CommonConstants.add
                : CommonConstants.send_otp,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: addButtonWithGesture);
  }

  void _sendOTPBtnTapped() {
    if (mobileNoController.text.length > 0 &&
        firstNameController.text.length > 0 &&
        lastNameController.text.length > 0 &&
        selectedRelationShip != null) {
      new FHBUtils().check().then((intenet) {
        if (intenet != null && intenet) {
          CommonUtil.showLoadingDialog(
              context, _keyLoader, variable.Please_Wait);

          var signInData = {};
          signInData[variable.strCountryCode] = '+' + _selected.dialingCode;
          signInData[variable.strPhoneNumber] =
              mobileNoController.text.replaceAll('+91', '');
          signInData[variable.strisPrimaryUser] = isPrimaryNoSelected;
          signInData[variable.strFirstName] = firstNameController.text;
          signInData[variable.strMiddleName] =
              middleNameController.text.length > 0
                  ? middleNameController.text
                  : '';
          signInData[variable.strLastName] = lastNameController.text;
          signInData[variable.strRelation] = selectedRelationShip.id;

          var jsonString = convert.jsonEncode(signInData);

          if (isPrimaryNoSelected) {
            _familyListBloc
                .postUserLinkingForPrimaryNo(jsonString)
                .then((addFamilyOTPResponse) {
              if (addFamilyOTPResponse.success &&
                  addFamilyOTPResponse.status == 200) {
                if (addFamilyOTPResponse.response.data != null) {
                  _familyListBloc.getFamilyMembersInfo().then((value) {
                    if (value.status == 200 && value.success) {
                      PreferenceUtil.saveFamilyData(
                              Constants.KEY_FAMILYMEMBER, value.response.data)
                          .then((value) {
                        Navigator.of(_keyLoader.currentContext,
                                rootNavigator: true)
                            .pop();

                        Navigator.pop(context);
                        Navigator.pushNamed(
                                context, router.rt_AddFamilyUserInfo,
                                arguments: AddFamilyUserInfoArguments(
                                    fromClass: CommonConstants.add_family,
                                    enteredFirstName: firstNameController.text,
                                    enteredMiddleName:
                                        middleNameController.text,
                                    enteredLastName: lastNameController.text,
                                    relationShip: selectedRelationShip,
                                    isPrimaryNoSelected: isPrimaryNoSelected,
                                    addFamilyUserInfo:
                                        addFamilyOTPResponse.response.data))
                            .then((value) {
                          mobileNoController.text = '';
                          nameController.text = '';
                          isPrimaryNoSelected = false;
                          selectedRelationShip = null;
                          rebuildFamilyBlock();
                          _familyListBloc
                              .getFamilyMembersList()
                              .then((familyMembersList) {
                            PreferenceUtil.saveFamilyData(
                                Constants.KEY_FAMILYMEMBER,
                                familyMembersList.response.data);
                          });
                        });
                      });
                    } else {
                      Navigator.of(_keyLoader.currentContext,
                              rootNavigator: true)
                          .pop();

                      Alert.displayAlertPlain(context,
                          title: variable.Error, content: value.message);
                    }
                  });
                } else {
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                      .pop();
                  Alert.displayAlertPlain(context,
                      title: variable.Error,
                      content: addFamilyOTPResponse.message);
                }
              } else {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                Alert.displayAlertPlain(context,
                    title: variable.Error,
                    content: addFamilyOTPResponse.message);
              }
            });
          } else {
            _familyListBloc.postUserLinking(jsonString).then((userLinking) {
              if (userLinking.success && userLinking.status == 200) {
                _familyListBloc.getFamilyMembersList().then((value) {
                  if (value.status == 200 && value.success) {
                    PreferenceUtil.saveFamilyData(
                            Constants.KEY_FAMILYMEMBER, value.response.data)
                        .then((value) {
                      Navigator.of(_keyLoader.currentContext,
                              rootNavigator: true)
                          .pop();

                      Navigator.pop(context);

                      Navigator.pushNamed(
                        context,
                        router.rt_AddFamilyOtp,
                        arguments: AddFamilyOTPArguments(
                            enteredMobNumber: mobileNoController.text,
                            enteredFirstName: firstNameController.text,
                            enteredMiddleName: middleNameController.text,
                            enteredLastName: lastNameController.text,
                            selectedCountryCode: _selected.dialingCode,
                            relationShip: selectedRelationShip,
                            isPrimaryNoSelected: isPrimaryNoSelected),
                      ).then((value) {
                        mobileNoController.text = '';
                        nameController.text = '';
                        isPrimaryNoSelected = false;
                        selectedRelationShip = null;
                        rebuildFamilyBlock();
                        _familyListBloc
                            .getFamilyMembersList()
                            .then((familyMembersList) {
                          PreferenceUtil.saveFamilyData(
                              Constants.KEY_FAMILYMEMBER,
                              familyMembersList.response.data);
                        });
                      });
                    });
                  } else {
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                        .pop();
                  }
                });
              } else {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                Alert.displayAlertPlain(context,
                    title: variable.Error, content: userLinking.message);
              }
            });
          }
        } else {
          new FHBBasicWidget()
              .showInSnackBar(Constants.STR_NO_CONNECTIVITY, scaffold_state);
        }
      });
    } else {
      // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      Alert.displayAlertPlain(context,
          title: variable.Error, content: CommonConstants.all_fields);
    }
  }

  rebuildFamilyBlock() {
    _familyListBloc = null;
    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersList();
    _familyListBloc.getCustomRoles();
  }
}
