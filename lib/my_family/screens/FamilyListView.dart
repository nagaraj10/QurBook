import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/common/CommonUtil.dart';

class FamilyListView {
  FamilyData familyData;

  FamilyListView(this.familyData);

  Future<Widget> getDialogBoxWithFamilyMember(
      FamilyData data,
      BuildContext context,
      GlobalKey<State> _keyLoader,
      Function(BuildContext context, String searchParam, String name)
          onTextFieldtap) async {
    // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    print('INSIDE DIALOG BOX CLASS');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
              type: MaterialType.transparency,
              child: Container(
                child: Column(
                  children: <Widget>[
                    data != null
                        ? setupAlertDialoadContainer(data.sharedbyme, context,
                            onTextFieldtap, _keyLoader)
                        : setupAlertDialoadContainer(
                            null, context, onTextFieldtap, _keyLoader),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                    color: Color( new CommonUtil().getMyPrimaryColor()),
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
                ),
              ));
        });
  }

  Widget setupAlertDialoadContainer(
      List<Sharedbyme> sharedByMe,
      BuildContext context,
      Function(BuildContext context, String searchParam, String name)
          onTextFieldtap,
      GlobalKey<State> _keyLoader) {
    print('INSIDE setupAlertDialoadContainer');
    MyProfile myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

    ProfileData profileData = new ProfileData(
        id: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
        userId: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN));
    LinkedData linkedData = new LinkedData(roleName: 'Self', nickName: 'Self');

    if (sharedByMe == null) {
      sharedByMe = new List();
      sharedByMe.add(
          new Sharedbyme(profileData: profileData, linkedData: linkedData));
      print('inside setupAlertDialoadContainer single' +
          sharedByMe.length.toString());
    } else {
      sharedByMe.insert(
          0, new Sharedbyme(profileData: profileData, linkedData: linkedData));
      print('inside setupAlertDialoadContainer multiple' +
          sharedByMe.length.toString());
    }
    if (sharedByMe.length > 0) {
      return Container(
          /*  constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 200), */
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
                      'Switch User',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black54,
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
                constraints: BoxConstraints(maxHeight: 440),
                child: ListView.builder(
                  shrinkWrap: true,
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
                                  child: sharedByMe[index]
                                              .linkedData
                                              .nickName ==
                                          'Self'
                                      ? new FHBBasicWidget()
                                          .getProfilePicWidget(myProfile
                                              .response
                                              .data
                                              .generalInfo
                                              .profilePicThumbnail)
                                      : sharedByMe[index]
                                                  .profileData
                                                  .profilePicThumbnail !=
                                              null
                                          ? Image.memory(
                                              Uint8List.fromList(
                                                  sharedByMe[index]
                                                      .profileData
                                                      .profilePicThumbnail
                                                      .data),
                                              height: 50,
                                              width: 50,
                                            )
                                          : Container(
                                              height: 50,
                                              width: 50,
                                              color: const Color(
                                                  fhbColors.bgColorContainer),
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
                          print('String tap');
                          onTextFieldtap(
                              context,
                              sharedByMe[index].profileData.userId,
                              sharedByMe[index].linkedData.nickName);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ));
    } else {
      return Center(child: Text('No family members added yet'));
    }
  }
}
