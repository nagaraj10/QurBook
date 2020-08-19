import 'dart:async';
import 'dart:io' show Platform;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/DatabseUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_router.dart' as router;
import 'package:myfhb/constants/router_variable.dart' as routervariable;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/schedules/add_reminders.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/video_call/model/CallArguments.dart';
import 'package:myfhb/video_call/pages/callmain.dart';
import 'package:myfhb/video_call/push_notification_provider.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart' as provider;

import 'common/CommonConstants.dart';
import 'common/CommonUtil.dart';
import 'src/ui/SplashScreen.dart';
import 'src/ui/connectivity_bloc.dart';

var firstCamera;
List<CameraDescription> listOfCameras;

//variable for all outer
var routes;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _handleCameraAndMic();
  final cameras = await availableCameras();
  listOfCameras = cameras;

  // Get a specific camera from the list of available cameras.
  firstCamera = cameras[0];
  routes = await router.setRouter(listOfCameras);

  //get secret from resource
  List<dynamic> resList = [];
  await CommonUtil.getResourceLoader().then((value) {
    Map mSecretMap = value;
    mSecretMap.values.forEach((element) {
      resList.add(element);
    });
    setValues(resList);
  });

  PreferenceUtil.init();

  await DatabaseUtil.getDBLength().then((length) {
    if (length == 0) {
      DatabaseUtil.insertCountryMetricsData();
    }
  });

  await DatabaseUtil.getDBLengthUnit().then((length) {
    if (length == 0) {
      DatabaseUtil.insertUnitsForDevices();
    }
  });

  await FHBUtils.instance.initPlatformState();
  await FHBUtils.instance.getDb();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
   MyFHB() ,
  );

  // await saveToPreference();
}

Future<void> _handleCameraAndMic() async {
  await PermissionHandler().requestPermissions(
    [PermissionGroup.camera, PermissionGroup.microphone],
  );
}

void saveToPreference() async {
  PreferenceUtil.saveString(Constants.KEY_USERID_MAIN, Constants.userID)
      .then((onValue) {
    PreferenceUtil.saveString(Constants.KEY_USERID, Constants.userID)
        .then((onValue) {
      PreferenceUtil.saveString(Constants.KEY_AUTHTOKEN, '').then((onValue) {
        PreferenceUtil.saveString(Constants.MOB_NUM, Constants.mobileNumber)
            .then((onValue) {
          PreferenceUtil.saveString(
                  Constants.COUNTRY_CODE, Constants.countryCode)
              .then((onValue) {
            PreferenceUtil.saveInt(CommonConstants.KEY_COUNTRYCODE,
                    int.parse(Constants.countryCode))
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
  CommonUtil.COGNITO_AUTH_CODE = values[9];
  CommonUtil.COGNITO_AUTH_TOKEN = values[10];
  CommonUtil.COGNITO_URL=values[11];
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
  static const nav_platform = const MethodChannel('navigation.channel');
  String navRoute = '';

  /// event channel for listening ns
  static const stream =
      const EventChannel('com.example.agoraflutterquickstart/stream');
  StreamSubscription _timerSubscription = null;
  String _msg = 'waiting for message';
  ValueNotifier<String> _msgListener = ValueNotifier('');

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    getMyRoute();
    _enableTimer();

    if (Platform.isIOS) {
      // Push Notifications
      final provider = PushNotificationsProvider();
      provider.initNotification();

      provider.pushController.listen((event) {
        Get.key.currentState.pushNamed(routervariable.rt_CallMain,
            arguments: CallArguments(
                role: ClientRole.Broadcaster, channelName: 'Test'));
      });
    }

    ////    gettingResponseFromNative();
////    showSecurityWall();
  }

  @override
  void dispose() {
    _disableTimer();
    super.dispose();
  }

  void _enableTimer() {
    if (_timerSubscription == null) {
      _timerSubscription = stream.receiveBroadcastStream().listen(_updateTimer);
    }
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  void _updateTimer(msg) {
    debugPrint("Current Message $msg");
    //setState(() => _msg = msg);
    _msgListener.value = _msg;
    final String c_msg = msg as String;
    if (c_msg.isNotEmpty || c_msg != null) {
      Get.to(CallMain(
        //channelName: navRoute,
        channelName: 'Test',
        role: ClientRole.Broadcaster,
        isAppExists: true,
      ));
    }
  }

  getMyRoute() async {
    var route = await nav_platform.invokeMethod("getMyRoute");
    if (route != null) {
      print('native nav_route $route');
      setState(() {
        navRoute = route;
      });
    }
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
    return provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider<ConnectivityBloc>(
            create: (_) => ConnectivityBloc(),
          ),
          provider.ChangeNotifierProvider<CallStatus>(
            create: (_) => CallStatus(),
          ),
        ],
        child: MaterialApp(
          title: Constants.APP_NAME,
          theme: ThemeData(
            fontFamily: variable.font_poppins,
            primaryColor: Color(myPrimaryColor),
            accentColor: Colors.white,
          ),
          home: navRoute.isEmpty
              ? SplashScreen()
              : CallMain(
                  isAppExists: false,
                  role: ClientRole.Broadcaster,
                  channelName: navRoute,
                ),
          routes: routes,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
        ));
  }

  Future<void> gettingResponseFromNative() async {
    String res = '';
    try {
      final String result =
          await platform.invokeMethod(variable.strGetAppVersion);
      res = result;
    } on PlatformException catch (e) {
      res = variable.strFailed + "'${e.message}'.";
    }

    setState(() {
      _responseFromNative = res;
      CommonConstants.appVersion = _responseFromNative;
    });
  }

  Future<void> showSecurityWall() async {
    try {
      final int RESULT_CODE =
          await secure_platform.invokeMethod(variable.strSecure);
      switch (RESULT_CODE) {
        case 1003:
          //todo authorized unsuccessfull
          SystemChannels.platform.invokeMethod<void>(variable.strpop);
          break;
      }
    } on PlatformException catch (e, s) {}
  }

  void requeatPermissionForAudioAndCamera() async {
    /*  final Permission cameraPermission = Permission.camera;
    var cameraPermissionResult = await cameraPermission.status;

    final Permission audioPermission = Permission.microphone;
    var audioPermissionResult = await cameraPermission.status;

    print(cameraPermissionResult.toString());
    print(audioPermissionResult.toString());


    if(cameraPermissionResult == PermissionStatus.denied || cameraPermissionResult == PermissionStatus.undetermined ){
      cameraPermission.request();
    }

    if(audioPermissionResult == PermissionStatus.denied || audioPermissionResult == PermissionStatus.undetermined ){
      audioPermission.request();
    }


    print(cameraPermissionResult.toString());
    print(audioPermissionResult.toString());

   */
  }
}
