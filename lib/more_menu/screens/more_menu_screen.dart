import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:intl/intl.dart';
import 'package:launch_review/launch_review.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/myfhb_weview/myfhb_webview.dart';
import 'package:myfhb/src/model/Authentication/SignOutResponse.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/ui/HomeScreen.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

class MoreMenuScreen extends StatefulWidget {
  final Function refresh;

  MoreMenuScreen({this.refresh});
  @override
  _MoreMenuScreenState createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends State<MoreMenuScreen> {
  MyProfileModel myProfile;
  File profileImage;

  String selectedMaya =
      PreferenceUtil.getStringValue(Constants.keyMayaAsset) != null
          ? PreferenceUtil.getStringValue(Constants.keyMayaAsset)
          : variable.icon_mayaMain;

  int selectedPrimaryColor =
      PreferenceUtil.getSavedTheme(Constants.keyPriColor) != null
          ? PreferenceUtil.getSavedTheme(Constants.keyPriColor)
          : 0xff5e1fe0;

  int selectedGradientColor =
      PreferenceUtil.getSavedTheme(Constants.keyGreyColor) != null
          ? PreferenceUtil.getSavedTheme(Constants.keyGreyColor)
          : 0xff753aec;

  @override
  void initState() {
    //getProfileImage();
  }

  getProfileImage() async {
    myProfile = await PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

    setState(() {
      String profileImageFile =
          PreferenceUtil.getStringValue(Constants.KEY_PROFILE_IMAGE);
      if (profileImageFile != null) {
        profileImage = File(profileImageFile);
      }
    });

    if (myProfile.result != null) {}
  }

  Future<MyProfileModel> getMyProfile() async {
    if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) != null) {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    } else {
      myProfile = await new CommonUtil().getMyProfile();
    }
    return myProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: GradientAppBar(),
            leading: IconWidget(
              icon: Icons.arrow_back_ios,
              colors: Colors.white,
              size: 20,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    new FHBBasicWidget().exitApp(context, () {
                      new CommonUtil().logout(moveToLoginPage);
                    });
                  })
            ]),
        body: getValuesFromSharedPrefernce());
  }

  void openWebView(String title, String url, bool isLocal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MyFhbWebView(
            title: title, selectedUrl: url, isLocalAsset: isLocal)));
  }

  Widget getBody() {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: ListTile(
            leading: ClipOval(
              child: profileImage != null
                  ? Image.file(profileImage,
                      width: 50, height: 50, fit: BoxFit.cover)
                  : FHBBasicWidget().getProfilePicWidgeUsingUrl(
                      myProfile.result.profilePicThumbnailUrl),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  myProfile.result != null
                      ? toBeginningOfSentenceCase(
                              myProfile.result.firstName ?? '') +
                          ' ' +
                          toBeginningOfSentenceCase(
                              myProfile.result.lastName ?? '')
                      : '',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  (myProfile.result.userContactCollection3 != null &&
                          myProfile.result.userContactCollection3.length > 0)
                      ? myProfile.result.userContactCollection3[0]
                                  .phoneNumber !=
                              null
                          ? myProfile
                              .result.userContactCollection3[0].phoneNumber
                          : ''
                      : '',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  (myProfile.result.userContactCollection3 != null &&
                          myProfile.result.userContactCollection3.length > 0)
                      ? myProfile.result.userContactCollection3[0].email != null
                          ? myProfile.result.userContactCollection3[0].email
                          : ''
                      : '',
                  style: TextStyle(fontSize: 11),
                )
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                router.rt_UserAccounts,
                arguments: UserAccountsArguments(selectedIndex: 0),
              );
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text(variable.strSettings,
              style: TextStyle(fontWeight: FontWeight.w500)),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
          onTap: () {
            PageNavigator.goTo(context, router.rt_AppSettings);
          },
        ),
        Divider(),
        Theme(
          data: theme,
          child: ExpansionTile(
            title: Text(variable.strHelp,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black)),
            children: <Widget>[
              InkWell(
                child: ListTile(
                    title: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_faq),
                      color: Colors.black,
                    ),
                    SizedBox(width: 20),
                    Text(Constants.FAQ),
                  ],
                )),
                onTap: () {
                  openWebView(Constants.FAQ, variable.file_faq, true);
                },
              ),
              ListTile(
                title: InkWell(
                    child: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_feedback),
                      color: Colors.black,
                    ),
                    SizedBox(width: 20),
                    Text(variable.strFeedBack),
                  ],
                )),
                onTap: () {
                  Navigator.pushNamed(context, router.rt_Feedbacks)
                      .then((value) {});
                },
              ),
              InkWell(
                child: ListTile(
                    title: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_term),
                      size: 20,
                      //size: 30,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20),
                    Text(Constants.terms_of_service)
                  ],
                )),
                onTap: () {
                  openWebView(
                      Constants.terms_of_service, variable.file_terms, true);
                },
              ),
              InkWell(
                onTap: () {
                  openWebView(
                      Constants.privacy_policy, variable.file_privacy, true);
                },
                child: ListTile(
                    title: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_privacy),
                      size: 20,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20),
                    Text(variable.strPrivacy),
                  ],
                )),
              ),
              InkWell(
                onTap: () {
                  LaunchReview.launch(
                      androidAppId: variable.strAppPackage, iOSAppId: "");
                },
                child: ListTile(
                    title: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_record_fav),
                      size: 20,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20),
                    Text(variable.strRateus),
                  ],
                )),
              )
            ],
          ),
        ),
        Divider(),
        Theme(
          data: theme,
          child: ExpansionTile(
              title: Text(variable.strMaya,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: <Widget>[
                ListTile(
                    title: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  height: 80,
                  //width: 200,
                  //color: Colors.green,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: variable.mayaAssets.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        PreferenceUtil.saveString(
                            Constants.keyMayaAsset, variable.mayaAssets[index]);
                        selectedMaya = variable.mayaAssets[index];
                        HomeScreen.of(context).refresh();
                        setState(() {});
                      },
                      child: Card(
                        color: variable.mayaAssets[index] == selectedMaya
                            ? Color(new CommonUtil().getMyPrimaryColor())
                            : Colors.white,
                        margin: EdgeInsets.all(2),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Image.asset(
                            variable.mayaAssets[index] + variable.strExtImg,
                            height: 50,
                            width: 50,
                          ),
                        ),
                        elevation: 1,
                        shape: CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                      ),
                    ),
                  ),
                ))
              ]),
        ),
        Divider(),
        Theme(
          data: theme,
          child: ExpansionTile(
              title: Text(variable.strColorPalete,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: <Widget>[
                ListTile(
                    title: Container(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: variable.myThemes.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              PreferenceUtil.saveTheme(Constants.keyPriColor,
                                  variable.myThemes[index]);
                              PreferenceUtil.saveTheme(Constants.keyGreyColor,
                                  variable.myGradient[index]);
                              selectedPrimaryColor = variable.myThemes[index];
                              HomeScreen.of(context).refresh();
                              setState(() {});
                            },
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(colors: [
                                        Color(variable.myThemes[index]),
                                        Color(variable.myGradient[index])
                                      ])),
                                  height: 50,
                                  width: 50,
                                  child: variable.myThemes[index] ==
                                          selectedPrimaryColor
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : SizedBox(),
                                )),
                          ),
                        ))),
              ]),
        ),
        Divider()
      ],
    );
  }

  Widget getValuesFromSharedPrefernce() {
    return new FutureBuilder<MyProfileModel>(
      future: getMyProfile(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(
              backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
            ),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          return getBody();
        }
      },
    );
  }

  void moveToLoginPage(SignOutResponse signOutResponse) {
    print('inside loout');
    PreferenceUtil.clearAllData().then((value) {
      // PageNavigator.goToPermanent(context,router.rt_SignIn);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => PatientSignInScreen()),
          (route) => false);
    });
  }
}
