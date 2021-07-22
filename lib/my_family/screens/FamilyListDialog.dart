import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../bloc/FamilyListBloc.dart';

import '../../colors/fhb_colors.dart' as fhbColors;
import '../../constants/fhb_constants.dart' as Constants;
import '../models/FamilyData.dart';
import '../models/FamilyMembersResponse.dart';
import '../models/LinkedData.dart';
import '../models/ProfileData.dart';
import '../models/Sharedbyme.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../src/utils/screenutils/size_extensions.dart';

class FamilyListDialog extends StatefulWidget {
  final FamilyData familyData;

  const FamilyListDialog(this.familyData);
  @override
  FamilyListDialogState createState() => FamilyListDialogState();
}

class FamilyListDialogState extends State<FamilyListDialog> {
  FamilyListBloc _familyListBloc;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  @override
  void initState() {
    super.initState();

    _familyListBloc = FamilyListBloc();
    _familyListBloc.getFamilyMembersListNew();
  }

  @override
  Widget build(BuildContext context) {
    if (_familyListBloc != null) {
      _familyListBloc = null;
      _familyListBloc = FamilyListBloc();
    }

    getDialogBoxWithFamilyMember(widget.familyData).then((widget) {
      return widget;
    });
  }

  Widget getFamilyMemberList() {
    return PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER) != null
        ? getDialogBoxWithFamilyMember(
            PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER))
        : StreamBuilder<ApiResponse<FamilyMembersList>>(
            stream: _familyListBloc.familyMemberListStream,
            builder: (context,
                snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    CommonUtil.showLoadingDialog(
                        context, _keyLoader, variable.Please_Wait);
                    break;

                  case Status.ERROR:
                    return Center(
                        child: Text(variable.strSomethingWrong,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.0.sp,
                            )));
                    break;

                  case Status.COMPLETED:
                    getDialogBoxWithFamilyMember(
                            snapshot.data.data.response.data)
                        .then((widget) {
                      return widget;
                    });
                    break;
                }
              } else {
                return Container(
                  width: 100.0.h,
                  height: 100.0.h,
                );
              }
            },
          );
  }

  Future<Widget> getDialogBoxWithFamilyMember(FamilyData data) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(variable.Switch_User),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black54,
                      size: 24.0.sp,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              content: data != null
                  ? setupAlertDialoadContainer(data.sharedbyme)
                  : setupAlertDialoadContainer(null));
        });
  }

  Widget getDialogBoxWithFamilyList(FamilyData familyData) {
    return AlertDialog(
        backgroundColor: const Color(fhbColors.bgColorContainer),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(variable.Switch_User),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: familyData != null
            ? setupAlertDialoadContainer(familyData.sharedbyme)
            : setupAlertDialoadContainer(null));
  }

  Widget setupAlertDialoadContainer(List<Sharedbyme> sharedByMe) {
    var myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

    var profileData = ProfileData(
        id: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN));
    var linkedData =
        LinkedData(roleName: variable.Self, nickName: variable.Self);

    if (sharedByMe == null) {
      sharedByMe = [];
      sharedByMe.add(
          Sharedbyme(profileData: profileData, linkedData: linkedData));
    } else {
      sharedByMe.insert(
          0, Sharedbyme(profileData: profileData, linkedData: linkedData));
    }
    if (sharedByMe.isNotEmpty) {
      return Container(
          height: 1.sh, // Change as per your requirement
          width: 1.sw,
          // Change as per your requirement
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              ListView.builder(
                itemCount: sharedByMe.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: InkWell(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 6),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: <Widget>[
                            ClipOval(
                                child: sharedByMe[index].linkedData.nickName ==
                                        variable.Self
                                    ? FHBBasicWidget()
                                        .getProfilePicWidgeUsingUrl(myProfile)
                                    : Image.memory(
                                        Uint8List.fromList(sharedByMe[index]
                                            .profileData
                                            .profilePicThumbnail
                                            .data),
                                        height: 50.0.h,
                                        width: 50.0.h,
                                        fit: BoxFit.cover,
                                      )),
                            SizedBox(width: 20.0.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  sharedByMe[index]?.linkedData?.nickName?.capitalizeFirstofEach,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  sharedByMe[index].linkedData.roleName,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        PreferenceUtil.saveString(Constants.KEY_USERID,
                                sharedByMe[index].profileData.id)
                            .then((onValue) {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(CommonUtil().getMyPrimaryColor()),
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    variable.strAddFamily,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0.sp,
                    ),
                  ),
                ),
              )
            ],
          ));
    } else {
      return Center(child: Text(variable.strNoFamily));
    }
  }
}
