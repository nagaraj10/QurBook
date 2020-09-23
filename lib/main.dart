import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/DatabseUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/fhb_router.dart' as router;
import 'package:myfhb/constants/router_variable.dart' as routervariable;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/schedules/add_reminders.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/video_call/pages/callmain.dart';
import 'package:myfhb/video_call/services/push_notification_provider.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
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
    MyFHB(),
  );

  // await saveToPreference();
  //await PreferenceUtil.saveString(Constants.KEY_AUTHTOKEN, Constants.AuthToken);
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
  CommonUtil.SHEELA_URL = values[0];
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
  CommonUtil.COGNITO_URL = values[11];
  CommonUtil.BASE_URL_V2 = values[12];
  CommonUtil.BASEURL_DEVICE_READINGS = values[13];
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

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _internetconnection = false;
  var _connectionStatus = '';
  FlutterToast toast = new FlutterToast();

  /// event channel for listening ns
  static const stream =
      const EventChannel('com.example.agoraflutterquickstart/stream');
  StreamSubscription _timerSubscription = null;
  String _msg = 'waiting for message';
  ValueNotifier<String> _msgListener = ValueNotifier('');

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  var globalContext;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    CommonUtil.askPermissionForCameraAndMic();
    getMyRoute();
    _enableTimer();

    if (Platform.isIOS) {
      // Push Notifications
      final provider = PushNotificationsProvider();
      provider.initNotification();

      provider.pushController.listen((callarguments) {
        Get.key.currentState
            .pushNamed(routervariable.rt_CallMain, arguments: callarguments);
      });
    }

    //gettingResponseFromNative();
    ///un comment this while on production mode for enabling security.
    //showSecurityWall();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
    var doctorPic = '';
    _msgListener.value = _msg;
    final String c_msg = msg as String;
    if (c_msg.isNotEmpty || c_msg != null) {
      var passedValArr = c_msg.split('&');
      if (c_msg == 'ack') {
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(selectedIndex: 0),
        ));
      } else if (passedValArr[0] == 'reschedule') {
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(selectedIndex: 1),
        ));
        // History doc = History(
        //   doctorId: '',
        //   bookingId: '', //this shoould be booking id
        // );

        // Get.to(
        //   ResheduleMain(
        //     doc: doc,
        //     isReshedule: true,
        //   ),
        // );
      } else if (passedValArr[0] == 'cancel_appointment') {
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(
              selectedIndex: 0,
              isCancelDialogShouldShow: true,
              bookingId: passedValArr[1] ?? ''),
        ));
      } else if (passedValArr[4] == 'call') {
        try {
          doctorPic = passedValArr[3];
          if (doctorPic.isNotEmpty) {
            doctorPic = json.decode(doctorPic);
          } else {
            doctorPic = '';
          }
        } catch (e) {}
        Get.to(CallMain(
          doctorName: passedValArr[1],
          doctorId: passedValArr[2],
          doctorPic: doctorPic,
          channelName: passedValArr[0],
          role: ClientRole.Broadcaster,
          isAppExists: true,
        ));
      }
    }
  }

  getMyRoute() async {
    var route = await nav_platform.invokeMethod("getMyRoute");
    if (route != null) {
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
          provider.ChangeNotifierProvider<HideProvider>(
            create: (_) => HideProvider(),
          ),
        ],
        child: MaterialApp(
          title: Constants.APP_NAME,
          theme: ThemeData(
            fontFamily: variable.font_poppins,
            primaryColor: Color(myPrimaryColor),
            accentColor: Colors.white,
          ),
          //home: navRoute.isEmpty ? SplashScreen() : StartTheCall(),
          home: findHomeWidget(navRoute),
          routes: routes,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
        ));
  }

  Widget findHomeWidget(String navRoute) {
    if (navRoute.isEmpty) {
      return SplashScreen();
    } else {
      if (navRoute.split('&')[0] == 'reschedule') {
        return SplashScreen(
          nsRoute: 'reschedule',
          doctorID: navRoute.split('&')[1],
        );
      } else if (navRoute.split('&')[0] == 'cancel_appointment') {
        return SplashScreen(
          nsRoute: 'cancel_appointment',
          bookingID: navRoute.split('&')[1],
        );
      } else {
        return StartTheCall();
      }
    }
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
    } on PlatformException catch (e, s) {}
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;

        try {
          if (!kIsWeb && Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiName = await _connectivity.getWifiName();
            } else {
              wifiName = await _connectivity.getWifiName();
            }
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = failed_wifi;
        }

        try {
          if (!kIsWeb && Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = failed_wifi_bssid;
        }

        try {
          wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = failed_wifi_ip;
        }

        setState(() {
          _internetconnection = true;
          _connectionStatus = '$result\n'
              'Wifi Name: $wifiName\n'
              'Wifi BSSID: $wifiBSSID\n'
              'Wifi IP: $wifiIP\n';
          toast.getToast(wifi_connected, Colors.green);
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          _internetconnection = true;
          toast.getToast(data_connected, Colors.green);
        });
        break;
      case ConnectivityResult.none:
        setState(() {
          _internetconnection = false;
          _connectionStatus = no_internet_conn;
          toast.getToast(no_internet_conn, Colors.red);
        });
        break;
      default:
        setState(() {
          _internetconnection = false;
          _connectionStatus = failed_get_conn;
          toast.getToast(failed_get_connectivity, Colors.red);
        });
        break;
    }
  }

  Widget StartTheCall() {
    var docPic = navRoute.split('&')[3];
    try {
      if (docPic.isNotEmpty) {
        docPic = json.decode(navRoute.split('&')[3]);
      } else {
        docPic = '';
      }
    } catch (e) {}
    return CallMain(
      isAppExists: false,
      role: ClientRole.Broadcaster,
      channelName: navRoute.split('&')[0],
      doctorName: navRoute.split('&')[1] ?? 'Test',
      doctorId: navRoute.split('&')[2] ?? 'Doctor',
      doctorPic: docPic,
    );
  }
}
