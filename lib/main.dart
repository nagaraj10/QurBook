import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/DatabseUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;

import 'package:myfhb/schedules/add_reminders.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/ui/connectivity_bloc.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:provider/provider.dart';
import 'common/CommonConstants.dart';
import 'common/CommonUtil.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/ui/HomeScreen.dart';
import 'package:myfhb/src/ui/IntroSlider.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';
import 'package:myfhb/src/ui/authentication/WebCognitoScreen.dart';
import 'package:myfhb/src/ui/camera/TakePictureScreen.dart';
import 'package:myfhb/src/ui/camera/take_picture_screen_for_devices.dart';
import 'package:myfhb/src/ui/dashboard.dart';
import 'package:myfhb/src/ui/settings/MySettings.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/add_address/screens/add_address_screen.dart';
import 'package:myfhb/add_family_otp/screens/add_family_otp_screen.dart';
import 'package:myfhb/add_family_user_info/screens/add_family_user_info.dart';
import 'package:myfhb/add_providers/screens/add_providers_screen.dart';
import 'package:myfhb/confirm_location/screens/confirm_location_screen.dart';
import 'package:myfhb/feedback/Feedbacks.dart';
import 'package:myfhb/feedback/FeedbacksSucess.dart';
import 'package:myfhb/my_family/screens/MyFamily.dart';
import 'package:myfhb/my_family_detail/screens/my_family_detail_screen.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/my_providers/screens/my_provider.dart';
import 'package:myfhb/my_family_detail_view/screens/my_family_detail_view.dart';
import 'package:myfhb/schedules/add_appointments.dart';


var firstCamera;
List<CameraDescription> listOfCameras;

//variable for all outer
var routes;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  listOfCameras = cameras;

  // Get a specific camera from the list of available cameras.
  firstCamera = cameras[0];
 // routes = await router.setRouter(listOfCameras);

  routes=<String, WidgetBuilder>{
    router.rt_Splash: (BuildContext context) => SplashScreen(),
    router.rt_SignIn: (BuildContext context) => SignInScreen(),
    router.rt_Dashboard: (BuildContext context) => DashboardScreen(),
    router.rt_HomeScreen: (BuildContext context) =>
        HomeScreen(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_UserAccounts: (BuildContext context) =>
        UserAccounts(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AppSettings: (BuildContext context) => MySettings(),
    router.rt_MyRecords: (BuildContext context) => MyRecords(),
    router.rt_MyFamily: (BuildContext context) => MyFamily(),
    router.rt_myprovider: (BuildContext context) => MyProvider(),
    router.rt_AddProvider: (BuildContext context) =>
        AddProviders(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AddAddress: (BuildContext context) =>
        AddAddressScreen(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_SearchProvider: (BuildContext context) => SearchSpecificList(
      arguments: ModalRoute.of(context).settings.arguments,
      toPreviousScreen: false,
    ),
    router.rt_TakePicture: (BuildContext context) => TakePictureScreen(
      camera: firstCamera,
    ),
    router.rt_TakePictureForDevices: (BuildContext context) =>
        TakePictureScreenForDevices(cameras: listOfCameras),
    router.rt_ConfirmLocation: (BuildContext context) => ConfirmLocationScreen(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AudioScreen: (BuildContext context) => AudioRecordScreen(),
    // "/sign_up_screen": (BuildContext context) => SignUpScreen(),
    router.rt_AddFamilyOtp: (BuildContext context) =>
        AddFamilyOTPScreen(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AddFamilyUserInfo: (BuildContext context) => AddFamilyUserInfoScreen(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_FamilyDetailScreen: (BuildContext context) => MyFamilyDetailScreen(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_FamilyInsurance: (BuildContext context) =>
        MyFamilyDetailView(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AddReminders: (BuildContext context) => AddReminder(),
    router.rt_AddAppointments: (BuildContext context) => AddAppointments(),
    router.rt_IntroSlider: (BuildContext context) => IntroSliderPage(),
    router.rt_Feedbacks: (BuildContext context) => Feedbacks(),
    router.rt_FeedbackSucess: (BuildContext context) => FeedbackSuccess(),
    router.rt_WebCognito: (BuildContext context) => WebCognitoScreen(),
    router.rt_TelehealthProvider: (BuildContext context) =>
        TelehealthProviders(arguments: ModalRoute.of(context).settings.arguments),
  };
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
}
