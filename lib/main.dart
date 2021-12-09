import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:agora_rtc_engine/rtc_engine.dart' as rtc;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_logs/flutter_logs.dart' as applog;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfhb/myPlan/view/myPlanDetail.dart';
import 'package:myfhb/src/utils/language/language_utils.dart';
import 'package:myfhb/src/utils/dynamic_links.dart';
import 'package:myfhb/src/utils/language/app_localizations.dart';
import 'package:myfhb/src/utils/language/languages.dart';
import 'package:myfhb/src/utils/language/view_model/language_view_model.dart';
import 'package:myfhb/video_call/utils/audiocall_provider.dart';
import 'package:myfhb/user_plans/view_model/user_plans_view_model.dart';
import 'package:myfhb/video_call/utils/rtc_engine.dart';
import 'package:myfhb/video_call/utils/videoicon_provider.dart';
import 'package:myfhb/video_call/utils/videorequest_provider.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import 'IntroScreens/IntroductionScreen.dart';
import 'add_provider_plan/service/PlanProviderViewModel.dart';
import 'constants/router_variable.dart';
import 'regiment/models/regiment_arguments.dart';

//import 'package:myfhb/QurPlan/WelcomeScreens/qurplan_welcome_screen.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'regiment/view/manage_activities/manage_activities_screen.dart';
import 'regiment/view_model/regiment_view_model.dart';
import 'constants/fhb_parameters.dart' as parameters;
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/IntroScreens/IntroductionScreen.dart';
import 'package:myfhb/authentication/service/authservice.dart';
import 'package:myfhb/authentication/view_model/otp_view_model.dart';
import 'package:myfhb/common/DatabseUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_router.dart' as router;
import 'package:myfhb/constants/router_variable.dart' as routervariable;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/landing/view_model/landing_view_model.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/regiment/models/regiment_arguments.dart';

//import 'package:myfhb/QurPlan/WelcomeScreens/qurplan_welcome_screen.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/schedules/add_reminders.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/NetworkScreen.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/src/ui/bot/view/sheela_arguments.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/src/utils/screenutils/screenutil.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/Notifications/services/notification_services.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/doctor.dart'
    as doc;
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:myfhb/video_call/pages/callmain.dart';
import 'package:myfhb/video_call/services/iOS_Notification_Handler.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
import 'package:myfhb/widgets/shopping_card_provider.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';

import 'authentication/service/authservice.dart';
import 'common/DatabseUtil.dart';
import 'common/PreferenceUtil.dart';
import 'constants/fhb_constants.dart' as Constants;
import 'constants/fhb_constants.dart';
import 'constants/fhb_router.dart' as router;
import 'constants/router_variable.dart' as routervariable;
import 'constants/variable_constant.dart' as variable;
import 'schedules/add_reminders.dart';
import 'src/blocs/Category/CategoryListBlock.dart';
import 'src/model/Category/catergory_result.dart';
import 'src/model/home_screen_arguments.dart';
import 'src/resources/network/ApiBaseHelper.dart';
import 'src/ui/Dashboard.dart';
import 'src/ui/MyRecord.dart';
import 'src/ui/MyRecordsArguments.dart';
import 'src/ui/SplashScreen.dart';
import 'src/ui/NetworkScreen.dart';
import 'src/ui/bot/view/ChatScreen.dart' as bot;
import 'src/ui/bot/view/sheela_arguments.dart';
import 'src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'src/utils/FHBUtils.dart';
import 'src/utils/PageNavigator.dart';
import 'telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'telehealth/features/Notifications/services/notification_services.dart';
import 'telehealth/features/Notifications/view/notification_main.dart';
import 'telehealth/features/appointments/model/fetchAppointments/doctor.dart'
    as doc;
import 'telehealth/features/appointments/view/resheduleMain.dart';
import 'telehealth/features/chat/view/chat.dart';
import 'telehealth/features/chat/view/home.dart';
import 'telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'telehealth/features/chat/viewModel/notificationController.dart';
import 'video_call/pages/callmain.dart';
import 'video_call/services/iOS_Notification_Handler.dart';
import 'video_call/utils/callstatus.dart';
import 'video_call/utils/hideprovider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/ui/bot/SuperMaya.dart';
import 'constants/router_variable.dart' as router;
import 'common/CommonConstants.dart';
import 'common/CommonUtil.dart';
import 'my_family/viewmodel/my_family_view_model.dart';
import 'src/ui/SplashScreen.dart';
import 'src/ui/connectivity_bloc.dart';
import 'telehealth/features/appointments/model/fetchAppointments/city.dart';
import 'telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'src/utils/screenutils/screenutil.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'src/model/user/user_accounts_arguments.dart';
import 'authentication/view_model/otp_view_model.dart';
import 'landing/view_model/landing_view_model.dart';

var firstCamera;
List<CameraDescription> listOfCameras;

//variable for all outer
var routes;

Future<void> main() async {
  var reminderMethodChannelAndroid =
      const MethodChannel('android/notification');

  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    var cameras = await availableCameras();
    listOfCameras = cameras;
    reminderMethodChannelAndroid.invokeMethod('testingNotification');
    // Get a specific camera from the list of available cameras.
    firstCamera = cameras[0];
    routes = await router.setRouter(listOfCameras);

    //get secret from resource
    final resList = <dynamic>[];
    await CommonUtil.getResourceLoader().then((value) {
      final Map mSecretMap = value;
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
    await saveUnitSystemToPreference();

    Map appsFlyerOptions;
    if (Platform.isIOS) {
      appsFlyerOptions = {
        'afDevKey': 'wAZtv6sqho7WqLGgTAAqFV',
        'afAppId': '1526444520',
        'isDebug': true
      };
    } else {
      appsFlyerOptions = {
        'afDevKey': 'UJdqFKHff633D3TcaZ5d55',
        'afAppId': '',
        'isDebug': true
      };
    }

    final appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

    await appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
    );

    if (Platform.isAndroid) {
      await FlutterDownloader.initialize(
          debug: true // optional: set false to disable printing logs to console
          );
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }

    // check if the app install on first time
    await CommonUtil().isFirstTime();
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarIconBrightness: Brightness.light,
    //     statusBarBrightness: Brightness.light,
    //   ),
    // );

    await applog.FlutterLogs.initLogs(
      logLevelsEnabled: [
        applog.LogLevel.INFO,
        applog.LogLevel.WARNING,
        applog.LogLevel.ERROR,
        applog.LogLevel.SEVERE,
      ],
      timeStampFormat: applog.TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: applog.DirectoryStructure.SINGLE_FILE_FOR_DAY,
      logTypesEnabled: ['device', 'network', 'errors'],
      logFileExtension: applog.LogFileExtension.TXT,
      logsWriteDirectoryName: 'Logs',
      logsExportDirectoryName: 'Shared',
      debugFileOperations: true,
      isDebuggable: true,
      singleLogFileSize: 10,
    );
    applog.FlutterLogs.channel.setMethodCallHandler((call) {
      if (call.method == 'logsExported') {
        print(call.arguments);
        CommonUtil.uploadTheLog(
          call.arguments.toString(),
        );
      }
    });
    runApp(
      provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider<ChatScreenViewModel>(
            create: (_) => ChatScreenViewModel(),
          ),
          provider.ChangeNotifierProvider<RegimentViewModel>(
            create: (_) => RegimentViewModel(),
          ),
          provider.ChangeNotifierProvider<PlanWizardViewModel>(
            create: (_) => PlanWizardViewModel(),
          ),
          provider.ChangeNotifierProvider<RTCEngineProvider>(
            create: (_) => RTCEngineProvider(),
          ),
          provider.ChangeNotifierProvider<PlanProviderViewModel>(
            create: (_) => PlanProviderViewModel(),
          ),
          provider.ChangeNotifierProvider<UserPlansViewModel>(
            create: (_) => UserPlansViewModel(),
          ),
          provider.ChangeNotifierProvider<LanguageProvider>(
            create: (_) => LanguageProvider(),
          ),
        ],
        child: MyFHB(),
      ),
    );
  }, (Object error, StackTrace stack) async {
    await CommonUtil.saveLog(
      isError: true,
      message: 'RunZonedGuarded Error - $error \nStackTrace - ${stack}',
    );
  });

  // await saveToPreference();
  //await PreferenceUtil.saveString(Constants.KEY_AUTHTOKEN, Constants.AuthToken);
}

void saveUnitSystemToPreference() async {
  if (CommonUtil.REGION_CODE != "IN") {
    await PreferenceUtil.saveString(Constants.STR_KEY_HEIGHT, STR_VAL_HEIGHT_US)
        .then((value) {
      PreferenceUtil.saveString(Constants.STR_KEY_WEIGHT, STR_VAL_WEIGHT_US)
          .then((value) {
        PreferenceUtil.saveString(Constants.STR_KEY_TEMP, STR_VAL_TEMP_US)
            .then((value) {});
      });
    });
  } else {
    await PreferenceUtil.saveString(
            Constants.STR_KEY_HEIGHT, STR_VAL_HEIGHT_IND)
        .then((value) {
      PreferenceUtil.saveString(Constants.STR_KEY_WEIGHT, STR_VAL_WEIGHT_IND)
          .then((value) {
        PreferenceUtil.saveString(Constants.STR_KEY_TEMP, STR_VAL_TEMP_IND)
            .then((value) {});
      });
    });
  }
}

void saveToPreference() async {
  await PreferenceUtil.saveString(Constants.KEY_USERID_MAIN, Constants.userID)
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
  CommonUtil.BASEURL_DEVICE_READINGS = values[8];
  CommonUtil.FIREBASE_CHAT_NOTIFY_TOKEN = values[9];
  CommonUtil.REGION_CODE = values.length > 10 ? (values[10] ?? 'IN') : 'IN';
  CommonUtil.CURRENCY = (CommonUtil.REGION_CODE == 'IN') ? INR : USD;
  CommonUtil.POWER_BI_URL = values[11];
}

Widget buildError(BuildContext context, FlutterErrorDetails error) {
  return Scaffold(
    body: Center(
      child: Text(
        '${error.library}',
        style: Theme.of(context).textTheme.headline6,
      ),
    ),
  );
}

class MyFHB extends StatefulWidget {
  @override
  _MyFHBState createState() => _MyFHBState();
}

class _MyFHBState extends State<MyFHB> {
  int myPrimaryColor = CommonUtil().getMyPrimaryColor();
  static const platform = variable.version_platform;
  String _responseFromNative = variable.strWaitLoading;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const secure_platform = variable.security;
  static const nav_platform = MethodChannel('navigation.channel');
  String navRoute = '';
  bool isAlreadyLoaded = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _internetconnection = true;
  FlutterToast toast = FlutterToast();

  /// event channel for listening ns
  static const stream =
      EventChannel('com.example.agoraflutterquickstart/stream');
  StreamSubscription _timerSubscription;
  final String _msg = 'waiting for message';
  final ValueNotifier<String> _msgListener = ValueNotifier('');

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  var globalContext;
  AuthService authService = AuthService();
  ChatViewModel chatViewModel = ChatViewModel();
  bool isFirstTime;

  @override
  void initState() {
    // TODO: implement initState

    /*NotificationController.instance.takeFCMTokenWhenAppLaunch();
    NotificationController.instance.initLocalNotification();*/
    PreferenceUtil.saveString(KEY_DYNAMIC_URL, '');
    DynamicLinks.initDynamicLinks();
    CheckForShowingTheIntroScreens();
    chatViewModel.setCurrentChatRoomID('none');
    super.initState();
    CommonUtil.askPermissionForCameraAndMic();
    getMyRoute();
    _enableTimer();

    var apiBaseHelper = ApiBaseHelper();
    final res = apiBaseHelper.updateLastVisited();
    isAlreadyLoaded = true;
    if (Platform.isIOS) {
      // Push Notifications
      var provider = IosNotificationHandler();
      provider.setUpListerForTheNotification();
      provider.isAlreadyLoaded = true;
    }
    FirebaseMessaging.instance.onTokenRefresh
        .listen(CommonUtil().saveTokenToDatabase);

    //gettingResponseFromNative();
    ///un comment this while on production mode for enabling security.
    //showSecurityWall();

    //initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  CheckForShowingTheIntroScreens() async {
    try {
      isFirstTime = PreferenceUtil.isKeyValid(Constants.KeyShowIntroScreens);
    } catch (e) {
      isFirstTime = false;
    }
  }

  @override
  void dispose() {
    _disableTimer();
    super.dispose();
  }

  void _enableTimer() {
    _timerSubscription ??= stream.receiveBroadcastStream().listen(_updateTimer);
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  void _updateTimer(msg) {
    var doctorPic = '';
    var patientPic = '';
    var callType = '';
    _msgListener.value = _msg;
    final cMsg = msg as String;
    if (cMsg.isNotEmpty || cMsg != null) {
      if (cMsg == 'chat') {
        fbaLog(eveParams: {
          'eventTime': '${DateTime.now()}',
          'ns_type': 'chat',
          'navigationPage': 'Tele Health Chat list',
        });
        Get.to(ChatHomeScreen());
      } else if (cMsg == 'FETCH_LOG') {
        CommonUtil.sendLogToServer();
      }
      final passedValArr = cMsg.split('&');
      if (passedValArr[0] == 'ack') {
        final temp = passedValArr[1].split('|');
        if (temp[0] == 'myRecords') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'myRecords',
            'navigationPage': temp[1],
          });
          CommonUtil()
              .navigateToMyRecordsCategory(temp[1], [passedValArr[2]], false);
        } else if (passedValArr[1] == 'sheela') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'sheela',
            'navigationPage': 'Sheela Start Page',
          });
          if (passedValArr[2] != null && passedValArr[2].isNotEmpty) {
            final rawTitle = passedValArr[2]?.split('|')[0];
            final rawBody = passedValArr[2]?.split('|')[1];
            var sheelaLang =
                PreferenceUtil.getStringValue(Constants.SHEELA_LANG);
            if ((Provider.of<ChatScreenViewModel>(context, listen: false)
                        ?.conversations
                        ?.length ??
                    0) >
                0) {
              Provider.of<ChatScreenViewModel>(context, listen: false)
                  ?.startMayaAutomatically(message: rawBody);
            } else if (sheelaLang != null && sheelaLang != '') {
              Get.toNamed(
                routervariable.rt_Sheela,
                arguments: SheelaArgument(
                  isSheelaAskForLang: false,
                  langCode: sheelaLang,
                  rawMessage: rawBody,
                ),
              );
            } else {
              Get.toNamed(
                routervariable.rt_Sheela,
                arguments: SheelaArgument(
                  isSheelaAskForLang: true,
                  rawMessage: rawBody,
                ),
              );
            }
          } else {
            Get.to(SuperMaya());
          }
        } else if (passedValArr[1] == 'profile_page' ||
            passedValArr[1] == 'profile') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'profile_page',
            'navigationPage': 'User Profile page',
          });
          Get.toNamed(router.rt_UserAccounts,
                  arguments: UserAccountsArguments(selectedIndex: 0))
              .then((value) => setState(() {}));
        } else if (passedValArr[1] == 'googlefit') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'googlefit',
            'navigationPage': 'Google Fit page',
          });
          Get.toNamed(router.rt_AppSettings);
        } else if (passedValArr[1] == 'th_provider' ||
            passedValArr[1] == 'provider') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'th_provider',
            'navigationPage': 'Tele Health Provider',
          });
          Get.toNamed(router.rt_TelehealthProvider,
                  arguments: HomeScreenArguments(selectedIndex: 1))
              .then((value) => setState(() {}));
        } else if (passedValArr[1] == 'my_record' ||
            passedValArr[1] == 'prescription_list' ||
            passedValArr[1] == 'add_doc') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'my_record',
            'navigationPage': 'My Records',
          });
          getProfileData();
          Get.toNamed(router.rt_HomeScreen,
                  arguments: HomeScreenArguments(selectedIndex: 1))
              .then((value) => setState(() {}));
        } else if (passedValArr[1] == 'regiment_screen') {
          //this need to be navigte to Regiment screen
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'regiment_screen',
            'navigationPage': 'Regimen Screen',
          });
          //PageNavigator.goToPermanent(context, router.rt_Landing);
          Provider.of<RegimentViewModel>(
            context,
            listen: false,
          )?.regimentMode = RegimentMode.Schedule;
          Provider.of<RegimentViewModel>(context, listen: false)
              ?.regimentFilter = RegimentFilter.Missed;
          Get.toNamed(router.rt_Regimen,
              arguments: RegimentArguments(eventId: passedValArr[2]));
        } else if (passedValArr[1] == 'dashboard') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'dashboard',
            'navigationPage': 'Device List Screen',
          });
          PageNavigator.goToPermanent(context, router.rt_Landing);
        } else if (passedValArr[1] == 'th_provider_hospital') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'th_provider_hospital',
            'navigationPage': 'TH provider Hospital Screen',
          });
          Get.toNamed(router.rt_TelehealthProvider,
              arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 1));
        } else if (passedValArr[1] == 'myfamily_list' ||
            passedValArr[1] == 'profile_my_family') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'myfamily_list',
            'navigationPage': 'MyFamily List Screen',
          });
          Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 1));
        } else if (passedValArr[1] == 'myprovider_list') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'myprovider_list',
            'navigationPage': 'MyProvider List Screen',
          });
          Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 2));
        } else if (passedValArr[1] == 'myplans') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'myplans',
            'navigationPage': 'MyPlans Screen',
          });
          Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 3));
        } else if (passedValArr[1] == 'appointmentList' ||
            passedValArr[1] == 'appointmentHistory') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'appointmentList',
            'navigationPage': 'appointmentList',
          });
          Get.to(SplashScreen(
            nsRoute: passedValArr[1],
          ));
        } else if (passedValArr[1] == 'devices_tab') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'device_list',
            'navigationPage': 'devices_tab',
          });
          getProfileData();
          Get.toNamed(
            router.rt_HomeScreen,
            arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 1),
          ).then((value) =>
              PageNavigator.goToPermanent(context, router.rt_Landing));
        } else if (passedValArr[1] == 'bills') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'bills',
            'navigationPage': 'Bills Screen',
          });
          Get.toNamed(
            router.rt_HomeScreen,
            arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 4),
          ).then((value) =>
              PageNavigator.goToPermanent(context, router.rt_Landing));
        } else if (passedValArr[1] == 'chat') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'initiate screen',
            'navigationPage': 'Chat Screen',
          });
          final chatParsedData = passedValArr[2]?.split('|');
          Get.to(Chat(
            peerId: chatParsedData[0],
            peerName: chatParsedData[1],
            peerAvatar: chatParsedData[2],
            patientId: chatParsedData[3],
            patientName: chatParsedData[4],
            patientPicture: chatParsedData[5],
            isFromVideoCall: false,
            message: chatParsedData[6],
            isCareGiver: false,
          )).then((value) =>
              PageNavigator.goToPermanent(context, router.rt_Landing));
        } else if (passedValArr[1] == 'mycart') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'my cart',
            'navigationPage': 'My Cart',
          });
          Get.to(CheckoutPage(isFromNotification: true)).then((value) =>
              PageNavigator.goToPermanent(context, router.rt_Landing));
        }
        else if (passedValArr[1] == 'manageActivities') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'manageActivities',
            'navigationPage': 'Manage Activities',
          });
          Get.to(ManageActivitiesScreen()).then((value) =>
              PageNavigator.goToPermanent(context, router.rt_Landing));
        }
        else {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'appointment_list',
            'navigationPage': 'Tele Health Appointment list',
          });
          PageNavigator.goToPermanent(Get.context, router.rt_Landing);
        }
      } else if (passedValArr[1] == 'appointmentList' ||
          passedValArr[1] == 'appointmentHistory') {
        fbaLog(eveParams: {
          'eventTime': '${DateTime.now()}',
          'ns_type': 'appointmentList',
          'navigationPage': 'Tele Health Appointment list',
        });
        Get.to(SplashScreen(
          nsRoute: passedValArr[1],
        ));
      } else if (passedValArr[0] == 'DoctorRescheduling') {
        /* Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(
            selectedIndex: 1,
          doctorID: passedValArr[1] ?? '',
          bookingId: passedValArr[2] ?? '',
          doctorSessionId: passedValArr[3] ?? '',
          healthOrganizationId: passedValArr[4] ?? ''
          ),
        )); */
        fbaLog(eveParams: {
          'eventTime': '${DateTime.now()}',
          'ns_type': 'DoctorRescheduling',
          'navigationPage': 'Reschedule screen',
        });
        final body = {};
        body['templateName'] = passedValArr[5] ?? '';
        body['contextId'] = passedValArr[2] ?? '';
        Get.to(ResheduleMain(
          isFromNotification: true,
          isReshedule: true,
          isFromFollowUpApp: false,
          doc: Past(
            //! this is has to be correct
            doctorSessionId: passedValArr[3],
            bookingId: passedValArr[2],
            doctor: doc.Doctor(id: passedValArr[1]),
            healthOrganization: City(id: passedValArr[4]),
          ),
          body: body,
        ));
      } else if (passedValArr[0] == 'DoctorCancellation') {
        fbaLog(eveParams: {
          'eventTime': '${DateTime.now()}',
          'ns_type': 'DoctorCancellation',
          'navigationPage': 'Appointment List',
        });
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(
              selectedIndex: 0,
              dialogType: 'CANCEL',
              isCancelDialogShouldShow: true,
              bookingId: passedValArr[1] ?? '',
              date: passedValArr[2] ?? '',
              templateName: passedValArr[3] ?? ''),
        ));
      } else if (passedValArr[0] == 'accept' || passedValArr[0] == 'decline') {
        final jsonInput = {};
        jsonInput['providerRequestId'] = passedValArr[1];
        jsonInput['action'] = passedValArr[2];
      } else if (passedValArr[0] == 'openurl') {
        final urlInfo = passedValArr[1];
        fbaLog(eveParams: {
          'eventTime': '${DateTime.now()}',
          'ns_type': 'openurl',
          'navigationPage': 'Browser page',
        });
        CommonUtil().launchURL(urlInfo);
      } else if (passedValArr[0] == 'Renew' || passedValArr[0] == 'Callback') {
        final planid = passedValArr[1];
        final template = passedValArr[2];
        final userId = passedValArr[3];
        final patName = passedValArr[4];
        //TODO if its Renew take the user into plandetail view
        if (passedValArr[0] == 'Renew') {
          final currentUserId = PreferenceUtil.getStringValue(KEY_USERID);
          if (currentUserId == userId) {
            fbaLog(eveParams: {
              'eventTime': '${DateTime.now()}',
              'ns_type': 'myplan_deatails',
              'navigationPage': 'My Plan Details',
            });
            Get.to(
              MyPlanDetail(
                packageId: planid,
                showRenew: true,
                templateName: template,
              ),
            );
          } else {
            CommonUtil.showFamilyMemberPlanExpiryDialog(patName);
          }
        } else {
          CommonUtil().CallbackAPI(
            patName,
            planid,
            userId,
          );
          var nsBody = {};
          nsBody['templateName'] = template;
          nsBody['contextId'] = planid;
          FetchNotificationService().updateNsActionStatus(nsBody).then((data) {
            FetchNotificationService().updateNsOnTapAction(nsBody);
          });
          //   //TODO if its Callback just show the message alone
          //   Get.rawSnackbar(
          //       messageText: Center(
          //         child: Text(
          //           '$patName, Thank you for reaching out.  Your caregiver will call you as soon as possible.',
          //           style: TextStyle(
          //               color: Colors.white, fontWeight: FontWeight.w500),
          //         ),
          //       ),
          //       snackPosition: SnackPosition.BOTTOM,
          //       snackStyle: SnackStyle.GROUNDED,
          //       duration: Duration(seconds: 3),
          //       backgroundColor: Colors.green.shade500);
        }
      } else if (passedValArr[4] == 'call') {
        try {
          doctorPic = passedValArr[3];
          patientPic = passedValArr[7];
          callType = passedValArr[8];
          var isWeb = passedValArr[9] == null
              ? false
              : passedValArr[9] == 'true'
                  ? true
                  : false;
          if (doctorPic.isNotEmpty) {
            try {
              doctorPic = json.decode(doctorPic);
            } catch (e) {}
          } else {
            doctorPic = '';
          }
          if (patientPic.isNotEmpty) {
            try {
              patientPic = json.decode(patientPic);
            } catch (e) {}
          } else {
            patientPic = '';
          }

          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'call',
            'navigationPage': 'TeleHelath Call screen',
          });
          if (callType.toLowerCase() == 'audio') {
            Provider.of<AudioCallProvider>(Get.context, listen: false)
                .enableAudioCall();
          } else if (callType.toLowerCase() == 'video') {
            Provider.of<AudioCallProvider>(Get.context, listen: false)
                .disableAudioCall();
          }

          Get.to(CallMain(
            doctorName: passedValArr[1],
            doctorId: passedValArr[2],
            doctorPic: doctorPic,
            patientId: passedValArr[5],
            patientName: passedValArr[6],
            patientPicUrl: patientPic,
            channelName: passedValArr[0],
            role: ClientRole.Broadcaster,
            isAppExists: true,
            isWeb: isWeb,
          ));
        } catch (e) {}
      }
    }
  }

  getMyRoute() async {
    final route = await nav_platform.invokeMethod('getMyRoute');
    if (route != null) {
      setState(() {
        navRoute = route;
      });
    }
  }

  void getProfileData() async {
    try {
      await CommonUtil().getUserProfileData();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final nsSettingsForAndroid =
        AndroidInitializationSettings(variable.strLauncher);
    final nsSettingsForIOS = IOSInitializationSettings();
    final platform = InitializationSettings(
        android: nsSettingsForAndroid, iOS: nsSettingsForIOS);

    Future notificationAction(String payload) async {
      await Navigator.push(
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
        provider.ChangeNotifierProvider<MyFamilyViewModel>(
          create: (_) => MyFamilyViewModel(),
        ),
        // provider.ChangeNotifierProvider<ChatScreenViewModel>(
        //   create: (_) => ChatScreenViewModel(),
        // ),
        // provider.ChangeNotifierProvider<RegimentViewModel>(
        //   create: (_) => RegimentViewModel(),
        // ),
        provider.ChangeNotifierProvider<OtpViewModel>(
          create: (_) => OtpViewModel(),
        ),
        provider.ChangeNotifierProvider<LandingViewModel>(
          create: (_) => LandingViewModel(),
        ),
        provider.ChangeNotifierProvider<ShoppingCardProvider>(
          create: (_) => ShoppingCardProvider(),
        ),
        provider.ChangeNotifierProvider<CheckoutPageProvider>(
          create: (_) => CheckoutPageProvider(),
        ),
        provider.ChangeNotifierProvider<AudioCallProvider>(
          create: (_) => AudioCallProvider(),
        ),
        provider.ChangeNotifierProvider<VideoIconProvider>(
          create: (_) => VideoIconProvider(),
        ),
        provider.ChangeNotifierProvider<VideoRequestProvider>(
          create: (_) => VideoRequestProvider(),
        ),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          ScreenUtil.init(
            constraints,
            designSize: orientation == Orientation.portrait
                ? Size(411.4, 822.9)
                : Size(822.9, 411.4),
          );
          return GetMaterialApp(
            title: Constants.APP_NAME,
            themeMode: ThemeMode.light,
            theme: ThemeData(
              fontFamily: variable.font_poppins,
              primaryColor: Color(myPrimaryColor),
              accentColor: Colors.white,
              appBarTheme: Theme.of(context).appBarTheme.copyWith(
                    brightness: Brightness.dark,
                  ),
            ),
            //home: navRoute.isEmpty ? SplashScreen() : StartTheCall(),
            home: findHomeWidget(navRoute),
            routes: routes,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            supportedLocales:
                Languages.languages.map((e) => Locale(e.code)).toList(),
            locale: provider.Provider.of<LanguageProvider>(context).locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        });
      }),
    );
  }

  Widget findHomeWidget(String navRoute) {
    if (isFirstTime != null && !isFirstTime) {
      return IntroductionScreen();
    } else if (navRoute.isEmpty) {
      return SplashScreen();
    } else {
      try {
        final parsedData = navRoute.split('&');
        if (navRoute == 'chat') {
          return SplashScreen(nsRoute: 'chat');
        } else if (navRoute == 'FETCH_LOG') {
          CommonUtil.sendLogToServer();
          return SplashScreen(
            nsRoute: '',
          );
        } else if (parsedData[1] == 'appointmentList' ||
            parsedData[1] == 'appointmentHistory') {
          return SplashScreen(
            nsRoute: parsedData[1],
          );
        } else if (parsedData[0] == 'ack') {
          final temp = parsedData[1].split('|');
          if (temp[0] == 'myRecords') {
            return SplashScreen(
              nsRoute: 'myRecords',
              templateName: temp[1],
              bundle: parsedData[2],
            );
          } else if (parsedData[1] == 'sheela') {
            return SplashScreen(
              nsRoute: 'sheela',
              bundle: parsedData[2],
            );
          } else if (parsedData[1] == 'profile_page' ||
              parsedData[1] == 'profile') {
            return SplashScreen(
              nsRoute: parsedData[1],
            );
          } else if (parsedData[1] == 'googlefit') {
            return SplashScreen(
              nsRoute: 'googlefit',
            );
          } else if (parsedData[1] == 'th_provider' ||
              parsedData[1] == 'provider') {
            return SplashScreen(
              nsRoute: parsedData[1],
            );
          } else if (parsedData[1] == 'my_record' ||
              parsedData[1] == 'prescription_list' ||
              parsedData[1] == 'add_doc') {
            return SplashScreen(
              nsRoute: parsedData[1],
            );
          } else if (parsedData[1] == 'regiment_screen') {
            //this need to be navigte to Regiment screen
            return SplashScreen(
              nsRoute: 'regiment_screen',
              bundle: parsedData[2],
            );
          } else if (parsedData[1] == 'th_provider_hospital') {
            //this need to be navigte to TH provider screen
            return SplashScreen(
              nsRoute: 'th_provider_hospital',
            );
          } else if (parsedData[1] == 'myfamily_list') {
            //this need to be navigte to My Family List screen
            return SplashScreen(
              nsRoute: 'myfamily_list',
            );
          } else if (parsedData[1] == 'myprovider_list' ||
              parsedData[1] == 'profile_my_family') {
            //this need to be navigte to My Provider screen
            return SplashScreen(
              nsRoute: parsedData[1],
            );
          } else if (parsedData[1] == 'myplans') {
            //this need to be navigte to My Plans screen
            return SplashScreen(
              nsRoute: 'myplans',
            );
          } else if (parsedData[1] == 'devices_tab') {
            //this need to be navigte to My Plans screen
            return SplashScreen(
              nsRoute: 'devices_tab',
            );
          } else if (parsedData[1] == 'bills') {
            //this need to be navigte to My Plans screen
            return SplashScreen(
              nsRoute: 'bills',
            );
          } else if (parsedData[1] == 'chat') {
            //this need to be navigte to My Plans screen
            return SplashScreen(
              nsRoute: 'chat',
              bundle: parsedData[2],
            );
          } else if (parsedData[1] == 'mycart') {
            //this need to be navigte to My Plans screen
            return SplashScreen(
              nsRoute: 'mycart',
              bundle: parsedData[2],
            );
          }
          else if (parsedData[1] == 'manageActivities') {

            return SplashScreen(
              nsRoute: 'manageActivities',
              bundle: parsedData[2],
            );

          }

          else {
            return SplashScreen(
              nsRoute: '',
            );
          }
        } else if (navRoute.split('&')[0] == 'DoctorRescheduling') {
          return SplashScreen(
              nsRoute: 'DoctorRescheduling',
              doctorID: navRoute.split('&')[1],
              bookingID: navRoute.split('&')[2],
              doctorSessionId: navRoute.split('&')[3],
              healthOrganizationId: navRoute.split('&')[4],
              templateName: navRoute.split('&')[5]);
        } else if (navRoute.split('&')[0] == 'DoctorCancellation') {
          return SplashScreen(
            nsRoute: 'DoctorCancellation',
            bookingID: navRoute.split('&')[1],
            appointmentDate: navRoute.split('&')[2],
            templateName: navRoute.split('&')[3],
          );
        } else if (navRoute.split('&')[0] == 'accept' ||
            navRoute.split('&')[0] == 'decline') {
          final jsonInput = {};
          jsonInput['providerRequestId'] = navRoute.split('&')[1];
          jsonInput['action'] = navRoute.split('&')[2];
          // var body = {
          //   "templateName": 'GoFHBDoctorOnboardingByHospital',
          //   "contextId": parsedData[1]
          // };
          return SplashScreen();
        } else if (navRoute.split('&')[0] == 'openurl') {
          return SplashScreen(
            nsRoute: 'openurl',
            bundle: navRoute.split('&')[1],
          );
        } else if (navRoute.split('&')[0] == 'Renew' ||
            navRoute.split('&')[0] == 'Callback') {
          return SplashScreen(
            nsRoute: navRoute.split('&')[0],
            bundle: {
              'planid': '${navRoute.split('&')[1]}',
              'template': '${navRoute.split('&')[2]}',
              'userId': '${navRoute.split('&')[3]}',
              'patName': '${navRoute.split('&')[4]}'
            },
          );
        } else {
          return StartTheCall();
        }
      } catch (e) {}
    }
  }

  Future<void> gettingResponseFromNative() async {
    var res = '';
    try {
      final result = await platform.invokeMethod(variable.strGetAppVersion);
      res = result;
    } on PlatformException catch (e) {
      res = TranslationConstants.failedToInvoke.t() + "'${e.message}'.";
    }

    setState(() {
      _responseFromNative = res;
      CommonConstants.appVersion = _responseFromNative;
    });
  }

  Future<void> showSecurityWall() async {
    try {
      final RESULTCODE = await secure_platform.invokeMethod(variable.strSecure);
    } on PlatformException catch (e, s) {}
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      //print(e.toString());
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
        if (!_internetconnection) {
          Navigator.pop(Get.context);
        }

        setState(() {
          _internetconnection = true;
          // toast.getToast(wifi_connected, Colors.green);
        });
        break;
      case ConnectivityResult.mobile:
        if (!_internetconnection) {
          Navigator.pop(Get.context);
        }
        setState(() {
          _internetconnection = true;
          //toast.getToast(data_connected, Colors.green);
        });
        break;
      case ConnectivityResult.none:
        await Get.to(NetworkScreen());
        setState(() {
          _internetconnection = false;
          // toast.getToast(no_internet_conn, Colors.red);
        });
        break;
      default:
        setState(() {
          _internetconnection = false;
          toast.getToast(failed_get_connectivity, Colors.red);
        });
        break;
    }
  }

  Widget StartTheCall() {
    var docPic = navRoute.split('&')[3];
    var patPic = navRoute.split('&')[7];
    var callType = navRoute.split('&')[8];
    var isWeb = navRoute.split('&')[9] == null
        ? false
        : navRoute.split('&')[9] == 'true'
            ? true
            : false;
    try {
      if (docPic.isNotEmpty) {
        try {
          docPic = json.decode(navRoute.split('&')[3]);
        } catch (e) {}
      } else {
        docPic = '';
      }
      if (patPic.isNotEmpty) {
        try {
          patPic = json.decode(navRoute.split('&')[7]);
        } catch (e) {}
      } else {
        patPic = '';
      }
    } catch (e) {}
    fbaLog(eveParams: {
      'eventTime': '${DateTime.now()}',
      'ns_type': 'call',
      'navigationPage': 'TeleHelath Call screen',
    });

    if (callType.toLowerCase() == 'audio') {
      Provider.of<AudioCallProvider>(Get.context, listen: false)
          .enableAudioCall();
    } else if (callType.toLowerCase() == 'video') {
      Provider.of<AudioCallProvider>(Get.context, listen: false)
          .disableAudioCall();
    }
    return CallMain(
      isAppExists: false,
      role: ClientRole.Broadcaster,
      channelName: navRoute.split('&')[0],
      doctorName: navRoute.split('&')[1] ?? 'Test',
      doctorId: navRoute.split('&')[2] ?? 'Doctor',
      doctorPic: docPic,
      patientId: navRoute.split('&')[5] ?? 'Patient',
      patientName: navRoute.split('&')[6] ?? 'Test',
      patientPicUrl: patPic,
      isWeb: isWeb,
    );
  }

  void onBoardNSAcknowledge(data, body) {
    final jsonString = jsonEncode(data);
    var toast = FlutterToast();
    authService.addDoctorAsProvider(jsonString).then((response) {
      if (response['isSuccess']) {
        toast.getToast(response['message'], Colors.green);
        FetchNotificationService().updateNsActionStatus(body).then((data) {
          //todo
        });
      } else {
        toast.getToast(response['diagnostics']['message'], Colors.red);
      }
    });
  }

  void navigateToMyRecordsCategory(
      categoryType, List<String> hrmId, bool isTerminate) async {
    await CommonUtil().getCategoryListPos(categoryType).then(
        (value) => CommonUtil().goToMyRecordsScreen(value, hrmId, isTerminate));
  }
}
