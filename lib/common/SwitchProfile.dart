import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/screens/FamilyListView.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import '../constants/fhb_constants.dart' as Constants;

class SwitchProfile {
  FamilyListBloc? _familyListBloc;
  MyProfileBloc? _myProfileBloc;

  late BuildContext context;
  GlobalKey<State> keyLoader = GlobalKey<State>();
  late Function callBackToRefresh;
  bool? isFromDashborad;

  FlutterToast toast = FlutterToast();

  static const double ActionWidgetSize = 55;
  static const double ActionWidgetTabSize = 60;

  static const double PlusIconSize = 14;
  static const double PlusIconTabSize = 25;

  Widget buildActions(BuildContext _context, GlobalKey<State> _keyLoader,
      Function _callBackToRefresh, bool isFromDashborad,
      {GlobalKey<ScaffoldMessengerState>? scaffold_state, bool? changeWhiteBg}) {
    context = _context;
    keyLoader = _keyLoader;
    callBackToRefresh = _callBackToRefresh;
    isFromDashborad = isFromDashborad;
    String? profileImage;
    MyProfileModel? myProfile;
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
      profileImage = PreferenceUtil.getStringValue(Constants.KEY_PROFILE_IMAGE);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      myProfile = null;
    }

    return Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
            onTap: () {
              if (_familyListBloc != null) {
                _familyListBloc = null;
                _familyListBloc = FamilyListBloc();
              } else {
                _familyListBloc = FamilyListBloc();
              }
              checkInternet(_keyLoader, scaffold_state);
            },
            child: isFromDashborad
                ? getCirleAvatarWithBorderIcon(myProfile,
                    changeWhiteBg: changeWhiteBg)
                : CircleAvatar(
                    radius: CommonUtil().isTablet! ? 18 : 15,
                    child: ClipOval(
                        child: myProfile != null
                            ? myProfile.result != null
                                ? myProfile.result!.profilePicThumbnailUrl !=
                                        null
                                    ? FHBBasicWidget()
                                        .getProfilePicWidgeUsingUrl(myProfile,
                                            changeWhiteBg: changeWhiteBg,
                                            textSize: CommonUtil().isTablet!
                                                ? 10
                                                : 28)
                                    : Container(
                                        height: CommonUtil().isTablet!
                                            ? imageTabHeader
                                            : imageMobileHeader,
                                        width: CommonUtil().isTablet!
                                            ? imageTabHeader
                                            : imageMobileHeader,
                                        color:
                                            Color(fhbColors.bgColorContainer),
                                        child: Center(
                                          child: Text(
                                            myProfile.result!.firstName != null
                                                ? myProfile
                                                    .result!.firstName![0]
                                                    .toUpperCase()
                                                : '',
                                            style: TextStyle(
                                                fontSize: CommonUtil().isTablet!
                                                    ? Constants.tabHeader4
                                                    : mobileHeader1,
                                                color: Color(CommonUtil()
                                                    .getMyPrimaryColor())),
                                          ),
                                        ))
                                : Container(
                                    height: 50.0.h,
                                    width: 50.0.h,
                                    color: Color(fhbColors.bgColorContainer),
                                  )
                            : Container(
                                height: 50.0.h,
                                width: 50.0.h,
                                color: Color(fhbColors.bgColorContainer),
                              )),
                  )));
  }

  Future<Widget?> getDialogBoxWithFamilyMemberScrap(
      FamilyMemberResult? familyData) {
    return FamilyListView(familyData).getDialogBoxWithFamilyMember(
        familyData, context, keyLoader, (context, userId, userName, _) {
      PreferenceUtil.saveString(Constants.KEY_USERID, userId!).then((onValue) {
        CommonUtil().updateSocketFamily();
        if (PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME) ==
            Constants.STR_IDDOCS) {
          if (PreferenceUtil.getStringValue(Constants.KEY_FAMILYMEMBERID) !=
                  null &&
              PreferenceUtil.getStringValue(Constants.KEY_FAMILYMEMBERID)!
                  .isNotEmpty) {
            PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, userId);
          } else {
            PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, '');
          }
        } else {
          PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, '');
        }

        Navigator.of(context).pop();
        try {
          ApiBaseHelper apiBaseHelper = ApiBaseHelper();
          var res = apiBaseHelper.updateLastVisited();
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }

        getUserProfileData();
      });
    });
  }

  getUserProfileData() async {
    CommonUtil.showLoadingDialog(context, keyLoader, variable.strSwitchingUser);
    if (_myProfileBloc != null) {
      _myProfileBloc = null;
      _myProfileBloc = MyProfileBloc();
    } else {
      _myProfileBloc = MyProfileBloc();
    }
    final _healthReportListForUserBlock = HealthReportListForUserBlock();

    await _myProfileBloc!
        .getMyProfileData(Constants.KEY_USERID)
        .then((profileData) {
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData)
          .then((value) {
        _healthReportListForUserBlock.getHelthReportLists().then((value) {
          PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value)
              .then((value) {
            Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();

            callBackToRefresh();
          });
        });

        //Navigator.of(context).pop();
        //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        QurhomeDashboardController qurhomeDashboardController;
        if (!Get.isRegistered<QurhomeDashboardController>()) {
          Get.put(QurhomeDashboardController());
        }
        qurhomeDashboardController = Get.find();
        qurhomeDashboardController.updateTabIndex(
            qurhomeDashboardController.currentSelectedIndex.value);
        try {
          Get.find<QurhomeRegimenController>().getRegimenList();
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
      });
    });
  }

  checkInternet(
      GlobalKey<State> _keyLoader, GlobalKey<ScaffoldMessengerState>? scaffoldState) {
    FHBUtils().check().then((intenet) {
      CommonUtil().showSingleLoadingDialog(context);
      if (intenet != null && intenet) {
        _familyListBloc!.getFamilyMembersListNew().then((familyMembersList) {
          CommonUtil().hideLoadingDialog(context);

          if (familyMembersList != null &&
              familyMembersList.result != null &&
              familyMembersList.result.sharedByUsers.length > 0) {
            //  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            getDialogBoxWithFamilyMemberScrap(familyMembersList.result);
          } else {
            if (PreferenceUtil.getStringValue(Constants.KEY_USERID) !=
                PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN)) {
              PreferenceUtil.saveString(Constants.KEY_USERID,
                      PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN)!)
                  .then((value) {
                Get.offAllNamed(
                  rt_Landing,
                  arguments: LandingArguments(),
                );
              });
            } else {
              toast.getToast(Constants.NO_DATA_FAMIY_CLONE, Colors.black54);
            }
          }
        });
      } else {
        toast.getToast(Constants.STR_NO_CONNECTIVITY, Colors.black54);
      }
    });
  }

  Widget getCirleAvatarWithBorderIcon(MyProfileModel? myProfile,
      {bool? changeWhiteBg}) {
    return Stack(
      children: [
        CircleAvatar(
          radius: CommonUtil().isTablet! ? 25 : 18,
          child: ClipOval(
            child: myProfile != null
                ? myProfile.result != null
                    ? myProfile.result!.profilePicThumbnailUrl != null
                        ? FHBBasicWidget().getProfilePicWidgeUsingUrl(myProfile,
                            changeWhiteBg: changeWhiteBg,
                            textSize: CommonUtil().isTablet! ? 10 : 28)
                        : Container(
                            height: 50,
                            width: 50,
                            color: Color(fhbColors.bgColorContainer),
                            child: Center(
                              child: Text(
                                myProfile.result!.firstName != null
                                    ? myProfile.result!.firstName![0]
                                        .toUpperCase()
                                    : '',
                                style: TextStyle(
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              ),
                            ))
                    : Container(
                        height: 50,
                        width: 50,
                        color: Color(fhbColors.bgColorContainer),
                      )
                : Container(
                    height: 50,
                    width: 50,
                    color: Color(fhbColors.bgColorContainer),
                  ),
          ),
        ),
        _getPlusIcon(),
      ],
    );
  }

  Widget _getPlusIcon() {
    return Positioned(
      bottom: 0,
      left: CommonUtil().isTablet!
          ? 28
          : ((ActionWidgetSize / 2) - (PlusIconSize / 2)),
      child: InkWell(
        onTap: () {
          navigateToAddFamily();
        },
        child: Container(
            width: CommonUtil().isTablet!
                ? PlusIconTabSize
                : PlusIconSize, // PlusIconSize = 20.0;

            height: CommonUtil().isTablet!
                ? PlusIconTabSize
                : PlusIconSize, // PlusIconSize = 20.0;

            decoration: BoxDecoration(
                color: ColorUtils.countColor,
                borderRadius: BorderRadius.circular(15)),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: CommonUtil().isTablet! ? 18 : 12,
            )),
      ),
    );
  }

  navigateToAddFamily() {
    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UserAccounts(arguments: UserAccountsArguments(selectedIndex: 1));
    }));*/
    if (!CommonUtil.isUSRegion())
      Navigator.pushNamed(
        context,
        rt_UserAccounts,
        arguments: UserAccountsArguments(
          selectedIndex: 1,
        ),
      );
  }

  Future<Widget> buildActionsNew(
      BuildContext _context,
      GlobalKey<State> _keyLoader,
      Function _callBackToRefresh,
      bool isFromDashborad,
      MyProfileModel myProfile,
      {GlobalKey<ScaffoldMessengerState>? scaffold_state}) async {
    context = _context;
    keyLoader = _keyLoader;
    callBackToRefresh = _callBackToRefresh;
    isFromDashborad = isFromDashborad;
    String? profileImage;
    MyProfileModel? myProfileNew;
    try {
      myProfileNew = await PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
      profileImage =
          await PreferenceUtil.getStringValue(Constants.KEY_PROFILE_IMAGE);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      myProfileNew = null;
    }

    return Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
            onTap: () {
              if (_familyListBloc != null) {
                _familyListBloc = null;
                _familyListBloc = FamilyListBloc();
              } else {
                _familyListBloc = FamilyListBloc();
              }
              checkInternet(_keyLoader, scaffold_state);
            },
            child: isFromDashborad
                ? getCirleAvatarWithBorderIcon(myProfile)
                : CircleAvatar(
                    radius: CommonUtil().isTablet! ? 18 : 15,
                    child: ClipOval(
                        child: myProfile != null
                            ? myProfile.result != null
                                ? myProfile.result!.profilePicThumbnailUrl !=
                                        null
                                    ? FHBBasicWidget()
                                        .getProfilePicWidgeUsingUrl(myProfile,
                                            textSize: CommonUtil().isTablet!
                                                ? 10
                                                : 28)
                                    : Container(
                                        height: 50.0.h,
                                        width: 50.0.h,
                                        color:
                                            Color(fhbColors.bgColorContainer),
                                        child: Center(
                                          child: Text(
                                            myProfile.result!.firstName != null
                                                ? myProfile
                                                    .result!.firstName![0]
                                                    .toUpperCase()
                                                : '',
                                            style: TextStyle(
                                                color: Color(CommonUtil()
                                                    .getMyPrimaryColor())),
                                          ),
                                        ))
                                : Container(
                                    height: 50.0.h,
                                    width: 50.0.h,
                                    color: Color(fhbColors.bgColorContainer),
                                  )
                            : Container(
                                height: 50.0.h,
                                width: 50.0.h,
                                color: Color(fhbColors.bgColorContainer),
                              )),
                  )));
  }
}
