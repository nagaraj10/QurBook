// ignore: file_names
import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import '../../add_family_otp/models/add_family_otp_arguments.dart';
import '../../add_family_user_info/models/add_family_user_info_arguments.dart';
import '../../add_family_user_info/services/add_family_user_info_repository.dart';
import '../../authentication/constants/constants.dart';
import '../../authentication/view/verifypatient_screen.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../bloc/FamilyListBloc.dart';
import '../models/FamilyMembersRes.dart';
import '../models/relationship_response_list.dart';
import '../models/relationships.dart';
import '../../my_family_detail/models/my_family_detail_arguments.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/utils/alert.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

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
  RelationsShipModel selectedRelationShip;

  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();

  var dialogContext;

  String parentProfilePic;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  MyProfileModel myProfile = MyProfileModel();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    _familyListBloc = FamilyListBloc();
    _familyListBloc.getFamilyMembersListNew();
    _familyListBloc.getCustomRoles();
    parentProfilePic =
        PreferenceUtil.getStringValue(Constants.KEY_PROFILE_IMAGE);
    PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, '');

    fetchUserProfileInfo();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'MyFamily Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    dialogContext = context;
    return Scaffold(
        key: scaffold_state,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            saveMediaDialog(context);
          },
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 24.0.sp,
          ),
        ),
        body: getAllFamilyMembers());
  }

  Widget getAllFamilyMembers() {
    Widget familyWidget;

    return StreamBuilder<ApiResponse<FamilyMembers>>(
      stream: _familyListBloc.familyMemberListNewStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              familyWidget = Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
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
              /* PreferenceUtil.saveFamilyDataNew(
                            Constants.KEY_FAMILYMEMBERNEW,
                            snapshot.data.data.result); */

              familyWidget = getMyFamilyMembers(snapshot.data.data.result);
              break;
          }
        } else {
          familyWidget = Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }
        return familyWidget;
      },
    );

    /* return firstTym
        ? PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBERNEW) != null
            ? getMyFamilyMembers(
                PreferenceUtil.getFamilyDataNew(Constants.KEY_FAMILYMEMBERNEW))
            : StreamBuilder<ApiResponse<FamilyMembers>>(
                stream: _familyListBloc.familyMemberListNewStream,
                builder: (context,
                    AsyncSnapshot<ApiResponse<FamilyMembers>> snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        familyWidget = Center(
                            child: SizedBox(
                          child: CircularProgressIndicator(
                            backgroundColor:
                                Color(CommonUtil().getMyPrimaryColor()),
                          ),
                          width: 30.0.h,
                          height: 30.0.h,
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
                        PreferenceUtil.saveFamilyDataNew(
                            Constants.KEY_FAMILYMEMBERNEW,
                            snapshot.data.data.result);

                        familyWidget =
                            getMyFamilyMembers(snapshot.data.data.result);
                        break;
                    }
                  } else {
                    familyWidget = Container(
                      width: 100.0.h,
                      height: 100.0.h,
                    );
                  }
                  return familyWidget;
                },
              )
        : getMyFamilyMembers(
            PreferenceUtil.getFamilyDataNew(Constants.KEY_FAMILYMEMBERNEW)); */
  }

  Widget getMyFamilyMembers(FamilyMemberResult data) {
    return data != null
        ? data.sharedByUsers.isNotEmpty
            ? Container(
                color: const Color(fhbColors.bgColorContainer),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 20),
                  itemBuilder: (c, i) => getCardWidgetForUser(
                      data.sharedByUsers[i == 0 ? 0 : i - 1],
                      i,
                      data.sharedByUsers,
                      userCollection: data),
                  itemCount: data.sharedByUsers.length + 1,
                ),
              )
            : Container(
                color: Color(fhbColors.bgColorContainer),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      Constants.NO_DATA_FAMIY,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
        : Container(
            color: Color(fhbColors.bgColorContainer),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
                child:
                    Text(Constants.NO_DATA_FAMIY, textAlign: TextAlign.center),
              ),
            ),
          );
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError('string: $string');
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  fetchUserProfileInfo() async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    if (userid != null) {
      myProfile = await addFamilyUserInfoRepository.getMyProfileInfoNew(userid);
    }

    return myProfile;
  }

  Widget getCardWidgetForUser(SharedByUsers data, int position,
      List<SharedByUsers> profilesSharedByMeAry,
      {FamilyMemberResult userCollection}) {
    /* String familyMemberName = '';
    if (data?.child != null) {
      familyMemberName = '${data.child.firstName} ${data.child.lastName}';
    } */
    var fulName = '';
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
      fulName = myProfile.result != null
          ? myProfile.result.firstName + ' ' + myProfile.result.lastName
          : '';
    } catch (e) {
      fulName = myProfile.result != null
          ? myProfile.result.firstName + ' ' + myProfile.result.lastName
          : '';
    }

    if (position != 0) {
      if (data?.child?.firstName != null && data?.child?.firstName != '') {
        fulName = data?.child?.firstName;
      }
      if (data?.child?.lastName != null && data?.child?.lastName != '') {
        fulName = fulName + ' ' + data?.child?.lastName;
      }
    }

    return InkWell(
      onTap: () {
        if (position != 0) {
          Navigator.pushNamed(
            context,
            router.rt_FamilyDetailScreen,
            arguments: MyFamilyDetailArguments(
                profilesSharedByMe: profilesSharedByMeAry,
                myProfile: myProfile,
                currentPage: position - 1),
          ).then((value) {
            if (value) {
              rebuildFamilyBlock();
              setState(() {});
              // FlutterToast toast = new FlutterToast();
              // toast.getToast('list updated', Colors.green);
            }
          });
        }
      },
      child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFe3e2e2),
                blurRadius: 16, // has the effect of softening the shadow
                spreadRadius: 2, // has the effect of extending the shadow
                offset: Offset(
                  0, // horizontal, move right 10
                  0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: position != 0
                    ? data?.child?.profilePicThumbnailUrl == null
                        ? Container(
                            width: 60.0.h,
                            height: 60.0.h,
                            color: Color(fhbColors.bgColorContainer),
                            child: Center(
                              child: Text(
                                data.child != null
                                    ? data.child.firstName[0].toUpperCase()
                                    : '',
                                style: TextStyle(
                                    fontSize: 22.0.sp,
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              ),
                            ),
                          )
                        : Image.network(
                            data.child?.profilePicThumbnailUrl,
                            fit: BoxFit.cover,
                            width: 60.0.h,
                            height: 60.0.h,
                            headers: {
                              HttpHeaders.authorizationHeader:
                                  PreferenceUtil.getStringValue(
                                      Constants.KEY_AUTHTOKEN)
                            },
                            errorBuilder: (context, exception, stackTrace) {
                              return Container(
                                height: 60.0.h,
                                width: 60.0.h,
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                child: Center(
                                    child: Text(
                                  data.child?.firstName != null &&
                                          data.child.lastName != null
                                      ? data.child.firstName[0].toUpperCase() +
                                          data.child.lastName[0].toUpperCase()
                                      : data.child.firstName != null
                                          ? data.child.firstName[0]
                                              .toUpperCase()
                                          : '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                              );
                            },
                          )
                    //!add condition for login user data
                    : myProfile != null
                        ? myProfile.result != null
                            ? myProfile.result.profilePicThumbnailUrl != null
                                ? FHBBasicWidget()
                                    .getProfilePicWidgeUsingUrl(myProfile)
                                : Container(
                                    width: 60.0.h,
                                    height: 60.0.h,
                                    color: Color(fhbColors.bgColorContainer),
                                    child: Center(
                                      child: Text(
                                        fulName != null
                                            ? fulName[0].toUpperCase()
                                            : '',
                                        style: TextStyle(
                                            fontSize: 22.0.sp,
                                            color: Color(CommonUtil()
                                                .getMyPrimaryColor())),
                                      ),
                                    ),
                                  )
                            : Container(
                                width: 60.0.h,
                                height: 60.0.h,
                                color: Color(fhbColors.bgColorContainer),
                                child: Center(
                                  child: Text(
                                    fulName != null
                                        ? fulName[0].toUpperCase()
                                        : '',
                                    style: TextStyle(
                                        fontSize: 22.0.sp,
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor())),
                                  ),
                                ),
                              )
                        : Container(
                            width: 60.0.h,
                            height: 60.0.h,
                            color: Color(fhbColors.bgColorContainer),
                            child: Center(
                              child: Text(
                                fulName != null ? fulName[0].toUpperCase() : '',
                                style: TextStyle(
                                    fontSize: 22.0.sp,
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              ),
                            ),
                          ),
              ),
              SizedBox(
                width: 20.0.w,
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
                              ? CommonUtil().titleCase(fulName.toLowerCase())
                              : ''
                          : data.child?.firstName != null
                              ? CommonUtil().titleCase(fulName)
                              : '',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0.sp,
                      ),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Text(
                      position == 0 //this is checking self
                          ? (myProfile?.result?.userContactCollection3 !=
                                      null &&
                                  myProfile?.result?.userContactCollection3
                                      .isNotEmpty)
                              ? myProfile?.result?.userContactCollection3[0]
                                  .phoneNumber
                              : ''
                          : (data?.child?.isVirtualUser != null &&
                                  data?.child?.isVirtualUser)
                              /*? data?.child?.isVirtualUser
                                */
                              ? userCollection
                                      ?.virtualUserParent?.phoneNumber ??
                                  ''
                              : (data?.child?.userContactCollection3 != null &&
                                      data?.child?.userContactCollection3
                                          .isNotEmpty)
                                  ? data?.child?.userContactCollection3[0]
                                      .phoneNumber
                                  : '',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.greycolor1,
                        fontSize: 16.0.sp,
                      ),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Text(
                      position == 0
                          ? variable.Self
                          : data.relationship != null
                              ? data.relationship.name ?? ''
                              : '',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0.sp,
                          color: Color(CommonUtil().getMyPrimaryColor())),
                    ),
                  ],
                ),
              ),
              position != 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Alert.displayConfirmProceed(context,
                                title: variable.Delink,
                                content: CommonConstants.delink_alert,
                                onPressedConfirm: () {
                              FHBUtils().check().then((intenet) {
                                if (intenet != null && intenet) {
                                  Navigator.pop(context);

                                  CommonUtil.showLoadingDialog(dialogContext,
                                      _keyLoader, variable.Please_Wait);

                                  final deLinkingData = {};
                                  deLinkingData[variable.strrelatedTo] =
                                      data.child?.id;
                                  deLinkingData[variable.strrelationshipType] =
                                      variable.strparentToChild;
                                  final jsonString =
                                      convert.jsonEncode(deLinkingData);

                                  _familyListBloc
                                      .postUserDeLinking(jsonString.toString())
                                      .then((userLinking) {
                                    if (userLinking.isSuccess) {
                                      Navigator.of(_keyLoader.currentContext,
                                              rootNavigator: true)
                                          .pop();
                                      rebuildFamilyBlock();
                                      setState(() {});
                                    } else {
                                      Navigator.of(_keyLoader.currentContext,
                                              rootNavigator: true)
                                          .pop();
                                    }
                                  });
                                } else {
                                  FHBBasicWidget().showInSnackBar(
                                      Constants.STR_NO_CONNECTIVITY,
                                      scaffold_state);
                                }
                              });
                            }, onPressedCancel: () {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor()))),
                            child: Text(
                              variable.DeLink,
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor())),
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

    final data = PreferenceUtil.getFamilyRelationship(Constants.keyFamily);

    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
            content: Container(
                width: 1.sw,
                height: 1.sh / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 24.0.sp,
                                    ),
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
                                  showFlag: false,
                                  //displays flag, true by default
                                  showDialingCode: true,
                                  //displays dialing code, false by default
                                  showName: false,
                                  //eg. 'GBP'
                                  onChanged: (country) {
                                    setState(() {
                                      _selected = country;
                                    });
                                  },
                                  selectedCountry: _selected,
                                ),
                                _ShowMobileNoTextField()
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
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
                                        ? Color(
                                            CommonUtil().getMyPrimaryColor())
                                        : ColorUtils.myFamilyGreyColor,
                                    size: 24.0.sp,
                                  ),
                                ),
                                SizedBox(width: 5.0.w),
                                Text(CommonConstants.primary_number,
                                    style: TextStyle(
                                        fontSize: 15.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.myFamilyGreyColor))
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                _showFirstNameTextField(),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                _showMiddleNameTextField(),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                _showLastNameTextField(),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                if (data != null)
                                  getRelationshipDetails(data)
                                else
                                  getAllCustomRoles()
                                //getRelationshipDetailsNew()
                              ],
                            ),
                            SizedBox(
                              height: 20.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _showOTPButton(),
                              ],
                            ),
                            SizedBox(
                              height: 20.0.h,
                            ),
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
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              familyWidget = Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              ));
              break;

            case Status.ERROR:
              familyWidget = Center(
                  child: Text(Constants.STR_ERROR_LOADING_DATA,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0.sp,
                      )));
              break;

            case Status.COMPLETED:
              isCalled = true;
              if (snapshot.data.data.result[0] != null) {
                PreferenceUtil.saveRelationshipArray(Constants.KEY_FAMILYREL,
                    snapshot?.data?.data?.result[0]?.referenceValueCollection);
                relationShipResponseList = snapshot.data.data;

                familyWidget = getRelationshipDetails(
                    snapshot?.data.data?.result[0]?.referenceValueCollection);
              }
              break;
          }
        } else {
          familyWidget = Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }
        return familyWidget;
      },
    );
  }

  Widget getRelationshipDetails(List<RelationsShipModel> data) {
    return StatefulBuilder(builder: (context, setState) {
      return Expanded(
          flex: 8,
          child: DropdownButton(
            isExpanded: true,
            hint: Text(CommonConstants.relationshipWithStar),
            value: selectedRelationShip,
            items: data.map((relationShipDetail) {
              return DropdownMenuItem(
                child: Text(relationShipDetail.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0.sp,
                        color: ColorUtils.blackcolor)),
                value: relationShipDetail,
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedRelationShip = newValue;
              });
            },
          ));
    });
  }

  Widget _ShowMobileNoTextField() {
    return Expanded(
      child: TextField(
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
          controller: mobileNoController,
          enabled: isPrimaryNoSelected ? false : true,
          keyboardType: TextInputType.text,
          focusNode: mobileNoFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            mobileNoFocus.unfocus();
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            hintText: CommonConstants.mobile_numberWithStar,
            labelStyle: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 16.0.sp,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          )),
    );
  }

  Widget _ShowNameTextField() {
    return Expanded(
      child: TextField(
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
          controller: nameController,
          keyboardType: TextInputType.text,
          focusNode: nameFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            nameFocus.unfocus();
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            hintText: CommonConstants.name,
            labelStyle: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 16.0.sp,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          )),
    );
  }

  Widget _showFirstNameTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: firstNameController,
      keyboardType: TextInputType.text,
      focusNode: firstNameFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        FocusScope.of(context).requestFocus(middleNameFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.firstNameWithStar,
        hintText: CommonConstants.firstName,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  Widget _showMiddleNameTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: middleNameController,
      keyboardType: TextInputType.text,
      focusNode: middleNameFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        FocusScope.of(context).requestFocus(lastNameFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.middleName,
        hintText: CommonConstants.middleName,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  Widget _showLastNameTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: lastNameController,
      keyboardType: TextInputType.text,
      focusNode: lastNameFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        lastNameFocus.unfocus();
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.lastNameWithStar,
        hintText: CommonConstants.lastName,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  Widget _showOTPButton() {
    final addButtonWithGesture = GestureDetector(
      onTap: _sendOTPBtnTapped,
      child: Container(
        width: 130.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: BorderRadius.all(Radius.circular(2)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            isPrimaryNoSelected == true
                ? CommonConstants.add
                : CommonConstants.send_otp,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  void _sendOTPBtnTapped() {
    if (mobileNoController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        selectedRelationShip != null) {
      FHBUtils().check().then((intenet) {
        if (intenet != null && intenet) {
          CommonUtil.showLoadingDialog(
              context, _keyLoader, variable.Please_Wait);

          if (isPrimaryNoSelected) {
            final addFamilyMemberRequest = {};
            addFamilyMemberRequest['isVirtualUser'] = true;
            addFamilyMemberRequest['firstName'] = firstNameController.text;
            addFamilyMemberRequest['lastName'] = lastNameController.text;
            addFamilyMemberRequest['dateOfBirth'] = null;
            addFamilyMemberRequest['relationship'] = selectedRelationShip.id;
            addFamilyMemberRequest['phoneNumber'] = mobileNoController.text;
            addFamilyMemberRequest['email'] = '';
            addFamilyMemberRequest['isPrimary'] = true;

            final jsonString = convert.jsonEncode(addFamilyMemberRequest);

            _familyListBloc
                .postUserLinkingForPrimaryNo(jsonString)
                .then((addFamilyOTPResponse) {
              if (addFamilyOTPResponse.isSuccess) {
                if (addFamilyOTPResponse.result != null) {
                  _familyListBloc.getFamilyMembersInfo().then((value) {
                    if (value.isSuccess) {
                      Navigator.of(_keyLoader.currentContext,
                              rootNavigator: true)
                          .pop();

                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        router.rt_AddFamilyUserInfo,
                        arguments: AddFamilyUserInfoArguments(
                            fromClass: CommonConstants.add_family,
                            enteredFirstName: firstNameController.text,
                            enteredMiddleName: middleNameController.text,
                            enteredLastName: lastNameController.text,
                            relationShip: selectedRelationShip,
                            isPrimaryNoSelected: isPrimaryNoSelected,
                            id: addFamilyOTPResponse.result.childInfo.id,
                            addFamilyUserInfo:
                                addFamilyOTPResponse.result ?? ''),
                      ).then((value) {
                        mobileNoController.text = '';
                        nameController.text = '';
                        isPrimaryNoSelected = false;
                        selectedRelationShip = null;
                        rebuildFamilyBlock();
                      });
                    } else {
                      Navigator.of(_keyLoader.currentContext,
                              rootNavigator: true)
                          .pop();

                      Alert.displayAlertPlain(context,
                          title: variable.Error, content: value?.message);
                    }
                  });
                } else {
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                      .pop();
                  Alert.displayAlertPlain(context,
                      title: variable.Error,
                      content: 'Error Adding Family member');
                }
              } else {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                Alert.displayAlertPlain(context,
                    title: variable.Error,
                    content: 'Error Adding Family member');
              }
            });
          } else {
            final mobileNo = '+91${mobileNoController.text}';
            final addFamilyMemberRequest = {};
            addFamilyMemberRequest['isVirtualUser'] = false;
            addFamilyMemberRequest['firstName'] = firstNameController.text;
            addFamilyMemberRequest['lastName'] = lastNameController.text;
            addFamilyMemberRequest['dateOfBirth'] = null;
            addFamilyMemberRequest['relationship'] = selectedRelationShip.id;
            addFamilyMemberRequest['phoneNumber'] =
                mobileNo; //TODO this has be dynamic country code.
            addFamilyMemberRequest['email'] = '';
            addFamilyMemberRequest['isPrimary'] = true;

            final jsonString = convert.jsonEncode(addFamilyMemberRequest);

            _familyListBloc.postUserLinking(jsonString).then((userLinking) {
              if (userLinking.success) {
                Navigator.pop(_keyLoader.currentContext);
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyPatient(
                      PhoneNumber: mobileNo,
                      from: strFromVerifyFamilyMember,
                      fName: firstNameController.text,
                      mName: middleNameController.text,
                      lName: lastNameController.text,
                      relationship: selectedRelationShip,
                      isPrimaryNoSelected: isPrimaryNoSelected,
                      userConfirm: false,
                    ),
                  ),
                ).then((value) {
                  mobileNoController.text = '';
                  nameController.text = '';
                  isPrimaryNoSelected = false;
                  selectedRelationShip = null;
                  rebuildFamilyBlock();
                });

                /* _familyListBloc.getFamilyMembersListNew().then((value) {
                  if (value.isSuccess) {
                    // Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    //     .pop();

                    Navigator.pop(_keyLoader.currentContext);
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyPatient(
                          PhoneNumber: mobileNo,
                          from: strFromVerifyFamilyMember,
                          fName: firstNameController.text,
                          mName: middleNameController.text,
                          lName: lastNameController.text,
                          relationship: selectedRelationShip,
                          isPrimaryNoSelected: isPrimaryNoSelected,
                        ),
                      ),
                    ).then((value) {
                      mobileNoController.text = '';
                      nameController.text = '';
                      isPrimaryNoSelected = false;
                      selectedRelationShip = null;
                      rebuildFamilyBlock();
                    });

                    /* Navigator.pushNamed(
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
                    }); */

                    /*  PreferenceUtil.saveFamilyData(
                            Constants.KEY_FAMILYMEMBER, value.result)
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
                            .getFamilyMembersListNew()
                            .then((familyMembersList) {
                          PreferenceUtil.saveFamilyData(
                              Constants.KEY_FAMILYMEMBER,
                              familyMembersList.result);
                        });
                      });
                    }); */
                  } else {
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                        .pop();
                  }
                }); */
              } else {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();
                Navigator.pop(_keyLoader.currentContext);

                Alert.displayAlertPlain(context,
                    title: variable.Error, content: userLinking?.message);
              }
            });
          }
        } else {
          FHBBasicWidget()
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
    _familyListBloc = FamilyListBloc();
    _familyListBloc.getFamilyMembersListNew();
    _familyListBloc.getCustomRoles();
  }
}
