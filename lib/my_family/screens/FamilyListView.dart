import 'dart:typed_data';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family/models/FamilyData.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/models/LinkedData.dart';
import 'package:myfhb/my_family/models/ProfileData.dart';
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_family/models/relationships.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';

class FamilyListView {
  FamilyMemberResult familyData;

  FamilyListView(this.familyData);

  Future<Widget> getDialogBoxWithFamilyMember(
      FamilyMemberResult data,
      BuildContext context,
      GlobalKey<State> _keyLoader,
      Function(BuildContext context, String searchParam, String name,
              String profilePic)
          onTextFieldtap) async {
    // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
              type: MaterialType.transparency,
              child: Container(
                child: Column(
                  children: <Widget>[
                    data != null
                        ? setupAlertDialoadContainer(data.sharedByUsers,
                            context, onTextFieldtap, _keyLoader)
                        : setupAlertDialoadContainer(
                            null, context, onTextFieldtap, _keyLoader),
                  ],
                ),
              ));
        });
  }

  String getName(Child child) {
    var name = '';
    if (child.firstName != null) {
      name = child.firstName.toLowerCase();
      if (child.lastName != null) {
        name = name + ' ' + child.lastName.toLowerCase();
      }
      return toBeginningOfSentenceCase(name);
    } else {
      return name;
    }
  }

  Widget setupAlertDialoadContainer(
      List<SharedByUsers> sharedByMeList,
      BuildContext context,
      Function(BuildContext context, String searchParam, String name,
              String profilePic)
          onTextFieldtap,
      GlobalKey<State> _keyLoader) {
    MyProfileModel myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

    ProfileData profileData = new ProfileData(
        id: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
        userId: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN));
    LinkedData linkedData =
        new LinkedData(roleName: variable.Self, nickName: variable.Self);

    try {
      sharedByMeList.insert(
          0,
          new SharedByUsers(
              id: myProfile.result.id,
              nickName: 'Self',
              relationship: RelationsShipModel(name: 'Self')));
    } catch (e) {}

    /* if (sharedByMeList == null) {
      sharedByMeList = new List();
      sharedByMeList.add(
          new SharedByUsers(profileData: profileData, linkedData: linkedData));
    } else {
      if (!sharedByMeList.contains(
          new Sharedbyme(profileData: profileData, linkedData: linkedData))) {
        sharedByMeList.insert(0,
            new Sharedbyme(profileData: profileData, linkedData: linkedData));
      }
    }*/
    List<SharedByUsers> sharedByMe = removeDuplicates(sharedByMeList);

    if (sharedByMe.length > 0) {
      return Container(
          decoration: BoxDecoration(
              color: const Color(fhbColors.bgColorContainer),
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(20),
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
                        Navigator.of(context).pop();
                        Navigator.of(_keyLoader.currentContext,
                                rootNavigator: true)
                            .pop();
                      },
                    )
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 440.0.h,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sharedByMe.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 6),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(
                                  child: sharedByMe[index].relationship.name ==
                                          variable.Self
                                      ? myProfile.result
                                                  .profilePicThumbnailUrl !=
                                              null
                                          ? new FHBBasicWidget()
                                              .getProfilePicWidgeUsingUrl(
                                                  myProfile.result
                                                      .profilePicThumbnailUrl)
                                          : Container(
                                              height: 50.0.h,
                                              width: 50.0.h,
                                              child: Center(
                                                  child: Text(
                                                      myProfile.result != null
                                                          ? myProfile.result
                                                                      .firstName !=
                                                                  null
                                                              ? myProfile.result
                                                                  .firstName[0]
                                                                  .toUpperCase()
                                                              : 'S'
                                                          : '',
                                                      style: TextStyle(
                                                          color: Color(CommonUtil()
                                                              .getMyPrimaryColor()),
                                                          fontSize: 22.0.sp))),
                                              color: const Color(
                                                  fhbColors.bgColorContainer),
                                            )
                                      : sharedByMe[index]
                                                  .child
                                                  .profilePicThumbnailUrl !=
                                              null
                                          ? Image.network(
                                              sharedByMe[index]
                                                  .child
                                                  .profilePicThumbnailUrl,
                                              height: 50.0.h,
                                              width: 50.0.h,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              height: 50.0.h,
                                              width: 50.0.h,
                                              child: Center(
                                                child: Text(
                                                  sharedByMe[index]
                                                              .child
                                                              .firstName !=
                                                          null
                                                      ? sharedByMe[index]
                                                          .child
                                                          .firstName[0]
                                                          .toUpperCase()
                                                      : '',
                                                  style: TextStyle(
                                                      color: Color(CommonUtil()
                                                          .getMyPrimaryColor()),
                                                      fontSize: 22.0.sp),
                                                ),
                                              ),
                                              color: const Color(
                                                  fhbColors.bgColorContainer),
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
                                            ? sharedByMe[index].nickName != null
                                                ? toBeginningOfSentenceCase(
                                                    sharedByMe[index]
                                                        .nickName
                                                        .toLowerCase())
                                                : ''
                                            : sharedByMe[index].child != null
                                                ? getName(
                                                    sharedByMe[index].child)
                                                : '',
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
                                                        .relationship
                                                        .name !=
                                                    null
                                                ? toBeginningOfSentenceCase(
                                                    sharedByMe[index]
                                                        .relationship
                                                        .name
                                                        .toLowerCase())
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
                          if (index == 0) {
                            onTextFieldtap(
                                context,
                                sharedByMe[index].id,
                                sharedByMe[index].nickName,
                                sharedByMe[index].nickName == variable.Self
                                    ? myProfile.result.profilePicThumbnailUrl !=
                                            null
                                        ? myProfile
                                            .result.profilePicThumbnailUrl
                                        : ""
                                    : myProfile.result != null
                                        ? myProfile.result.firstName != null
                                            ? myProfile.result.firstName[0]
                                                .toUpperCase()
                                            : 'S'
                                        : '');
                          } else {
                            onTextFieldtap(
                                context,
                                sharedByMe[index].child.id,
                                sharedByMe[index].child.firstName,
                                sharedByMe[index]
                                            .child
                                            .profilePicThumbnailUrl !=
                                        null
                                    ? sharedByMe[index]
                                        .child
                                        .profilePicThumbnailUrl
                                    : (sharedByMe[index].child.firstName[0] !=
                                            null
                                        ? sharedByMe[index]
                                            .child
                                            .firstName[0]
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

  List<SharedByUsers> removeDuplicates(List<SharedByUsers> SharedbymeList) {
    List<SharedByUsers> sharedByMeClone = new List();

    for (SharedByUsers sharedbymeObj in SharedbymeList) {
      if (!sharedByMeClone.contains(sharedbymeObj)) {
        sharedByMeClone.add(sharedbymeObj);
      }
    }
    return sharedByMeClone;
  }
}
