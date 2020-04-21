import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/DatabseUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/ShapesPainter.dart';
import 'package:showcaseview/showcase_widget.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          Duration(milliseconds: 200),
          () => ShowCaseWidget.of(_myContext)
              .startShowCase([_showMaya, _provider, _records, _family]));
    });
    _myProfileBloc = new MyProfileBloc();
    getUserProfileData();
    new CommonUtil().getMedicalPreference();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {},
      builder: Builder(
        builder: (context) {
          _myContext = context;
          return Scaffold(
              body: Stack(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: new AssetImage('assets/bg/family_bg.png'),
                          fit: BoxFit.cover)),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.black.withOpacity(0.5),
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
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: CommonUtil.customShowCase(
                                            _showMaya,
                                            'Tap to speak',
                                            Image.asset(
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
                                          CommonUtil.customShowCase(
                                            _provider,
                                            'show provider',
                                            Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Image.asset(
                                                'assets/navicons/my_providers.png',
                                                width: 30,
                                                height: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
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
                                        CommonUtil.customShowCase(
                                          _records,
                                          'see your records',
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              'assets/navicons/records.png',
                                              color: Colors.white,
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                        ),
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
                                      moveToNextScreen(0);
                                    },
                                  )),
                              Positioned(
                                bottom: 50,
                                right: 20,
                                child: InkWell(
                                  child: Column(
                                    children: <Widget>[
                                      CommonUtil.customShowCase(
                                        _family,
                                        'see family member',
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Image.asset(
                                            'assets/navicons/my_family.png',
                                            height: 30,
                                            width: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
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
      print('Inside dashboard' + profileData.toString());
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
          .then((value) {
        try {
          if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) !=
              PreferenceUtil.getProfileData(Constants.KEY_PROFILE)) {
          } else {
            PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData);
          }
        } catch (e) {
          PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData);
        }
      });
    });

    DatabaseUtil.getCountryMetrics(
        PreferenceUtil.getIntValue(CommonConstants.KEY_COUNTRYCODE));

    var commonConstants = new CommonConstants();
    commonConstants.getCountryMetrics();
  }
}
