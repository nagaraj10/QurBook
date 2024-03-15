import 'dart:async';
import 'dart:io' show Platform;
import 'package:camera/camera.dart';
import 'package:myfhb/services/pushnotification_service.dart';
import 'package:myfhb/src/ui/NetworkScreen.dart';
import 'package:myfhb/voice_cloning/model/voice_clone_status_arguments.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/app_theme.dart';
import 'package:myfhb/voice_cloning/controller/voice_cloning_controller.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'QurHub/Controller/HubListViewController.dart';
import 'add_provider_plan/service/PlanProviderViewModel.dart';
import 'authentication/service/authservice.dart';
import 'authentication/view_model/otp_view_model.dart';
import 'chat_socket/viewModel/chat_socket_view_model.dart';
import 'common/CommonConstants.dart';
import 'common/CommonUtil.dart';
import 'common/DatabseUtil.dart';
import 'common/PreferenceUtil.dart';
import 'common/firestore_services.dart';
import 'constants/fhb_constants.dart' as Constants;
import 'constants/fhb_constants.dart';
import 'constants/fhb_router.dart' as router;
import 'constants/variable_constant.dart' as variable;
import 'device_integration/viewModel/Device_model.dart';
import 'landing/view_model/landing_view_model.dart';
import 'my_family/viewmodel/my_family_view_model.dart';
import 'plan_wizard/view_model/plan_wizard_view_model.dart';
import 'regiment/view_model/regiment_view_model.dart';
import 'src/blocs/Category/CategoryListBlock.dart';
import 'src/resources/network/ApiBaseHelper.dart';
import 'src/ui/MyRecord.dart';
import 'src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'src/ui/SheelaAI/Services/SheelaAIBLEServices.dart';
import 'src/ui/SplashScreen.dart';
import 'src/utils/FHBUtils.dart';
import 'src/utils/cron_jobs.dart';
import 'src/utils/dynamic_links.dart';
import 'src/utils/language/language_utils.dart';
import 'src/utils/language/languages.dart';
import 'src/utils/lifecycle_state_provider.dart';
import 'src/utils/screenutils/screenutil.dart';
import 'src/utils/timezone/timezone_services.dart';
import 'telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'user_plans/view_model/user_plans_view_model.dart';
import 'video_call/services/iOS_Notification_Handler.dart';
import 'video_call/utils/audiocall_provider.dart';
import 'video_call/utils/callstatus.dart';
import 'video_call/utils/hideprovider.dart';
import 'video_call/utils/rtc_engine.dart';
import 'video_call/utils/videoicon_provider.dart';
import 'video_call/utils/videorequest_provider.dart';
import 'widgets/checkout_page_provider.dart';
import 'widgets/shopping_card_provider.dart';

var firstCamera;
late List<CameraDescription> listOfCameras;

//variable for all outer
late var routes;
final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    var cameras = await availableCameras();
    listOfCameras = cameras;
    // Get a specific camera from the list of available cameras.
    firstCamera = cameras[0];
    routes = await router.setRouter(listOfCameras);
    //get secret from resource
    final resList = <dynamic>[];

    ///Added to identify the app name for foreground and Background.
    var packageInfo = await PackageInfo.fromPlatform();
    CommonUtil.AppName = packageInfo.appName;
    await CommonUtil.getResourceLoader().then((value) {
      final Map mSecretMap = value;
      mSecretMap.values.forEach((element) {
        resList.add(element);
      });
      setValues(resList);
    });

    PreferenceUtil.init();
    await PushNotificationService().setupNotification();

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
    CommonUtil().initPortraitMode();

    if (Platform.isAndroid) {
      await FlutterDownloader.initialize(
          debug: true // optional: set false to disable printing logs to console
          );
      //await Permission.storage.request();
      //   await Permission.manageExternalStorage.request();
    }

    try {
      CommonUtil().askAllPermissions().then((value) {
        CommonUtil().askPermissionForNotification();
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    // check if the app install on first time
    try {
      var isFirstTime = await CommonUtil().isFirstTime();
      var tokenForLogin =
          await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
      if (!isFirstTime && (tokenForLogin ?? '').isNotEmpty) {
        CategoryListBlock().getCategoryLists();
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        print(e.toString());
      }
    }
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<RegimentViewModel>(
            create: (_) => RegimentViewModel(),
          ),
          ChangeNotifierProvider<PlanWizardViewModel>(
            create: (_) => PlanWizardViewModel(),
          ),
          ChangeNotifierProvider<RTCEngineProvider>(
            create: (_) => RTCEngineProvider(),
          ),
          ChangeNotifierProvider<PlanProviderViewModel>(
            create: (_) => PlanProviderViewModel(),
          ),
          ChangeNotifierProvider<UserPlansViewModel>(
            create: (_) => UserPlansViewModel(),
          ),
          ChangeNotifierProvider<LanguageProvider>(
            create: (_) => LanguageProvider(),
          ),
          ChangeNotifierProvider<DevicesViewModel>(
            create: (_) => DevicesViewModel(),
          ),
        ],
        child: MyFHB(),
      ),
    );
  }, (Object error, StackTrace stack) async {
    debugPrint(error.toString());
  });
}

void saveUnitSystemToPreference() async {
  CommonUtil().commonMethodToSetPreference();
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
  CommonUtil.BASE_URL_QURHUB = values[12];
  CommonUtil.TRUE_DESK_URL = values[13];
  CommonUtil.WEB_URL = values[14];
  CommonUtil.PORTAL_URL = values[15];
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
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  @override
  _MyFHBState createState() => _MyFHBState();
}

class _MyFHBState extends State<MyFHB> {
  final SheelaAIController sheelaAIController = Get.put(SheelaAIController());
  var sheelaMethodChannelAndroid = const MethodChannel('sheela.channel');
  static const platform = variable.version_platform;
  String? _responseFromNative = variable.strWaitLoading;
  //final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String navRoute = '';
  bool isAlreadyLoaded = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  FlutterToast toast = FlutterToast();
  final String _msg = 'waiting for message';
  final ValueNotifier<String> _msgListener = ValueNotifier('');

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  var globalContext;
  AuthService authService = AuthService();
  ChatViewModel chatViewModel = ChatViewModel();
  bool? isFirstTime;
  var apiBaseHelper = ApiBaseHelper();
  bool avoidExtraNotification = true;

  @override
  void initState() {
    PreferenceUtil.saveString(KEY_DYNAMIC_URL, '');
    DynamicLinks.initDynamicLinks();
    CheckForShowingTheIntroScreens();
    chatViewModel.setCurrentChatRoomID('none');
    super.initState();
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
    Get
      ..put(
        HubListViewController(),
      )
      ..lazyPut(
        () => SheelaAIController(),
      )
      ..lazyPut(
        () => SheelaBLEController(),
      );

    //initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // Function to set up cron job and event listeners which is called after
    //some delay to make sure all the environment related data are setup.
    Future.delayed(const Duration(seconds: 4)).then(
      (value) => setUpCronJobAndListeners(),
    );
  }

// Function to set up cron job and event listeners
  void setUpCronJobAndListeners() {
    try {
      // Schedule the cron job to run at midnight for
      //getting the latest regiment
      CronJobServices().scheduleUpdateForData();

      // Add an observer to handle lifecycle events,
      // specifically when the app is resumed
      WidgetsBinding.instance.addObserver(
        LifecycleEventHandler(
          // Callback executed upon app resumption
          resumeCallBack: () async {
            // Update Firestore data for 'all' with loading indicator
            FirestoreServices().updateDataFor(
              'all',
              withLoading: true,
            );

            // Check and update the timezone information
            await TimezoneServices().checkUpdateTimezone();

            // Record the user's last access time
            CommonUtil().saveUserLastAccessTime();
          },
        ),
      );
    } catch (e, stackTrace) {
      // Handle and log any exceptions that occur during setup
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  CheckForShowingTheIntroScreens() async {
    try {
      isFirstTime = PreferenceUtil.isKeyValid(Constants.KeyShowIntroScreens);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      isFirstTime = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }



  void getProfileData() async {
    try {
      await CommonUtil().getUserProfileData();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CallStatus>(
          create: (_) => CallStatus(),
        ),
        ChangeNotifierProvider<HideProvider>(
          create: (_) => HideProvider(),
        ),
        ChangeNotifierProvider<MyFamilyViewModel>(
          create: (_) => MyFamilyViewModel(),
        ),
        // ChangeNotifierProvider<ChatScreenViewModel>(
        //   create: (_) => ChatScreenViewModel(),
        // ),
        // ChangeNotifierProvider<RegimentViewModel>(
        //   create: (_) => RegimentViewModel(),
        // ),
        ChangeNotifierProvider<OtpViewModel>(
          create: (_) => OtpViewModel(),
        ),
        ChangeNotifierProvider<LandingViewModel>(
          create: (_) => LandingViewModel(),
        ),
        ChangeNotifierProvider<ShoppingCardProvider>(
          create: (_) => ShoppingCardProvider(),
        ),
        ChangeNotifierProvider<CheckoutPageProvider>(
          create: (_) => CheckoutPageProvider(),
        ),
        ChangeNotifierProvider<AudioCallProvider>(
          create: (_) => AudioCallProvider(),
        ),
        ChangeNotifierProvider<VideoIconProvider>(
          create: (_) => VideoIconProvider(),
        ),
        ChangeNotifierProvider<VideoRequestProvider>(
          create: (_) => VideoRequestProvider(),
        ),
        ChangeNotifierProvider<ChatSocketViewModel>(
          create: (_) => ChatSocketViewModel(),
        ),
        ChangeNotifierProvider<VoiceCloningController>(
            create: (_) => VoiceCloningController())
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
            theme: AppTheme().themeData,
            //home: navRoute.isEmpty ? SplashScreen() : StartTheCall(),
            home: SplashScreen(),
            navigatorObservers: [MyFHB.routeObserver],
            routes: routes,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            supportedLocales:
                Languages.languages.map((e) => Locale(e.code)).toList(),
            locale: Provider.of<LanguageProvider>(context).locale,
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

}
