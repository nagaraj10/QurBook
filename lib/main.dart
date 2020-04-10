import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/DatabseUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/dashboard/dashboard_screen.dart';
import 'package:myfhb/my_family_detail_view/screens/my_family_detail_view.dart';
import 'package:myfhb/my_providers/screens/my_provider.dart';
import 'package:myfhb/schedules/add_reminders.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/src/ui/HomeScreen.dart';
import 'package:myfhb/src/ui/MyRecords.dart';
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
import 'confirm_location/screens/confirm_location_screen.dart';
import 'my_family/screens/MyFamily.dart';
import 'my_family_detail/screens/my_family_detail_screen.dart';

var firstCamera;
List<CameraDescription> listOfCameras;

var routes = <String, WidgetBuilder>{
  "/splashscreen": (BuildContext context) => SplashScreen(),
  "/sign_in_screen": (BuildContext context) => SignInScreen(),
  "/dashboard_screen": (BuildContext context) => DashboardScreen(),
  /* "/home_screen": (BuildContext context) => HomeScreen(
        bottomindex: 0,
      ), */
  "/home_screen": (BuildContext context) =>
      HomeScreen(arguments: ModalRoute.of(context).settings.arguments),
  "/user_accounts": (BuildContext context) =>
      UserAccounts(arguments: ModalRoute.of(context).settings.arguments),
  "/app_settings": (BuildContext context) => MySettings(),
  "/my_records": (BuildContext context) => MyRecords(),
  "/my_family": (BuildContext context) => MyFamily(),
  "/my_providers": (BuildContext context) => MyProvider(),
  "/add_providers": (BuildContext context) =>
      AddProviders(arguments: ModalRoute.of(context).settings.arguments),
  "/add_address": (BuildContext context) =>
      AddAddressScreen(arguments: ModalRoute.of(context).settings.arguments),
  "/search_providers": (BuildContext context) => SearchSpecificList(
        arguments: ModalRoute.of(context).settings.arguments,
        toPreviousScreen: false,
      ),
  "/take_picture_screen": (BuildContext context) => TakePictureScreen(
        camera: firstCamera,
      ),
  "/take_picture_screen_for_devices": (BuildContext context) =>
      TakePictureScreenForDevices(cameras: listOfCameras),
  "/confirm_location": (BuildContext context) => ConfirmLocationScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/audio_record_screen": (BuildContext context) => AudioRecordScreen(),
  // "/sign_up_screen": (BuildContext context) => SignUpScreen(),
  "/add_family_otp_screen": (BuildContext context) =>
      AddFamilyOTPScreen(arguments: ModalRoute.of(context).settings.arguments),
  "/add_family_user_info": (BuildContext context) => AddFamilyUserInfoScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/my_family_detail_screen": (BuildContext context) => MyFamilyDetailScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/my_family_detail_view_insurance": (BuildContext context) =>
      MyFamilyDetailView(arguments: ModalRoute.of(context).settings.arguments),
  "/add_reminders": (BuildContext context) => AddReminder(),
  "/review_page": (BuildContext context) => MyReviewPage(),
};

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  listOfCameras = cameras;

  // Get a specific camera from the list of available cameras.
  firstCamera = cameras.first;

  await PreferenceUtil.init();

  DatabaseUtil.getDBLength().then((length) {
    if (length > 0) {
    } else {
      DatabaseUtil.insertCountryMetricsData();
    }
  });

  await FHBUtils.instance.initPlatformState();
  await FHBUtils.instance.getDb();

  /* PreferenceUtil.saveString(
      Constants.KEY_USERID, 'ad5d2d37-4eaf-4d91-99e8-a07881d72649');

  PreferenceUtil.saveString(
      Constants.KEY_USERID_MAIN, 'ad5d2d37-4eaf-4d91-99e8-a07881d72649');
  PreferenceUtil.saveString(Constants.KEY_AUTHTOKEN,
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJhZDVkMmQzNy00ZWFmLTRkOTEtOTllOC1hMDc4ODFkNzI2NDkiLCJjb3VudHJ5Q29kZSI6Iis5MSIsInN1YmplY3QiOiI5ODQwOTcyMjc1Iiwic2Vzc2lvblJvbGVzIjoiNWQ1MzgwMjItNzJkZS00M2RkLWJkMTktZmJiMGRiYmJhMzkxIiwicm9sZUlkIjoiNWQ1MzgwMjItNzJkZS00M2RkLWJkMTktZmJiMGRiYmJhMzkxIiwic2Vzc2lvbkRhdGUiOjE1ODQwMjczMTEzMDIsImV4cGlyeURhdGUiOjE1ODQwMzA5MTEzMDIsImlhdCI6MTU4NDAyNzMxMSwiZXhwIjoxNTg3NjI3MzExLCJhdWQiOiJ0cmlkZW50QXBwIiwiaXNzIjoiRkhCIiwianRpIjoiMzE2MjhmODUtZWZmOS00ZmI0LTlkYzItZWQyN2UyNzU2Njc1In0.ntgo0u93ZNb2Rwmch1n8dsu2djDOWjpwJpUGo2HyUuU');
 */

  runApp(
    MyFHB(),
  );
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    gettingResponseFromNative();
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

//    Get.snackbar('From native code response:', _responseFromNative);
//    print('From native code response:$_responseFromNative');
  }
}
