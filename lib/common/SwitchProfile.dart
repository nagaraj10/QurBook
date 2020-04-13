import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/screens/FamilyListView.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;


class SwitchProfile{
  FamilyListBloc _familyListBloc;
  MyProfileBloc _myProfileBloc;

  BuildContext context;
  GlobalKey<State> keyLoader = new GlobalKey<State>();
  Function callBackToRefresh;

   Widget buildActions(BuildContext _context,GlobalKey<State> _keyLoader,Function _callBackToRefresh) {
  context=_context;
  keyLoader=_keyLoader;
  callBackToRefresh=_callBackToRefresh;
    MyProfile myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);

    return Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
            onTap: () {
              print('Profile Pressed');
              //getAllFamilyMembers();
              CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait');

              if (_familyListBloc != null) {
                _familyListBloc = null;
                _familyListBloc = new FamilyListBloc();
              }else{
                                _familyListBloc = new FamilyListBloc();

              }
              _familyListBloc.getFamilyMembersList().then((familyMembersList) {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                getDialogBoxWithFamilyMemberScrap(
                    familyMembersList.response.data);
              });

              //return new FamilyListDialog();
            },
            child: CircleAvatar(
              radius: 15,
              child: ClipOval(
                  child: new FHBBasicWidget().getProfilePicWidget(
                      myProfile.response.data.generalInfo.profilePicThumbnail)),
            )));

    //}

    /*  return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ]; */
  }

   Future<Widget> getDialogBoxWithFamilyMemberScrap(FamilyData familyData) {
    return new FamilyListView(familyData).getDialogBoxWithFamilyMember(
        familyData, context, keyLoader, (context, userId, userName) {
      PreferenceUtil.saveString(Constants.KEY_USERID, userId).then((onValue) {
        Navigator.of(context).pop();

        getUserProfileData();
      });
    });
  }

  getUserProfileData() async {
    CommonUtil.showLoadingDialog(context, keyLoader, 'Relaoding');
 if (_myProfileBloc != null) {
                _myProfileBloc = null;
      _myProfileBloc = new MyProfileBloc();
              }else{
      _myProfileBloc = new MyProfileBloc();

              }
    _myProfileBloc.getMyProfileData(Constants.KEY_USERID).then((profileData) {
      print('inside myrecprds' + profileData.toString());
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData)
          .then((value) {
        Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
        new CommonUtil()
            .getMedicalPreference(callBackToRefresh:callBackToRefresh);
      });

      //Navigator.of(context).pop();
      //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    });
  }


}