import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/DatabseUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/ShapesPainter.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'dart:io';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  MyProfileBloc _myProfileBloc;
  BuildContext _myContext;
  final GlobalKey _showMaya = GlobalKey();
  final GlobalKey _provider = GlobalKey();
  final GlobalKey _records = GlobalKey();
  final GlobalKey _family = GlobalKey();
  final GlobalKey _coverImage = GlobalKey();
  File imageURIProfile;

  @override
  void initState() {
    super.initState();
    var isFirstTime =
        PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_DASHBOARD);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          Duration(milliseconds: 200),
          () => isFirstTime
              ? null
              : ShowCaseWidget.of(_myContext).startShowCase(
                  [_showMaya, _provider, _records, _family, _coverImage]));
    });
    _myProfileBloc = new MyProfileBloc();
    getUserProfileData();
    new CommonUtil().getMedicalPreference();

    String profilebanner =
        PreferenceUtil.getStringValue(Constants.KEY_DASHBOARD_BANNER);
    if (profilebanner != null) {
      imageURIProfile = File(profilebanner);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {
        PreferenceUtil.saveString(Constants.KEY_SHOWCASE_DASHBOARD, 'true');
      },
      builder: Builder(
        builder: (context) {
          _myContext = context;
          return Scaffold(
              body: Stack(
            children: <Widget>[
              Container(
                  decoration: imageURIProfile != null
                      ? BoxDecoration(
                          image: DecorationImage(
                              image: new FileImage(imageURIProfile),
                              fit: BoxFit.cover))
                      : BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                      CustomPaint(
                          painter: ShapesPainter(),
                          child: Container(
                              child: Stack(
                            children: <Widget>[
                              Positioned(
                                  bottom: -20,
                                  left:
                                      (MediaQuery.of(context).size.width / 2) -
                                          60,
                                  child: InkWell(
                                    child: AvatarGlow(
                                      startDelay: Duration(milliseconds: 1000),
                                      glowColor: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      endRadius: 60.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration:
                                          Duration(milliseconds: 100),
                                      child: Material(
                                        color: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: CircleBorder(),
                                        child: FHBBasicWidget.customShowCase(
                                            _showMaya,
                                            Constants.MAYA_DESC,
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Image.asset(
                                                  PreferenceUtil.getStringValue(
                                                              'maya_asset') !=
                                                          null
                                                      ? PreferenceUtil
                                                              .getStringValue(
                                                                  'maya_asset') +
                                                          '_main.png'
                                                      : 'assets/maya/maya_us.png',
                                                  height: 60,
                                                  width: 60,
                                                ),
                                              ),
                                              radius: 30.0,
                                            ),
                                            Constants.MAYA_TITLE),
                                      ),
                                      shape: BoxShape.circle,
                                      animate: true,
                                      curve: Curves.fastOutSlowIn,
                                    ),
                                    onTap: () {
                                      moveToNextScreen(2);
                                    },
                                  )),
                              Positioned(
                                  bottom: 50,
                                  left: 20,
                                  child: InkWell(
                                      child: Column(
                                        children: <Widget>[
                                          FHBBasicWidget.customShowCase(
                                              _provider,
                                              Constants.PROVIDERS_DESC,
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Image.asset(
                                                  'assets/navicons/my_providers.png',
                                                  width: 30,
                                                  height: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Constants.PROVIDERS_TITLE),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'My Providers',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        //moveToNextScreen(3);
                                        Navigator.pushNamed(
                                          context,
                                          '/user_accounts',
                                          arguments: UserAccountsArguments(
                                              selectedIndex: 2),
                                        );
                                      })),
                              Positioned(
                                  bottom: 130,
                                  left:
                                      (MediaQuery.of(context).size.width / 2) -
                                          35,
                                  child: InkWell(
                                    splashColor: Colors.red,
                                    child: Column(
                                      children: <Widget>[
                                        FHBBasicWidget.customShowCase(
                                            _records,
                                            Constants.RECORDS_DESC,
                                            Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Image.asset(
                                                'assets/navicons/records.png',
                                                color: Colors.white,
                                                height: 25,
                                                width: 25,
                                              ),
                                            ),
                                            Constants.RECORDS_TITLE),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'My Records',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      moveToNextScreen(1);
                                    },
                                  )),
                              Positioned(
                                bottom: 50,
                                right: 20,
                                child: InkWell(
                                  child: Column(
                                    children: <Widget>[
                                      FHBBasicWidget.customShowCase(
                                          _family,
                                          Constants.FAMILY_DESC,
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              'assets/navicons/my_family.png',
                                              height: 30,
                                              width: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Constants.FAMILY_TITLE),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'My Family',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/user_accounts',
                                        arguments: UserAccountsArguments(
                                            selectedIndex: 1));
                                  },
                                ),
                              )
                            ],
                          ))),
                      Container(
                        margin: EdgeInsets.only(
                          top: 20,
                        ),
                        alignment: Alignment.topRight,
                        child: imageURIProfile != null
                            ? IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  saveMediaDialog(context, false);
                                },
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FHBBasicWidget.customShowCase(
                                        _coverImage,
                                        Constants.COVER_IMG_DESC,
                                        Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                gradient:
                                                    LinearGradient(colors: [
                                                  Color(CommonUtil()
                                                      .getMyPrimaryColor()),
                                                  Color(CommonUtil()
                                                      .getMyGredientColor())
                                                ])),
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.add_a_photo,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  saveMediaDialog(
                                                      context, false);
                                                })),
                                        Constants.COVER_IMG_TITLE),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 10, left: 40, right: 40),
                                      child: Text(
                                        Constants.NO_DATA_DASHBOARD,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Color(CommonUtil()
                                                .getMyPrimaryColor()),
                                            fontSize: 13,
                                            fontFamily: 'Poppins'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      )
                    ],
                  )),
            ],
          ));
        },
      ),
    );
  }

  moveToNextScreen(int i) {
    Navigator.pushNamed(
      context,
      '/home_screen',
      arguments: HomeScreenArguments(selectedIndex: i),
    ).then((value) {});
  }

  getUserProfileData() async {
    _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      if (profileData != null &&
          profileData.status == 200 &&
          profileData.success) {
        print('Inside dashboard' + profileData.toString());
        PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
            .then((value) {
          try {
            if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) !=
                PreferenceUtil.getProfileData(Constants.KEY_PROFILE)) {
            } else {
              PreferenceUtil.saveProfileData(
                  Constants.KEY_PROFILE, profileData);
            }
          } catch (e) {
            PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData);
          }
        });
      }
    });

    DatabaseUtil.getCountryMetrics(
        PreferenceUtil.getIntValue(CommonConstants.KEY_COUNTRYCODE));

    var commonConstants = new CommonConstants();
    commonConstants.getCountryMetrics();
  }

  saveMediaDialog(BuildContext cont, bool isProfileImage) {
    print('Inside saveMedia');
    return showDialog<void>(
      context: cont,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: Text('Make a Choice!'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text('Gallery'),
                      onTap: () {
                        Navigator.pop(context);

                        var image =
                            ImagePicker.pickImage(source: ImageSource.gallery);
                        image.then((value) {
                          print('file Path' + value.path);

                          imageURIProfile = value;
                          PreferenceUtil.saveString(
                              Constants.KEY_DASHBOARD_BANNER, value.path);

                          (cont as Element).markNeedsBuild();
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    GestureDetector(
                      child: Text('Camera'),
                      onTap: () {
                        Navigator.pop(context);

                        var image =
                            ImagePicker.pickImage(source: ImageSource.camera);
                        image.then((value) {
                          imageURIProfile = value;
                          PreferenceUtil.saveString(
                              Constants.KEY_DASHBOARD_BANNER, value.path);

                          (cont as Element).markNeedsBuild();
                        });
                      },
                    ),
                  ],
                ),
              ));
        });
      },
    );
  }
}
