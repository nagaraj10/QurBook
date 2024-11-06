import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../add_family_user_info/bloc/add_family_user_info_bloc.dart';
import '../../../add_family_user_info/models/add_family_user_info_arguments.dart';
import '../../../add_family_user_info/services/add_family_user_info_repository.dart';
import '../../../common/CommonConstants.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/FHBBasicWidget.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../common/common_circular_indicator.dart';
import '../../../common/errors_widget.dart';
import '../../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/fhb_constants.dart';
import '../../../constants/router_variable.dart' as router;
import '../../../constants/variable_constant.dart' as variable;
import '../../../language/model/Language.dart';
import '../../../language/repository/LanguageRepository.dart';
import '../../../main.dart';
import '../../../user_plans/view/user_profile_image.dart';
import '../../../user_plans/view_model/user_plans_view_model.dart';
import '../../../widgets/TagsList.dart';
import '../../blocs/Media/MediaTypeBlock.dart';
import '../../model/GetDeviceSelectionModel.dart';
import '../../model/TagsResult.dart';
import '../../model/user/MyProfileModel.dart';
import '../../model/user/MyProfileResult.dart';
import '../../model/user/Tags.dart';
import '../../resources/repository/health/HealthReportListForUserRepository.dart';
import '../../utils/FHBUtils.dart';
import '../../utils/screenutils/size_extensions.dart';
import '../authentication/OtpVerifyScreen.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();
  GlobalKey<ScaffoldMessengerState> scaffold_state =
      GlobalKey<ScaffoldMessengerState>();
  FlutterToast toast = FlutterToast();
  var mobile = TextEditingController();
  var name = TextEditingController();
  var email = TextEditingController();
  var gender = TextEditingController();
  var bloodGroupController = TextEditingController();
  var bloodRangeController = TextEditingController();
  File? imageURIProfile, profileImage;
  var dob = TextEditingController();
  var languageController = TextEditingController();

  var heightController = TextEditingController();
  var weightController = TextEditingController();
  var heightInchController = TextEditingController();

  var firstName = TextEditingController();
  var middleName = TextEditingController();
  var lastName = TextEditingController();

  var cntrlr_addr_one = TextEditingController(text: '');
  var cntrlr_addr_two = TextEditingController(text: '');
  var cntrlr_addr_city = TextEditingController(text: '');
  var cntrlr_addr_state = TextEditingController(text: '');
  var cntrlr_addr_zip = TextEditingController(text: '');

  var cntrlr_corp_name = TextEditingController(text: '');

  LanguageModel? languageModelList;
  LanguageRepository languageBlock = LanguageRepository();

  bool _isEditable = false;
  double sliverBarHeight = 220;
  late AddFamilyUserInfoBloc addFamilyUserInfoBloc;

  bool isFeetOrInches = true;
  bool isKg = true;

  MediaTypeBlock? _mediaTypeBlock;
  late HealthReportListForUserRepository _healthReportListForUserRepository;

  List<Tags> selectedTags = [];

  @override
  void initState() {
    PreferenceUtil.init();
    FABService.trackCurrentScreen(FBAMyInfoScreen);
    super.initState();
    languageBlock = LanguageRepository();
    addFamilyUserInfoBloc = AddFamilyUserInfoBloc();
    _healthReportListForUserRepository = HealthReportListForUserRepository();
    addFamilyUserInfoBloc.getDeviceSelectionValues().then((value) {});

    if (_mediaTypeBlock == null) {
      _mediaTypeBlock = MediaTypeBlock();
      _mediaTypeBlock!.getMediTypesList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffold_state, body: getProfileDetailClone());
  }

  Future<String?> getPreferredLanguage(MyProfileResult? myProfile) async {
    try {
      try {
        var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
        if (userid != null) {
          languageModelList = await languageBlock.getLanguage();
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }

      return setValueLanguages(myProfile);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      String currentLanguage = '';
      final lan = CommonUtil.getCurrentLanCode();
      if (lan != "undef") {
        final langCode = lan!.split("-").first;
        currentLanguage = langCode;
      } else {
        currentLanguage = strDefaultLanguage;
        PreferenceUtil.saveString(SHEELA_LANG, strDefaultLanguage);
      }
      if (currentLanguage.isNotEmpty) {
        CommonUtil.supportedLanguages.forEach((language, languageCode) {
          if (currentLanguage == languageCode) {
            languageController.text = toBeginningOfSentenceCase(language)!;
            return;
          }
        });
      }
    }
  }

  String? setValueLanguages(MyProfileResult? myProfile) {
    String? languagePreferred = "English";
    if (myProfile!.userProfileSettingCollection3!.isNotEmpty) {
      ProfileSetting? profileSetting =
          myProfile.userProfileSettingCollection3![0].profileSetting;
      if (profileSetting != null) {
        CommonUtil.langaugeCodes.forEach((language, languageCode) {
          if (language == profileSetting.preferred_language) {
            final langCode = language.split("-").first;
            String currentLanguage = langCode;

            if (currentLanguage.isNotEmpty) {
              CommonUtil.supportedLanguages.forEach((language, languageCode) {
                if (currentLanguage == languageCode) {
                  languagePreferred = toBeginningOfSentenceCase(language);
                  PreferenceUtil.saveString(SHEELA_LANG,
                      CommonUtil.langaugeCodes[languageCode] ?? strDefaultLanguage);
                }
              });
            }
          }
        });
      } else {
        languagePreferred = "English";
        PreferenceUtil.saveString(SHEELA_LANG, strDefaultLanguage);
      }

      return languagePreferred;
    }
  }

  Widget getProfileDetailClone() {
    var useridMain =
        (PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN)) ?? '';
    var userid = (PreferenceUtil.getStringValue(Constants.KEY_USERID)) ?? '';
    return FutureBuilder<MyProfileModel>(
      future: addFamilyUserInfoRepository.getMyProfileInfoNew(useridMain),
      builder: (BuildContext context, AsyncSnapshot<MyProfileModel> snapshot) {
        if (snapshot.hasData) {
          //* its done with fetching the data from remote
          if (snapshot.hasData && snapshot.data != null) {
            //getPreferredLanguage(snapshot.data.result);
            if (useridMain == userid) {
              PreferenceUtil.saveProfileData(
                  Constants.KEY_PROFILE, snapshot.data);
            }
            return getProfileWidget(snapshot.data, snapshot.data!.result!);
          } else {
            //todo proper error msg to users
            toast.getToast('something went wrong!', Colors.red);
            return getProfileWidget(snapshot.data, null as MyProfileResult,
                errorMsg: 'something went wrong!');
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //* its fetching the data from remote
          return Center(
            child: Column(
              children: [
                CommonCircularIndicator(),
                Text(
                  'Hey Please Hangon!\nprofile is loading.',
                  style:
                      TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        } else {
          // toast.getToast('${snapshot.error.toString()}', Colors.red);
          // return getProfileWidget(snapshot.data, null,
          //     errorMsg: snapshot.error.toString());
          return ErrorsWidget();
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

  Widget getProfileWidget(MyProfileModel? myProfile, MyProfileResult data,
      {String? errorMsg}) {
    addFamilyUserInfoBloc.getDeviceSelectionValues().then((value) {});
    if (data != null) {
      setUnit(data);

      if (data.userContactCollection3 != null) {
        if (data.userContactCollection3!.length > 0) {
          mobile.text = data.userContactCollection3![0]!.phoneNumber ?? '';
        }
      }
      if (data != null) {
        // name.text = toBeginningOfSentenceCase(
        //     data.firstName.toLowerCase() + data.lastName.toLowerCase());
        name.text = data.firstName!.capitalizeFirstofEach +
            data.lastName!.capitalizeFirstofEach;
      }
      if (data.userContactCollection3 != null) {
        if (data.userContactCollection3!.length > 0) {
          email.text = data.userContactCollection3![0]!.email ?? '';
        }
      }

      if (data.additionalInfo != null) {
        if (isFeetOrInches) {
          heightController.text =
              data.additionalInfo?.heightObj?.valueFeet ?? '';
          heightInchController.text =
              data.additionalInfo?.heightObj?.valueInches ?? '';
        } else {
          heightController.text = data.additionalInfo!.height != null
              ? data.additionalInfo!.height ?? ''
              : '';
        }

        weightController.text = data.additionalInfo!.weight != null
            ? data.additionalInfo!.weight ?? ''
            : '';
      }
      if (data.gender != null) {
        gender.text = toBeginningOfSentenceCase(data.gender!.toLowerCase())!;
      }
      if (data.bloodGroup != null) {
        print('current blood group ${data.bloodGroup}');
        bloodGroupController.text = data.bloodGroup!.split(' ')[0];
        bloodRangeController.text = data.bloodGroup!.split(' ')[1];
        //renameBloodGroup(data.bloodGroup);
      }
      if (data.dateOfBirth != null) {
        if (CommonUtil.isUSRegion()) {
          dob.text = FHBUtils().getFormattedDateOnly(data.dateOfBirth ?? "");
        } else {
          dob.text = FHBUtils().getFormattedDateOnlyNew(data.dateOfBirth)!;
        }
      }
      if (data != null) {
        firstName.text = data.firstName!.capitalizeFirstofEach;
        middleName.text = ((data.middleName != null && data.middleName != '')
            ? data.middleName?.capitalizeFirstofEach
            : '')!;
        lastName.text = data.lastName!.capitalizeFirstofEach;
      } else {
        firstName.text = data != null
            ? data.firstName!.capitalizeFirstofEach +
                data.lastName!.capitalizeFirstofEach
            : '';
        middleName.text = '';
        lastName.text = '';
      }

      if (data.userAddressCollection3 != null) {
        if ((data.userAddressCollection3?.length ?? 0) > 0) {
          cntrlr_addr_one.text =
              data.userAddressCollection3![0].addressLine1 ?? '';
          cntrlr_addr_two.text =
              data.userAddressCollection3![0].addressLine2 ?? '';
          cntrlr_addr_zip.text = data.userAddressCollection3![0].pincode ?? '';
          cntrlr_addr_city.text =
              data.userAddressCollection3![0].city!.name ?? '';
          cntrlr_addr_state.text =
              data.userAddressCollection3![0].state!.name ?? '';
        }
      }

      if (data.membershipOfferedBy != null && data.membershipOfferedBy != '') {
        cntrlr_corp_name.text = data.membershipOfferedBy ?? '';
      }
    }
    try {
      try {
        String? profileImageFile =
            PreferenceUtil.getStringValue(Constants.KEY_PROFILE_IMAGE);
        if (profileImageFile != null) {
          profileImage = File(profileImageFile);
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
      return Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 120.0.h,
                        width: 120.0.h,
                        decoration: ShapeDecoration(
                          shape: CircleBorder(
                              side: BorderSide(
                                  width: 1.5.w,
                                  color: (Provider.of<UserPlansViewModel>(
                                              context)
                                          .isGoldMember)
                                      ? Colors.transparent
                                      : mAppThemeProvider.primaryColor)),
                        ),
                        child: data.profilePicThumbnailUrl != null
                            ? UserProfileImage(myProfile,
                                textColor:
                                    mAppThemeProvider.primaryColor)
                            : Container(),
                      ),
                    ),
                    IconButton(
                        icon: _isEditable
                            ? Visibility(
                                visible: false, child: Icon(Icons.save))
                            : Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            if (_isEditable) {
                              _isEditable = false;
                            } else {
                              _isEditable = true;
                              //sliverBarHeight = 50;
                              if (myProfile?.result != null) {
                                Navigator.pushNamed(
                                        context, router.rt_AddFamilyUserInfo,
                                        arguments: AddFamilyUserInfoArguments(
                                            isForFamilyAddition: false,
                                            isFromAppointmentOrSlotPage: false,
                                            myProfileResult: myProfile?.result,
                                            isForFamily: false,
                                            fromClass:
                                                CommonConstants.user_update))
                                    .then((value) {
                                  setState(() {
                                    _isEditable = false;
                                  });
                                });
                              } else {
                                FlutterToast().getToast(
                                    'Unable to Fetch User Profile data',
                                    Colors.red);
                                setState(() {
                                  _isEditable = false;
                                });
                              }
                            }
                            sliverBarHeight = 220;
                          });
                        })
                  ],
                ),

                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: 16.0.sp),
                      controller: mobile,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: variable.strMobileNum,
                        hintStyle: TextStyle(fontSize: 16.0.sp),
                        labelText: variable.strMobileNum,
                      ),
                    )),

                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: 16.0.sp),
                      controller: firstName,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: CommonConstants.firstName,
                        hintStyle: TextStyle(fontSize: 16.0.sp),
                        labelText: CommonConstants.firstName,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: 16.0.sp),
                      controller: middleName,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: CommonConstants.middleName,
                        hintStyle: TextStyle(fontSize: 16.0.sp),
                        labelText: CommonConstants.middleName,
                      ),
                    )),
                // _showMiddleNameTextField(),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: 16.0.sp),
                      controller: lastName,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: CommonConstants.lastName,
                        hintStyle: TextStyle(fontSize: 16.0.sp),
                        labelText: CommonConstants.lastName,
                      ),
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(fontSize: 16.0.sp),
                        controller: email,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: variable.strEmailAddress,
                          hintStyle: TextStyle(fontSize: 16.0.sp),
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
                    //                     fontSize: 15.0.sp,
                    //                     fontWeight: FontWeight.w400,
                    //                     color: Color(CommonUtil()
                    //                         .getMyPrimaryColor())))),
                    //         onTap: () {
                    //           FHBUtils().check().then((intenet) {
                    //             if (intenet != null && intenet) {
                    //               verifyEmail();
                    //             } else {
                    //               FHBBasicWidget().showInSnackBar(
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
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 16.0.sp),
                    controller: gender,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: CommonConstants.gender,
                      hintStyle: TextStyle(fontSize: 16.0.sp),
                      labelText: CommonConstants.gender,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 1.sw / 2 - 40,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontSize: 16.0.sp),
                            controller: bloodGroupController,
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: CommonConstants.blood_group,
                                hintStyle: TextStyle(fontSize: 16.0.sp),
                                labelText: CommonConstants.blood_group),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 1.sw / 2 - 40,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontSize: 16.0.sp),
                            controller: bloodRangeController,
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: CommonConstants.STR_RHTYPE,
                                hintStyle: TextStyle(fontSize: 16.0.sp),
                                labelText: CommonConstants.STR_RHTYPE),
                          ),
                        )),
                  ],
                ),
                isFeetOrInches
                    ? Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                width: 0.5.sw / 2 - 20,
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: TextStyle(fontSize: 16.0.sp),
                                  controller: heightController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText:
                                          CommonConstants.heightNameFeetInd,
                                      hintStyle: TextStyle(fontSize: 16.0.sp),
                                      labelText:
                                          CommonConstants.heightNameFeetInd),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                width: 0.5.sw / 2 - 20,
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: TextStyle(fontSize: 16.0.sp),
                                  controller: heightInchController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText:
                                          CommonConstants.heightNameInchInd,
                                      hintStyle: TextStyle(fontSize: 16.0.sp),
                                      labelText:
                                          CommonConstants.heightNameInchInd),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                width: 1.sw / 2 - 40,
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: TextStyle(fontSize: 16.0.sp),
                                  controller: weightController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText: isKg
                                          ? CommonConstants.weightName
                                          : CommonConstants.weightNameUS,
                                      hintStyle: TextStyle(fontSize: 16.0.sp),
                                      labelText: isKg
                                          ? CommonConstants.weightName
                                          : CommonConstants.weightNameUS),
                                ),
                              )),
                        ],
                      )
                    : Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                width: 1.sw / 2 - 40,
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: TextStyle(fontSize: 16.0.sp),
                                  controller: heightController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText: CommonConstants.height,
                                      hintStyle: TextStyle(fontSize: 16.0.sp),
                                      labelText: CommonConstants.height),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                width: 1.sw / 2 - 40,
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: TextStyle(fontSize: 16.0.sp),
                                  controller: weightController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText: isKg
                                          ? CommonConstants.weightName
                                          : CommonConstants.weightNameUS,
                                      hintStyle: TextStyle(fontSize: 16.0.sp),
                                      labelText: isKg
                                          ? CommonConstants.weightName
                                          : CommonConstants.weightNameUS),
                                ),
                              )),
                        ],
                      ),

                getLanguageWidget(myProfile),
                addFamilyUserInfoBloc.tagsList!.length > 0
                    ? getDropDownWithTagsdrop()
                    : SizedBox(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 16.0.sp),
                    controller: dob,
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: CommonUtil.isUSRegion()
                            ? CommonConstants.date_of_birth
                            : CommonConstants.year_of_birth,
                        hintStyle: TextStyle(fontSize: 16.0.sp),
                        labelText: CommonUtil.isUSRegion()
                            ? CommonConstants.date_of_birthWithStar
                            : CommonConstants.year_of_birth_with_star),
                  ),
                ),
                cntrlr_corp_name.text != ''
                    ? Padding(
                        padding: EdgeInsets.all(10),
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
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 16.0.sp),
                    controller: cntrlr_addr_one,
                    enabled: false,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 16.0.sp),
                      labelText: CommonConstants.addr_line_1,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 16.0.sp),
                    controller: cntrlr_addr_two,
                    enabled: false,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 16.0.sp),
                      labelText: CommonConstants.addr_line_2,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 16.0.sp),
                    controller: cntrlr_addr_city,
                    enabled: false,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 16.0.sp),
                      labelText: CommonConstants.addr_city,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 16.0.sp),
                    controller: cntrlr_addr_state,
                    enabled: false,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 16.0.sp),
                      labelText: CommonConstants.addr_state,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 16.0.sp),
                    controller: cntrlr_addr_zip,
                    enabled: false,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 16.0.sp),
                      labelText: CommonUtil.REGION_CODE == 'IN'
                          ? CommonConstants.addr_pin
                          : CommonConstants.addr_zip,
                    ),
                  ),
                ),
              ],
            ),
          ));
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return Container(
        child: Center(
          child: Text(errorMsg != null ? errorMsg : 'Something Went Wrong!'),
        ),
      );
    }
  }

  void verifyEmail() {
    AddFamilyUserInfoBloc addFamilyUserInfoBloc = AddFamilyUserInfoBloc();
    addFamilyUserInfoBloc.verifyEmail().then((value) {
      if (value!.success! &&
          value.message!.contains(Constants.MSG_VERIFYEMAIL_VERIFIED)) {
        FHBBasicWidget().showInSnackBar(value.message!, scaffold_state);
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

  String setLanguageToField(String language, String languageCode) {
    final langCode = language.split("-").first;
    String currentLanguage = langCode;

    if (currentLanguage.isNotEmpty) {
      CommonUtil.supportedLanguages.forEach((language, languageCode) {
        if (currentLanguage == languageCode) {
          languageController.text = toBeginningOfSentenceCase(language)!;
          return;
        }
      });
    }

    return languageController.text;
  }

  getLanguageWidget(MyProfileModel? myProfile) {
    return FutureBuilder(
        future: getPreferredLanguage(myProfile?.result),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.data != null && snapshot.data != "") {
            languageController.text = snapshot.data!;
          } else {
            languageController.text = "English";
          }
          return Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 16.0.sp),
              controller: languageController,
              enabled: false,
              decoration: InputDecoration(
                hintText: CommonConstants.preferredLanguage,
                hintStyle: TextStyle(fontSize: 16.0.sp),
                labelText: CommonConstants.preferredLanguage,
              ),
            ),
          );
        });
  }

  void setUnit(MyProfileResult data) {
    var profileSetting = data.userProfileSettingCollection3![0].profileSetting;
    if (profileSetting != null) {
      if (profileSetting.preferredMeasurement != null) {
        try {
          String? heightUnit =
              profileSetting.preferredMeasurement?.height?.unitCode;
          String? weightUnit =
              profileSetting.preferredMeasurement?.weight?.unitCode;
          if (heightUnit == Constants.STR_VAL_HEIGHT_IND) {
            isFeetOrInches = true;
          } else {
            isFeetOrInches = false;
          }

          if (weightUnit == Constants.STR_VAL_WEIGHT_IND) {
            isKg = true;
          } else {
            isKg = false;
          }
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);

          if (CommonUtil.REGION_CODE == 'IND') {
            isFeetOrInches = true;
            isKg = true;
          } else {
            isFeetOrInches = false;
            isKg = false;
          }
        }
      }
    } else {
      if (CommonUtil.REGION_CODE == 'IND') {
        isFeetOrInches = true;
        isKg = true;
      } else {
        isFeetOrInches = false;
        isKg = false;
      }
    }
  }

  Widget getDropDownWithTagsdrop() {
    return FutureBuilder<TagsResult>(
        future: _healthReportListForUserRepository.getTags(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CommonCircularIndicator();
          }

          final List<Tags>? tagslist =
              snapshot.data!.result; // snapshot.data.result to snapshot.data
          //  final mediaResultFiltered = removeUnwantedCategories(tagslist);
          setTheValuesForDropdown(tagslist);
          return Taglist(
            forMyProfile: true,
            tags: addFamilyUserInfoBloc.tagsList,
            onChecked: (result) {
              addSelectedcategoriesToList(result!);
            },
          );
        });
  }

  void setTheValuesForDropdown(List<Tags>? result) {
    if (selectedTags != null && selectedTags.isNotEmpty) {
      for (var mediaResultObj in result!) {
        if (selectedTags.contains(mediaResultObj.id)) {
          mediaResultObj.isChecked = true;
        }
      }
    }
  }

  void addSelectedcategoriesToList(List<Tags> result) {
    selectedTags = [];
    for (final mediaResultObj in result) {
      if (!selectedTags.contains(mediaResultObj.id) &&
          mediaResultObj.isChecked!) {
        selectedTags.add(mediaResultObj);
      }
    }
  }
}
