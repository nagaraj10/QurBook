import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/DatabseUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family_detail_view/screens/my_family_detail_view.dart';
import 'package:myfhb/my_providers/screens/my_provider.dart';
import 'package:myfhb/schedules/add_appointments.dart';
import 'package:myfhb/schedules/add_reminders.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/src/ui/HomeScreen.dart';
import 'package:myfhb/src/ui/IntroSlider.dart';
import 'package:myfhb/src/ui/MyRecordClone.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';
import 'package:myfhb/src/ui/camera/TakePictureScreen.dart';
import 'package:myfhb/src/ui/camera/take_picture_screen_for_devices.dart';
import 'package:myfhb/src/ui/connectivity_bloc.dart';
import 'package:myfhb/src/ui/dashboard.dart';
import 'package:myfhb/src/ui/settings/MySettings.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:provider/provider.dart';
import 'add_address/screens/add_address_screen.dart';
import 'add_family_otp/screens/add_family_otp_screen.dart';
import 'add_family_user_info/screens/add_family_user_info.dart';
import 'add_providers/screens/add_providers_screen.dart';
import 'common/CommonConstants.dart';
import 'common/CommonUtil.dart';
import 'confirm_location/screens/confirm_location_screen.dart';
import 'feedback/Feedbacks.dart';
import 'feedback/FeedbacksSucess.dart';
import 'my_family/screens/MyFamily.dart';
import 'my_family_detail/screens/my_family_detail_screen.dart';
import 'package:myfhb/src/model/secretmodel.dart';
import 'package:myfhb/src/model/sceretLoader.dart';
import 'telehealth/features/MyProvider/view/TelehealthProviders.dart';


var firstCamera;
List<CameraDescription> listOfCameras;

var routes = <String, WidgetBuilder>{
  "/splashscreen": (BuildContext context) => SplashScreen(),
  "/sign-in-screen": (BuildContext context) => SignInScreen(),
  "/dashboard-screen": (BuildContext context) => DashboardScreen(),
  "/home-screen": (BuildContext context) =>
      HomeScreen(arguments: ModalRoute.of(context).settings.arguments),
  "/user-accounts": (BuildContext context) =>
      UserAccounts(arguments: ModalRoute.of(context).settings.arguments),
  "/app-settings": (BuildContext context) => MySettings(),
  "/my-records": (BuildContext context) => MyRecordsClone(),
  "/my-family": (BuildContext context) => MyFamily(),
  "/my-providers": (BuildContext context) => MyProvider(),
  "/add-providers": (BuildContext context) =>
      AddProviders(arguments: ModalRoute.of(context).settings.arguments),
  "/add-address": (BuildContext context) =>
      AddAddressScreen(arguments: ModalRoute.of(context).settings.arguments),
  "/search-providers": (BuildContext context) => SearchSpecificList(
        arguments: ModalRoute.of(context).settings.arguments,
        toPreviousScreen: false,
      ),
  "/take-picture-screen": (BuildContext context) => TakePictureScreen(
        camera: firstCamera,
      ),
  "/take-picture-screen-for-devices": (BuildContext context) =>
      TakePictureScreenForDevices(cameras: listOfCameras),
  "/confirm-location": (BuildContext context) => ConfirmLocationScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/audio-record-screen": (BuildContext context) => AudioRecordScreen(),
  // "/sign_up_screen": (BuildContext context) => SignUpScreen(),
  "/add-family-otp-screen": (BuildContext context) =>
      AddFamilyOTPScreen(arguments: ModalRoute.of(context).settings.arguments),
  "/add-family-user-info": (BuildContext context) => AddFamilyUserInfoScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/my-family-detail-screen": (BuildContext context) => MyFamilyDetailScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/my-family-detail-view-insurance": (BuildContext context) =>
      MyFamilyDetailView(arguments: ModalRoute.of(context).settings.arguments),
  "/add-reminders": (BuildContext context) => AddReminder(),
  "/add-appointments": (BuildContext context) => AddAppointments(),
  "/intro-slider": (BuildContext context) => IntroSliderPage(),
  "/feedbacks": (BuildContext context) => Feedbacks(),
  "/feedbacks-success": (BuildContext context) => FeedbackSuccess(),

    "/telehealth-providers": (BuildContext context) =>
      TelehealthProviders(arguments: ModalRoute.of(context).settings.arguments),
};

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  //get secret from resource
  List<dynamic> resList= [];
  await CommonUtil.getResourceLoader().then((value){
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

  await PreferenceUtil.init();

  DatabaseUtil.getDBLength().then((length) {
    if (length > 0) {
    } else {
      DatabaseUtil.insertCountryMetricsData();
    }
  });

  DatabaseUtil.getDBLengthUnit().then((length) {
    if (length > 0) {
    } else {
      DatabaseUtil.insertUnitsForDevices();
    }
  });

  await FHBUtils.instance.initPlatformState();
  await FHBUtils.instance.getDb();
  await saveToPreference();



  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MyFHB(),
  );

   await saveToPreference();
}

void saveToPreference()async{

  PreferenceUtil.saveString(
              Constants.KEY_USERID_MAIN, 'bde140db-0ffc-4be6-b4c0-5e44b9f54535')
          .then((onValue) {
        PreferenceUtil.saveString(Constants.KEY_USERID, 'bde140db-0ffc-4be6-b4c0-5e44b9f54535')
            .then((onValue) {
          PreferenceUtil.saveString(
                  Constants.KEY_AUTHTOKEN, Constants.Auth_token)
              .then((onValue) {
            PreferenceUtil.saveString(
                    Constants.MOB_NUM, '9176117878')
                .then((onValue) {
              PreferenceUtil.saveString(
                      Constants.COUNTRY_CODE, '91')
                  .then((onValue) {
                PreferenceUtil.saveInt(CommonConstants.KEY_COUNTRYCODE,
                        int.parse('91'))
                    .then((value) {
                });
              });
            });
          });
        });
      });
}

void setValues(List<dynamic> values){
  CommonUtil.MAYA_URL=values[0];
  CommonUtil.FAQ_URL=values[1];
  CommonUtil.GOOGLE_MAP_URL=values[2];
  CommonUtil.GOOGLE_PLACE_API_KEY=values[3];
  CommonUtil.GOOGLE_MAP_PLACE_DETAIL_URL=values[4];
  CommonUtil.GOOGLE_ADDRESS_FROM__LOCATION_URL=values[5];
  CommonUtil.GOOGLE_STATIC_MAP_URL=values[6];
  CommonUtil.BASE_URL_FROM_RES=values[7];
  CommonUtil.BASE_COVER_IMAGE=values[8];
  CommonUtil.BASE_URL_V2=values[9];
}



class MyFHB extends StatefulWidget {
  @override
  _MyFHBState createState() => _MyFHBState();
}

class _MyFHBState extends State<MyFHB> {
  int myPrimaryColor = new CommonUtil().getMyPrimaryColor();
  static const platform = const MethodChannel('flutter.native/versioncode');
  String _responseFromNative = 'wait! Its loading';
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const secure_platform = const MethodChannel('flutter.native/security');

  @override
  void initState() {
    super.initState();
    gettingResponseFromNative();
    showSecurityWall();
  }

  @override
  Widget build(BuildContext context) {
    var nsSettingsForAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
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
            fontFamily: 'Poppins',
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
      final String result = await platform.invokeMethod('getAppVersion');
      res = result;
    } on PlatformException catch (e) {
      res = "Failed to Invoke: '${e.message}'.";
    }

    setState(() {
      _responseFromNative = res;
      CommonConstants.appVersion = _responseFromNative;
    });

  }

  Future<void> showSecurityWall() async {
    try {
     
      final int RESULT_CODE = await secure_platform.invokeMethod('secureMe');
      switch (RESULT_CODE) {
        case 1003:
          //todo authorized unsuccessfull
          SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
          break;
      }
    } on PlatformException catch (e, s) {

    }
  }

}
