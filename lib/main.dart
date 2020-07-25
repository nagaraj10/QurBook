import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/DatabseUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_router.dart' as router;

import 'package:myfhb/schedules/add_reminders.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/ui/connectivity_bloc.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:provider/provider.dart';
import 'common/CommonConstants.dart';
import 'common/CommonUtil.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;


var firstCamera;
List<CameraDescription> listOfCameras;

//variable for all outer
var routes;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  //get secret from resource
  List<dynamic> resList = [];
  await CommonUtil.getResourceLoader().then((value) {
    Map mSecretMap = value;
    mSecretMap.values.forEach((element) {
      resList.add(element);
    });
    setValues(resList);
  });

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  listOfCameras = cameras;

  // Get a specific camera from the list of available cameras.
  firstCamera = cameras[0];

  routes =await  router.setRouter(listOfCameras);
  PreferenceUtil.init();

  await DatabaseUtil.getDBLength().then((length) {
    if (length > 0) {
    } else {
      DatabaseUtil.insertCountryMetricsData();
    }
  });

  await DatabaseUtil.getDBLengthUnit().then((length) {
    if (length > 0) {
    } else {
      DatabaseUtil.insertUnitsForDevices();
    }
  });

  await FHBUtils.instance.initPlatformState();
  await FHBUtils.instance.getDb();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MyFHB(),
  );

  await saveToPreference();
}

void saveToPreference() async {
  PreferenceUtil.saveString(
          Constants.KEY_USERID_MAIN, Constants.userID)
      .then((onValue) {
    PreferenceUtil.saveString(
            Constants.KEY_USERID, Constants.userID)
        .then((onValue) {
      PreferenceUtil.saveString(Constants.KEY_AUTHTOKEN, Constants.Auth_token)
          .then((onValue) {
        PreferenceUtil.saveString(Constants.MOB_NUM, Constants.mobileNumber)
            .then((onValue) {
          PreferenceUtil.saveString(Constants.COUNTRY_CODE, Constants.countryCode)
              .then((onValue) {
            PreferenceUtil.saveInt(
                    CommonConstants.KEY_COUNTRYCODE, int.parse(Constants.countryCode))
                .then((value) {});
          });
        });
      });
    });
  });
}

void setValues(List<dynamic> values) {
  CommonUtil.MAYA_URL = values[0];
  CommonUtil.FAQ_URL = values[1];
  CommonUtil.GOOGLE_MAP_URL = values[2];
  CommonUtil.GOOGLE_PLACE_API_KEY = values[3];
  CommonUtil.GOOGLE_MAP_PLACE_DETAIL_URL = values[4];
  CommonUtil.GOOGLE_ADDRESS_FROM__LOCATION_URL = values[5];
  CommonUtil.GOOGLE_STATIC_MAP_URL = values[6];
  CommonUtil.BASE_URL_FROM_RES = values[7];
  CommonUtil.BASE_COVER_IMAGE = values[8];
  CommonUtil.BASE_URL_V2 = values[9];
}

class MyFHB extends StatefulWidget {
  @override
  _MyFHBState createState() => _MyFHBState();
}

class _MyFHBState extends State<MyFHB> {
  int myPrimaryColor = new CommonUtil().getMyPrimaryColor();
  static const platform = variable.version_platform;
  String _responseFromNative = variable.strWaitLoading;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const secure_platform = variable.security;

  @override
  void initState() {
    super.initState();
    gettingResponseFromNative();
    showSecurityWall();
  }

  @override
  Widget build(BuildContext context) {
    var nsSettingsForAndroid =
        new AndroidInitializationSettings(variable.strLauncher);
    var nsSettingsForIOS = new IOSInitializationSettings();
    var platform =
        new InitializationSettings(nsSettingsForAndroid, nsSettingsForIOS);

    Future notificationAction(String payload) async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddReminder()));
    }

    flutterLocalNotificationsPlugin.initialize(platform,
        onSelectNotification: notificationAction);
    return baseWidget();
  }

  Widget baseWidget() {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ConnectivityBloc(),
          )
        ],
        child: MaterialApp(
          title: Constants.APP_NAME,
          theme: ThemeData(
            fontFamily: variable.font_poppins,
            primaryColor: Color(myPrimaryColor),
            accentColor: Colors.white,
          ),
          home: SplashScreen(),
          routes: routes,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
        ));
  }

  Future<void> gettingResponseFromNative() async {
    String res = '';
    try {
      final String result = await platform.invokeMethod(variable.strGetAppVersion);
      res = result;
    } on PlatformException catch (e) {
      res = variable.strFailed+"'${e.message}'.";
    }

    setState(() {
      _responseFromNative = res;
      CommonConstants.appVersion = _responseFromNative;
    });
  }

  Future<void> showSecurityWall() async {
    try {
      final int RESULT_CODE = await secure_platform.invokeMethod(variable.strSecure);
      switch (RESULT_CODE) {
        case 1003:
          //todo authorized unsuccessfull
          SystemChannels.platform.invokeMethod<void>(variable.strpop);
          break;
      }
    } on PlatformException catch (e, s) {}
  }
}
