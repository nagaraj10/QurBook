import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:camera/camera.dart';
import 'package:myfhb/services/pushnotification_service.dart';
import 'package:myfhb/voice_cloning/model/voice_clone_status_arguments.dart';
import 'package:connectivity/connectivity.dart';
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
import 'package:provider/provider.dart';

import 'IntroScreens/IntroductionScreen.dart';
import 'QurHub/Controller/HubListViewController.dart';
import 'Qurhome/QurhomeDashboard/View/QurhomeDashboard.dart';
import 'add_provider_plan/service/PlanProviderViewModel.dart';
import 'authentication/service/authservice.dart';
import 'authentication/view_model/otp_view_model.dart';
import 'caregiverAssosication/caregiverAPIProvider.dart';
import 'chat_socket/view/ChatDetail.dart';
import 'chat_socket/view/ChatUserList.dart';
import 'chat_socket/viewModel/chat_socket_view_model.dart';
import 'claim/screen/ClaimRecordDisplay.dart';
import 'common/CommonConstants.dart';
import 'common/CommonUtil.dart';
import 'common/DatabseUtil.dart';
import 'common/PreferenceUtil.dart';
import 'common/firebase_analytics_service.dart';
import 'common/firestore_services.dart';
import 'constants/fhb_constants.dart' as Constants;
import 'constants/fhb_constants.dart';
import 'constants/fhb_parameters.dart';
import 'constants/fhb_router.dart' as router;
import 'constants/router_variable.dart' as router;
import 'constants/router_variable.dart' as routervariable;
import 'constants/router_variable.dart';
import 'constants/variable_constant.dart' as variable;
import 'device_integration/viewModel/Device_model.dart';
import 'landing/view_model/landing_view_model.dart';
import 'myPlan/view/myPlanDetail.dart';
import 'my_family/viewmodel/my_family_view_model.dart';
import 'my_family_detail/models/my_family_detail_arguments.dart';
import 'my_family_detail/screens/my_family_detail_screen.dart';
import 'plan_wizard/view_model/plan_wizard_view_model.dart';
import 'regiment/models/regiment_arguments.dart';
import 'regiment/view/manage_activities/manage_activities_screen.dart';
import 'regiment/view_model/regiment_view_model.dart';
import 'schedules/add_reminders.dart';
import 'services/notification_helper.dart';
import 'src/blocs/Category/CategoryListBlock.dart';
import 'src/model/home_screen_arguments.dart';
import 'src/model/user/user_accounts_arguments.dart';
import 'src/resources/network/ApiBaseHelper.dart';
import 'src/ui/MyRecord.dart';
import 'src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'src/ui/SheelaAI/Services/SheelaAIBLEServices.dart';
import 'src/ui/SheelaAI/Views/SuperMaya.dart';
import 'src/ui/SplashScreen.dart';
import 'src/ui/connectivity_bloc.dart';
import 'src/ui/settings/CaregiverSettng.dart';
import 'src/utils/FHBUtils.dart';
import 'src/utils/PageNavigator.dart';
import 'src/utils/cron_jobs.dart';
import 'src/utils/dynamic_links.dart';
import 'src/utils/language/app_localizations.dart';
import 'src/utils/language/language_utils.dart';
import 'src/utils/language/languages.dart';
import 'src/utils/language/view_model/language_view_model.dart';
import 'src/utils/lifecycle_state_provider.dart';
import 'src/utils/screenutils/screenutil.dart';
import 'src/utils/timezone/timezone_services.dart';
import 'telehealth/features/MyProvider/view/BookingConfirmation.dart';
import 'telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'telehealth/features/Notifications/services/notification_services.dart';
import 'telehealth/features/appointments/controller/AppointmentDetailsController.dart';
import 'telehealth/features/appointments/model/fetchAppointments/city.dart';
import 'telehealth/features/appointments/model/fetchAppointments/doctor.dart'
    as doc;
import 'telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'telehealth/features/appointments/view/AppointmentDetailScreen.dart';
import 'telehealth/features/appointments/view/resheduleMain.dart';
import 'telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'ticket_support/view/detail_ticket_view_screen.dart';
import 'user_plans/view_model/user_plans_view_model.dart';
import 'video_call/pages/callmain.dart';
import 'video_call/services/iOS_Notification_Handler.dart';
import 'video_call/utils/audiocall_provider.dart';
import 'video_call/utils/callstatus.dart';
import 'video_call/utils/hideprovider.dart';
import 'video_call/utils/rtc_engine.dart';
import 'video_call/utils/videoicon_provider.dart';
import 'video_call/utils/videorequest_provider.dart';
import 'widgets/checkout_page.dart';
import 'widgets/checkout_page_provider.dart';
import 'widgets/shopping_card_provider.dart';

var firstCamera;
late List<CameraDescription> listOfCameras;

//variable for all outer
late var routes;
final FlutterLocalNotificationsPlugin localNotificationsPlugin =
FlutterLocalNotificationsPlugin();

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

    // Future.delayed(Duration(seconds: 0)).then((_) {
    //   if (PreferenceUtil.getIfQurhomeisAcive()) {
    //     CommonUtil().initQurHomePortraitLandScapeMode();
    //   } else {
    //     CommonUtil().initPortraitMode();
    //   }
    // });

    // if (CommonUtil().isTablet) {
    //   CommonUtil().initQurHomePortraitLandScapeMode();
    // } else {
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

    var firebase = FirebaseAnalyticsService();
    firebase.setUserId(PreferenceUtil.getStringValue(KEY_USERID_MAIN));
    firebase.trackCurrentScreen("startScreen", "classOverride");
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
  static const secure_platform = variable.security;
  static const nav_platform = MethodChannel('navigation.channel');
  String navRoute = '';
  bool isAlreadyLoaded = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _internetconnection = true;
  FlutterToast toast = FlutterToast();

  /// event channel for listening ns
  static const stream =
      EventChannel('com.example.agoraflutterquickstart/stream');
  StreamSubscription? _timerSubscription;
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
    /*CommonUtil.askPermissionForCameraAndMic().then((value) {
      CommonUtil.askPermissionForLocation().then((value) {
        CommonUtil().askPermissionForNotification();
      });
    });*/
    //getMyRoute();
    _enableTimer();
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
    Get.put(
      HubListViewController(),
    );
    Get.lazyPut(
      () => SheelaAIController(),
    );
    Get.lazyPut(
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
    _disableTimer();
    super.dispose();
  }

  void _enableTimer() {
    _timerSubscription ??= stream.receiveBroadcastStream().listen(_updateTimer);
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription!.cancel();
      _timerSubscription = null;
    }
  }

  getSpeechToText(message) {
    String? sheela_lang = PreferenceUtil.getStringValue(SHEELA_LANG);
    Get.toNamed(
      rt_Sheela,
      arguments: SheelaArgument(
        isSheelaAskForLang: !((sheela_lang ?? '').isNotEmpty),
        langCode: (sheela_lang ?? ''),
      ),
    );
  }

  Future<void> _updateTimer(msg) async {
    String? doctorPic = '';
    String? patientPic = '';
    var callType = '';
    var notificationListId = '';
    _msgListener.value = _msg;
    print('datanotificaton: ' + msg.toString());
    final cMsg = msg as String;
    if (cMsg.isNotEmpty || cMsg != null) {
      if (cMsg == 'chat') {
        fbaLog(eveParams: {
          'eventTime': '${DateTime.now()}',
          'ns_type': 'chat',
          'navigationPage': 'Tele Health Chat list',
        });
        Get.to(ChatUserList());
      } else if (cMsg == 'FETCH_LOG') {}
      if(cMsg =='vcApproveByProvider' || cMsg =='vcDeclineByProvider'){
        Get.toNamed(
          rt_VoiceCloningStatus,
          arguments: const VoiceCloneStatusArguments(fromMenu: true),
        );
      }
      final passedValArr = cMsg.split('&');
      if (passedValArr[0] == 'facebookdeeplink') {
        var firebase = FirebaseAnalyticsService();
        print(passedValArr[1]);
        firebase.trackEvent("on_facebook_clicked", {
          "user_id": PreferenceUtil.getStringValue(KEY_USERID_MAIN),
          "total": passedValArr[1]
        });
      }
      if (passedValArr[0] == 'activityRemainderInvokeSheela') {
        //// allow the user for auto redirect to sheela screen on time
        if (CommonUtil().isAllowSheelaLiveReminders()) {
          // live reminder On deafult existing flow
          if (sheelaAIController.isSheelaScreenActive) {
            var reqJson = {
              KIOSK_task: KIOSK_remind,
              KIOSK_eid: passedValArr[1].toString()
            };
            CommonUtil().callQueueNotificationPostApi(reqJson);
          } else {
            if (sheelaAIController.isQueueDialogShowing.value) {
              Get.back();
              sheelaAIController.isQueueDialogShowing.value = false;
            }
            Future.delayed(Duration(milliseconds: 500), () async {
              getToSheelaNavigate(passedValArr,
                  isFromActivityRemainderInvokeSheela: true);
            });
          }
        } else {
          // live reminder off only queue flow working
          var reqJson = {
            KIOSK_task: KIOSK_remind,
            KIOSK_eid: passedValArr[1].toString()
          };
          CommonUtil().callQueueNotificationPostApi(reqJson);
        }
      }
      if (passedValArr[0] == 'isSheelaFollowup') {
        /*if (sheelaAIController.isSheelaScreenActive) {
          if (((passedValArr[3].toString()).isNotEmpty) &&
              (passedValArr[3] != 'null')) {
            var reqJsonAudio = {
              KIOSK_task: KIOSK_audio,
              KIOSK_audio_url: passedValArr[3].toString()
            };
            CommonUtil().callQueueNotificationPostApi(reqJsonAudio);
          } else {
            var reqJsonText = {
              KIOSK_task: KIOSK_read,
              KIOSK_message_api: passedValArr[2].toString()
            };
            CommonUtil().callQueueNotificationPostApi(reqJsonText);
          }
        } else {*/

        ///// allow the user for auto redirect to sheela screen on time
        if (CommonUtil().isAllowSheelaLiveReminders()) {
          if (((passedValArr[3].toString()).isNotEmpty) &&
              (passedValArr[3] != 'null')) {
            if (sheelaAIController.isQueueDialogShowing.value) {
              Get.back();
              Future.delayed(Duration(milliseconds: 500), () async {
                getToSheelaNavigate(passedValArr, isFromAudio: true);
              });
            } else {
              Future.delayed(Duration(milliseconds: 500), () async {
                getToSheelaNavigate(passedValArr, isFromAudio: true);
              });
            }
          } else {
            if (sheelaAIController.isQueueDialogShowing.value) {
              Get.back();
              Future.delayed(Duration(milliseconds: 500), () async {
                getToSheelaNavigate(passedValArr);
              });
            } else {
              Future.delayed(Duration(milliseconds: 500), () async {
                getToSheelaNavigate(passedValArr);
              });
            }
            //}
          }
        }
      }
      if (passedValArr[0] == 'ack') {
        final temp = passedValArr[1].split('|');
        if (temp[0] == 'myRecords') {
          final dataOne = temp[1];
          final dataTwo = temp[2];
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'myRecords',
            'navigationPage': temp[1],
          });
          if (dataTwo.runtimeType == String && (dataTwo).isNotEmpty) {
            final userId = PreferenceUtil.getStringValue(KEY_USERID);
            if ((passedValArr[2]) == userId) {
              CommonUtil().navigateToRecordDetailsScreen(dataTwo);
            } else {
              CommonUtil.showFamilyMemberPlanExpiryDialog(
                passedValArr[3],
                redirect: temp[0],
              );
            }
          } else {
            CommonUtil()
                .navigateToMyRecordsCategory(temp[1], [passedValArr[2]], false);
            // navigateToMyRecordsCategory(
            //     temp[1], [passedValArr[2]], false
            // );
          }
        } else if (passedValArr[1] == 'notifyCaregiverForMedicalRecord') {
          Get.to(ChatDetail(
              peerId: passedValArr[2],
              peerAvatar: passedValArr[8],
              peerName: passedValArr[3],
              patientId: '',
              patientName: '',
              patientPicture: '',
              isFromVideoCall: false,
              isFromFamilyListChat: true,
              isFromCareCoordinator: passedValArr[7].toLowerCase() == 'true',
              carecoordinatorId: passedValArr[4],
              isCareGiver: passedValArr[5].toLowerCase() == 'true',
              groupId: '',
              lastDate: passedValArr[6]));
        } else if (passedValArr[1] == 'escalateToCareCoordinatorToRegimen') {
          final userId = PreferenceUtil.getStringValue(KEY_USERID);
          if (passedValArr[7] == userId) {
            CommonUtil().escalateNonAdherance(
                passedValArr[2],
                passedValArr[3],
                passedValArr[4],
                passedValArr[5],
                passedValArr[6],
                passedValArr[7],
                passedValArr[8],
                passedValArr[9]);
            Get.toNamed(rt_Regimen);
          } else {
            CommonUtil.showFamilyMemberPlanExpiryDialog(
              passedValArr[3],
              redirect: "caregiver",
            );
          }
        } else if (passedValArr[1] == 'qurbookServiceRequestStatusUpdate') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'qurbookServiceRequestStatusUpdate',
            'navigationPage': 'TicketDetails',
          });
          Get.to(DetailedTicketView(null, true, passedValArr[2]));
        } else if (passedValArr[1] == 'notifyPatientServiceTicketByCC') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'notifyPatientServiceTicketByCC',
            'navigationPage': 'TicketDetails',
          });
          Get.to(DetailedTicketView(null, true, passedValArr[2]));
        } else if (passedValArr[1] == 'appointmentPayment') {
          var nsBody = {};
          nsBody['templateName'] = strCaregiverAppointmentPayment;
          nsBody['contextId'] = passedValArr[3];
          FetchNotificationService().updateNsActionStatus(nsBody).then((data) {
            FetchNotificationService().updateNsOnTapAction(nsBody).then(
                (value) => Get.to(BookingConfirmation(
                    isFromPaymentNotification: true,
                    appointmentId: passedValArr[2])));
          });
        } else if (passedValArr[1] == 'careGiverMemberProfile') {
          print('caregiverid: ' + passedValArr[2]);
          Get.to(
            MyFamilyDetailScreen(
              arguments:
                  MyFamilyDetailArguments(caregiverRequestor: passedValArr[2]),
            ),
          );
          // Navigator.pushNamed(
          //   context,
          //   router.rt_FamilyDetailScreen,
          //   arguments: MyFamilyDetailArguments(
          //       caregiverRequestor: passedValArr[2]),
          // );
        } else if (passedValArr[1] == 'communicationSetting') {
          print("working communication");
          Get.to(CareGiverSettings());

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         CareGiverSettings(),
          //   ),
          // );
        } else if (passedValArr[1] == 'sheela') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'sheela',
            'navigationPage': 'Sheela Start Page',
          });
          try {
            if (CommonUtil().isAllowSheelaLiveReminders()) {
              if (passedValArr[2] != null && passedValArr[2].isNotEmpty) {
                var rawTitle = "";
                var rawBody = "";
                var eventType = "";
                var others = "";

                if (passedValArr[2] == strWrapperCall) {
                  eventType = passedValArr[2];
                  rawTitle = passedValArr[3].split('|')[1];
                  rawBody = passedValArr[3].split('|')[2];
                  others = passedValArr[3].split('|')[0];
                } else {
                  rawTitle = passedValArr[2].split('|')[0];
                  rawBody = passedValArr[2].split('|')[1];
                  if (passedValArr[3] != null && passedValArr[3].isNotEmpty) {
                    notificationListId = passedValArr[3];
                    FetchNotificationService()
                        .inAppUnreadAction(notificationListId);
                  }
                }

                Get.toNamed(
                  routervariable.rt_Sheela,
                  arguments: SheelaArgument(
                    isSheelaAskForLang: true,
                    rawMessage: rawBody,
                    eventType: eventType,
                    others: others,
                  ),
                );
              } else {
                Get.to(SuperMaya());
              }
            }
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
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
                  arguments: UserAccountsArguments(selectedIndex: 0))!
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
                  arguments: HomeScreenArguments(selectedIndex: 1))!
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
                  arguments: HomeScreenArguments(selectedIndex: 1))!
              .then((value) => setState(() {}));
        } else if (passedValArr[1] == 'regiment_screen') {
          //this need to be navigte to Regiment screen
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': CommonUtil.isUSRegion()
                ? 'QurHomeRegimenScreen'
                : 'regiment_screen',
            'navigationPage': 'Regimen Screen',
          });
          if ((CommonUtil.isUSRegion()) &&
              (passedValArr[3] != null) &&
              (passedValArr[3] != 'null') &&
              (passedValArr[4] != null) &&
              (passedValArr[4] != 'null')) {
            var qurhomeDashboardController =
                CommonUtil().onInitQurhomeDashboardController();
            qurhomeDashboardController.eventId.value = passedValArr[2];
            qurhomeDashboardController.estart.value = passedValArr[3];
            if (passedValArr[4] == Constants.doseValueless ||
                passedValArr[4] == Constants.doseValueHigh) {
              qurhomeDashboardController.isOnceInAPlanActivity.value = true;
            } else {
              qurhomeDashboardController.isOnceInAPlanActivity.value = false;
            }
            qurhomeDashboardController.updateTabIndex(0);

            if (!CommonUtil.isCallStarted) {
              Get.offNamedUntil(router.rt_Landing, (route) => false);
            } else {
              Get.to(() => QurhomeDashboard());
            }
          } else {
            Provider.of<RegimentViewModel>(
              context,
              listen: false,
            ).regimentMode = RegimentMode.Schedule;
            Provider.of<RegimentViewModel>(context, listen: false)
                .regimentFilter = RegimentFilter.Missed;
            Get.toNamed(router.rt_Regimen,
                arguments: RegimentArguments(eventId: passedValArr[2]));
          }
        } else if (passedValArr[1] == 'dashboard') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'dashboard',
            'navigationPage': 'Device List Screen',
          });
          PageNavigator.goToPermanent(context, router.rt_Landing);
        } else if (passedValArr[1] == 'familyMemberCaregiverRequest') {
          if (passedValArr[2] == 'accept') {
            CaregiverAPIProvider().approveCareGiver(
              phoneNumber: passedValArr[3],
              code: passedValArr[4],
            );
          } else {
            CaregiverAPIProvider().rejectCareGiver(
              receiver: passedValArr[5],
              requestor: passedValArr[6],
            );
          }
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
        } else if (CommonUtil.isUSRegion() &&
            passedValArr[1] == strPatientReferralAcceptToPatient) {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'myprovider_list',
            'navigationPage': 'MyProvider List Screen',
          });
          Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 2));
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
          )!
              .then((value) =>
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
          )!
              .then((value) =>
                  PageNavigator.goToPermanent(context, router.rt_Landing));
        } else if (passedValArr[1] == 'chat') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'initiate screen',
            'navigationPage': 'Chat Screen',
          });
          Get.to(() => ChatDetail(
                    peerId: passedValArr[2],
                    peerName: passedValArr[3],
                    peerAvatar: passedValArr[4],
                    groupId: passedValArr[5],
                    patientId: '',
                    patientName: '',
                    patientPicture: '',
                    isFromVideoCall: false,
                    isCareGiver: false,
                  ))!
              .then((value) =>
                  PageNavigator.goToPermanent(context, router.rt_Landing));
          ;
        } else if (passedValArr[1] == 'mycart') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'my cart',
            'navigationPage': 'My Cart',
          });
          var nsBody = {};
          nsBody['templateName'] = strCaregiverNotifyPlanSubscription;
          nsBody['contextId'] = passedValArr[4];
          FetchNotificationService().updateNsActionStatus(nsBody).then((data) {
            FetchNotificationService().updateNsOnTapAction(nsBody).then(
                (value) => Get.to(CheckoutPage(
                      isFromNotification: true,
                      cartUserId: passedValArr[2],
                      bookingId: passedValArr[4],
                      notificationListId: passedValArr[3],
                      cartId: passedValArr[4],
                      patientName: passedValArr[6],
                    ))!
                        .then((value) => PageNavigator.goToPermanent(
                            context, router.rt_Landing)));
          });
        } else if (passedValArr[1] == 'familyProfile') {
          CommonUtil()
              .getDetailsOfAddedFamilyMember(Get.context!, passedValArr[2]);
        } else if (passedValArr[1] == 'manageActivities') {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'manageActivities',
            'navigationPage': 'Manage Activities',
          });
          Get.to(ManageActivitiesScreen())!.then((value) =>
              PageNavigator.goToPermanent(context, router.rt_Landing));
        } else if (passedValArr[1] == strAppointmentDetail) {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'appointmentDetail',
            'navigationPage': 'Appointment Detail Page',
          });
          if (passedValArr[2] != null) {
            try {
              if (passedValArr[3] != null) {
                CommonUtil().acceptCareGiverTransportRequestReminder(
                    context,
                    passedValArr[2],
                    passedValArr[3],
                    passedValArr[4].toString().contains("accept"));
              } else {
                AppointmentDetailsController appointmentDetailsController =
                    CommonUtil().onInitAppointmentDetailsController();
                appointmentDetailsController
                    .getAppointmentDetail(passedValArr[2]);
                Get.to(() => AppointmentDetailScreen());
              }
            } catch (e, stackTrace) {
              CommonUtil().appLogs(message: e, stackTrace: stackTrace);
              AppointmentDetailsController appointmentDetailsController =
                  CommonUtil().onInitAppointmentDetailsController();
              appointmentDetailsController
                  .getAppointmentDetail(passedValArr[2]);
              Get.to(() => AppointmentDetailScreen());
            }
          }
        } else if (passedValArr[1] == strConnectedDevicesScreen) {
          CommonUtil().navigateToHubList(Get.context!, fromNotification: false);
        } else {
          fbaLog(eveParams: {
            'eventTime': '${DateTime.now()}',
            'ns_type': 'appointment_list',
            'navigationPage': 'Tele Health Appointment list',
          });
          PageNavigator.goToPermanent(Get.context!, router.rt_Landing);
        }
      }
      // new feature appointment reminder 5 mins before from api side
      else if (passedValArr[0] == 'sheela') {
        if (passedValArr[1] == strAppointment) {
          // Prepare JSON data for adding to the sheela queue request
          final reqJson = {
            KIOSK_task: KIOSK_appointment_avail,
            KIOSK_appoint_id: passedValArr[2] ?? '',
            KIOSK_eid: passedValArr[3] ?? '',
          };
          // Check if Sheela Live reminders are allowed
          if (CommonUtil().isAllowSheelaLiveReminders()) {
            // Check if Sheela screen is active
            if (sheelaAIController?.isSheelaScreenActive ?? false) {
              //Adding the notificaiton to sheela reminder Queue
              CommonUtil().callQueueNotificationPostApi(reqJson);
            } else if (PreferenceUtil.getIfQurhomeisAcive()) {
              // Navigate to Sheela screen with specific arguments
              await Get.toNamed(
                rt_Sheela,
                arguments: SheelaArgument(
                  scheduleAppointment: true,
                ),
              );
            }
          } else {
            //Adding the notificaiton to sheela reminder Queue
            //since the live notifications are disabled.
            CommonUtil().callQueueNotificationPostApi(reqJson);
          }
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
        body['templateName'] = passedValArr[5];
        body['contextId'] = passedValArr[2];
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
              bookingId: passedValArr[1],
              date: passedValArr[2],
              templateName: passedValArr[3]),
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
      } else if (passedValArr[0] == 'myplandetails') {
        final planid = passedValArr[1];
        final template = passedValArr[2];
        final userId = passedValArr[3];
        final patName = passedValArr[4];
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
              showRenew: false,
              templateName: template,
            ),
          );
        } else {
          CommonUtil.showFamilyMemberPlanExpiryDialog(patName,
              redirect: "myplandetails");
        }
      } else if (passedValArr[0] == 'claimList') {
        final claimId = passedValArr[1];
        final userId = passedValArr[2];
        final currentUserId = PreferenceUtil.getStringValue(KEY_USERID);
        fbaLog(eveParams: {
          'eventTime': '${DateTime.now()}',
          'ns_type': 'claim_Details',
          'navigationPage': 'Claim Record Display',
        });
        Get.to(
          ClaimRecordDisplay(
            claimID: claimId,
          ),
        );
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
      } else if (passedValArr[0] == Constants.strVoiceClonePatientAssignment) {
        // Check if the first element of passedValArr is related to voice clone patient assignment

        // Call the method to save the voice clone patient assignment status
        CommonUtil().saveVoiceClonePatientAssignmentStatus(passedValArr[1],
            passedValArr[2].toString().contains(accept.toLowerCase()));
      } else if (passedValArr.asMap().containsKey(4)) {
        if (passedValArr[4] == 'call') {
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
              } catch (e, stackTrace) {
                CommonUtil().appLogs(message: e, stackTrace: stackTrace);
              }
            } else {
              doctorPic = '';
            }
            if (patientPic.isNotEmpty) {
              try {
                patientPic = json.decode(patientPic);
              } catch (e, stackTrace) {
                CommonUtil().appLogs(message: e, stackTrace: stackTrace);
              }
            } else {
              patientPic = '';
            }

            fbaLog(eveParams: {
              'eventTime': '${DateTime.now()}',
              'ns_type': 'call',
              'navigationPage': 'TeleHelath Call screen',
            });
            if (callType.toLowerCase() == 'audio') {
              Provider.of<AudioCallProvider>(Get.context!, listen: false)
                  .enableAudioCall();
            } else if (callType.toLowerCase() == 'video') {
              Provider.of<AudioCallProvider>(Get.context!, listen: false)
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
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          }
        }
      }
    }
  }

  getToSheelaNavigate(var passedValArr,
      {bool isFromAudio = false,
      bool isFromActivityRemainderInvokeSheela = false}) {
    if (isFromActivityRemainderInvokeSheela) {
      Get.toNamed(
        rt_Sheela,
        arguments: SheelaArgument(eId: passedValArr[1].toString()),
      )!
          .then((value) {
        try {
          sheelaAIController.getSheelaBadgeCount(isNeedSheelaDialog: true);
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
      });
      return;
    }
    if (isFromAudio) {
      Get.toNamed(
        router.rt_Sheela,
        arguments: SheelaArgument(
          allowBackBtnPress: true,
          audioMessage: passedValArr[3].toString(),
          eventIdViaSheela: passedValArr[4].toString(),
        ),
      )!
          .then((value) {
        try {
          sheelaAIController.getSheelaBadgeCount(isNeedSheelaDialog: true);
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          if (kDebugMode) {
            print(e);
          }
        }
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () async {
        Get.toNamed(
          rt_Sheela,
          arguments: SheelaArgument(
              allowBackBtnPress: true,
              isSheelaFollowup: true,
              textSpeechSheela: (passedValArr[2] != null &&
                      passedValArr[2] != 'null' &&
                      passedValArr[2] != '')
                  ? passedValArr[2]
                  : passedValArr[1],
              audioMessage: '',
              isNeedPreferredLangauge: true,
              eventIdViaSheela: passedValArr[4]),
        )!
            .then((value) {
          try {
            sheelaAIController.getSheelaBadgeCount(isNeedSheelaDialog: true);
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            if (kDebugMode) {
              print(e);
            }
          }
        });
      });
    }
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
    final nsSettingsForAndroid =
        AndroidInitializationSettings(variable.strLauncher);
        
    final nsSettingsForIOS = DarwinInitializationSettings(
        notificationCategories: darwinIOSCategories);
    final platform = InitializationSettings(
        android: nsSettingsForAndroid, iOS: nsSettingsForIOS);

    Future notificationAction(NotificationResponse details) async {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddReminder()));
    }

/*    flutterLocalNotificationsPlugin.initialize(platform,
        onDidReceiveNotificationResponse: notificationAction);*/
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectivityBloc>(
          create: (_) => ConnectivityBloc(),
        ),
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
        ChangeNotifierProvider<VoiceCloningController>(create:(_)=>VoiceCloningController())
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

  Widget? findHomeWidget(String navRoute) {
    if (navRoute.isEmpty && navRoute != 'null') {
      // return SplashScreen();
      if (isFirstTime != null && !isFirstTime!) {
        return CommonUtil.REGION_CODE == 'IN'
            ? IntroductionScreen()
            : SplashScreen();
      } else {
        return SplashScreen();
      }
    } else {
      try {

        if (navRoute == 'FETCH_LOG') {
          return SplashScreen(
            nsRoute: '',
          );
        }
        if(navRoute =='vcApproveByProvider' || navRoute =='vcDeclineByProvider'){
          return SplashScreen(
            nsRoute:navRoute,
          );
        }
        final parsedData = navRoute.split('&');
        if (parsedData != null && parsedData.length > 0) {
          if (parsedData[0] == 'isSheelaFollowup') {
            if ((parsedData[3].toString()).isNotEmpty &&
                parsedData[3] != 'null') {
              return SplashScreen(
                nsRoute: 'isSheelaFollowup',
                bundle:
                    'isSheelaFollowup' + '|' + 'audio' + '|' + parsedData[3],
              );
            } else {
              return SplashScreen(
                nsRoute: 'isSheelaFollowup',
                bundle: parsedData[0] + '|' + parsedData[2],
              );
            }
          } else if (parsedData[1] == 'appointmentList' ||
              parsedData[1] == 'appointmentHistory') {
            return SplashScreen(
              nsRoute: parsedData[1],
            );
          } else if (parsedData[0] == 'sheela') {
            if (parsedData[1] == strAppointment) {
              return SplashScreen(
                nsRoute: strAppointment,
              );
            }
          } else if (parsedData[0] == 'ack') {
            final temp = parsedData[1].split('|');
            if (temp[0] == 'myRecords') {
              return SplashScreen(
                nsRoute: 'myRecords',
                templateName: parsedData[1],
                bundle: parsedData[2],
              );
            } else if (parsedData[1] == 'notifyCaregiverForMedicalRecord') {
              return SplashScreen(
                nsRoute: 'notifyCaregiverForMedicalRecord',
                templateName: parsedData[1],
                bundle: parsedData[2] +
                    '|' +
                    parsedData[3] +
                    '|' +
                    parsedData[4] +
                    '|' +
                    parsedData[5] +
                    '|' +
                    parsedData[6] +
                    '|' +
                    parsedData[7] +
                    '|' +
                    parsedData[8],
              );
            } else if (parsedData[1] == 'sheela') {
              var bundleText;
              if (parsedData.length == 5) {
                bundleText =
                    parsedData[2] + '|' + parsedData[3] + '|' + parsedData[4];
              } else if (parsedData.length == 4) {
                bundleText = parsedData[2] + '|' + parsedData[3];
              } else if (parsedData.length == 3) {
                bundleText = parsedData[2] + '|' + parsedData[1];
              }
              return SplashScreen(
                nsRoute: 'sheela',
                bundle: bundleText,
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
            } else if (parsedData[1] == 'familyMemberCaregiverRequest') {
              return SplashScreen(
                nsRoute: 'familyMemberCaregiverRequest',
                bundle: parsedData[2] +
                    '|' +
                    parsedData[3] +
                    '|' +
                    parsedData[4] +
                    '|' +
                    parsedData[5] +
                    '|' +
                    parsedData[6],
              );
            } else if (parsedData[1] == 'escalateToCareCoordinatorToRegimen') {
              return SplashScreen(
                nsRoute: 'escalateToCareCoordinatorToRegimen',
                bundle: parsedData[2] +
                    '|' +
                    parsedData[3] +
                    '|' +
                    parsedData[4] +
                    '|' +
                    parsedData[5] +
                    '|' +
                    parsedData[6],
              );
            } else if (parsedData[1] == 'appointmentPayment') {
              return SplashScreen(
                  nsRoute: 'appointmentPayment',
                  bundle: parsedData[1] +
                      '&' +
                      parsedData[2] +
                      '&' +
                      parsedData[3]);
            } else if (parsedData[1] == 'qurbookServiceRequestStatusUpdate') {
              return SplashScreen(
                  nsRoute: 'qurbookServiceRequestStatusUpdate',
                  bundle: parsedData[2]);
            } else if (parsedData[1] == 'notifyPatientServiceTicketByCC') {
              return SplashScreen(
                  nsRoute: 'notifyPatientServiceTicketByCC',
                  bundle: parsedData[2]);
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
                bundle: navRoute,
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
              //this need to be navigte to chat detail screen
              return SplashScreen(
                nsRoute: 'chat',
                bundle: navRoute,
              );
            } else if (parsedData[1] == 'careGiverMemberProfile') {
              //this need to be navigte to chat detail screen
              return SplashScreen(
                nsRoute: 'careGiverMemberProfile',
                bundle: parsedData[2],
              );
            } else if (parsedData[1] == 'communicationSetting') {
              //this need to be navigte to chat detail screen
              return SplashScreen(
                nsRoute: 'communicationSetting',
              );
            } else if (parsedData[1] == 'mycart') {
              //this need to be navigte to My Plans screen
              return SplashScreen(
                  nsRoute: 'mycart',
                  bundle: parsedData[0] +
                      '&' +
                      parsedData[1] +
                      '&' +
                      parsedData[2] +
                      '&' +
                      parsedData[3] +
                      '&' +
                      parsedData[4] +
                      '&' +
                      parsedData[5] +
                      '&' +
                      parsedData[6]);
            } else if (parsedData[1] == 'familyProfile') {
              return SplashScreen(
                  nsRoute: 'familyProfile',
                  bundle: parsedData[0] +
                      '&' +
                      parsedData[1] +
                      '&' +
                      parsedData[2]);
            } else if (parsedData[1] == 'manageActivities') {
              return SplashScreen(
                nsRoute: 'manageActivities',
                bundle: parsedData[2],
              );
            } else if (parsedData[1] == strAppointmentDetail) {
              if (parsedData[2] != null) {
                return SplashScreen(
                    nsRoute: strAppointmentDetail, bundle: navRoute);
              }
            } else if (parsedData[1] == strPatientReferralAcceptToPatient) {
              //this need to be navigte to My Provider screen
              return SplashScreen(
                nsRoute: parsedData[1],
              );
            } else if (parsedData[1] == strConnectedDevicesScreen) {
              return SplashScreen(
                nsRoute: parsedData[1],
              );
            } else {
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
          } else if (navRoute.split('&')[0] == 'myplandetails') {
            return SplashScreen(
              nsRoute: navRoute.split('&')[0],
              bundle: {
                'planid': '${navRoute.split('&')[1]}',
                'template': '${navRoute.split('&')[2]}',
                'userId': '${navRoute.split('&')[3]}',
                'patName': '${navRoute.split('&')[4]}'
              },
            );
          } else if (navRoute.split('&')[0] == 'claimList') {
            return SplashScreen(
              nsRoute: navRoute.split('&')[0],
              bundle: {
                'claimId': '${navRoute.split('&')[1]}',
                'userId': '${navRoute.split('&')[2]}'
              },
            );
          } else if (navRoute.split('&')[0] ==
              Constants.strVoiceClonePatientAssignment) {
            // Check if the first element of the split result from navRoute (using '&') is related to voice clone patient assignment
            return SplashScreen(
                nsRoute: navRoute.split('&')[0], bundle: navRoute);
          } else if (parsedData.asMap().containsKey(4)) {
            if (parsedData[4] == call) {
              return SplashScreen(
                nsRoute: parsedData[4],
                bundle: navRoute,
              );
            }
          } else {
            return SplashScreen();
          }
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
  }

  Future<void> gettingResponseFromNative() async {
    String? res = '';
    try {
      final result = await platform.invokeMethod(variable.strGetAppVersion);
      res = result;
    } on PlatformException catch (e, stackTrace) {
      res = TranslationConstants.failedToInvoke.t() + "'${e.message}'.";
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    setState(() {
      _responseFromNative = res;
      CommonConstants.appVersion = _responseFromNative;
    });
  }

  Future<void> showSecurityWall() async {
    try {
      final RESULTCODE = await secure_platform.invokeMethod(variable.strSecure);
    } on PlatformException catch (e, stackTrace) {
      CommonUtil()
          .appLogs(message: e.toString(), stackTrace: stackTrace.toString());
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult? result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult? result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        if (!_internetconnection) {
          //Navigator.pop(Get.context);
        }

        setState(() {
          _internetconnection = true;
          //toast.getToast(wifi_connected, Colors.green);
        });
        break;
      case ConnectivityResult.mobile:
        if (!_internetconnection) {
          //Navigator.pop(Get.context);
        }
        setState(() {
          _internetconnection = true;
          //toast.getToast(data_connected, Colors.green);
        });
        break;
      case ConnectivityResult.none:
        //await Get.to(NetworkScreen());
        setState(() {
          _internetconnection = false;
          toast.getToast(no_internet_conn, Colors.red);
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
