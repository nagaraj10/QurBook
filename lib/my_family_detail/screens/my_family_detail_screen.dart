import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../add_family_user_info/bloc/add_family_user_info_bloc.dart';
import '../../add_family_user_info/models/add_family_user_info_arguments.dart';
import '../../add_family_user_info/services/add_family_user_info_repository.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../main.dart';
import '../../my_family/models/FamilyMembersRes.dart';
import '../../my_family/models/relationship_response_list.dart';
import '../../my_family/models/relationships.dart';
import '../../my_family/services/FamilyMemberListRepository.dart';
import '../../my_family_detail_view/models/my_family_detail_view_arguments.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../models/my_family_detail_arguments.dart';

class MyFamilyDetailScreen extends StatefulWidget {
  MyFamilyDetailArguments? arguments;

  MyFamilyDetailScreen({this.arguments});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyFamilyDetailScreenState();
  }
}

class MyFamilyDetailScreenState extends State<MyFamilyDetailScreen> {
  final PageController _pageController = PageController();
  int? _currentPage = 0;
  static File? imageURI;
  final double expandedHeight = 170.0.h;
  List<int>? profileData;

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

  var cntrlr_addr_one = TextEditingController(text: '');
  var cntrlr_addr_two = TextEditingController(text: '');
  var cntrlr_addr_city = TextEditingController(text: '');
  var cntrlr_addr_state = TextEditingController(text: '');
  var cntrlr_addr_zip = TextEditingController(text: '');

  var cntrlr_corp_name = TextEditingController(text: '');

  final _formkey = GlobalKey<FormState>();

  late RelationShipResponseList relationShipResponseList;
  RelationsShipModel? selectedRelationShip;

  DateTime dateTime = DateTime.now();
  // MyProfileModel myProfile;
  bool isCalled = false;

  List<int>? fetchedProfileData;

  AddFamilyUserInfoBloc? addFamilyUserInfoBloc;
  late AddFamilyUserInfoRepository addFamilyUserInfoRepository;

  //MyProfileModel myProf = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);

  String? selectedBloodGroup;
  String? selectedBloodRange;

  String? selectedGender;

  var heightConroller = TextEditingController();
  var heightInchConroller = TextEditingController();

  FocusNode heightFocus = FocusNode();

  var weightController = TextEditingController();
  FocusNode weightFocus = FocusNode();
  MyProfileModel? myProfile = MyProfileModel();
  FamilyMemberListRepository _familyResponseListRepository =
      FamilyMemberListRepository();
  List<SharedByUsers>? profilesSharedByMeAry = [];

  bool isFeetOrInches = true;
  bool isKg = true;
  @override
  void initState() {
    super.initState();
    addFamilyUserInfoBloc = AddFamilyUserInfoBloc();

    if (widget.arguments!.caregiverRequestor != null) {
      getAllCustomRoles();
    } else {
      getAllCustomRoles();
      fetchUserProfileInfo();
      setState(() {
        _currentPage = widget.arguments!.currentPage;
      });
    }
  }

  void getFamilyMembers() async {
    FamilyMembers familyResponseList =
        await _familyResponseListRepository.getFamilyMembersListNew();
    profilesSharedByMeAry = familyResponseList.result!.sharedByUsers;
    var position = 0;
    for (var i = 0; i < profilesSharedByMeAry!.length; i++) {
      if (widget.arguments!.caregiverRequestor ==
          profilesSharedByMeAry![i].child!.id) {
        position = i;
      }
    }
    if (widget.arguments!.currentPage == null) {
      _currentPage = position;
    }
    setState(() {});
  }

  fetchUserProfileInfo() async {
    addFamilyUserInfoRepository = AddFamilyUserInfoRepository();
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    myProfile = widget.arguments!.myProfile;
    getFamilyMembers();

    return myProfile;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child: Scaffold(
//        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: mAppThemeProvider.primaryColor,
            elevation: 0,
            title: Text(
              CommonConstants.my_family_title,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 18.0.sp,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(context, router.rt_AddFamilyUserInfo,
                            arguments: AddFamilyUserInfoArguments(
                                //TODO we need to pass the logged in user id
                                isForFamilyAddition: false,
                                isFromAppointmentOrSlotPage: false,
                                id: widget
                                    .arguments!
                                    .profilesSharedByMe![_currentPage!]
                                    .child!
                                    .id,
                                sharedbyme: widget.arguments!
                                    .profilesSharedByMe![_currentPage!],
                                fromClass: CommonConstants.my_family,
                                isForFamily: false,
                                defaultrelationShips:
                                    relationShipResponseList.result!.isNotEmpty
                                        ? relationShipResponseList
                                            .result![0].referenceValueCollection
                                        : <RelationsShipModel>[]))
                        .then((value) {});
                  })
            ]),
        body: PageView(
            physics: ClampingScrollPhysics(),
            controller: PageController(
                initialPage: widget.arguments!.caregiverRequestor != null
                    ? 0
                    : _currentPage!,
                keepPage: false,
                viewportFraction: 1),
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: buildMyFamilDetailPages()),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicator(),
        ),
      ),
    );
  }

  List<Widget> buildMyFamilDetailPages() {
    var children = <Widget>[];
    if (widget.arguments!.caregiverRequestor != null) {
      if (profilesSharedByMeAry!.length > 0) {
        children.add(_showPageData(profilesSharedByMeAry![_currentPage!]));
      }
    } else {
      for (var i = 0; i < widget.arguments!.profilesSharedByMe!.length; i++) {
        children.add(_showPageData(widget.arguments!.profilesSharedByMe![i]));
      }
    }

    return children;
  }

  Widget _showPageData(SharedByUsers sharedbyme) {
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

    heightConroller = TextEditingController(text: '');
    heightInchConroller = TextEditingController(text: '');

    weightController = TextEditingController(text: '');

    cntrlr_addr_one = TextEditingController(text: '');
    cntrlr_addr_two = TextEditingController(text: '');
    cntrlr_addr_city = TextEditingController(text: '');
    cntrlr_addr_state = TextEditingController(text: '');
    cntrlr_addr_zip = TextEditingController(text: '');

    if (sharedbyme.child != null) {
      if (sharedbyme.child!.firstName != null &&
          sharedbyme.child!.lastName != null) {
        firstNameController.text =
            sharedbyme.child!.firstName!.capitalizeFirstofEach;
        if (sharedbyme.child!.middleName != null) {
          middleNameController.text =
              sharedbyme.child!.middleName!.capitalizeFirstofEach;
        }
        lastNameController.text =
            sharedbyme.child!.lastName!.capitalizeFirstofEach;
      }
    } else {
      firstNameController.text = sharedbyme.child!.name!;
      middleNameController.text = '';
      lastNameController.text = '';
    }

    if (sharedbyme.child?.isVirtualUser != null) {
      try {
        if (sharedbyme.child!.isVirtualUser!) {
          try {
            var myProf =
                PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) ??
                    PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
            if (myProf!.result!.userContactCollection3 != null) {
              if (myProf.result!.userContactCollection3!.isNotEmpty) {
                mobileNoController.text =
                    myProf.result!.userContactCollection3![0]!.phoneNumber!;
                emailController.text =
                    myProf.result!.userContactCollection3![0]!.email!;
              }
            }
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);

            if (sharedbyme.child!.isVirtualUser!) {
              mobileNoController.text =
                  myProfile!.result!.userContactCollection3![0]!.phoneNumber!;
              emailController.text =
                  myProfile!.result!.userContactCollection3![0]!.email!;
            } else {
              mobileNoController.text = '';
              emailController.text = '';
            }
          }
        } else {
          // this is non primary user
          if (sharedbyme.child!.userContactCollection3!.isNotEmpty) {
            mobileNoController.text =
                sharedbyme.child!.userContactCollection3![0].phoneNumber!;
            emailController.text =
                sharedbyme.child!.userContactCollection3![0].email!;
          }
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        if (sharedbyme.child!.isVirtualUser!) {
          mobileNoController.text =
              myProfile!.result!.userContactCollection3![0]!.phoneNumber!;
          emailController.text =
              myProfile!.result!.userContactCollection3![0]!.email!;
        } else {
          mobileNoController.text = '';
          emailController.text = '';
        }
      }
    } else {
      // this is non primary user
      if (sharedbyme.child!.userContactCollection3!.isNotEmpty) {
        mobileNoController.text =
            sharedbyme.child!.userContactCollection3![0].phoneNumber!;
        emailController.text =
            sharedbyme.child!.userContactCollection3![0].email!;
      }
    }

    if (sharedbyme.child?.additionalInfo != null) {
      if (sharedbyme.child?.additionalInfo?.heightObj != null) {
        isFeetOrInches = true;
        heightConroller.text =
            sharedbyme.child?.additionalInfo!.heightObj?.valueFeet ?? '';
        heightInchConroller.text =
            sharedbyme.child?.additionalInfo!.heightObj?.valueInches ?? '';
      } else {
        isFeetOrInches = false;

        heightConroller.text = sharedbyme.child?.additionalInfo!.height ?? '';
      }

      if (sharedbyme.child?.additionalInfo?.weightUnitCode == 'lb') {
        isKg = false;
      } else {
        isKg = true;
      }
      weightController.text =
          sharedbyme.child?.additionalInfo!.weight.toString() ?? '';
    } else {
      var preferredMeasurement = PreferenceUtil.getPreferredMeasurement(
          Constants.KEY_PREFERREDMEASUREMENT);

      if (preferredMeasurement != null) {
        try {
          if (preferredMeasurement.height?.unitCode ==
                  Constants.STR_VAL_HEIGHT_IND ||
              preferredMeasurement.height?.unitCode == STR_VAL_HEIGHT_IND_NEW) {
            isFeetOrInches = true;
          } else {
            isFeetOrInches = false;
          }

          if (preferredMeasurement.weight?.unitCode ==
              Constants.STR_VAL_WEIGHT_IND) {
            isKg = true;
          } else {
            isKg = false;
          }
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          if (CommonUtil.REGION_CODE == 'IN') {
            isFeetOrInches = true;
            isKg = true;
          } else {
            isFeetOrInches = true;
            isKg = false;
          }
        }
      }
    }

    if (CommonUtil().checkIfStringisNull(sharedbyme.child!.bloodGroup)) {
      //renameBloodGroup(sharedbyme.child.bloodGroup);
      final bloodGroup = sharedbyme.child!.bloodGroup!;
      bloodGroupController.text = bloodGroup.split(' ')[0];
      bloodRangeController.text = bloodGroup.split(' ')[1];
    }

    if (sharedbyme.child!.gender != null) {
      genderController.text =
          toBeginningOfSentenceCase(sharedbyme.child!.gender!.toLowerCase())!;
    }

    if (sharedbyme.relationship != null) {
      relationShipController.text = sharedbyme.relationship!.name!;
    }

    if (sharedbyme.child!.dateOfBirth != null) {
      if (CommonUtil.isUSRegion()) {
        dateOfBirthController.text = FHBUtils()
            .getFormattedDateOnly(sharedbyme.child!.dateOfBirth ?? "");
      } else {
        dateOfBirthController.text =
            FHBUtils().getFormattedDateOnlyNew(sharedbyme.child!.dateOfBirth)!;
      }
    }

    if (sharedbyme.child!.userAddressCollection3!.isNotEmpty) {
      cntrlr_addr_one.text =
          sharedbyme.child!.userAddressCollection3![0].addressLine1 ?? "";
      cntrlr_addr_two.text =
          sharedbyme.child!.userAddressCollection3![0].addressLine2 ?? "";
      cntrlr_addr_city.text =
          sharedbyme.child!.userAddressCollection3![0].city?.name ?? "";
      cntrlr_addr_state.text =
          sharedbyme.child!.userAddressCollection3![0].state?.name ?? "";
      cntrlr_addr_zip.text =
          sharedbyme.child!.userAddressCollection3![0].pincode ?? "";
    }

    if (sharedbyme.membershipOfferedBy != null &&
        sharedbyme.membershipOfferedBy != '') {
      cntrlr_corp_name.text = sharedbyme.membershipOfferedBy!;
    }

    final profilebanner =
        PreferenceUtil.getStringValue(Constants.KEY_PROFILE_BANNER);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30.0.h,
          ),
          InkWell(
              onTap: () {},
              child: Opacity(
                  opacity: 1,
                  child: ClipOval(
                    child: sharedbyme.child!.profilePicThumbnailUrl != null
                        ? Image.network(
                            sharedbyme.child!.profilePicThumbnailUrl!,
                            fit: BoxFit.cover,
                            width: 100.0.h,
                            height: 100.0.h,
                            headers: {
                              HttpHeaders.authorizationHeader:
                                  PreferenceUtil.getStringValue(
                                      Constants.KEY_AUTHTOKEN)!
                            },
                            errorBuilder: (context, exception, stackTrace) {
                              return Container(
                                height: 100.0.h,
                                width: 100.0.h,
                                color: Colors.grey[200],
                                child: Center(
                                  child: getFirstLastNameText(sharedbyme.child),
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 100.0.h,
                            height: 100.0.h,
                            color: mAppThemeProvider.primaryColor,
                            child: Center(
                              child: Text(
                                sharedbyme.child!.firstName != null
                                    ? sharedbyme.child!.firstName![0]
                                        .toUpperCase()
                                    : '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 60.0.sp,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ),
                  ))),
//          Container(
//              color: mAppThemeProvider.primaryColor,
//              height: expandedHeight,
//              child: Stack(
//                fit: StackFit.expand,
//                overflow: Overflow.visible,
//                children: [
//                  profilebanner != null
//                      ? Image.file(File(profilebanner),
//                          fit: BoxFit.cover, width: 100, height: 100)
//                      : Container(
//                          color: Colors.black.withOpacity(0.2),
//                        ),
//                  Positioned(
//                      top: expandedHeight - 50,
//                      left: 24, //1.sw / 4,
//                      child: InkWell(
//                          onTap: () {},
//                          child: Opacity(
//                              opacity: 1,
//                              child: ClipOval(
//                                child: sharedbyme
//                                            .child.profilePicThumbnailUrl !=
//                                        null
//                                    ? Image.network(
//                                        sharedbyme.child.profilePicThumbnailUrl,
//                                        fit: BoxFit.cover,
//                                        width: 100,
//                                        height: 100,
//                                        headers: {
//                                          HttpHeaders.authorizationHeader:
//                                              PreferenceUtil.getStringValue(
//                                                  Constants.KEY_AUTHTOKEN)
//                                        },
//                                      )
//                                    : Container(
//                                        width: 100,
//                                        height: 100,
//                                        color: Color(CommonUtil()
//                                            .getMyPrimaryColor()),
//                                        child: Center(
//                                          child: Text(
//                                            sharedbyme.child.firstName != null
//                                                ? sharedbyme.child.firstName[0]
//                                                    .toUpperCase()
//                                                : '',
//                                            style: TextStyle(
//                                              color: Colors.white,
//                                              fontSize: 60.0.sp,
//                                              fontWeight: FontWeight.w200,
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                              )))),
//                ],
//              )),
          SizedBox(height: 30.0.h),
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
          isFeetOrInches
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: showHeight(
                          heightConroller, CommonConstants.heightNameFeetInd),
                    ),
                    Expanded(
                      child: showHeight(heightInchConroller,
                          CommonConstants.heightNameInchInd),
                    ),
                    Expanded(
                      child: showWeight(),
                    )
                  ],
                )
              : Row(
                  children: <Widget>[
                    showHeight(heightConroller, CommonConstants.heightName),
                    showWeight(),
                  ],
                ),
          _showDateOfBirthTextField(),
          cntrlr_corp_name.text != ''
              ? Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 16.0.sp),
                    controller: cntrlr_corp_name,
                    enabled: false,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 16.0.sp),
                      labelText: CommonConstants.corpname,
                    ),
                  ),
                )
              : SizedBox(),

          _userAddressInfo(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: _showViewInsuranceButton(sharedbyme),
              ),
              Expanded(
                child: _showViewHospitalButton(sharedbyme),
              )
            ],
          ),
          SizedBox(height: 20.0.h),

//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: _buildPageIndicator(),
//          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    var list = <Widget>[];
    if (widget.arguments!.profilesSharedByMe != null) {
      list = <Widget>[];
      for (var i = 0; i < widget.arguments!.profilesSharedByMe!.length; i++) {
        list.add(i == _currentPage ? _indicator(true) : _indicator(false));
      }
    }

    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      height: 8.0.h,
      width: 8.0.h,
      decoration: BoxDecoration(
        color: isActive
            ? mAppThemeProvider.primaryColor
            : ColorUtils.greycolor,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  void renameBloodGroup(String selectedBloodGroupClone) {
    if (selectedBloodGroupClone != null) {
      final bloodGroupSplitName = selectedBloodGroupClone.split('_');

      try {
        if (bloodGroupSplitName.length > 1) {
          for (final bloodGroup in variable.bloodGroupArray) {
            if (bloodGroupSplitName[0] == bloodGroup) {
              selectedBloodGroup = bloodGroup;
              bloodGroupController.text = selectedBloodGroup!;
            }
          }

          for (var bloodRange in variable.bloodRangeArray) {
            if (bloodGroupSplitName[1] == bloodRange) {
              selectedBloodRange = bloodRange;
              bloodRangeController.text = selectedBloodRange!;
            }
          }
        } else {
          final bloodGroupSplitName = selectedBloodGroupClone.split(' ');
          if (bloodGroupSplitName.length > 1) {
            for (var bloodGroup in variable.bloodGroupArray) {
              if (bloodGroupSplitName[0] == bloodGroup) {
                selectedBloodGroup = bloodGroup;
                bloodGroupController.text = selectedBloodGroup!;
              }

              for (var bloodRange in variable.bloodRangeArray) {
                if (bloodGroupSplitName[1][0] == bloodRange) {
                  selectedBloodRange = bloodRange;
                  bloodRangeController.text = selectedBloodRange!;
                }
              }
            }
          } else {
            selectedBloodGroup = null;
            selectedBloodRange = null;
          }
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        selectedBloodGroup = null;
        selectedBloodRange = null;
      }
    }
  }

  Widget _showMobileNoTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          enabled: false,
          cursorColor: mAppThemeProvider.primaryColor,
          controller: mobileNoController,
          enableInteractiveSelection: false,
          keyboardType: TextInputType.text,
          focusNode: mobileNoFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(nameFocus);
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.mobile_number,
            hintText: CommonConstants.mobile_number,
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
          ),
        ));
  }

  Widget _showNameTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: mAppThemeProvider.primaryColor,
          controller: nameController,
          enabled: false,
          keyboardType: TextInputType.text,
//          focusNode: nameFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(relationShipFocus);
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.name,
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
          ),
        ));
  }

  Widget _showFirstNameTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: mAppThemeProvider.primaryColor,
          controller: firstNameController,
          enabled: false,
          keyboardType: TextInputType.text,
//          focusNode: nameFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(middleNameFocus);
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.firstName,
            hintText: CommonConstants.firstName,
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
          ),
        ));
  }

  Widget _showMiddleNameTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: mAppThemeProvider.primaryColor,
          controller: middleNameController,
          enabled: false,
          keyboardType: TextInputType.text,
//          focusNode: nameFocus,
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
          ),
        ));
  }

  Widget _showLastNameTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: mAppThemeProvider.primaryColor,
          controller: lastNameController,
          enabled: false,
          keyboardType: TextInputType.text,
//          focusNode: nameFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(relationShipFocus);
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.lastName,
            hintText: CommonConstants.lastName,
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
          ),
        ));
  }

  Widget _showRelationShipTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: mAppThemeProvider.primaryColor,
          controller: relationShipController,
          enabled: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(emailFocus);
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.relationship,
            hintText: CommonConstants.relationship,
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
          ),
        ));
  }

  Widget _showEmailAddTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: mAppThemeProvider.primaryColor,
          controller: emailController,
          enabled: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(genderFocus);
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.email_address_optional,
            hintText: CommonConstants.email_address_optional,
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
          ),
        ));
  }

  Widget _showGenderTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: mAppThemeProvider.primaryColor,
          controller: genderController,
          enabled: false,
          keyboardType: TextInputType.text,
          focusNode: genderFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(bloodGroupFocus);
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.gender,
            hintText: CommonConstants.gender,
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
          ),
        ));
  }

  Widget _showBloodGroupTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: Container(
            width: 1.sw / 2 - 40,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              cursorColor: mAppThemeProvider.primaryColor,
              controller: bloodGroupController,
              enabled: false,
              keyboardType: TextInputType.text,
              focusNode: bloodGroupFocus,
              textInputAction: TextInputAction.done,
              onSubmitted: (term) {
                FocusScope.of(context).requestFocus(bloodRangeFocus);
              },
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0.sp,
                  color: ColorUtils.blackcolor),
              decoration: InputDecoration(
                labelText: CommonConstants.blood_group,
                hintText: CommonConstants.blood_group,
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
                    borderSide:
                        BorderSide(color: ColorUtils.myFamilyGreyColor)),
              ),
            )));
  }

  Widget _showBloodRangeTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: Container(
            width: 1.sw / 2 - 40,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              cursorColor: mAppThemeProvider.primaryColor,
              controller: bloodRangeController,
              enabled: false,
              keyboardType: TextInputType.text,
              focusNode: bloodRangeFocus,
              textInputAction: TextInputAction.done,
              onSubmitted: (term) {
                FocusScope.of(context).requestFocus(dateOfBirthFocus);
              },
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0.sp,
                  color: ColorUtils.blackcolor),
              decoration: InputDecoration(
                labelText: 'Rh type',
                hintText: 'Rh type',
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
                    borderSide:
                        BorderSide(color: ColorUtils.myFamilyGreyColor)),
              ),
            )));
  }

  Widget showHeight(TextEditingController heightConroller, String labelText) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: Container(
            width: 1.sw / 2 - 40,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              cursorColor: mAppThemeProvider.primaryColor,
              controller: heightConroller,
              enabled: false,
              keyboardType: TextInputType.text,
              focusNode: heightFocus,
              textInputAction: TextInputAction.done,
              onSubmitted: (term) {
                FocusScope.of(context).requestFocus(bloodRangeFocus);
              },
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0.sp,
                  color: ColorUtils.blackcolor),
              decoration: InputDecoration(
                labelText: labelText,
                hintText: labelText,
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
                    borderSide:
                        BorderSide(color: ColorUtils.myFamilyGreyColor)),
              ),
            )));
  }

  Widget showWeight() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: Container(
            width: 1.sw / 2 - 40,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              cursorColor: mAppThemeProvider.primaryColor,
              controller: weightController,
              enabled: false,
              keyboardType: TextInputType.text,
              focusNode: weightFocus,
              textInputAction: TextInputAction.done,
              onSubmitted: (term) {
                FocusScope.of(context).requestFocus(dateOfBirthFocus);
              },
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0.sp,
                  color: ColorUtils.blackcolor),
              decoration: InputDecoration(
                labelText: isKg
                    ? CommonConstants.weight
                    : CommonConstants.weightNameUS,
                hintText: isKg
                    ? CommonConstants.weightName
                    : CommonConstants.weightNameUS,
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
                    borderSide:
                        BorderSide(color: ColorUtils.myFamilyGreyColor)),
              ),
            )));
  }

  Widget _showDateOfBirthTextField() {
    return GestureDetector(
      child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            cursorColor: mAppThemeProvider.primaryColor,
            controller: dateOfBirthController,
            readOnly: true,
            enabled: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onSubmitted: (term) {
              dateOfBirthFocus.unfocus();
            },
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
                color: ColorUtils.blackcolor),
            decoration: InputDecoration(
              suffixIcon: CommonUtil.isUSRegion()
                  ? IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {},
                    )
                  : null,
              labelText: CommonUtil.isUSRegion()
                  ? CommonConstants.date_of_birthWithStar
                  : CommonConstants.year_of_birth_with_star,
              hintText: CommonUtil.isUSRegion()
                  ? CommonConstants.date_of_birth
                  : CommonConstants.year_of_birth,
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
            ),
          )),
    );
  }

  Widget _showViewInsuranceButton(SharedByUsers sharedbyme) {
    final viewInsuranceButtonWithGesture = GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, router.rt_FamilyInsurance,
            arguments:
                MyFamilyDetailViewArguments(index: 0, sharedbyme: sharedbyme));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            width: 150.0.w,
            height: 40.0.h,
            decoration: BoxDecoration(
              color: mAppThemeProvider.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                CommonConstants.view_insurance,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return viewInsuranceButtonWithGesture;
  }

  Widget _showViewHospitalButton(SharedByUsers sharedbyme) {
    final viewHospitalButtonWithGesture = GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, router.rt_FamilyInsurance,
            arguments:
                MyFamilyDetailViewArguments(index: 1, sharedbyme: sharedbyme));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            width: 150.0.w,
            height: 40.0.h,
            decoration: BoxDecoration(
              color: mAppThemeProvider.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                CommonConstants.view_hospital,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0.sp,
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

  Future<void> getAllCustomRoles() async {
    addFamilyUserInfoRepository = AddFamilyUserInfoRepository();
    relationShipResponseList =
        await addFamilyUserInfoRepository.getCustomRoles();
    fetchUserProfileInfo();
  }

  Widget getRelationshipDetails(RelationShipResponseList data) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Container(
              width: 1.sw - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.relationship),
                value: selectedRelationShip,
                items: data.result!.map((relationShipDetail) {
                  return DropdownMenuItem(
                    value: relationShipDetail,
                    child: Text(relationShipDetail.name!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
                            color: ColorUtils.blackcolor)),
                  );
                }).toList(),
                onChanged: (dynamic newValue) {
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
          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Container(
              width: 1.sw - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.blood_group),
                value: selectedBloodGroup,
                items: variable.bloodGroupArray.map((eachBloodGroup) {
                  return DropdownMenuItem(
                    value: eachBloodGroup,
                    child: Text(eachBloodGroup,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
                            color: ColorUtils.blackcolor)),
                  );
                }).toList(),
                onChanged: (dynamic newValue) {
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
          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Container(
              width: 1.sw - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.blood_range),
                value: selectedBloodRange,
                items: variable.bloodRangeArray.map((eachBloodGroup) {
                  return DropdownMenuItem(
                    value: eachBloodGroup,
                    child: Text(eachBloodGroup,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
                            color: ColorUtils.blackcolor)),
                  );
                }).toList(),
                onChanged: (dynamic newValue) {
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
          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Container(
              width: 1.sw - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.gender),
                value: selectedGender != null
                    ? toBeginningOfSentenceCase(selectedGender!.toLowerCase())
                    : selectedGender,
                items: variable.genderArray.map((eachGender) {
                  return DropdownMenuItem(
                    child: Text(eachGender,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
                            color: ColorUtils.blackcolor)),
                    value: eachGender,
                  );
                }).toList(),
                onChanged: (dynamic newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
              )));
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light().copyWith(
            primary: mAppThemeProvider.primaryColor,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        dateTime = picked;
        dateOfBirthController.text =
            CommonUtil.dateConversionToApiFormat(dateTime);
      });
    }
  }

  void dateOfBirthTapped() {
    _selectDate(context);
  }

  Widget _userAddressInfo() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
              controller: cntrlr_addr_one,
              enabled: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 16.0.sp),
                labelText: CommonConstants.addr_line_1
                    .substring(0, CommonConstants.addr_line_1.length - 1),
              ),
              validator: (res) {
                return (res!.isEmpty || res == null)
                    ? 'Address line1 can\'t be empty'
                    : null;
              },
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
              controller: cntrlr_addr_two,
              enabled: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 16.0.sp),
                labelText: CommonConstants.addr_line_2
                    .substring(0, CommonConstants.addr_line_2.length - 1),
              ),
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
              controller: cntrlr_addr_city,
              enabled: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 16.0.sp),
                labelText: CommonConstants.addr_city
                    .substring(0, CommonConstants.addr_city.length - 1),
              ),
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
              controller: cntrlr_addr_state,
              enabled: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 16.0.sp),
                labelText: CommonConstants.addr_state
                    .substring(0, CommonConstants.addr_state.length - 1),
              ),
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
              controller: cntrlr_addr_zip,
              enabled: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 16.0.sp),
                  labelText: CommonUtil.REGION_CODE == 'IN'
                      ? CommonConstants.addr_pin
                      : CommonConstants.addr_zip
                  //.substring(0, CommonConstants.addr_zip.length - 1),
                  ),
              validator: (res) {
                return (res!.isEmpty || res == null)
                    ? 'Zip can\'t be empty'
                    : null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getFirstLastNameText(Child? myProfile) {
    if (myProfile != null &&
        myProfile.firstName != null &&
        myProfile.lastName != null) {
      return Text(
        myProfile.firstName![0].toUpperCase() +
            (myProfile.lastName!.length > 0
                ? myProfile.lastName![0].toUpperCase()
                : ''),
        style: TextStyle(
          color: mAppThemeProvider.primaryColor,
          fontSize: 28.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (myProfile != null && myProfile.firstName != null) {
      return Text(
        myProfile.firstName![0].toUpperCase(),
        style: TextStyle(
          color: mAppThemeProvider.primaryColor,
          fontSize: 28.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else {
      return Text(
        '',
        style: TextStyle(
          color: mAppThemeProvider.primaryColor,
          fontSize: 28.0.sp,
          fontWeight: FontWeight.w200,
        ),
      );
    }
  }
}
