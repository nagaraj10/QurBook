import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';

import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family/models/FamilyData.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/models/LinkedData.dart';
import 'package:myfhb/my_family/models/ProfileData.dart';
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

class FamilyListDialog extends StatefulWidget {
  final FamilyData familyData;

  FamilyListDialog(this.familyData);
  @override
  FamilyListDialogState createState() => FamilyListDialogState();
}

class FamilyListDialogState extends State<FamilyListDialog> {
  FamilyListBloc _familyListBloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();

    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersList();
  }

  @override
  Widget build(BuildContext context) {
    if (_familyListBloc != null) {
      _familyListBloc = null;
      _familyListBloc = new FamilyListBloc();
    }

    //CommonUtil.showLoadingDialogWithCustomChild(context, _keyLoader, '', getDialogBoxWithFamilyList(widget.familyData));

    getDialogBoxWithFamilyMember(widget.familyData).then((widget) {
      return widget;
    });

    //return Container(child: Text('Empty'),);
  }

  Widget getFamilyMemberList() {
    return PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER) != null
        ? getDialogBoxWithFamilyMember(
            PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER))
        : StreamBuilder<ApiResponse<FamilyMembersList>>(
            stream: _familyListBloc.familyMemberListStream,
            builder: (context,
                AsyncSnapshot<ApiResponse<FamilyMembersList>> snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    CommonUtil.showLoadingDialog(
                        context, _keyLoader, 'Please Wait');
                    break;

                  case Status.ERROR:
                    return Center(
                        child: Text('Oops, something went wrong',
                            style: TextStyle(color: Colors.red)));
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
                  width: 100,
                  height: 100,
                );
              }
            },
          );
  }

  Future<Widget> getDialogBoxWithFamilyMember(FamilyData data) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Switch User'),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black54,
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
            Text('Switch User'),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
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
    MyProfile myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

    ProfileData profileData = new ProfileData(
        id: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN));
    LinkedData linkedData = new LinkedData(roleName: 'Self', nickName: 'Self');

    if (sharedByMe == null) {
      sharedByMe = new List();
      sharedByMe.add(
          new Sharedbyme(profileData: profileData, linkedData: linkedData));
      
    } else {
      sharedByMe.insert(
          0, new Sharedbyme(profileData: profileData, linkedData: linkedData));
      
    }
    if (sharedByMe.length > 0) {
      return Container(
          height: MediaQuery.of(context)
              .size
              .height, // Change as per your requirement
          width: MediaQuery.of(context).size.width,
          // Change as per your requirement
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              ListView.builder(
                shrinkWrap: false,
                itemCount: sharedByMe.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: InkWell(
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
                                child: sharedByMe[index].linkedData.nickName ==
                                        'Self'
                                    ? new FHBBasicWidget().getProfilePicWidget(
                                        myProfile.response.data.generalInfo
                                            .profilePicThumbnail)
                                    : Image.memory(
                                        Uint8List.fromList(sharedByMe[index]
                                            .profileData
                                            .profilePicThumbnail
                                            .data),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  sharedByMe[index].linkedData.nickName,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  sharedByMe[index].linkedData.roleName,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 10),
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
                          //getUserProfileData();
                        });
                      },
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                    //TODO chnage theme
                    color: Color(new CommonUtil().getMyPrimaryColor()),
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                  child: Text(
                    'Add new family member',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ));
    } else {
      return Center(child: Text('No family members added yet'));
    }
  }
}
