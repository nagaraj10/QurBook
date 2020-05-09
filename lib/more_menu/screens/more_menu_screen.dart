import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/myfhb_weview/myfhb_webview.dart';
import 'package:myfhb/src/model/Authentication/SignOutResponse.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/src/ui/HomeScreen.dart';
import 'package:launch_review/launch_review.dart';

class MoreMenuScreen extends StatefulWidget {
  Function refresh;

  MoreMenuScreen({this.refresh});
  @override
  _MoreMenuScreenState createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends State<MoreMenuScreen> {
  MyProfile myProfile =
      PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

  List<String> mayaAssets = [
    'assets/maya/maya_us_main',
    'assets/maya/maya_india_main',
    'assets/maya/maya_africa_main',
    'assets/maya/maya_arab_main',
  ];

  List<int> myThemes = [
    0xff5e1fe0,
    0xffcf4791,
    0xff0483df,
    0xff118c94,
    0xff17a597,
  ];

  List<int> myGradient = [
    0xff753aec,
    0xfffab273,
    0xff01bbd4,
    0xff0cbcb6,
    0xff84ce6b,
  ];

  String selectedMaya = PreferenceUtil.getStringValue('maya_asset') != null
      ? PreferenceUtil.getStringValue('maya_asset')
      : 'assets/maya/maya_us_main.png';

  int selectedPrimaryColor = PreferenceUtil.getSavedTheme('pri_color') != null
      ? PreferenceUtil.getSavedTheme('pri_color')
      : 0xff5e1fe0;

  int selectedGradientColor = PreferenceUtil.getSavedTheme('gre_color') != null
      ? PreferenceUtil.getSavedTheme('gre_color')
      : 0xff753aec;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: GradientAppBar(),
            leading: Container(),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    new FHBBasicWidget().exitApp(context, () {
                      PreferenceUtil.clearAllData().then((value) {
                        new CommonUtil().logout(moveToLoginPage);
                      });
                    });
                  })
            ]),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: ListTile(
                leading: ClipOval(
                  child: FHBBasicWidget().getProfilePicWidget(
                      myProfile.response.data.generalInfo.profilePicThumbnail),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      myProfile.response.data.generalInfo.name != null
                          ? toBeginningOfSentenceCase(
                              myProfile.response.data.generalInfo.name)
                          : '',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      myProfile.response.data.generalInfo.countryCode +
                          ' ' +
                          myProfile.response.data.generalInfo.phoneNumber,
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      myProfile.response.data.generalInfo.email,
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
                    '/user_accounts',
                    arguments: UserAccountsArguments(selectedIndex: 0),
                  );
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Settings',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
              onTap: () {
                PageNavigator.goTo(context, '/app_settings');
              },
            ),
            Divider(),
            Theme(
              data: theme,
              child: ExpansionTile(
                title: Text('Help and support',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black)),
                children: <Widget>[
                  InkWell(
                    child: ListTile(
                        title: Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/navicons/faq.png'),
                          color: Colors.black,
                        ),
                        SizedBox(width: 20),
                        Text(Constants.FAQ),
                      ],
                    )),
                    onTap: () {
                      openWebView(Constants.FAQ,
                          'https://fhb.faqs.vsolgmi.com/', false);
                    },
                  ),
                  ListTile(
                    title: InkWell(
                        child: Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/navicons/feedback.png'),
                          color: Colors.black,
                        ),
                        SizedBox(width: 20),
                        Text('Feedback'),
                      ],
                    )),
                    onTap: () {
                      Navigator.pushNamed(context, '/feedbacks')
                          .then((value) {});
                    },
                  ),
                  InkWell(
                    child: ListTile(
                        title: Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/settings/terms.png'),
                          size: 20,
                          //size: 30,
                          color: Colors.black,
                        ),
                        SizedBox(width: 20),
                        Text(Constants.terms_of_service)
                      ],
                    )),
                    onTap: () {
                      openWebView(Constants.terms_of_service,
                          'assets/help_docs/termsandconditions.html', true);
                    },
                  ),
                  InkWell(
                    onTap: () {
                      openWebView(Constants.privacy_policy,
                          'assets/help_docs/privacypolicy.html', true);
                    },
                    child: ListTile(
                        title: Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/settings/privacy.png'),
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(width: 20),
                        Text('Privacy policy'),
                      ],
                    )),
                  ),
                  InkWell(
                    onTap: () {
                      LaunchReview.launch(
                          androidAppId: "com.globalmantrainnovations.myfhb",
                          iOSAppId: "");
                    },
                    child: ListTile(
                        title: Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/icons/record_fav.png'),
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(width: 20),
                        Text('Rate us'),
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
                  title: Text('Maya',
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
                        itemCount: mayaAssets.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            PreferenceUtil.saveString(
                                'maya_asset', mayaAssets[index]);
                            selectedMaya = mayaAssets[index];
                            HomeScreen.of(context).refresh();
                            setState(() {});
                          },
                          child: Card(
                            color: mayaAssets[index] == selectedMaya
                                ? Color(new CommonUtil().getMyPrimaryColor())
                                : Colors.white,
                            margin: EdgeInsets.all(2),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Image.asset(
                                mayaAssets[index] + '.png',
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
                  title: Text('Color palette',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black)),
                  children: <Widget>[
                    ListTile(
                        title: Container(
                            //padding: EdgeInsets.only(top: 10, bottom: 10),
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: myThemes.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  PreferenceUtil.saveTheme(
                                      'pri_color', myThemes[index]);
                                  PreferenceUtil.saveTheme(
                                      'gre_color', myGradient[index]);
                                  selectedPrimaryColor = myThemes[index];
                                  HomeScreen.of(context).refresh();
                                  setState(() {});
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(colors: [
                                            Color(myThemes[index]),
                                            Color(myGradient[index])
                                          ])),
                                      height: 50,
                                      width: 50,
                                      child: myThemes[index] ==
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
        ));
  }

  void openWebView(String title, String url, bool isLocal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MyFhbWebView(
            title: title, selectedUrl: url, isLocalAsset: isLocal)));
  }

  void moveToLoginPage(SignOutResponse signOutResponse) {
    PageNavigator.goToPermanent(context, '/sign_in_screen');
  }
}
