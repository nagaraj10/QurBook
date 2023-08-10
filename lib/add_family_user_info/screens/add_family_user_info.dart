import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:myfhb/common/common_circular_indicator.dart';

import '../../src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../bloc/add_family_user_info_bloc.dart';
import '../models/CityListModel.dart';
import '../models/add_family_user_info_arguments.dart';
import '../models/address_result.dart';
import '../models/update_relatiosnship_model.dart';
import '../services/add_family_user_info_repository.dart';
import '../widget/address_type_widget.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../my_family/bloc/FamilyListBloc.dart';
import '../../my_family/models/FamilyMembersRes.dart';
import '../../my_family/models/RelationShip.dart';
import '../../my_family/models/relationship_response_list.dart';
import '../../my_family/models/relationships.dart';
import '../../my_providers/models/ProfilePicThumbnail.dart';
import '../../src/blocs/User/MyProfileBloc.dart';
import '../../src/model/common_response.dart';
import '../../src/model/user/AddressTypeModel.dart';
import '../../src/model/user/City.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/model/user/MyProfileResult.dart';
import '../../src/model/user/UserAddressCollection.dart';
//import 'package:myfhb/src/model/user/UserAddressCollection.dart';
import '../../src/model/user/city_list_model.dart';
import '../../src/model/user/state_list_model.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/ui/authentication/OtpVerifyScreen.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/utils/alert.dart';
import '../../src/utils/colors_utils.dart';

import '../../common/CommonConstants.dart';
import '../../src/model/user/State.dart' as stateObj;

class AddFamilyUserInfoScreen extends StatefulWidget {
  AddFamilyUserInfoArguments? arguments;

  AddFamilyUserInfoScreen({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return AddFamilyUserInfoScreenState();
  }
}

class AddFamilyUserInfoScreenState extends State<AddFamilyUserInfoScreen> {
  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();
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

  late AddFamilyUserInfoBloc addFamilyUserInfoBloc;
  final AddFamilyUserInfoRepository _addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();
  bool isCalled = false;
  List<RelationsShipModel>? relationShipResponseList;
  RelationsShipModel? selectedRelationShip;

  String? currentselectedBloodGroup;
  String? currentselectedBloodGroupRange;

  DateTime dateTime = DateTime.now();
  MyProfileModel? myProfile;

  List<int>? fetchedProfileData;

  String? selectedBloodGroup;
  String? selectedBloodRange;

  String? selectedGender;

  bool updateProfile = false;
  bool firstTym = true;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

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

  late var dialogContext;

  String strErrorMsg = '';
  CommonUtil commonUtil = CommonUtil();

  String? dateofBirthStr;
  PickedFile? imageURI;

  final double circleRadius = 100.0.h;
  final double circleBorderWidth = 2.0.w;

  final _formkey = GlobalKey<FormState>();

  String? city = '';
  String? state = '';
  String? currentUserID;
  static int count = 0;
  var currentSelectedProfilePic;

  //CityResult cityVal = new CityResult();
  City? cityVal = City();
  stateObj.State? stateVal = stateObj.State();

  AddressResult _addressResult = AddressResult();
  List<AddressResult> _addressList = [];
  String? addressTypeId;

  @override
  void initState() {
    super.initState();
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    PaintingBinding.instance!.imageCache!.clear();
    addFamilyUserInfoBloc = AddFamilyUserInfoBloc();
    try {
      /* if (PreferenceUtil.getFamilyRelationship(Constants.KEY_FAMILYREL) !=
          null) {
        setState(() {
          relationShipResponseList =
              PreferenceUtil.getFamilyRelationship(Constants.KEY_FAMILYREL);

          PreferenceUtil.saveRelationshipArray(
              Constants.KEY_FAMILYREL, relationShipResponseList);
          getSelectedRelation();
        });
      } else { */
      //getAllCustomRoles();
      relationShipResponseList = widget.arguments?.defaultrelationShips;
      if (widget.arguments?.sharedbyme?.relationship?.name != null) {
        selectedRelationShip = widget.arguments!.sharedbyme!.relationship;
      }
      // addFamilyUserInfoBloc.getCustomRoles().then((value) {
      //   setState(() {
      //     if (value.result[0] != null) {
      //       if (value.result[0].referenceValueCollection.isNotEmpty) {
      //         relationShipResponseList =
      //             value.result[0].referenceValueCollection;

      //         /*  PreferenceUtil.saveRelationshipArray(
      //               Constants.KEY_FAMILYREL, relationShipResponseList); */
      //         getSelectedRelation();
      //       }
      //     }
      //   });
      // });
      //}
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }

    /* if (widget.arguments.fromClass == CommonConstants.my_family) {
      /* for (var i = 0; i < relationShipResponseList?.length; i++) {
        if (relationShipResponseList[i].name ==
            widget.arguments.sharedbyme.relationship.name) {
          selectedRelationShip = relationShipResponseList[i];
        }
      } */
    } */
    var profilebanner =
        PreferenceUtil.getStringValue(Constants.KEY_PROFILE_BANNER);
    if (profilebanner != null) {
      MySliverAppBar.imageURIProfile = PickedFile(profilebanner);
    }

    if (widget.arguments!.fromClass == CommonConstants.my_family) {
      addFamilyUserInfoBloc.userId = widget
          .arguments!.sharedbyme!.id; //widget.arguments.addFamilyUserInfo.id;
      if (widget.arguments!.sharedbyme!.child!.isVirtualUser != null) {
        try {
          if (widget.arguments!.sharedbyme!.child!.isVirtualUser!) {
            var myProf = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
            if (myProf!.result!.userContactCollection3 != null) {
              if (myProf.result!.userContactCollection3!.isNotEmpty) {
                mobileNoController.text =
                    myProf.result!.userContactCollection3![0]!.phoneNumber!;
                emailController.text =
                    myProf.result!.userContactCollection3![0]!.email!;
              }
            }
          } else {
            //! this must be loook
            //  mobileNoController.text =
            //         myProf.result.userContactCollection3[0].phoneNumber;
            //     emailController.text =
            //         myProf.result.userContactCollection3[0].email;
          }
        } catch (e,stackTrace) {
          CommonUtil().appLogs(message: e,stackTrace:stackTrace);
          mobileNoController.text = '';
          emailController.text = '';
        }
      }
    }
    /* if (widget.arguments.fromClass == CommonConstants.user_update) {
      try {
        MyProfileModel myProf =
            PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
        mobileNoController.text =
            myProf.result.userContactCollection3[0].phoneNumber;
        emailController.text = myProf.result.userContactCollection3[0].email;
      } catch (e,stackTrace) {
        mobileNoController.text = '';
        emailController.text = '';
      }
    } else {
      // mobileNoController.text =
      //     widget.arguments.sharedbyme.profileData.phoneNumber;
      // emailController.text = widget.arguments.sharedbyme.profileData.email;
    } */

    if (widget.arguments!.sharedbyme != null) {
      if (widget.arguments!.sharedbyme!.child!.firstName != null) {
        firstNameController.text =
            widget.arguments!.sharedbyme!.child!.firstName ?? '';
        middleNameController.text =
            widget.arguments!.sharedbyme!.child!.middleName ?? '';
        lastNameController.text =
            widget.arguments!.sharedbyme!.child!.lastName ?? '';
      } else {
        firstNameController.text = '';
      }
      if (commonUtil.checkIfStringisNull(
          widget.arguments!.sharedbyme!.child!.bloodGroup)) {
        selectedBloodGroup = widget.arguments!.sharedbyme!.child!.bloodGroup;
        currentselectedBloodGroup =
            widget.arguments!.sharedbyme!.child!.bloodGroup!.split(' ')[0];
        currentselectedBloodGroupRange =
            widget.arguments!.sharedbyme!.child!.bloodGroup!.split(' ')[1];
        renameBloodGroup(selectedBloodGroup);
      } else {
        selectedBloodGroup = null;
        selectedBloodRange = null;
        currentselectedBloodGroup = null;
        currentselectedBloodGroupRange = null;
      }

      if (widget.arguments!.sharedbyme!.child!.gender != null) {
        selectedGender = widget.arguments!.sharedbyme!.child!.gender;
      }

      if (widget
          .arguments!.sharedbyme!.child!.userAddressCollection3!.isNotEmpty) {
        final currentAddress =
            widget.arguments!.sharedbyme!.child!.userAddressCollection3![0];
        cntrlr_addr_one.text = currentAddress.addressLine1!;
        cntrlr_addr_two.text = currentAddress.addressLine2!;
        cntrlr_addr_city.text = currentAddress.city!.name!;
        cntrlr_addr_state.text = currentAddress.state!.name!;
        cntrlr_addr_zip.text = currentAddress.pincode!;
        _addressResult = AddressResult(
            id: currentAddress.addressType!.id,
            code: currentAddress.addressType!.code,
            name: currentAddress.addressType!.name);

        cityVal = currentAddress.city;
        stateVal = currentAddress.state;
      }
      // else { //?this should be uncomment for testing
      //   _addressResult = AddressResult(
      //       id: '22f814a7-5b72-41aa-b5f7-7d2cd38d5da4',
      //       code: 'RESADD',
      //       name: 'Resident Address');
      // }

      if (widget.arguments!.sharedbyme!.child!.dateOfBirth != null) {
        dateofBirthStr = FHBUtils().getFormattedDateForUserBirth(
            widget.arguments!.sharedbyme!.child!.dateOfBirth!);
        dateOfBirthController.text = FHBUtils().getFormattedDateOnlyNew(
            widget.arguments!.sharedbyme!.child!.dateOfBirth)!;
      }
    } else if (widget.arguments!.fromClass == CommonConstants.user_update) {
      updateProfile = true;
      addFamilyUserInfoBloc.userId = widget.arguments!.myProfileResult!.id;

      if (widget.arguments!.fromClass == CommonConstants.user_update) {
        // MyProfileModel myProf =
        //     PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
        if (widget.arguments!.myProfileResult!.userContactCollection3 != null) {
          if (widget
              .arguments!.myProfileResult!.userContactCollection3!.isNotEmpty) {
            mobileNoController.text = widget.arguments!.myProfileResult!
                .userContactCollection3![0]!.phoneNumber!;
            emailController.text = widget
                .arguments!.myProfileResult!.userContactCollection3![0]!.email!;
          }
        }

        dateOfBirthController.text = FHBUtils().getFormattedDateOnlyNew(
            widget.arguments!.myProfileResult!.dateOfBirth)!;

        if (widget.arguments!.myProfileResult!.userAddressCollection3 != null &&
            widget.arguments!.myProfileResult!.userAddressCollection3!
                .isNotEmpty) {
          cntrlr_addr_one.text = widget.arguments!.myProfileResult!
              .userAddressCollection3![0].addressLine1!;
          cntrlr_addr_two.text = widget.arguments!.myProfileResult!
              .userAddressCollection3![0].addressLine2!;
          cntrlr_addr_city.text = widget.arguments!.myProfileResult!
              .userAddressCollection3![0].city!.name!;
          cntrlr_addr_state.text = widget.arguments!.myProfileResult!
              .userAddressCollection3![0].state!.name!;
          cntrlr_addr_zip.text = widget
              .arguments!.myProfileResult!.userAddressCollection3![0].pincode!;

          cityVal = widget
              .arguments!.myProfileResult!.userAddressCollection3![0].city;
          stateVal = widget
              .arguments!.myProfileResult!.userAddressCollection3![0].state;

          _addressResult = AddressResult(
              id: widget.arguments!.myProfileResult!.userAddressCollection3![0]
                  .addressType!.id,
              code: widget.arguments!.myProfileResult!
                  .userAddressCollection3![0].addressType!.code,
              name: widget.arguments!.myProfileResult!
                  .userAddressCollection3![0].addressType!.name);
        }
      }
      if (widget.arguments!.myProfileResult!.firstName != null) {
        firstNameController.text =
            widget.arguments!.myProfileResult!.firstName ?? '';
        middleNameController.text =
            widget.arguments!.myProfileResult!.middleName ?? '';
        lastNameController.text =
            widget.arguments!.myProfileResult!.lastName ?? '';
      }

      if (commonUtil
          .checkIfStringisNull(widget.arguments!.myProfileResult!.bloodGroup)) {
        selectedBloodGroup = widget.arguments!.myProfileResult!.bloodGroup;
        currentselectedBloodGroup =
            widget.arguments!.myProfileResult!.bloodGroup!.split(' ')[0];
        currentselectedBloodGroupRange =
            widget.arguments!.myProfileResult!.bloodGroup!.split(' ')[1];
        renameBloodGroup(selectedBloodGroup);
      } else {
        selectedBloodGroup = null;
        selectedBloodRange = null;
        currentselectedBloodGroupRange = null;
        currentselectedBloodGroup = null;
      }

      if (widget.arguments!.myProfileResult!.gender != null) {
        selectedGender = widget.arguments!.myProfileResult!.gender;
      }

      if (widget.arguments!.myProfileResult!.dateOfBirth != null) {
        // List<String> list = widget.arguments.sharedbyme.child.dateOfBirth
        //     .split("T"); //by space" " the string need to splited

        // dateOfBirthController.text = list[0];
        dateofBirthStr = FHBUtils().getFormattedDateForUserBirth(
            widget.arguments!.myProfileResult!.dateOfBirth!);
        dateOfBirthController.text = FHBUtils().getFormattedDateOnlyNew(
            widget.arguments!.myProfileResult!.dateOfBirth)!;
      }
      if (firstTym) {
        firstTym = false;
        setState(() {
          // fetchedProfileData = widget
          //             .arguments.sharedbyme.child.profilePicThumbnailUrl !=
          //         null
          //     ? widget.arguments.sharedbyme.child.profilePicThumbnailUrl.data
          //     : null;
        });
      }
    } else {
      addFamilyUserInfoBloc.userId = widget.arguments!.addFamilyUserInfo!.id;
      addFamilyUserInfoBloc.getMyProfileInfo().then((value) {
        myProfile = value;

        if (widget.arguments!.isPrimaryNoSelected!) {
          final myProf =
              PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
          mobileNoController.text =
              myProf!.result!.userContactCollection3![0]!.phoneNumber!;
          emailController.text =
              myProf.result!.userContactCollection3![0]!.email!;
        } else {
          mobileNoController.text =
              value!.result!.userContactCollection3![0]!.phoneNumber!;
          emailController.text =
              value.result!.userContactCollection3![0]!.email!;
        }

        firstNameController.text = widget.arguments!.enteredFirstName!;
        middleNameController.text = widget.arguments!.enteredMiddleName!;
        lastNameController.text = widget.arguments!.enteredLastName!;

        relationShipController.text = widget.arguments!.relationShip!.name!;

        if (commonUtil.checkIfStringisNull(value!.result!.bloodGroup)) {
          selectedBloodGroup = value.result!.bloodGroup;
          currentselectedBloodGroup = value.result!.bloodGroup!.split(' ')[0];
          currentselectedBloodGroupRange =
              value.result!.bloodGroup!.split(' ')[1];
          renameBloodGroup(selectedBloodGroup);
        } else {
          selectedBloodGroup = null;
          selectedBloodRange = null;
          currentselectedBloodGroup = null;
          currentselectedBloodGroupRange = null;
        }
        selectedGender = value.result!.gender == null
            ? null
            : toBeginningOfSentenceCase(value.result!.gender!.toLowerCase());

        dateofBirthStr = value.result!.dateOfBirth != null
            ? FHBUtils()
                .getFormattedDateForUserBirth(value.result!.dateOfBirth!)
            : '';
        dateOfBirthController.text = value.result!.dateOfBirth != null
            ? FHBUtils().getFormattedDateOnlyNew(value.result!.dateOfBirth)!
            : '';

        if (firstTym) {
          firstTym = false;
          setState(() {
            // if (widget.arguments.sharedbyme != null) {
            //   if (widget.arguments.sharedbyme.profileData != null) {
            //     fetchedProfileData = widget
            //         .arguments.sharedbyme.profileData.profilePicThumbnail.data;
            //   }
            // }
          });
        }
      });
    }
  }

  void renameBloodGroup(String? selectedBloodGroupClone) {
    if (selectedBloodGroupClone != null) {
      final bloodGroupSplitName = selectedBloodGroupClone.split('_');
      try {
        if (bloodGroupSplitName.length > 1) {
          for (var bloodGroup in variable.bloodGroupArray) {
            if (bloodGroupSplitName[0] == bloodGroup) {
              selectedBloodGroup = bloodGroup;
            }
          }

          for (var bloodRange in variable.bloodRangeArray) {
            if (bloodGroupSplitName[1] == bloodRange) {
              selectedBloodRange = bloodRange;
            }
          }
        } else {
          final bloodGroupSplitName = selectedBloodGroupClone.split(' ');
          if (bloodGroupSplitName.length > 1) {
            for (final bloodGroup in variable.bloodGroupArray) {
              if (bloodGroupSplitName[0] == bloodGroup) {
                selectedBloodGroup = bloodGroup;
              }

              for (var bloodRange in variable.bloodRangeArray) {
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
      } catch (e,stackTrace) {
        CommonUtil().appLogs(message: e,stackTrace:stackTrace);
        selectedBloodGroup = null;
        selectedBloodRange = null;
      }
    }
  }

  getUserProfileData() async {
    var _myProfileBloc = MyProfileBloc();
    var _familyListBloc = FamilyListBloc();

    await _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
          .then((value) {
        _familyListBloc.getFamilyMembersListNew().then((value) {
          PreferenceUtil.saveFamilyData(
                  Constants.KEY_FAMILYMEMBER, value.result)
              .then((value) {
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

            Navigator.pop(context);
            /* Navigator.popUntil(context, (Route<dynamic> route) {
            bool shouldPop = false;
            if (route.settings.name == router.rt_UserAccounts) {
              shouldPop = true;
            }
            return shouldPop;
          });*/
          });
        });
      });
    });
  }

  // Future<CommonResponse> getMyProfilePicFromRemote(String userId) async {
  //   CommonResponse response =
  //       await _addFamilyUserInfoRepository.getUserProfilePic(userId);
  //   return response;
  // }

  Future<void> setMyProfilePic(String userId, File image) async {
    final response =
        await _addFamilyUserInfoRepository.updateUserProfilePic(userId, image);
    if (response.isSuccess!) {
      FlutterToast().getToast(response.message!, Colors.green);
    } else {
      FlutterToast().getToast(response.message!, Colors.red);
    }
  }

  Widget showProfileImageNew() {
    if (widget.arguments!.fromClass == CommonConstants.my_family) {
      currentUserID = widget.arguments!.sharedbyme!.child!.id;
      return FutureBuilder<CommonResponse>(
        future: _addFamilyUserInfoRepository
            .getUserProfilePic(widget.arguments!.sharedbyme!.child!.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isSuccess! && snapshot.data?.result != null) {
              return Image.network(
                snapshot.data!.result!,
                fit: BoxFit.cover,
                width: 60.0.h,
                height: 60.0.h,
                headers: {
                  HttpHeaders.authorizationHeader:
                      PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!,
                },
              );
            } else {
              return Center(
                child: Text(
                  widget.arguments!.sharedbyme!.child!.firstName != null
                      ? widget.arguments!.sharedbyme!.child!.firstName![0]
                          .toUpperCase()
                      : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.0.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CommonCircularIndicator();
          } else {
            return Center(
              child: Text(
                widget.arguments!.sharedbyme!.child!.firstName != null
                    ? widget.arguments!.sharedbyme!.child!.firstName![0]
                        .toUpperCase()
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0.sp,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }
        },
      );
    } else if (widget.arguments!.fromClass == CommonConstants.user_update) {
      currentUserID = widget.arguments!.myProfileResult!.id;
      return FutureBuilder<CommonResponse>(
        future: _addFamilyUserInfoRepository
            .getUserProfilePic(widget.arguments!.myProfileResult!.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isSuccess! && snapshot.data?.result != null) {
              return Image.network(
                snapshot.data!.result!,
                fit: BoxFit.cover,
                width: 60.0.h,
                height: 60.0.h,
                headers: {
                  HttpHeaders.authorizationHeader:
                      PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!,
                  Constants.KEY_OffSet: CommonUtil().setTimeZone()
                },
              );
            } else {
              return Center(
                child: Text(
                  widget.arguments!.myProfileResult!.firstName != null
                      ? widget.arguments!.myProfileResult!.firstName![0]
                          .toUpperCase()
                      : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.0.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CommonCircularIndicator();
          } else {
            return Center(
              child: Text(
                widget.arguments!.myProfileResult!.firstName != null
                    ? widget.arguments!.myProfileResult!.firstName![0]
                        .toUpperCase()
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0.sp,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }
        },
      );
    } else {
      currentUserID = widget.arguments!.addFamilyUserInfo!.id;
      return FutureBuilder<CommonResponse>(
        future: _addFamilyUserInfoRepository
            .getUserProfilePic(widget.arguments!.addFamilyUserInfo!.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isSuccess! && snapshot.data?.result != null) {
              return Image.network(
                snapshot.data!.result!,
                fit: BoxFit.cover,
                width: 60.0.h,
                height: 60.0.h,
                headers: {
                  HttpHeaders.authorizationHeader:
                      PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!,
                },
              );
            } else {
              return Center(
                child: Text(
                  widget.arguments!.enteredFirstName != null
                      ? widget.arguments!.enteredFirstName![0].toUpperCase()
                      : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.0.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CommonCircularIndicator();
          } else {
            return Center(
              child: Text(
                widget.arguments!.enteredFirstName != null
                    ? widget.arguments!.enteredFirstName![0].toUpperCase()
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0.sp,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }
        },
      );
    }
  }

  /* Widget showProfileImage() {
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
                  fontSize: 60.0.sp,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
    } else {
      if (imageURI == null) {
        if (widget.arguments.sharedbyme != null) {
          if (widget.arguments.sharedbyme.child.profilePicThumbnailUrl !=
              null) {
            return Image.network(
              widget.arguments.sharedbyme.child.profilePicThumbnailUrl,
              fit: BoxFit.cover,
              width: 60.0.h,
              height: 60.0.h,
              headers: {
                HttpHeaders.authorizationHeader:
                    PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)
              },
            );
          } else {
            return Center(
              child: Text(
                widget.arguments.sharedbyme.child.firstName != null
                    ? widget.arguments.sharedbyme.child.firstName[0]
                        .toUpperCase()
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0.sp,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }
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
  } */

  Widget getProfilePicWidget(ProfilePicThumbnail profilePicThumbnail) {
    return profilePicThumbnail != null
        ? Image.memory(
            Uint8List.fromList(profilePicThumbnail.data!),
            height: 30.0.h,
            width: 30.0.h,
            fit: BoxFit.cover,
          )
        : Container(
            color: Color(fhbColors.bgColorContainer),
            height: 30.0.h,
            width: 30.0.h,
          );
  }

  saveMediaDialog(BuildContext cont) {
    var userId = currentUserID;
    return showDialog(
      context: cont,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: Text(
                variable.makeAChoice,
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        var image = await ImagePicker.platform
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imageURI = image;
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        variable.Gallery,
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);

                        var image = await ImagePicker.platform
                            .pickImage(source: ImageSource.camera);
                        if (image != null) {
                          imageURI = image;
                          await setMyProfilePic(userId!, File(imageURI!.path));
                        }
                      },
                      child: Text(variable.Camera),
                    ),
                  ],
                ),
              ));
        });
      },
    ).then((value) {
      setState(() {});
      setMyProfilePic(userId!, File(imageURI!.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    count = count + 1;
    print('build is called $count times');
    dialogContext = context;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return Future.value(true);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )),
        key: scaffold_state,
        body: SingleChildScrollView(
          child: Stack(alignment: Alignment.topCenter, children: <Widget>[
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: circleRadius / 2.0),
                          child: Container(
                            color: Color(CommonUtil().getMyPrimaryColor()),
                            height: 160.0.h,
                            child: Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
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
                                color: Color(CommonUtil().getMyPrimaryColor())),
                            child: Padding(
                              padding: EdgeInsets.all(circleBorderWidth),
                              child: InkWell(
                                onTap: () {
                                  saveMediaDialog(context);
                                },
                                child: ClipOval(
                                    child: (imageURI != null && imageURI != '')
                                        ? Image.file(
                                            File(imageURI!.path),
                                            fit: BoxFit.cover,
                                            width: 60.0.h,
                                            height: 60.0.h,
                                          )
                                        : showProfileImageNew()),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _showMobileNoTextField(),
                    _showFirstNameTextField(),
                    _showMiddleNameTextField(),
                    _showLastNameTextField(),
                    //_showRelationShipTextField(),
                    if (widget.arguments!.fromClass ==
                        CommonConstants.my_family)
                      relationShipResponseList!.isNotEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: getRelationshipDetails(
                                      relationShipResponseList!),
                                )
                              ],
                            )
                          : _showRelationShipTextField()
                    else
                      widget.arguments!.fromClass == CommonConstants.user_update
                          ? new Container()
                          : _showRelationShipTextField(),
                    _showEmailAddTextField(),
                    Row(
                      children: <Widget>[Expanded(child: getGenderDetails())],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child: getBloodGroupDetails()),
                        Expanded(child: getBloodRangeDetails())
                      ],
                    ),
                    _showDateOfBirthTextField(),
                    AddressTypeWidget(
                      addressResult: _addressResult,
                      addressList: _addressList,
                      onSelected: (addressResult, addressList) {
                        setState(() {
                          _addressResult = addressResult!;
                          addressTypeId = addressResult.id;
                          _addressList = addressList!;
                        });
                      },
                    ),
                    _userAddressInfo(),
                    _showSaveButton()
                  ]),
            )
          ]),
        ),
      ),
    );
  }

  // 1
  Widget _showMobileNoTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          enabled: false,
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
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
            labelText: CommonConstants.mobile_numberWithStar,
            hintText: CommonConstants.mobile_number,
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

  // 2
  Widget _showNameTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
          controller: nameController,
          enabled: (widget.arguments!.fromClass == CommonConstants.my_family ||
                  widget.arguments!.fromClass == CommonConstants.user_update)
              ? true
              : false,
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

  // 3
  Widget _showRelationShipTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          onTap: () {
            /*  widget.arguments.fromClass == CommonConstants.my_family
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
                            : _showRelationShipTextField(), */
          },
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
          controller: relationShipController,
          enabled: widget.arguments!.fromClass == CommonConstants.my_family
              ? true
              : false,
          keyboardType: TextInputType.text,
          //          focusNode: relationShipFocus,
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

  // 4
  Widget _showEmailAddTextField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Color(CommonUtil().getMyPrimaryColor()),
            controller: emailController,
            enabled: widget.arguments!.fromClass == CommonConstants.user_update
                ? true
                : false,
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
          //                     fontSize: 15.0.sp,
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
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
          controller: genderController,
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

  // 6
  Widget _showBloodGroupTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
          controller: bloodGroupController,
          keyboardType: TextInputType.text,
          focusNode: bloodGroupFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(dateOfBirthFocus);
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.blood_group,
            hintText: CommonConstants.blood_group,
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

  // 7
  Widget _showDateOfBirthTextField() {
    return GestureDetector(
      onTap: dateOfBirthTapped,
      child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Color(CommonUtil().getMyPrimaryColor()),
            controller: dateOfBirthController,
            readOnly: true,
            keyboardType: TextInputType.text,
            //          focusNode: dateOfBirthFocus,
            textInputAction: TextInputAction.done,
            onSubmitted: (term) {
              dateOfBirthFocus.unfocus();
            },
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
                color: ColorUtils.blackcolor),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  size: 24.0.sp,
                ),
                onPressed: () {
                  _selectDate(context);
                },
              ),
              labelText: CommonConstants.year_of_birth,
              hintText: CommonConstants.year_of_birth,
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
          )),
    );
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
              enabled: true,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 16.0.sp,
                ),
                labelText: CommonConstants.addr_line_1,
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
              enabled: true,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 16.0.sp,
                ),
                labelText: CommonConstants.addr_line_2,
              ),
            ),
            TypeAheadFormField<City>(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: cntrlr_addr_city,
                  decoration: InputDecoration(
                    hintText: 'City',
                    labelText: 'City',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 16.0.sp,
                    ),
                  )),
              suggestionsCallback: (pattern) async {
                if (pattern.length >= 3) {
                  return await (getCitybasedOnSearch(
                    pattern,
                    'city',
                  ) as FutureOr<Iterable<City>>);
                } else {
                  return [];
                }
              }, //as FutureOr<Iterable<City>> Function(String), // FUcrash
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    suggestion.name!,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                    ),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                cntrlr_addr_city.text = suggestion.name!;
                cityVal = suggestion;
                //stateVal = suggestion.state;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please select a city';
                }
                return null;
              },
              onSaved: (value) => city = value,
            ),
            /* TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: cntrlr_addr_state,
              enabled: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 14.0.sp,),
                labelText: CommonConstants.addr_state,
              ),
              validator: (res) {
                return (res.isEmpty || res == null)
                    ? 'State can\'t be empty'
                    : null;
              },
            ),*/
            TypeAheadFormField<stateObj.State>(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: cntrlr_addr_state,
                  decoration: InputDecoration(
                    hintText: 'State',
                    labelText: 'State',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 16.0.sp,
                    ),
                  )),
              suggestionsCallback: (pattern) async {
                if (pattern.length >= 3) {
                  return await (getStateBasedOnSearch(
                    pattern,
                    'state',
                  ) as FutureOr<Iterable<stateObj.State>>);
                } else {
                  return [];
                }
              }, //as FutureOr<Iterable<stateObj.State>> Function(String),// FUcrash
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.name!),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                cntrlr_addr_state.text = suggestion.name!;
                stateVal = suggestion;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please select a State';
                }
                return null;
              },
              onSaved: (value) => state = value,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
              controller: cntrlr_addr_zip,
              enabled: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 16.0.sp,
                ),
                labelText: CommonConstants.addr_zip,
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

  Widget _showSaveButton() {
    final addButtonWithGesture = GestureDetector(
      onTap: _saveBtnTapped,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            width: 150.0.w,
            height: 40.0.h,
            decoration: BoxDecoration(
              color: Color(CommonUtil().getMyPrimaryColor()),
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
                (widget.arguments!.fromClass == CommonConstants.my_family ||
                        widget.arguments!.fromClass ==
                            CommonConstants.user_update)
                    ? CommonConstants.update
                    : CommonConstants.save,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  Widget getAllCustomRoles() {
    late Widget familyWidget;

    return StreamBuilder<ApiResponse<RelationShipResponseList>>(
      stream: addFamilyUserInfoBloc.relationShipStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              break;

            case Status.ERROR:
              familyWidget = Center(
                  child: Text(Constants.STR_ERROR_LOADING_DATA,
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              isCalled = true;
              // relationShipResponseList =
              //     snapshot.data.data.result[0].referenceValueCollection;
              setState(() {
                relationShipResponseList =
                    snapshot.data!.data!.result![0].referenceValueCollection;
              });

              // if (widget.arguments.fromClass == CommonConstants.my_family) {
              //   for (var i = 0;
              //       i <
              //           snapshot.data.data.result[0].referenceValueCollection
              //               .length;
              //       i++) {
              //     if (snapshot.data.data.result[0].name ==
              //         widget.arguments.sharedbyme.relationship.name) {
              //       selectedRelationShip =
              //           snapshot.data.data.result[0].name;
              //     }
              //   }
              // }

              //familyWidget = getRelationshipDetails(relationShipResponseList);
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
    var currentSelectedUserRole = data[0];
    for (var model in data) {
      if (model.id == selectedRelationShip!.id) {
        currentSelectedUserRole = model;
      }
    }
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: DropdownButton<RelationsShipModel>(
        hint: Text(CommonConstants.relationship),
        isExpanded: true,
        value: currentSelectedUserRole,
        items: data.map((val) {
          return DropdownMenuItem<RelationsShipModel>(
            value: val,
            child: Text(val.name!),
          );
        }).toList(),
        onChanged: (newSelectedValue) {
          setState(() {
            selectedRelationShip = newSelectedValue;
          });
        },
      ),
    );

    /* return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: Container(
              width: 1.sw - 40,
              child: DropdownButton<RelationsShipModel>(
                isExpanded: true,
                hint: Text(CommonConstants.relationship),

                value: selectedRelationShip != null ? selectedRelationShip : null,
                /* items: data.map((relationShipDetail) {
                  return DropdownMenuItem<RelationsShipModel>(
                    child: new Text(relationShipDetail.name,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
                            color: ColorUtils.blackcolor)),
                    value:
                        relationShipDetail != null ? relationShipDetail : 'helloo',
                  );
                }).toList(), */
                items: [
                  //DropdownMenuItem(child: Text(data[0].name),value: data[0],)
                ],
                onChanged: (newValue) {
                  setState(() {
                    selectedRelationShip = newValue;
                  });
                },
              )));
    }); */
  }

  Widget getBloodGroupDetails() {
    String? bgGroup = variable.bloodGroupArray[0];
    for (final bg in variable.bloodGroupArray) {
      if (bg == currentselectedBloodGroup) {
        bgGroup = currentselectedBloodGroup;
      }
    }
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Container(
        width: 1.sw / 2 - 40,
        child: DropdownButton<String>(
          hint: Text(CommonConstants.blood_groupWithStar),
          value: bgGroup,
          items: variable.bloodGroupArray.map((eachBloodGroup) {
            return DropdownMenuItem<String>(
              child: Text(eachBloodGroup,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0.sp,
                      color: ColorUtils.blackcolor)),
              value: eachBloodGroup,
            );
          }).toList(),
          onChanged: (newSelectedValue) {
            setState(() {
              currentselectedBloodGroup = newSelectedValue;
            });
          },
        ),
      ),
    );

    /* return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: Container(
              width: 1.sw / 2 - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.blood_groupWithStar),
                value: selectedBloodGroup,
                items: variable.bloodGroupArray.map((eachBloodGroup) {
                  return DropdownMenuItem(
                    child: new Text(eachBloodGroup,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
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
    }); */
  }

  Widget getBloodRangeDetails() {
    String? bgGroupRange = variable.bloodRangeArray[0];
    for (var bg in variable.bloodRangeArray) {
      if (bg == currentselectedBloodGroupRange) {
        bgGroupRange = currentselectedBloodGroupRange;
      }
    }
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Container(
        width: 1.sw / 2 - 40,
        child: DropdownButton<String>(
          hint: Text(CommonConstants.blood_rangeWithStar),
          isExpanded: true,
          value: bgGroupRange,
          items: variable.bloodRangeArray.map((eachBloodGroup) {
            return DropdownMenuItem<String>(
              value: eachBloodGroup,
              child: new Text(eachBloodGroup,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0.sp,
                      color: ColorUtils.blackcolor)),
            );
          }).toList(),
          onChanged: (newSelectedValue) {
            setState(() {
              currentselectedBloodGroupRange = newSelectedValue;
            });
          },
        ),
      ),
    );

    /* return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: Container(
              width: 1.sw / 2 - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.blood_rangeWithStar),
                value: selectedBloodRange,
                items: variable.bloodRangeArray.map((eachBloodGroup) {
                  return DropdownMenuItem(
                    child: new Text(eachBloodGroup,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
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
    }); */
  }

  Widget getGenderDetails() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Container(
        width: 1.sw - 40,
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(CommonConstants.genderWithStar),
          value: selectedGender != null
              ? selectedGender!.toLowerCase() != null
                  ? toBeginningOfSentenceCase(selectedGender!.toLowerCase())
                  : selectedGender
              : null,
          items: variable.genderArray.map((eachGender) {
            return DropdownMenuItem(
              value: eachGender,
              child: new Text(eachGender,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0.sp,
                      color: ColorUtils.blackcolor)),
            );
          }).toList(),
          onChanged: (newSelectedValue) {
            setState(() {
              selectedGender = newSelectedValue;
            });
          },
        ),
      ),
    );

    /* return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: Container(
              width: 1.sw - 40,
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
                            fontSize: 16.0.sp,
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
    }); */
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1940),
        lastDate: DateTime.now());

    if (picked != null) {
      setState(() {
        dateTime = picked;

        dateofBirthStr =
            FHBUtils().getFormattedDateForUserBirth(dateTime.toString());
        dateOfBirthController.text =
            FHBUtils().getFormattedDateOnlyNew(dateTime.toString())!;
      });
    }
  }

  void _saveBtnTapped() {
    FHBUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        //address fields validation
        if (_formkey.currentState!.validate()) {
          /* addFamilyUserInfoBloc.name = firstNameController.text;
          addFamilyUserInfoBloc.email = emailController.text;
          if (selectedGender != null) {
            addFamilyUserInfoBloc.gender =
                toBeginningOfSentenceCase(selectedGender.toLowerCase());
          }

          addFamilyUserInfoBloc.dateOfBirth = dateofBirthStr;

          if (selectedBloodGroup != null && selectedBloodRange != null) {
            addFamilyUserInfoBloc.bloodGroup =
                selectedBloodGroup + '' + selectedBloodRange;
          }

          addFamilyUserInfoBloc.profilePic = imageURI;

          addFamilyUserInfoBloc.firstName = firstNameController.text;
          addFamilyUserInfoBloc.middleName = middleNameController.text;
          addFamilyUserInfoBloc.lastName = lastNameController.text;

          addFamilyUserInfoBloc.profileBanner = MySliverAppBar.imageURIProfile;

          addFamilyUserInfoBloc.addressLine1 = cntrlr_addr_one.text;
          addFamilyUserInfoBloc.addressLine2 = cntrlr_addr_two.text;
          addFamilyUserInfoBloc.stateId = stateVal.id;
          addFamilyUserInfoBloc.cityId = cityVal.id;
          addFamilyUserInfoBloc.zipcode = cntrlr_addr_zip.text;

          MyProfileModel myProf =
              PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

          MyProfileResult profileResult = myProf.result;
          profileResult.firstName = firstNameController.text;
          profileResult.middleName = middleNameController.text;
          profileResult.lastName = lastNameController.text;

          if (selectedBloodGroup != null && selectedBloodRange != null) {
            profileResult.bloodGroup =
                selectedBloodGroup + ' ' + selectedBloodRange;
          }
          profileResult.userAddressCollection3[0].pincode =
              cntrlr_addr_zip.text;
          profileResult.userAddressCollection3[0].addressLine1 =
              cntrlr_addr_one.text;
          profileResult.userAddressCollection3[0].addressLine2 =
              cntrlr_addr_two.text;
          profileResult.userAddressCollection3[0].isPrimary= true;
          profileResult.userAddressCollection3[0].isActive= true;
          profileResult.userAddressCollection3[0].createdOn= '';
          profileResult.userAddressCollection3[0].lastModifiedOn= '';
          profileResult.userAddressCollection3[0].createdBy= '';

          profileResult.userAddressCollection3[0].state = stateVal;
          profileResult.userAddressCollection3[0].city = new City(
              id: cityVal.id,
              isActive: cityVal.isActive,
              name: cityVal.name,
              createdOn: cityVal.createdOn,
              lastModifiedOn: cityVal.lastModifiedOn);

          profileResult.dateOfBirth = dateOfBirthController.text;
          addFamilyUserInfoBloc.myProfileModel = myProf; */

          var _familyListBloc = FamilyListBloc();
          //NOTE this would be called when family member profile update
          if (widget.arguments!.fromClass == CommonConstants.my_family) {
            addFamilyUserInfoBloc.userId = widget.arguments!.id;
            addFamilyUserInfoBloc.phoneNo = mobileNoController.text;
            addFamilyUserInfoBloc.relationship = UpdateRelationshipModel(
                id: widget.arguments!.sharedbyme!.id,
                relationship: selectedRelationShip);

            var myProf = MyProfileModel();

            var profileResult = MyProfileResult();
            profileResult.firstName = firstNameController.text;
            profileResult.middleName = middleNameController.text;
            profileResult.lastName = lastNameController.text;
            profileResult.dateOfBirth = dateOfBirthController.text;
            profileResult.id = widget.arguments!.id;
            profileResult.isIeUser = false;
            profileResult.isCpUser = false;
            profileResult.isSignedIn = false;
            profileResult.isActive = true;
            profileResult.gender = selectedGender;
            // profileResult.createdBy=null;
            // profileResult.createdOn=null;
            profileResult.lastModifiedBy = null;
            profileResult.lastModifiedOn = null;

            if (currentselectedBloodGroup != null &&
                currentselectedBloodGroupRange != null) {
              profileResult.bloodGroup = currentselectedBloodGroup! +
                  ' ' +
                  currentselectedBloodGroupRange!;
            }
            final userAddressCollection3 = UserAddressCollection3();
            addFamilyUserInfoBloc.isUpdate = true;
            if (widget.arguments!.sharedbyme!.child!.userAddressCollection3!
                .isNotEmpty) {
              userAddressCollection3.id = widget
                  .arguments!.sharedbyme!.child!.userAddressCollection3![0].id;
              userAddressCollection3.addressLine1 = cntrlr_addr_one.text;
              userAddressCollection3.addressLine2 = cntrlr_addr_two.text;
              userAddressCollection3.pincode = cntrlr_addr_zip.text;
              userAddressCollection3.city = cityVal;
              userAddressCollection3.state = stateVal;
            }

            userAddressCollection3.isPrimary = true;
            userAddressCollection3.isActive = true;
            userAddressCollection3.createdOn =
                CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now());
            userAddressCollection3.lastModifiedOn = null;
            userAddressCollection3.createdBy = widget.arguments!.id;

            _addressResult ??= _addressList[0];
            userAddressCollection3.addressType = AddressType(
              id: _addressResult.id,
              code: _addressResult.code,
              name: _addressResult.name,
              description: _addressResult.name,
              isActive: true,
              createdBy: PreferenceUtil.getStringValue(Constants.KEY_USERID),
              createdOn:
                  CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now()),
            );

            final List<UserAddressCollection3> userAddressCollection3List = [];
            userAddressCollection3List.add(userAddressCollection3);
            profileResult.userAddressCollection3 = userAddressCollection3List;

            myProf.result = profileResult;
            addFamilyUserInfoBloc.myProfileModel = myProf;

            if (doValidation()) {
              if (addFamilyUserInfoBloc.profileBanner != null) {
                PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
                    addFamilyUserInfoBloc.profileBanner!.path);
              }
              CommonUtil.showLoadingDialog(
                  dialogContext, _keyLoader, variable.Please_Wait); //

              addFamilyUserInfoBloc.updateSelfProfile(false).then((value) {
                if (value != null && value.isSuccess!) {
                  _familyListBloc.getFamilyMembersListNew().then((value) {
                    PreferenceUtil.saveFamilyData(
                            Constants.KEY_FAMILYMEMBER, value.result)
                        .then((value) {
                      //saveProfileImage();
                      MySliverAppBar.imageURI = null;
                      fetchedProfileData = null;
                      imageURI = null;
                      Navigator.pop(dialogContext);
                      Navigator.pop(dialogContext);
                      Navigator.pop(dialogContext, true);
                      //Navigator.pop(dialogContext, true);
                      //Get.offAllNamed(router.rt_UserAccounts);
                      // Navigator.of(context).popUntil(
                      //     ModalRoute.withName(router.rt_UserAccounts));
                      // Navigator.popUntil(dialogContext, (Route<dynamic> route) {
                      //   bool shouldPop = false;
                      //   if (route.settings.name == router.rt_UserAccounts) {
                      //     shouldPop = true;
                      //   }
                      //   return shouldPop;
                      // });

                      //Navigator.of(context).popUntil();
                    });
                  });
                } else {
                  Navigator.pop(dialogContext);
                  Alert.displayAlertPlain(context,
                      title: variable.Error, content: value!.message);
                }
              });
            } else {
              Navigator.pop(dialogContext);
              Alert.displayAlertPlain(context,
                  title: variable.Error,
                  content: CommonConstants.all_fields_mandatory);
            }
          }

          /* if (widget.arguments.fromClass == CommonConstants.my_family) {
            addFamilyUserInfoBloc.relationship = selectedRelationShip.name;
            addFamilyUserInfoBloc.userId = widget.arguments.sharedbyme.child.id;
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
                  widget.arguments.sharedbyme.child.countryCode;
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
                  addFamilyUserInfoBloc.updateUserProfile(false).then((value) {
                    if (value.success && value.status == 200) {
                      _familyListBloc.getFamilyMembersListNew().then((value) {
                        PreferenceUtil.saveFamilyData(
                                Constants.KEY_FAMILYMEMBER, value.result)
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
          } */
          else if (widget.arguments!.fromClass == CommonConstants.user_update) {
            //NOTE user profile update

            addFamilyUserInfoBloc.userId =
                widget.arguments!.myProfileResult!.id;
            //addFamilyUserInfoBloc.phoneNo = mobileNoController.text;
            // addFamilyUserInfoBloc.relationship = UpdateRelationshipModel(
            //     id: widget.arguments.sharedbyme.id,
            //     relationship: selectedRelationShip);

            var myProf = MyProfileModel();

            var profileResult = MyProfileResult();
            profileResult.firstName = firstNameController.text;
            profileResult.middleName = middleNameController.text;
            profileResult.lastName = lastNameController.text;
            profileResult.dateOfBirth = dateOfBirthController.text;
            profileResult.id = widget.arguments!.myProfileResult!.id;
            profileResult.isIeUser = false;
            profileResult.isCpUser = false;
            profileResult.isSignedIn = false;
            profileResult.isActive = true;
            profileResult.gender = selectedGender;
            profileResult.profilePicThumbnailUrl = null;
            // profileResult.createdBy=null;
            // profileResult.createdOn=null;
            profileResult.lastModifiedBy = null;
            profileResult.lastModifiedOn = null;

            if (currentselectedBloodGroup != null &&
                currentselectedBloodGroupRange != null) {
              profileResult.bloodGroup = currentselectedBloodGroup! +
                  ' ' +
                  currentselectedBloodGroupRange!;
            }
            final userAddressCollection3 = UserAddressCollection3();
            addFamilyUserInfoBloc.isUpdate = false;
            if (widget.arguments!.myProfileResult!.userAddressCollection3!
                .isNotEmpty) {
              userAddressCollection3.id = widget
                  .arguments!.myProfileResult!.userAddressCollection3![0].id;
              userAddressCollection3.addressLine1 = cntrlr_addr_one.text;
              userAddressCollection3.addressLine2 = cntrlr_addr_two.text;
              userAddressCollection3.pincode = cntrlr_addr_zip.text;
              /* userAddressCollection3.city = new City(
                  id: widget.arguments?.myProfileResult?.userAddressCollection3[0].city?.id,
                  isActive: widget.arguments?.myProfileResult?.userAddressCollection3[0].city?.isActive,
                  name: widget.arguments?.myProfileResult?.userAddressCollection3[0].city?.name,
                  createdOn: widget.arguments?.myProfileResult?.userAddressCollection3[0].city?.createdOn,
                  lastModifiedOn: widget.arguments?.myProfileResult?.userAddressCollection3[0].city?.lastModifiedOn); */
              userAddressCollection3.city = cityVal;
              userAddressCollection3.state = stateVal;
            } else {
              userAddressCollection3.addressLine1 = cntrlr_addr_one.text;
              userAddressCollection3.addressLine2 = cntrlr_addr_two.text;
              userAddressCollection3.pincode = cntrlr_addr_zip.text;
              userAddressCollection3.city = cityVal;
              userAddressCollection3.state = stateVal;
            }

            userAddressCollection3.isPrimary = true;
            userAddressCollection3.isActive = true;
            userAddressCollection3.createdOn =
                CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now());
            userAddressCollection3.lastModifiedOn = null;
            userAddressCollection3.createdBy =
                widget.arguments!.myProfileResult!.id;
            userAddressCollection3.addressType = AddressType(
              id: _addressResult.id,
              code: _addressResult.code,
              name: _addressResult.name,
              description: _addressResult.name,
              isActive: true,
              createdBy: PreferenceUtil.getStringValue(Constants.KEY_USERID),
              createdOn:
                  CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now()),
            );

            final userAddressCollection3List = <UserAddressCollection3>[];
            userAddressCollection3List.add(userAddressCollection3);
            profileResult.userAddressCollection3 = userAddressCollection3List;

            myProf.result = profileResult;
            addFamilyUserInfoBloc.myProfileModel = myProf;

            if (doValidation()) {
              if (addFamilyUserInfoBloc.profileBanner != null) {
                PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
                    addFamilyUserInfoBloc.profileBanner!.path);
              }
              CommonUtil.showLoadingDialog(
                  dialogContext, _keyLoader, variable.Please_Wait); //

              addFamilyUserInfoBloc.updateSelfProfile(false).then((value) {
                if (value != null && value.isSuccess!) {
                  _familyListBloc.getFamilyMembersListNew().then((value) {
                    MySliverAppBar.imageURI = null;
                    fetchedProfileData = null;
                    imageURI = null;
                    Navigator.pop(dialogContext);
                    Navigator.pop(dialogContext, true);

                    /* PreferenceUtil.saveFamilyData(
                            Constants.KEY_FAMILYMEMBER, value.result)
                        .then((value) {
                      //saveProfileImage();
                      MySliverAppBar.imageURI = null;
                      fetchedProfileData = null;
                      imageURI = null;
                      Navigator.pop(dialogContext);
                      Navigator.pop(dialogContext,true);
                      //Navigator.pop(dialogContext, true);
                      //Get.offAllNamed(router.rt_UserAccounts);
                      // Navigator.of(context).popUntil(
                      //     ModalRoute.withName(router.rt_UserAccounts));
                      // Navigator.popUntil(dialogContext, (Route<dynamic> route) {
                      //   bool shouldPop = false;
                      //   if (route.settings.name == router.rt_UserAccounts) {
                      //     shouldPop = true;
                      //   }
                      //   return shouldPop;
                      // });

                      //Navigator.of(context).popUntil();
                    }); */
                  });
                } else {
                  Navigator.pop(dialogContext);
                  Alert.displayAlertPlain(context,
                      title: variable.Error, content: value!.message);
                }
              });
            } else {
              Navigator.pop(dialogContext);
              Alert.displayAlertPlain(context,
                  title: variable.Error,
                  content: CommonConstants.all_fields_mandatory);
            }

            /* if (_formkey.currentState.validate()) {
              if (doValidation()) {
                CommonUtil.showLoadingDialog(
                    context, _keyLoader, variable.Please_Wait);

                addFamilyUserInfoBloc.updateSelfProfile(true).then((value) {
                  if (value != null && value.isSuccess) {
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
            } */
          } else {
            addFamilyUserInfoBloc.userId = widget.arguments!.id;
            addFamilyUserInfoBloc.phoneNo = mobileNoController.text;
            addFamilyUserInfoBloc.relationship = null;

            var myProf = MyProfileModel();

            var profileResult = MyProfileResult();
            profileResult.firstName = firstNameController.text;
            profileResult.middleName = middleNameController.text;
            profileResult.lastName = lastNameController.text;
            profileResult.dateOfBirth = dateOfBirthController.text;
            profileResult.id = widget.arguments!.id;
            profileResult.isIeUser = false;
            profileResult.isCpUser = false;
            profileResult.isSignedIn = false;
            profileResult.isActive = true;
            profileResult.gender = selectedGender;
            // profileResult.createdBy=null;
            // profileResult.createdOn=null;
            profileResult.lastModifiedBy = null;
            profileResult.lastModifiedOn = null;

            if (currentselectedBloodGroup != null &&
                currentselectedBloodGroupRange != null) {
              profileResult.bloodGroup = currentselectedBloodGroup! +
                  ' ' +
                  currentselectedBloodGroupRange!;
            }
            var userAddressCollection3 = UserAddressCollection3();
            addFamilyUserInfoBloc.isUpdate = false;
            //userAddressCollection3.id = null;
            userAddressCollection3.addressLine1 = cntrlr_addr_one.text;
            userAddressCollection3.addressLine2 = cntrlr_addr_two.text;
            userAddressCollection3.pincode = cntrlr_addr_zip.text;
            userAddressCollection3.city = cityVal;
            userAddressCollection3.state = stateVal;

            userAddressCollection3.isPrimary = true;
            userAddressCollection3.isActive = true;
            userAddressCollection3.createdOn =
                CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now());
            userAddressCollection3.lastModifiedOn = null;
            userAddressCollection3.createdBy = widget.arguments!.id;
            userAddressCollection3.addressType = AddressType(
              id: _addressResult.id,
              code: _addressResult.code,
              name: _addressResult.name,
              description: _addressResult.name,
              isActive: true,
              createdBy: PreferenceUtil.getStringValue(Constants.KEY_USERID),
              createdOn:
                  CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now()),
            );

            var userAddressCollection3List = <UserAddressCollection3>[];
            userAddressCollection3List.add(userAddressCollection3);
            profileResult.userAddressCollection3 = userAddressCollection3List;

            myProf.result = profileResult;
            addFamilyUserInfoBloc.myProfileModel = myProf;

            if (doValidation()) {
              if (addFamilyUserInfoBloc.profileBanner != null) {
                PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
                    addFamilyUserInfoBloc.profileBanner!.path);
              }
              CommonUtil.showLoadingDialog(
                  dialogContext, _keyLoader, variable.Please_Wait); //

              addFamilyUserInfoBloc.updateSelfProfile(false).then((value) {
                if (value != null && value.isSuccess!) {
                  _familyListBloc.getFamilyMembersListNew().then((value) {
                    PreferenceUtil.saveFamilyData(
                            Constants.KEY_FAMILYMEMBER, value.result)
                        .then((value) {
                      //saveProfileImage();
                      MySliverAppBar.imageURI = null;
                      fetchedProfileData = null;
                      imageURI = null;
                      Navigator.pop(dialogContext);
                      Navigator.pop(dialogContext, true);
                    });
                  });
                } else {
                  Navigator.pop(dialogContext);
                  Alert.displayAlertPlain(context,
                      title: variable.Error, content: value!.message);
                }
              });
            } else {
              Navigator.pop(dialogContext);
              Alert.displayAlertPlain(context,
                  title: variable.Error,
                  content: CommonConstants.all_fields_mandatory);
            }
          }
        } else {
          //address validation not valid.
          print('invalid user input');
        }
      } else {
        FHBBasicWidget()
            .showInSnackBar(Constants.STR_NO_CONNECTIVITY, scaffold_state);
      }
    });
  }

  void saveProfileImage() async {
    if (addFamilyUserInfoBloc.profileBanner != null) {
      await PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
          addFamilyUserInfoBloc.profileBanner!.path);
    }
    if (addFamilyUserInfoBloc.profilePic != null) {
      await PreferenceUtil.saveString(
          Constants.KEY_PROFILE_IMAGE, addFamilyUserInfoBloc.profilePic!.path);
    }
  }

  bool doValidation() {
    var isValid = false;

    if (firstNameController.text == '') {
      isValid = false;
      strErrorMsg = variable.enterFirstName;
    } else if (lastNameController.text == '') {
      isValid = false;
      strErrorMsg = variable.enterLastName;
    } else if (selectedGender == null) {
      isValid = false;
      strErrorMsg = variable.selectGender;
    } else if (dateOfBirthController.text.isEmpty) {
      isValid = false;
      strErrorMsg = variable.selectDOB;
    } else {
      isValid = true;
    }

    /* if (selectedBloodGroup != null) {
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
    } */

    if (currentselectedBloodGroup != null) {
      if (currentselectedBloodGroupRange == null) {
        isValid = false;
        strErrorMsg = variable.selectRHType;
      } else {
        addFamilyUserInfoBloc.bloodGroup =
            currentselectedBloodGroup! + '_' + currentselectedBloodGroupRange!;
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
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
          controller: firstNameController,
          enabled: (widget.arguments!.fromClass == CommonConstants.my_family ||
                  widget.arguments!.fromClass == CommonConstants.user_update)
              ? true
              : false,
          keyboardType: TextInputType.text,
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
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
          controller: middleNameController,
          enabled: (widget.arguments!.fromClass == CommonConstants.my_family ||
                  widget.arguments!.fromClass == CommonConstants.user_update)
              ? true
              : false,
          keyboardType: TextInputType.text,
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
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
          controller: lastNameController,
          enabled: (widget.arguments!.fromClass == CommonConstants.my_family ||
                  widget.arguments!.fromClass == CommonConstants.user_update)
              ? true
              : false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(relationShipFocus);
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

  void verifyEmail() {
    addFamilyUserInfoBloc.verifyEmail().then((value) {
      if (value!.success! &&
          value.message!.contains(Constants.MSG_VERIFYEMAIL_VERIFIED)) {
        FHBBasicWidget().showInSnackBar(value.message!, scaffold_state);
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
          Navigator.popUntil(context, (route) {
            var shouldPop = false;
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
    if (widget.arguments!.fromClass == CommonConstants.my_family) {
      for (var i = 0; i < relationShipResponseList!.length; i++) {
        // if (relationShipResponseList[i].roleName ==
        //     widget.arguments.sharedbyme.linkedData.roleName) {
        //   selectedRelationShip = relationShipResponseList[i];
        // }
      }
    }
  }

  Future<List<City>> getCitybasedOnSearch(
    String cityname,
    String apibody,
  ) {
    Future<List<City>> citylist;
    citylist = addFamilyUserInfoBloc.getCityDataList(cityname, apibody);
    return citylist;
  }

  Future<List<stateObj.State>> getStateBasedOnSearch(
    String stateName,
    String apibody,
  ) {
    Future<List<stateObj.State>> stateList;
    stateList = addFamilyUserInfoBloc.geStateDataList(stateName, apibody);
    return stateList;
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  static PickedFile? imageURI;
  static PickedFile? imageURIProfile;

  List<int>? profileData;

  bool imageSet = false;

  final AddFamilyUserInfoArguments? arguments;
  final String? fromClass;

  MySliverAppBar({
    required this.expandedHeight,
    this.profileData,
    this.fromClass,
    this.arguments,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        InkWell(
            onTap: () {
              saveMediaDialog(context, false);
            },
            child: imageURIProfile != null
                ? Image.file(
                    File(imageURIProfile!.path),
                    fit: BoxFit.cover,
                    width: 100.0.h,
                    height: 100.0.h,
                  )
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
                height: 50.0.h,
                width: 50.0.h,
              ),
            ),
          ),
        ),
        Positioned(
          top: (expandedHeight - 50) - shrinkOffset,
          left: 24, //1.sw / 4,
          child: InkWell(
              onTap: () {
                saveMediaDialog(context, true);
              },
              child: Opacity(
                opacity: 1 - shrinkOffset / expandedHeight,
                child: ClipOval(
                    child: profileData != null && imageURI == null
                        ? Image.memory(
                            Uint8List.fromList(profileData!),
                            fit: BoxFit.cover,
                            width: 100.0.h,
                            height: 100.0.h,
                          )
                        : imageURI == null
                            ? Container(
                                width: 100.0.h,
                                height: 100.0.h,
                                color: ColorUtils.lightPrimaryColor,
                              )
                            : Image.file(File(imageURI!.path),
                                width: 100.0.h,
                                height: 100.0.h,
                                fit: BoxFit.cover)),
              )),
        ),
      ],
    );
  }

  saveMediaDialog(BuildContext cont, bool isProfileImage) {
    return showDialog<void>(
      context: cont,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: Text(variable.makeAChoice),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        final image = ImagePicker.platform
                            .pickImage(source: ImageSource.gallery);
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
                      child: Text(variable.Gallery),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        final image = ImagePicker.platform
                            .pickImage(source: ImageSource.camera);
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
                      child: Text(variable.Camera),
                    ),
                  ],
                ),
              ));
        });
      },
    );
  }

  Future getImageFromCamera() async {
    final image =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    imageURI = image;
  }

  Future getImageFromGallery() async {
    final image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    imageURI = image;
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
