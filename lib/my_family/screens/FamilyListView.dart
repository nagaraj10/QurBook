import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';

import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/variable_constant.dart' as variable;
import '../../main.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../models/relationships.dart';

class FamilyListView {
  FamilyMemberResult? familyData;

  FamilyListView(this.familyData);

  Future<Widget?> getDialogBoxWithFamilyMember(
      FamilyMemberResult? data,
      BuildContext context,
      GlobalKey<State> _keyLoader,
      Function(BuildContext context, String? searchParam, String? name,
              String profilePic)
          onTextFieldtap,
      {bool removeDuplicate = false}) async {
    // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    List<SharedByUsers> sharedByUsersList = [];
    FamilyListBloc _familyListBloc = FamilyListBloc();

// return the combine family member list
    sharedByUsersList = _familyListBloc.getSharedByUsersCombinedList(data);

    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: SizedBox(
                width: (CommonUtil().isTablet!)
                    ? (MediaQuery.of(context).orientation ==
                            Orientation.landscape)
                        ? MediaQuery.sizeOf(context).width / 2
                        : MediaQuery.sizeOf(context).height / 1.5
                    : MediaQuery.sizeOf(context).height /
                        1.5, //  <------- Use SizedBox to limit width
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (data != null)
                      setupAlertDialoadContainer(sharedByUsersList, context,
                          onTextFieldtap, _keyLoader,
                          removeDuplicate: removeDuplicate)
                    else
                      setupAlertDialoadContainer(
                          null, context, onTextFieldtap, _keyLoader,
                          removeDuplicate: removeDuplicate),
                  ],
                ),
              ));
        });
  }

  String? getName(Child child) {
    String? name = '';
    if (child.firstName != null) {
      name = child.firstName;
      if (child.lastName != null && child.lastName != "") {
        name = name! + ' ' + child.lastName!;
      }
      //return toBeginningOfSentenceCase(name);
      return name?.capitalizeFirstofEach;
    } else {
      return name;
    }
  }

  Widget setupAlertDialoadContainer(
      List<SharedByUsers>? sharedByMeList,
      BuildContext context,
      Function(BuildContext context, String? searchParam, String? name,
              String profilePic)
          onTextFieldtap,
      GlobalKey<State> _keyLoader,
      {bool removeDuplicate = false}) {
    var myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

    try {
      String? name = "";
      try {
        if (((myProfile?.result?.firstName != null) &&
            (myProfile?.result?.firstName != ""))) {
          name = '${myProfile?.result?.firstName?.capitalizeFirstofEach} ';
        }
        if (((myProfile?.result?.lastName != null) &&
            (myProfile?.result?.lastName != ""))) {
          name += '${myProfile?.result?.lastName?.capitalizeFirstofEach}';
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
      sharedByMeList!.insert(
          0,
          SharedByUsers(
              id: myProfile!.result!.id,
              nickName: 'Self',
              nickNameSelf: name,
              relationship: RelationsShipModel(name: 'Self')));
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    /* if (sharedByMeList == null) {
      sharedByMeList = List();
      sharedByMeList.add(
          SharedByUsers(profileData: profileData, linkedData: linkedData));
    } else {
      if (!sharedByMeList.contains(
          new Sharedbyme(profileData: profileData, linkedData: linkedData))) {
        sharedByMeList.insert(0,
            new Sharedbyme(profileData: profileData, linkedData: linkedData));
      }
    }*/
    var sharedByMe =
        removeDuplicates(sharedByMeList!, condition: removeDuplicate);

    if (sharedByMe.isNotEmpty) {
      return Container(
          decoration: BoxDecoration(
              color: const Color(fhbColors.bgColorContainer),
              borderRadius: BorderRadius.circular(10)),
          //margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      variable.Switch_User,
                      style: TextStyle(
                          fontSize: 18.0.sp, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black54,
                        size: 24.0.sp,
                      ),
                      onPressed: () {
                        try {
                          Navigator.of(context).pop();
                          Navigator.of(_keyLoader.currentContext!,
                                  rootNavigator: true)
                              .pop();
                        } catch (e, stackTrace) {
                          CommonUtil()
                              .appLogs(message: e, stackTrace: stackTrace);
                        }
                      },
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  maxHeight: (MediaQuery.of(context).orientation ==
                          Orientation.landscape)
                      ? MediaQuery.sizeOf(context).height / 1.5
                      : MediaQuery.sizeOf(context).height / 2,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sharedByMe.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 6),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: <Widget>[
                              ClipOval(
                                  child: sharedByMe[index].relationship!.name ==
                                          variable.Self
                                      ? myProfile!.result!
                                                  .profilePicThumbnailUrl !=
                                              null
                                          ? FHBBasicWidget()
                                              .getProfilePicWidgeUsingUrl(
                                                  myProfile)
                                          : Container(
                                              height: CommonUtil().isTablet!
                                                  ? imageProfileTabHeader
                                                  : imageProfileMobileHeader,
                                              width: CommonUtil().isTablet!
                                                  ? imageProfileTabHeader
                                                  : imageProfileMobileHeader,
                                              color: const Color(
                                                  fhbColors.bgColorContainer),
                                              child: Center(
                                                  child: Text(
                                                      myProfile.result != null
                                                          ? myProfile.result!
                                                                      .firstName !=
                                                                  null
                                                              ? myProfile
                                                                  .result!
                                                                  .firstName![0]
                                                                  .toUpperCase()
                                                              : 'S'
                                                          : '',
                                                      style: TextStyle(
                                                          color: mAppThemeProvider.primaryColor,
                                                          fontSize: 22.0.sp))),
                                            )
                                      : sharedByMe[index]
                                                  .child!
                                                  .profilePicThumbnailUrl !=
                                              null
                                          ? Image.network(
                                              sharedByMe[index]
                                                  .child!
                                                  .profilePicThumbnailUrl!,
                                              height: 50.0.h,
                                              width: 50.0.h,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, exception,
                                                  stackTrace) {
                                                return Container(
                                                  height: 50.0.h,
                                                  width: 50.0.h,
                                                  color: mAppThemeProvider.primaryColor,
                                                  child: Center(
                                                      child: Text(
                                                    sharedByMe[index]
                                                                    .child!
                                                                    .firstName !=
                                                                null &&
                                                            (sharedByMe[index]
                                                                        .child!
                                                                        .lastName !=
                                                                    null &&
                                                                sharedByMe[index]
                                                                        .child!
                                                                        .lastName !=
                                                                    "")
                                                        ? sharedByMe[index]
                                                                .child!
                                                                .firstName![0]
                                                                .toUpperCase() +
                                                            sharedByMe[index]
                                                                .child!
                                                                .lastName![0]
                                                                .toUpperCase()
                                                        : sharedByMe[index]
                                                                    .child!
                                                                    .firstName !=
                                                                null
                                                            ? sharedByMe[index]
                                                                .child!
                                                                .firstName![0]
                                                                .toUpperCase()
                                                            : '',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22.0.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )),
                                                );
                                              },
                                            )
                                          : Container(
                                              height: 50.0.h,
                                              width: 50.0.h,
                                              color: const Color(
                                                  fhbColors.bgColorContainer),
                                              child: Center(
                                                child: Text(
                                                  sharedByMe[index]
                                                              .child!
                                                              .firstName !=
                                                          null
                                                      ? sharedByMe[index]
                                                          .child!
                                                          .firstName![0]
                                                          .toUpperCase()
                                                      : '',
                                                  style: TextStyle(
                                                      color: mAppThemeProvider.primaryColor,
                                                      fontSize: 22.0.sp),
                                                ),
                                              ),
                                            )),
                              SizedBox(width: 20.0.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        index == 0
                                            ? sharedByMe[index].child != null
                                                ? getName(
                                                    sharedByMe[index].child!)!
                                                : '${(sharedByMe[index].nickNameSelf?.capitalizeFirstofEach)}'
                                            : (sharedByMe[index].nickName !=
                                                    null
                                                ? (sharedByMe[index]
                                                            .nickName
                                                            ?.toLowerCase() ==
                                                        variable.Self
                                                            .toLowerCase())
                                                    ? '${(sharedByMe[index].nickNameSelf?.capitalizeFirstofEach)}'
                                                    : getName(sharedByMe[index]
                                                        .child!)!
                                                /* toBeginningOfSentenceCase(
                                                    sharedByMe[index]
                                                        .nickName
                                                        .toLowerCase()) */
                                                : ''),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        sharedByMe[index].relationship != null
                                            ? sharedByMe[index]
                                                        .relationship!
                                                        .name !=
                                                    null
                                                ? toBeginningOfSentenceCase(
                                                    sharedByMe[index]
                                                        .relationship!
                                                        .name!
                                                        .toLowerCase())!
                                                : ''
                                            : '',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12.0.sp),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          if (index == 0 &&
                              sharedByMe[index].nickName == variable.Self) {
                            onTextFieldtap(
                                context,
                                sharedByMe[index].id,
                                sharedByMe[index].nickName,
                                sharedByMe[index].nickName == variable.Self
                                    ? myProfile!
                                            .result!.profilePicThumbnailUrl ??
                                        ""
                                    : myProfile!.result != null
                                        ? myProfile.result!.firstName != null
                                            ? myProfile.result!.firstName![0]
                                                .toUpperCase()
                                            : 'S'
                                        : '');
                          } else {
                            onTextFieldtap(
                                context,
                                sharedByMe[index].child!.id,
                                sharedByMe[index].child!.firstName,
                                sharedByMe[index]
                                        .child!
                                        .profilePicThumbnailUrl ??
                                    (sharedByMe[index].child!.firstName![0] !=
                                            null
                                        ? sharedByMe[index]
                                            .child!
                                            .firstName![0]
                                            .toUpperCase()
                                        : ''));
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ));
    } else {
      return Center(child: Text(variable.strNoFamily));
    }
  }

  List<SharedByUsers> removeDuplicates(List<SharedByUsers> SharedbymeList,
      {bool condition = false}) {
    List<SharedByUsers> sharedByMeClone = [];
    String? userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    String? familyID;
    for (int i = 0; i < SharedbymeList.length; i++) {
      if (!condition) {
        if (userId != SharedbymeList[i].id) {
          if (SharedbymeList[i].nickName == variable.Self) {
            familyID = SharedbymeList[i].id;
          } else {
            familyID = SharedbymeList[i].child?.id;
          }
          if (!sharedByMeClone.contains(SharedbymeList[i]) &&
              (userId != familyID)) {
            sharedByMeClone.add(SharedbymeList[i]);
          }
        }
      } else {
        if (!sharedByMeClone.contains(SharedbymeList[i]) &&
            (userId != familyID)) {
          sharedByMeClone.add(SharedbymeList[i]);
        }
      }
    }
    if (condition) {
      List<SharedByUsers> copyOfSharedByMeClone = [];
      copyOfSharedByMeClone = sharedByMeClone;
      var ids = copyOfSharedByMeClone.map((e) => e.child?.id).toSet();
      copyOfSharedByMeClone.retainWhere((x) => ids.remove(x.child?.id));
      sharedByMeClone = copyOfSharedByMeClone;
    }
    return sharedByMeClone;
  }
}
