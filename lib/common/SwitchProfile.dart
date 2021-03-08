import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyData.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/screens/FamilyListView.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class SwitchProfile {
  FamilyListBloc _familyListBloc;
  MyProfileBloc _myProfileBloc;

  BuildContext context;
  GlobalKey<State> keyLoader = new GlobalKey<State>();
  Function callBackToRefresh;
  bool isFromDashborad;

  FlutterToast toast = new FlutterToast();

  static const double ActionWidgetSize = 55.0;
  static const double PlusIconSize = 14.0;

  Widget buildActions(BuildContext _context, GlobalKey<State> _keyLoader,
      Function _callBackToRefresh, bool isFromDashborad,
      {GlobalKey<ScaffoldState> scaffold_state}) {
    context = _context;
    keyLoader = _keyLoader;
    callBackToRefresh = _callBackToRefresh;
    isFromDashborad = isFromDashborad;
    String profileImage;
    MyProfileModel myProfile;
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
      profileImage = PreferenceUtil.getStringValue(Constants.KEY_PROFILE_IMAGE);
    } catch (e) {
      myProfile = null;
    }

    return Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
            onTap: () {
              if (_familyListBloc != null) {
                _familyListBloc = null;
                _familyListBloc = new FamilyListBloc();
              } else {
                _familyListBloc = new FamilyListBloc();
              }

              /*  PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER) != null
                  ? getDialogBoxWithFamilyMemberScrap(
                      PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER))
                  :*/
              checkInternet(_keyLoader, scaffold_state);

              //return new FamilyListDialog();
            },
            child: isFromDashborad?getCirleAvatarWithBorderIcon(myProfile):CircleAvatar(
              radius: 15,
              child: ClipOval(
                  child: myProfile != null
                      ? myProfile.result != null
                      ? myProfile.result.profilePicThumbnailUrl != null
                      ? new FHBBasicWidget().getProfilePicWidgeUsingUrl(
                      myProfile)
                      : Container(
                      height: 50.0.h,
                      width: 50.0.h,
                      color: Color(fhbColors.bgColorContainer),
                      child: Center(
                        child: Text(
                          myProfile.result.firstName != null
                              ? myProfile.result.firstName[0]
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

  Future<Widget> getDialogBoxWithFamilyMemberScrap(
      FamilyMemberResult familyData) {
    return new FamilyListView(familyData).getDialogBoxWithFamilyMember(
        familyData, context, keyLoader, (context, userId, userName, _) {
      PreferenceUtil.saveString(Constants.KEY_USERID, userId).then((onValue) {
        if (PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME) ==
            Constants.STR_IDDOCS) {
          if (PreferenceUtil.getStringValue(Constants.KEY_FAMILYMEMBERID) !=
              null &&
              PreferenceUtil.getStringValue(Constants.KEY_FAMILYMEMBERID)
                  .length >
                  0) {
            PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, userId);
          } else {
            PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, '');
          }
        } else {
          PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, '');
        }

        Navigator.of(context).pop();

        getUserProfileData();
      });
    });
  }

  getUserProfileData() async {
    CommonUtil.showLoadingDialog(context, keyLoader, variable.strRelaoding);
    if (_myProfileBloc != null) {
      _myProfileBloc = null;
      _myProfileBloc = new MyProfileBloc();
    } else {
      _myProfileBloc = new MyProfileBloc();
    }
    HealthReportListForUserBlock _healthReportListForUserBlock =
    new HealthReportListForUserBlock();

    _myProfileBloc.getMyProfileData(Constants.KEY_USERID).then((profileData) {
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData)
          .then((value) {
        _healthReportListForUserBlock.getHelthReportLists().then((value) {
          PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value)
              .then((value) {
            Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
            new CommonUtil()
                .getMedicalPreference(callBackToRefresh: callBackToRefresh);
          });
        });

        //Navigator.of(context).pop();
        //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    });
  }

  checkInternet(
      GlobalKey<State> _keyLoader, GlobalKey<ScaffoldState> scaffold_state) {
    new FHBUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        _familyListBloc.getFamilyMembersListNew().then((familyMembersList) {
          if (familyMembersList != null &&
              familyMembersList.result != null &&
              familyMembersList.result.sharedByUsers.length > 0) {
            //  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            getDialogBoxWithFamilyMemberScrap(familyMembersList.result);
          } else {
            toast.getToast(Constants.NO_DATA_FAMIY_CLONE, Colors.black54);
          }
        });
      } else {
        toast.getToast(Constants.STR_NO_CONNECTIVITY, Colors.black54);
      }
    });
  }

  Widget getCirleAvatarWithBorderIcon(MyProfileModel myProfile) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 18,
          child: ClipOval(
              child: myProfile != null
                  ? myProfile.result != null
                  ? myProfile.result.profilePicThumbnailUrl != null
                  ? new FHBBasicWidget().getProfilePicWidgeUsingUrl(
                  myProfile)
                  : Container(
                  height: 50,
                  width: 50,
                  color: Color(fhbColors.bgColorContainer),
                  child: Center(
                    child: Text(
                      myProfile.result.firstName != null
                          ? myProfile.result.firstName[0]
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
              )),
        ),
        _getPlusIcon(),
      ],
    );
  }

  Widget _getPlusIcon() {
    return Positioned(
      bottom: 0,
      left: ((ActionWidgetSize / 2) - (PlusIconSize / 2)),
      child: InkWell(
        onTap: () {
          navigateToAddFamily();
        },
        child: Container(
            width: PlusIconSize, // PlusIconSize = 20.0;

            height: PlusIconSize, // PlusIconSize = 20.0;

            decoration: BoxDecoration(
                color: ColorUtils.countColor,
                borderRadius: BorderRadius.circular(15.0)),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 12.0,
            )),
      ),
    );
  }

  navigateToAddFamily() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return UserAccounts(arguments: UserAccountsArguments(selectedIndex: 1));
    }));
  }
}