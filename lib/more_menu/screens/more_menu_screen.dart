import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../QurHub/Controller/HubListViewController.dart';
import '../../QurHub/View/HubListView.dart';
import '../../authentication/constants/constants.dart';
import '../../authentication/view/otp_remove_account_screen.dart';
import '../../authentication/view_model/patientauth_view_model.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonUtil.dart';
import '../../common/DeleteAccountWebScreen.dart';
import '../../common/DexComWebScreen.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../common/errors_widget.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../constants/variable_constant.dart';
import '../../device_integration/view/screens/Device_Card.dart';
import '../../device_integration/view/screens/Device_Data.dart';
import '../../device_integration/viewModel/Device_model.dart';
import '../../device_integration/viewModel/deviceDataHelper.dart';
import '../../landing/view/landing_screen.dart';
import '../../main.dart';
import '../../myfhb_weview/myfhb_webview.dart';
import '../../src/blocs/User/MyProfileBloc.dart';
import '../../src/model/CreateDeviceSelectionModel.dart';
import '../../src/model/GetDeviceSelectionModel.dart';
import '../../src/model/UpdatedDeviceModel.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/model/user/Tags.dart';
import '../../src/model/user/user_accounts_arguments.dart';
import '../../src/resources/repository/health/HealthReportListForUserRepository.dart';
import '../../src/ui/HomeScreen.dart';
import '../../src/ui/SheelaAI/Controller/SheelaAIController.dart';
import '../../src/ui/settings/CaregiverSettng.dart';
import '../../src/ui/settings/MySettings.dart';
import '../../src/ui/settings/NonAdheranceSettingsScreen.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../unit/choose_unit.dart';
import '../../voice_cloning/model/voice_clone_status_arguments.dart';
import '../../widgets/GradientAppBar.dart';
import '../../app_theme_provider.dart';
import '../models/app_theme_type.dart';
import 'terms_and_conditon.dart';
import 'trouble_shooting.dart';

class MoreMenuScreen extends StatefulWidget {
  final Function(bool userChanged)? refresh;

  const MoreMenuScreen({this.refresh});

  @override
  _MoreMenuScreenState createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends State<MoreMenuScreen> {
  MyProfileModel? myProfile;
  File? profileImage;
  late AuthViewModel authViewModel;
  FlutterToast toast = FlutterToast();

  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();
  GetDeviceSelectionModel? selectionResult;
  CreateDeviceSelectionModel? createDeviceSelectionModel;
  UpdateDeviceModel? updateDeviceModel;

  int? preColor = 0xff5e1fe0;
  int? greColor = 0xff753aec;
  String? userMappingId = '';

  bool? _isdigitRecognition = true;
  bool? _isdeviceRecognition = true;
  bool? _isSheelaLiveReminders = true;
  bool? _isGFActive;
  late DevicesViewModel _deviceModel;
  bool? _isHKActive = false;
  bool _firstTym = true;
  bool? _isBPActive = true;
  bool? _isGLActive = true;
  bool? _isOxyActive = true;
  bool? _isTHActive = true;
  bool? _isWSActive = true;
  bool _isHealthFirstTime = false;
  String? preferred_language;
  String? qa_subscription;

  bool voiceCloning = false;
  ///Added for Family members
  bool useClonedVoice = false;
  bool providerAllowedVoiceCloningModule = false;
  bool superAdminAllowedVoiceCloningModule = false;
  String voiceCloningStatus = strInActive; //set defaut value
  bool showVoiceCloningUI = true;
  String healthOrganization = '';

  String selectedMaya = PreferenceUtil.getStringValue(Constants.keyMayaAsset) ??
      variable.icon_mayaMain;

  int selectedGradientColor =
      PreferenceUtil.getSavedTheme(Constants.keyGreyColor) ?? 0xff753aec;

  String version = '';
  List<Tags>? tagsList = [];
  List<Widget> devices = [];
  bool? allowAppointmentNotification = true;
  bool? allowVitalNotification = true;
  bool? allowSymptomsNotification = true;
  bool isCareGiver = false;

  late List<DeviceData> selectedList;
  bool isTouched = false;
  DeviceDataHelper _deviceDataHelper = DeviceDataHelper();

  bool isSkillIntegration = false;
  bool isCareGiverCommunication = false;
  bool isVitalPreferences = false;
  bool isDisplayDevices = false;
  bool isPrivacyAndSecurity = false;
  bool isBiometric = false;
  bool isDeleteAccount = false;

  bool isDisplayPreference = false;
  bool isAppThemePreference = false;
  bool isSheelaNotificationPref = false;
  bool isIntegration = false;
  bool isColorPallete = false;
  bool loading = false;
  PreferredMeasurement? preferredMeasurement;

  var qurhomeDashboardController =
      CommonUtil().onInitQurhomeDashboardController();
  bool isProd = false;

  SheelaAIController? sheelaAIcontroller =
      CommonUtil().onInitSheelaAIController();
  /**
       * Declared the below size to maintain UI font size similar in 
       * Qurhome tablet ans mobile
       */

  double iconSize = CommonUtil().isTablet!
      ? Constants.imageCloseTab
      : Constants.imageCloseMobile;

  double title =
      CommonUtil().isTablet! ? Constants.tabHeader1 : Constants.mobileHeader1;
  double subtitle =
      CommonUtil().isTablet! ? Constants.tabHeader2 : Constants.mobileHeader2;
  double title3 =
      CommonUtil().isTablet! ? Constants.tabHeader3 : Constants.mobileHeader3;

  double title4 =
      CommonUtil().isTablet! ? Constants.tabHeader4 : Constants.mobileHeader4;

  double arrowIcon = CommonUtil().isTablet! ? 20.0.sp : 16.0.sp;
  double switchTrail = CommonUtil().isTablet! ? 1.0 : 0.8;
  bool? isVoiceCloningChanged; // bool value to allow navigation when tapped
  ///Added for family members to identify  whether voice is assigned or not
  bool isVoiceAssigned =false;

  @override
  void initState(){
    super.initState();
    qurhomeDashboardController.getModuleAccess();
    if (CommonUtil.REGION_CODE == 'US') {
      getAvailableDevices();
    }
    PackageInfo.fromPlatform().then((packageInfo) {
      version = '${packageInfo.version} + ${packageInfo.buildNumber}';
    });
    selectedList = [];
    _deviceModel = DevicesViewModel();
    authViewModel = AuthViewModel();
    FABService.trackCurrentScreen(FBASettingScreen);
    if ((BASE_URL == prodINURL) ||
        (BASE_URL == prodUSURL) ||
        (BASE_URL == demoINURL) ||
        (BASE_URL == demoUSURL)) {
      isProd = true;
    } else {
      isProd = false;
    }
  }

  getProfileImage() async {
    myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

    setState(() {
      final profileImageFile =
          PreferenceUtil.getStringValue(Constants.KEY_PROFILE_IMAGE);
      if (profileImageFile != null) {
        profileImage = File(profileImageFile);
      }
    });

    if (myProfile!.result != null) {}
  }

  Future<MyProfileModel?> getMyProfile() async {
    if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) != null) {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    } else {
      myProfile = await CommonUtil().getMyProfile();
    }
    return myProfile;
  }

  _sendOtpDetails() async {
    var response = await authViewModel.getDeleteAccountOtp(isResend: false);
    if (response.isSuccess!) {
      toast.getToast('One Time Password sent successfully', Colors.green);
    } else {
      if (response.message != null) {
        toast.getToast(response.message!, Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: GradientAppBar(),
            leading: IconWidget(
              icon: Icons.arrow_back_ios,
              colors: Colors.white,
              size: 24.0.sp,
              onTap: () {
                Navigator.pop(context, false);
              },
            ),
            actions: <Widget>[
              // IconButton(
              //     icon: Icon(
              //       Icons.exit_to_app,
              //       size: 24.0.sp,
              //     ),
              //     onPressed: () {
              //       FHBBasicWidget().exitApp(context, () {
              //         CommonUtil().logout(moveToLoginPage);
              //       });
              //     })
            ]),
        floatingActionButton: !isProd
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TroubleShooting(),
                    ),
                  ).then((value) {
                    if (value) {
                      setState(() {});
                    }
                  });
                },
                child: Container(
                  width: CommonUtil().isTablet! ? 250 : 200,
                  height: CommonUtil().isTablet! ? 60 : 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: mAppThemeProvider.primaryColor,
                  ),
                  child: Center(
                    child: Text(strTroubleShoot,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0.sp,
                          color: ColorUtils.white,
                        )),
                  ),
                ),
              )
            : SizedBox(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: getValuesFromSharedPrefernce());
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to update the changes'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => createAppColorSelection(preColor, greColor),
            child: Text('Yes'),
          ),
        ],
      ),
    ).then((value) => value as bool);
  }

  void openWebView(String title, String url, bool isLocal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MyFhbWebView(
            title: title, selectedUrl: url, isLocalAsset: isLocal)));
  }

  Widget getBody() {
    var theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: ListTile(
            leading: ClipOval(
              child: profileImage != null
                  ? Image.file(profileImage!,
                      width: CommonUtil().isTablet!
                          ? imageTabHeader
                          : Constants.imageMobileHeader,
                      height: CommonUtil().isTablet!
                          ? imageTabHeader
                          : Constants.imageMobileHeader,
                      fit: BoxFit.cover)
                  : FHBBasicWidget().getProfilePicWidgeUsingUrl(myProfile),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  myProfile!.result != null
                      ? /* toBeginningOfSentenceCase(
                              myProfile.result.firstName ?? '') +
                          ' ' +
                          toBeginningOfSentenceCase(
                              myProfile.result.lastName ?? '') */
                      myProfile?.result?.firstName?.capitalizeFirstofEach ??
                          '' ' ' +
                              myProfile!.result!.lastName!.capitalizeFirstofEach
                      : '',
                  style: TextStyle(
                      fontSize:
                          CommonUtil().isTablet! ? tabHeader1 : mobileHeader2),
                ),
                Text(
                  (myProfile!.result!.userContactCollection3 != null &&
                          myProfile!.result!.userContactCollection3!.isNotEmpty)
                      ? myProfile!.result!.userContactCollection3![0]!
                              .phoneNumber ??
                          ''
                      : '',
                  style: TextStyle(
                      fontSize:
                          CommonUtil().isTablet! ? tabHeader2 : mobileHeader2),
                ),
                Text(
                  (myProfile!.result!.userContactCollection3 != null &&
                          myProfile!.result!.userContactCollection3!.isNotEmpty)
                      ? myProfile!.result!.userContactCollection3![0]!.email ??
                          ''
                      : '',
                  style: TextStyle(
                      fontSize:
                          CommonUtil().isTablet! ? tabHeader3 : mobileHeader3),
                )
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: arrowIcon,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                router.rt_UserAccounts,
                arguments: UserAccountsArguments(selectedIndex: 0),
              );
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text(variable.strSettings,
              style: TextStyle(fontWeight: FontWeight.w500)),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: arrowIcon,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MySettings(priColor: preColor, greColor: greColor),
              ),
            ).then((value) {
              if (value) {
                setState(() {});
              }
            });
            //PageNavigator.goTo(context, router.rt_AppSettings);
          },
        ),
        isCareGiver ? Divider() : Container(),
        isCareGiver
            ? Theme(
                data: theme,
                child: ExpansionTile(
                  iconColor: Colors.black,
                  title: Text(variable.strCareGiverCommunication,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: title)),
                  children: [
                    ListTile(
                      title: Text(variable.strCareGiverSettings,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: arrowIcon,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CareGiverSettings(),
                          ),
                        ).then((value) {
                          if (value) {
                            setState(() {});
                          }
                        });
                        //PageNavigator.goTo(context, router.rt_AppSettings);
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text(variable.strNonAdherenceSettings,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: arrowIcon,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NonAdheranceSettingsScreen(),
                          ),
                        ).then((value) {
                          if (value) {
                            setState(() {});
                          }
                        });
                        //PageNavigator.goTo(context, router.rt_AppSettings);
                      },
                    ),
                  ],
                ),
              )
            : Container(),
        Divider(),
        Theme(
          data: theme,
          child: ExpansionTile(
              iconColor: Colors.black,
              title: Text(variable.strColorPalete,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: <Widget>[
                ListTile(
                    title: Container(
                        height: 60.0.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: variable.myThemes.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              context.read<AppThemeProvider>().updatePrimaryColor(variable.myThemes[index]);
                              context.read<AppThemeProvider>().updateGradientColor(variable.myGradient[index]);
                              preColor = variable.myThemes[index];
                              greColor=variable.myGradient[index];
                              createAppColorSelection(variable.myThemes[index],
                                  variable.myGradient[index]);
                              if (widget.refresh != null) {
                                widget.refresh!(false);
                              }
                            },
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(colors: [
                                        Color(variable.myThemes[index]),
                                        Color(variable.myGradient[index])
                                      ])),
                                  height: 50.0.h,
                                  width: 50.0.h,
                                  child:mAppThemeProvider.primaryColor.value.isEqual(variable.myThemes[index])
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 24.0.sp,
                                        )
                                      : SizedBox(),
                                )),
                          ),
                        ))),
              ]),
        ),
        Divider(),
        Center(
            child: Text(
          version != null ? 'v' + version : '',
          style: TextStyle(color: Colors.grey, fontSize: subtitle),
        )),
      ],
    );
  }

  void unPairDexCom(String? externalSourceId) async {
    setState(() {
      loading = true;
    });
    await healthReportListForUserRepository
        .unPairDexcomm(externalSourceId)
        .then((value) {
      setState(() {
        loading = false;
      });
      if (value.isSuccess!) {
        getAvailableDevices();
      }
    });
  }

  getAvailableDevices() async {
    setState(() {
      loading = true;
    });
    await healthReportListForUserRepository.getAvailableDevices().then((value) {
      if (value.isSuccess!) {
        devices.clear();
        value.result!.forEach((element) {
          devices.add(ListTile(
            title: Text(element.name!,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: title)),
            trailing: Text(
              (element.isPaired! ? 'Un Pair' : 'Pair'),
              style: TextStyle(
                  color: element.isPaired! ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: title),
            ),
            onTap: () {
              if (element.isPaired!) {
                unPairDexCom(element.externalSourceId);
              } else {
                String? baseUrl = '';
                String? clientId = '';
                String? redirectUrl = '';
                String state = '';
                element.systemConfiguration!.forEach((config) {
                  if (config.name == "clientId") {
                    clientId = config.value;
                  }
                  if (config.name == "redirectUrl") {
                    redirectUrl = config.value;
                  }
                  if (config.name == "baseurl") {
                    baseUrl = config.value;
                  }
                });
                var userId =
                    PreferenceUtil.getStringValue(Constants.KEY_USERID);

                state = 'Dexcom/${userId}';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DexComWebScreen(
                      baseUrl: baseUrl,
                      redirectUrl: redirectUrl,
                      clientId: clientId,
                      state: state,
                    ),
                  ),
                ).then((value) {
                  getAvailableDevices();
                });
              }
            },
          ));
          devices.add(Divider());
        });
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }

  Future<GetDeviceSelectionModel?> getAppColorValues(
      {bool forNavigation = false}) async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    await healthReportListForUserRepository
        .getDeviceSelection(userIdFromBloc: userId)
        .then((value) {
      selectionResult = value;
      if (selectionResult!.isSuccess!) {
        if (selectionResult!.result != null) {
          if (forNavigation) {
            setVoiceCloneValue(selectionResult!);
          } else {
            setValues(selectionResult!);
          }
          userMappingId = selectionResult!.result![0].id;
        } else {
          userMappingId = '';
          preColor = 0xff5e1fe0;
          greColor = 0xff753aec;
          _isdeviceRecognition = true;
          _isSheelaLiveReminders = true;
          _isHKActive = false;
          _firstTym = true;
          _isBPActive = true;
          _isGLActive = true;
          _isOxyActive = true;
          _isTHActive = true;
          _isWSActive = true;
          _isHealthFirstTime = false;
          allowAppointmentNotification = true;
          allowSymptomsNotification = true;
          allowVitalNotification = true;
        }
      } else {
        userMappingId = '';
        preColor = 0xff5e1fe0;
        greColor = 0xff753aec;

        allowAppointmentNotification = true;
        allowSymptomsNotification = true;
        allowVitalNotification = true;
      }
    });
    return selectionResult;
  }

  setValues(GetDeviceSelectionModel getDeviceSelectionModel) {
    preColor = getDeviceSelectionModel.result![0].profileSetting!.preColor;
    greColor = getDeviceSelectionModel.result![0].profileSetting!.greColor;

    _isdeviceRecognition = getDeviceSelectionModel
                    .result![0].profileSetting!.allowDevice !=
                null &&
            getDeviceSelectionModel.result![0].profileSetting!.allowDevice != ''
        ? getDeviceSelectionModel.result![0].profileSetting!.allowDevice
        : true;
    _isdigitRecognition =
        getDeviceSelectionModel.result![0].profileSetting!.allowDigit != null &&
                getDeviceSelectionModel.result![0].profileSetting!.allowDigit !=
                    ''
            ? getDeviceSelectionModel.result![0].profileSetting!.allowDigit
            : true;
    _isSheelaLiveReminders = getDeviceSelectionModel
                    .result![0].profileSetting!.sheelaLiveReminders !=
                null &&
            getDeviceSelectionModel
                    .result![0].profileSetting!.sheelaLiveReminders !=
                ''
        ? getDeviceSelectionModel.result![0].profileSetting!.sheelaLiveReminders
        : true;
    sheelaAIcontroller?.isAllowSheelaLiveReminders =
        _isSheelaLiveReminders ?? true;
    _isGFActive =
        getDeviceSelectionModel.result![0].profileSetting!.googleFit != null &&
                getDeviceSelectionModel.result![0].profileSetting!.googleFit !=
                    ''
            ? getDeviceSelectionModel.result![0].profileSetting!.googleFit
            : false;
    _isHKActive =
        getDeviceSelectionModel.result![0].profileSetting!.healthFit != null &&
                getDeviceSelectionModel.result![0].profileSetting!.healthFit !=
                    ''
            ? getDeviceSelectionModel.result![0].profileSetting!.healthFit
            : false;
    _isBPActive =
        getDeviceSelectionModel.result![0].profileSetting!.bpMonitor != null &&
                getDeviceSelectionModel.result![0].profileSetting!.bpMonitor !=
                    ''
            ? getDeviceSelectionModel.result![0].profileSetting!.bpMonitor
            : true;
    _isGLActive =
        getDeviceSelectionModel.result![0].profileSetting!.glucoMeter != null &&
                getDeviceSelectionModel.result![0].profileSetting!.glucoMeter !=
                    ''
            ? getDeviceSelectionModel.result![0].profileSetting!.glucoMeter
            : true;
    _isOxyActive = getDeviceSelectionModel
                    .result![0].profileSetting!.pulseOximeter !=
                null &&
            getDeviceSelectionModel.result![0].profileSetting!.pulseOximeter !=
                ''
        ? getDeviceSelectionModel.result![0].profileSetting!.pulseOximeter
        : true;
    _isWSActive =
        getDeviceSelectionModel.result![0].profileSetting!.weighScale != null &&
                getDeviceSelectionModel.result![0].profileSetting!.weighScale !=
                    ''
            ? getDeviceSelectionModel.result![0].profileSetting!.weighScale
            : true;
    _isTHActive = getDeviceSelectionModel
                    .result![0].profileSetting!.thermoMeter !=
                null &&
            getDeviceSelectionModel.result![0].profileSetting!.thermoMeter != ''
        ? getDeviceSelectionModel.result![0].profileSetting!.thermoMeter
        : true;

    preferred_language = getDeviceSelectionModel
                    .result![0].profileSetting!.preferred_language !=
                null &&
            getDeviceSelectionModel
                    .result![0].profileSetting!.preferred_language !=
                ''
        ? getDeviceSelectionModel.result![0].profileSetting!.preferred_language
        : 'undef';

    qa_subscription =
        getDeviceSelectionModel.result![0].profileSetting!.qa_subscription !=
                    null &&
                getDeviceSelectionModel
                        .result![0].profileSetting!.qa_subscription !=
                    ''
            ? getDeviceSelectionModel.result![0].profileSetting!.qa_subscription
            : 'Y';

    tagsList = getDeviceSelectionModel.result![0].tags != null &&
            getDeviceSelectionModel.result![0].tags!.length > 0
        ? getDeviceSelectionModel.result![0].tags
        : [];

    allowAppointmentNotification = getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                null &&
            getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                ''
        ? getDeviceSelectionModel.result![0].profileSetting!
            .caregiverCommunicationSetting?.appointments
        : true;

    allowVitalNotification = getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                null &&
            getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                ''
        ? getDeviceSelectionModel
            .result![0].profileSetting!.caregiverCommunicationSetting?.vitals
        : true;

    allowSymptomsNotification = getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                null &&
            getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                ''
        ? getDeviceSelectionModel
            .result![0].profileSetting!.caregiverCommunicationSetting?.symptoms
        : true;

    preferredMeasurement =
        getDeviceSelectionModel.result![0].profileSetting != null
            ? getDeviceSelectionModel
                .result![0].profileSetting!.preferredMeasurement
            : null;

    setVoiceCloneValue(getDeviceSelectionModel);

    healthOrganization = getDeviceSelectionModel
            .result![0].primaryProvider?.healthorganizationid ??
        '';

    ///Saving the Healthorganization id to shared preferences.
    PreferenceUtil.saveString(keyHealthOrganizationId, healthOrganization);
  }

  Future<CreateDeviceSelectionModel?> createAppColorSelection(
      int? priColor, int? greColor) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    await healthReportListForUserRepository
        .createDeviceSelection(
            _isdigitRecognition,
            _isdeviceRecognition,
            _isSheelaLiveReminders,
            _isGFActive,
            _isHKActive,
            _isBPActive,
            _isGLActive,
            _isOxyActive,
            _isTHActive,
            _isWSActive,
            userId,
            preferred_language,
            qa_subscription,
            priColor,
            greColor,
            tagsList,
            allowAppointmentNotification,
            allowVitalNotification,
            allowSymptomsNotification,
            voiceCloning,
            useClonedVoice)
        .then((value) async {
      createDeviceSelectionModel = value;
      if (createDeviceSelectionModel!.isSuccess!) {
      } else {
        if (createDeviceSelectionModel!.message ==
            STR_USER_PROFILE_SETTING_ALREADY) {
          await updateDeviceSelectionModel(priColor, greColor);
        }
      }
    });
    return createDeviceSelectionModel;
  }

  Future<UpdateDeviceModel?> updateDeviceSelectionModel(
      int? priColor, int? greColor) async {
    await healthReportListForUserRepository
        .updateDeviceModel(
            userMappingId,
            _isdigitRecognition,
            _isdeviceRecognition,
            _isSheelaLiveReminders,
            _isGFActive,
            _isHKActive,
            _isBPActive,
            _isGLActive,
            _isOxyActive,
            _isTHActive,
            _isWSActive,
            preferred_language,
            qa_subscription,
            priColor,
            greColor,
            tagsList,
            allowAppointmentNotification,
            allowVitalNotification,
            allowSymptomsNotification,
            preferredMeasurement,
            voiceCloning,
            isVoiceCloningChanged,
             useClonedVoice)
        .then((value) async {
      updateDeviceModel = value;
      if (updateDeviceModel!.isSuccess!) {
        // app color updgated
        // await getAppColorValues(forNavigation: isVoiceCloningChanged);
      }
    });
    return updateDeviceModel;
  }

  Widget getValuesFromSharedPrefernce() {
    final _myProfileBloc = MyProfileBloc();

    return FutureBuilder<MyProfileModel?>(
      future: _myProfileBloc.getMyProfileData(Constants.KEY_USERID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CommonCircularIndicator();
        } else if (snapshot.hasError) {
          if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) !=
              null) {
            myProfile =
                PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
            myProfile = snapshot.data;
            isCareGiver = myProfile?.result?.isCaregiver ?? false;
            return getAppColorsAndDeviceValues();
          }
          return ErrorsWidget();
        } else {
          myProfile = snapshot.data;
          isCareGiver = myProfile?.result?.isCaregiver ?? false;
          return getAppColorsAndDeviceValues();
        }
      },
    );
  }

  Widget getAppColorsAndDeviceValues() {
    return FutureBuilder<GetDeviceSelectionModel?>(
      future: getAppColorValues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CommonCircularIndicator();
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          return getBodyNew();
        }
      },
    );
  }

  moveToLoginPage() {
    CommonUtil().moveToLoginPage();
  }

  void launchWhatsApp({
    required String phone,
    required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return 'whatsapp://wa.me/$phone/?text=${Uri.parse(message)}';
      } else {
        return 'whatsapp://send?phone=$phone&text=${Uri.parse(message)}';
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  Widget getBodyNew() {
    var theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: ListTile(
            leading: ClipOval(
              child: profileImage != null
                  ? Image.file(profileImage!,
                      width: CommonUtil().isTablet!
                          ? imageProfileTabHeader
                          : imageProfileMobileHeader,
                      height: CommonUtil().isTablet!
                          ? imageProfileTabHeader
                          : imageProfileMobileHeader,
                      fit: BoxFit.cover)
                  : FHBBasicWidget().getProfilePicWidgeUsingUrl(myProfile),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    myProfile!.result != null
                        ? /* toBeginningOfSentenceCase(
                              myProfile.result.firstName ?? '') +
                          ' ' +
                          toBeginningOfSentenceCase(
                              myProfile.result.lastName ?? '') */
                        myProfile?.result?.firstName?.capitalizeFirstofEach ??
                            '' ' ' +
                                myProfile!
                                    .result!.lastName!.capitalizeFirstofEach
                        : '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: CommonUtil().isTablet!
                          ? Constants.tabHeader1
                          : mobileHeader1,
                    )),
                Text(
                  (myProfile!.result!.userContactCollection3 != null &&
                          myProfile!.result!.userContactCollection3!.isNotEmpty)
                      ? myProfile!.result!.userContactCollection3![0]!
                              .phoneNumber ??
                          ''
                      : '',
                  style: TextStyle(
                    fontSize: CommonUtil().isTablet!
                        ? Constants.tabHeader2
                        : mobileHeader2,
                  ),
                ),
                Text(
                  (myProfile!.result!.userContactCollection3 != null &&
                          myProfile!.result!.userContactCollection3!.isNotEmpty)
                      ? myProfile!.result!.userContactCollection3![0]!.email ??
                          ''
                      : '',
                  style: TextStyle(
                    fontSize: CommonUtil().isTablet!
                        ? Constants.tabHeader3
                        : mobileHeader3,
                  ),
                )
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: arrowIcon,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                router.rt_UserAccounts,
                arguments: UserAccountsArguments(selectedIndex: 0),
              );
            },
          ),
        ),
        Divider(),
        Theme(
            data: theme,
            child: ExpansionTile(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              iconColor: Colors.black,
              initiallyExpanded: isSkillIntegration,
              onExpansionChanged: (value) {
                isSkillIntegration = value;
              },
              title: Text(variable.strSkillsIntegration,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: title)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: arrowIcon,
              ),
              children: [
                ListTile(
                    leading: ImageIcon(
                      AssetImage(variable.icon_digit_reco),
                      size: iconSize,
                      color: Colors.black,
                    ),
                    title: Text(variable.strAllowDigit,
                        style: TextStyle(fontSize: subtitle)),
                    subtitle: Text(
                      variable.strScanDevices,
                      style: TextStyle(fontSize: title3),
                    ),
                    trailing: Transform.scale(
                      scale: switchTrail,
                      child: Switch(
                        value: _isdigitRecognition!,
                        activeColor: mAppThemeProvider.primaryColor,
                        onChanged: (bool newValue) {
                          setState(() {
                            isSkillIntegration = true;
                            isCareGiverCommunication = false;
                            isVitalPreferences = false;
                            isDisplayPreference = false;
                            isSheelaNotificationPref = false;
                            isAppThemePreference = false;
                            isTouched = true;
                            isVoiceCloningChanged =
                                null; // to restrict navigation to terms page

                            _isdigitRecognition = newValue;
                            createAppColorSelection(preColor, greColor);
                            /*PreferenceUtil.saveString(
                                        Constants.allowDigitRecognition,
                                        _isdigitRecognition.toString());*/
                          });
                        },
                      ),
                    )),
                Divider(),
                ListTile(
                    leading: ImageIcon(
                      AssetImage(variable.icon_device_recon),
                      size: iconSize,
                      color: Colors.black,
                    ),
                    title: Text(variable.strAllowDevice,
                        style: TextStyle(fontSize: subtitle)),
                    subtitle: Text(
                      variable.strScanAuto,
                      style: TextStyle(
                        fontSize: title3,
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: switchTrail,
                      child: Switch(
                        value: _isdeviceRecognition!,
                        activeColor: mAppThemeProvider.primaryColor,
                        onChanged: (bool newValue) {
                          setState(() {
                            isSkillIntegration = true;
                            isCareGiverCommunication = false;
                            isVitalPreferences = false;
                            isDisplayPreference = false;
                            isAppThemePreference = false;
                            isSheelaNotificationPref = false;
                            isTouched = true;
                            _isdeviceRecognition = newValue;
                            isVoiceCloningChanged =
                                null; // to restrict navigation to terms page

                            createAppColorSelection(preColor, greColor);
                            /*PreferenceUtil.saveString(
                                        Constants.allowDeviceRecognition,
                                        _isdeviceRecognition.toString());*/
                          });
                        },
                      ),
                    )),
                Divider(),
                if (isCareGiver) //show the voice cloning UI only when the user is caregiver
                  Visibility(
                    visible: superAdminAllowedVoiceCloningModule,
                    child: ListTile(
                        leading: ImageIcon(
                          AssetImage(CommonUtil.isUSRegion()?variable.icon_mic_icon:variable.icon_voice_cloning),
                          size: iconSize,
                          color: providerAllowedVoiceCloningModule
                              ? Colors.black
                              : Colors.grey,
                        ),
                        title: Text(variable.strAllowVoiceCloning,
                            style: TextStyle(
                                fontSize: subtitle,
                                color: providerAllowedVoiceCloningModule
                                    ? Colors.black
                                    : Colors.grey)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              variable.strSheelaDesc,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: title4, color: Colors.grey),
                            ),
                            Row(children: [
                              Text(
                                variable.strStatus,
                                style: TextStyle(
                                    fontWeight:
                                        providerAllowedVoiceCloningModule
                                            ? FontWeight.bold
                                            : null,
                                    fontSize: title3,
                                    color: Colors.grey[600]),
                              ),
                              Text(voiceCloningStatus,
                                  style: AppBarForVoiceCloning()
                                      .getTextStyle(voiceCloningStatus)),
                            ]),
                          ],
                        ),
                        trailing: Transform.scale(
                          scale: switchTrail,
                          child: Switch(
                            value: voiceCloning,
                            activeColor: (superAdminAllowedVoiceCloningModule &&
                                    providerAllowedVoiceCloningModule)
                                ? mAppThemeProvider.primaryColor
                                : (Colors.grey),
                            onChanged: handleVoiceCloneSwitch,
                          ),
                        ),
                        onTap: () => navigateToTermsOrStatusScreen()),
                  ),
                _useClonedVoiceWidget(),
                if (Platform.isAndroid)
                  Theme(
                      data: theme,
                      child: ExpansionTile(
                        iconColor: Colors.black,
                        initiallyExpanded: isIntegration,
                        onExpansionChanged: (value) {
                          setState(() {
                            isIntegration = value;
                          });
                        },
                        title: Text(variable.strIntegration,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: title)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: arrowIcon,
                        ),
                        children: [
                          if (isIntegration && Platform.isAndroid)
                            FutureBuilder(
                                future: _handleGoogleFit(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: ImageIcon(
                                            AssetImage(
                                                variable.icon_digit_googleFit),
                                            size: iconSize,
                                            color: Colors.black,
                                          ),
                                          title: Text(variable.strGoogleFit,
                                              style: TextStyle(
                                                  fontSize: subtitle)),
                                          subtitle: Text(
                                            variable.strAllowGoogle,
                                            style: TextStyle(fontSize: title3),
                                          ),
                                          trailing: Wrap(
                                            children: <Widget>[
                                              Transform.scale(
                                                scale: switchTrail,
                                                child: IconButton(
                                                  icon: Icon(Icons.sync),
                                                  onPressed: () {
                                                    _deviceDataHelper
                                                        .syncGoogleFit();
                                                  },
                                                ),
                                              ),
                                              Transform.scale(
                                                scale: switchTrail,
                                                child: Switch(
                                                  value: _isGFActive!,
                                                  activeColor: mAppThemeProvider.primaryColor,
                                                  onChanged: (bool newValue) {
                                                    setState(() {
                                                      //isTouched = true;
                                                      _isGFActive = newValue;
                                                      isIntegration = true;
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        !loading
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: devices.length,
                                                itemBuilder: (context, index) {
                                                  return devices[index];
                                                })
                                            : CircularProgressIndicator(),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          Container(
                            height: 1,
                            color: Colors.grey[200],
                          ),
                        ],
                      )),
              ],
            ),),
        Divider(),
        isCareGiver
            ? Theme(
                data: theme,
                child: ExpansionTile(
                  backgroundColor: const Color(fhbColors.bgColorContainer),
                  iconColor: Colors.black,
                  title: Text(variable.strCareGiverCommunication,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: title)),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: arrowIcon,
                  ),
                  children: [
                    ListTile(
                      leading: ImageIcon(
                          AssetImage(
                            variable.notification_preference,
                          ),
                          size: iconSize),
                      title: Text(variable.strNotificationPreference,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: subtitle)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: arrowIcon,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CareGiverSettings(),
                          ),
                        ).then((value) {
                          if (value) {
                            setState(() {});
                          }
                        });
                        //PageNavigator.goTo(context, router.rt_AppSettings);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: ImageIcon(
                        AssetImage(variable.activity_non_adherance),
                        size: iconSize,
                      ),
                      title: Text(variable.strNonAdherenceSettings,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: subtitle)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: arrowIcon,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NonAdheranceSettingsScreen(),
                          ),
                        ).then((value) {
                          if (value) {
                            setState(() {});
                          }
                        });
                        //PageNavigator.goTo(context, router.rt_AppSettings);
                      },
                    ),
                  ],
                ))
            : Container(),
        isCareGiver ? Divider() : Container(),
        (CommonUtil.isUSRegion() &&
                qurhomeDashboardController.isVitalModuleDisable.value)
            ? Theme(
                data: theme,
                child: ListTile(
                  onTap: () {
                    FlutterToast().getToast(strFeatureNotEnable, Colors.black);
                  },
                  title: Text(variable.strVitalsPreferences,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey)),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: arrowIcon,
                  ),
                ),
              )
            : Theme(
                data: theme,
                child: ExpansionTile(
                  iconColor: Colors.black,
                  backgroundColor: const Color(fhbColors.bgColorContainer),
                  initiallyExpanded: isVitalPreferences,
                  title: Text(variable.strVitalsPreferences,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: title)),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: arrowIcon,
                  ),
                  children: [
                    Theme(
                      data: theme,
                      child: ExpansionTile(
                        leading: ImageIcon(
                          AssetImage(variable.display_devices),
                          size: iconSize,
                        ),
                        iconColor: Colors.black,
                        initiallyExpanded: isDisplayDevices,
                        onExpansionChanged: (value) {
                          isDisplayDevices = value;
                        },
                        title: Text(variable.strDisplayDevices,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: subtitle)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: arrowIcon,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  variable.strAddDevice,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0.sp),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder<List<DeviceData>?>(
                                  future: _deviceModel.getDevices(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      for (int i = 0;
                                          i <= snapshot.data!.length;
                                          i++) {
                                        switch (i) {
                                          case 0:
                                            snapshot.data![i].isSelected =
                                                _isBPActive;
                                            break;
                                          case 1:
                                            snapshot.data![i].isSelected =
                                                _isGLActive;
                                            break;
                                          case 2:
                                            snapshot.data![i].isSelected =
                                                _isOxyActive;
                                            break;
                                          case 3:
                                            snapshot.data![i].isSelected =
                                                _isTHActive;
                                            break;
                                          case 4:
                                            snapshot.data![i].isSelected =
                                                _isWSActive;
                                            break;

                                          default:
                                        }
                                      }
                                    }
                                    return snapshot.hasData
                                        ? Container(
                                            height: CommonUtil().isTablet!
                                                ? 75.h
                                                : 75,
                                            color: Colors.white,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, i) {
                                                return DeviceCard(
                                                    deviceData:
                                                        snapshot.data![i],
                                                    isSelected: (bool? value) {
                                                      isTouched = true;
                                                      switch (i) {
                                                        case 0:
                                                          _isBPActive = value;
                                                          /* PreferenceUtil.saveString(
                                                  Constants.bpMon,
                                                  _isBPActive.toString());*/
                                                          break;
                                                        case 1:
                                                          _isGLActive = value;
                                                          /*PreferenceUtil.saveString(
                                                  Constants.glMon,
                                                  _isGLActive.toString());*/

                                                          break;
                                                        case 2:
                                                          _isOxyActive = value;
                                                          /*PreferenceUtil.saveString(
                                                  Constants.oxyMon,
                                                  _isOxyActive.toString());*/
                                                          break;
                                                        case 3:
                                                          _isTHActive = value;
                                                          /*PreferenceUtil.saveString(
                                                  Constants.thMon,
                                                  _isTHActive.toString());*/
                                                          break;
                                                        case 4:
                                                          _isWSActive = value;
                                                          /*PreferenceUtil.saveString(
                                                  Constants.wsMon,
                                                  _isWSActive.toString());*/
                                                          break;
                                                        default:
                                                      }
                                                      setState(() {
                                                        if (value!) {
                                                          selectedList.add(
                                                              snapshot
                                                                  .data![i]);
                                                        } else {
                                                          selectedList.remove(
                                                              snapshot
                                                                  .data![i]);
                                                        }
                                                      });

                                                      isSkillIntegration =
                                                          false;
                                                      isCareGiverCommunication =
                                                          false;
                                                      isVitalPreferences = true;
                                                      isDisplayDevices = true;
                                                      isDisplayPreference =
                                                          false;
                                                      isAppThemePreference = false;
                                                      isSheelaNotificationPref =
                                                          false;

                                                      createAppColorSelection(
                                                          preColor, greColor);
                                                    },
                                                    key: Key(snapshot
                                                        .data![i].status
                                                        .toString()));
                                              },
                                            ),
                                          )
                                        : CommonCircularIndicator();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: ImageIcon(
                        AssetImage(variable.unit_preference),
                        size: iconSize,
                      ),
                      title: Text(strUnitPreferences,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: subtitle)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: arrowIcon,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChooseUnit(),
                          ),
                        ).then((value) {
                          if (value) {
                            setState(() {});
                          }
                        });
                        //PageNavigator.goTo(context, router.rt_AppSettings);
                      },
                    ),
                  ],
                )),
        Divider(),
        if (!CommonUtil.isUSRegion())
          Theme(
            data: theme,
            child: ExpansionTile(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              iconColor: Colors.black,
              initiallyExpanded: isDisplayPreference,
              title: Text(variable.strDisplayPreferences,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: title)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: arrowIcon,
              ),
              children: [
                ListTile(
                  leading: CommonUtil().qurHomeMainIcon(),
                  title: Text(variable.strQurHome,
                      style: TextStyle(fontSize: subtitle)),
                  subtitle: Text(
                    variable.strDefaultUI,
                    style: TextStyle(fontSize: title3),
                  ),
                  trailing: Transform.scale(
                    scale: switchTrail,
                    child: Switch(
                      value: PreferenceUtil.getIfQurhomeisDefaultUI(),
                      activeColor: mAppThemeProvider.primaryColor,
                      onChanged: (bool newValue) {
                        setState(
                          () {
                            PreferenceUtil.saveQurhomeAsDefaultUI(
                              qurhomeStatus: newValue,
                            );
                            isSkillIntegration = false;
                            isCareGiverCommunication = false;
                            isVitalPreferences = false;
                            isDisplayPreference = true;
                            isSheelaNotificationPref = false;
                            isVoiceCloningChanged =
                                null; // to restrict navigation to terms page
                          },
                        );
                      },
                    ),
                  ),
                ),
                Divider(),
                Theme(
                  data: theme,
                  child: ExpansionTile(
                      iconColor: Colors.black,
                      initiallyExpanded: isColorPallete,
                      onExpansionChanged: (value) {
                        isColorPallete = value;
                        isDisplayPreference = true;
                      },
                      title: Text(variable.strColorPalete,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      children: <Widget>[
                        ListTile(
                            title: Container(
                                height: 60.0.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: variable.myThemes.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                    onTap: () {
                                      context.read<AppThemeProvider>().updatePrimaryColor(variable.myThemes[index]);
                                      context.read<AppThemeProvider>().updateGradientColor(variable.myGradient[index]);
                                      preColor = variable.myThemes[index];
                                      greColor=variable.myGradient[index];
                                      createAppColorSelection(
                                          variable.myThemes[index],
                                          variable.myGradient[index]);
                                      if (widget.refresh != null) {
                                        widget.refresh!(false);
                                      }
                                    },
                                    child: Padding(
                                        padding:  EdgeInsets.all(5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(colors: [
                                                Color(variable.myThemes[index]),
                                                Color(
                                                    variable.myGradient[index])
                                              ])),
                                          height: 50.0.h,
                                          width: 50.0.h,
                                          child:mAppThemeProvider.primaryColor.value.isEqual(variable.myThemes[index])
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 24.0.sp,
                                                )
                                              : SizedBox(),
                                        )),
                                  );
                                  },
                                ))),
                      ]),
                ),
              ],
            ),
          ),
        if (!CommonUtil.isUSRegion()) const Divider(),
        Consumer<AppThemeProvider>(
          builder: (
            context,
            AppThemeProvider themeNotifier,
            child,
          ) =>
              Theme(
            data: theme,
            child: ExpansionTile(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              iconColor: Colors.black,
              initiallyExpanded: isAppThemePreference,
              onExpansionChanged: (value) {
                isAppThemePreference = value;
              },
              title: Text(variable.strAppThemes,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: title)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: arrowIcon,
              ),
              children: EnumAppThemeType.values
                  .map(
                    (themeType) => RadioListTile(
                      value: themeType,
                      groupValue: themeNotifier.currentEnumAppThemeType,
                      activeColor: mAppThemeProvider.primaryColor,
                      title: Text(
                        themeType.toShortString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                      onChanged: (value) {
                        setState(() {
                          isSkillIntegration = false;
                          isCareGiverCommunication = false;
                          isVitalPreferences = false;
                          isDisplayPreference = false;
                          isSheelaNotificationPref = false;
                          isAppThemePreference = true;
                          isTouched = true;
                          isVoiceCloningChanged = null;

                          themeNotifier.appThemeType =
                              value ?? EnumAppThemeType.Classic;
                          PreferenceUtil.saveCurrentAppTheme(
                            themeNotifier.currentEnumAppThemeType
                                .toShortString(),
                          );
                          createAppColorSelection(
                            preColor,
                            greColor,
                          );
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const Divider(),
        (CommonUtil.isUSRegion() &&
                qurhomeDashboardController.isVitalModuleDisable.value)
            ? Theme(
                data: theme,
                child: ListTile(
                  onTap: () {
                    FlutterToast().getToast(strFeatureNotEnable, Colors.black);
                  },
                  title: Text(variable.strConnectedDevices,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: CommonUtil().isTablet!
                              ? Constants.tabHeader1
                              : mobileHeader1)),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: arrowIcon,
                  ),
                ),
              )
            : Theme(
                data: theme,
                child: ListTile(
                  onTap: () {
                    try {
                      //Get.back();
                      Get.to(
                        () => HubListView(),
                        binding: BindingsBuilder(
                          () {
                            if (!Get.isRegistered<HubListViewController>()) {
                              Get.lazyPut(
                                () => HubListViewController(),
                              );
                            }
                          },
                        ),
                      );
                    } catch (e, stackTrace) {
                      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
                    }
                  },
                  title: Text(variable.strConnectedDevices,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: CommonUtil().isTablet!
                              ? Constants.tabHeader1
                              : mobileHeader1)),
                ),
              ),
        Divider(),
        // this widget is for sheela live reminder toggle on off widget added
        Theme(
          data: theme,
          child: ExpansionTile(
            backgroundColor: const Color(fhbColors.bgColorContainer),
            iconColor: Colors.black,
            initiallyExpanded: isSheelaNotificationPref,
            title: Text(variable.strSheelaNotificationPref,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: CommonUtil().isTablet!
                        ? Constants.tabHeader1
                        : mobileHeader1)),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: arrowIcon,
            ),
            children: [
              ListTile(
                leading: Image.asset(
                  icon_mayaMain,
                  height: 40.h,
                  width: 40.w,
                ),
                title: Text(variable.strSheelaLiveReminders,
                    style: TextStyle(fontSize: subtitle)),
                /*subtitle: Text(
                  variable.strDefaultUI,
                  style: TextStyle(fontSize: 12.0.sp),
                ),*/
                trailing: Transform.scale(
                  scale: switchTrail,
                  child: Switch(
                    value: _isSheelaLiveReminders ?? false,
                    activeColor: mAppThemeProvider.primaryColor,
                    onChanged: (bool newValue) {
                      _isSheelaLiveReminders = newValue;
                      isSkillIntegration = false;
                      isCareGiverCommunication = false;
                      isVitalPreferences = false;
                      isDisplayPreference = false;
                      isSheelaNotificationPref = true;
                      isVoiceCloningChanged =
                          null; // to restrict navigation to terms page

                      createAppColorSelection(preColor, greColor).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Theme(
            data: theme,
            child: ExpansionTile(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              iconColor: Colors.black,
              initiallyExpanded: isPrivacyAndSecurity,
              onExpansionChanged: (value) {
                isPrivacyAndSecurity = value;
              },
              title: Text(variable.strPrivacyAndSecurity,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: CommonUtil().isTablet!
                          ? Constants.tabHeader1
                          : mobileHeader1)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: arrowIcon,
              ),
              children: [
                ListTile(
                    leading: ImageIcon(
                      AssetImage(variable.icon_lock),
                      size: iconSize,
                      color: Colors.black,
                    ),
                    title: Text(variable.strAllowBiometric,
                        style: TextStyle(fontSize: subtitle)),
                    subtitle: Text(
                      variable.strEnableApplock,
                      style: TextStyle(fontSize: title3),
                    ),
                    trailing: Transform.scale(
                      scale: switchTrail,
                      child: Switch(
                        value: PreferenceUtil.getEnableAppLock(),
                        activeColor: mAppThemeProvider.primaryColor,
                        onChanged: (bool newValue) async {
                          if (newValue) {
                            String msg = 'You are not authorized.';
                            try {
                              var value = await CommonUtil().checkAppLock();

                              setState(() {
                                PreferenceUtil.saveEnableAppLock(
                                  appLockStatus: value,
                                );
                              });
                            } on PlatformException catch (e, stackTrace) {
                              msg = "Error while opening pattern/pin/passcode";
                              if (kDebugMode) {
                                printError(info: msg.toString());
                                printError(info: e.toString());
                                if (e.code == auth_error.notAvailable) {
                                  // Add handling of no hardware here.
                                } else if (e.code == auth_error.notEnrolled) {}
                              }
                            }
                          } else {
                            setState(() {
                              PreferenceUtil.saveEnableAppLock(
                                appLockStatus: false,
                              );
                            });
                          }
                        },
                      ),
                    )),
              ],
            )),
        Divider(),
        // User account
        Theme(
            data: theme,
            child: ExpansionTile(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              iconColor: Colors.black,
              initiallyExpanded: isDeleteAccount,
              onExpansionChanged: (value) {
                isDeleteAccount = value;
              },
              title: Text(variable.strUserAccount,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: CommonUtil().isTablet!
                          ? Constants.tabHeader1
                          : mobileHeader1)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: arrowIcon,
              ),
              children: [
                InkWell(
                  onTap: () {
                    Get.to(DeleteAccountWebScreen());
                  },
                  child: ListTile(
                    leading: ImageIcon(
                      AssetImage(variable.remove_user),
                      size: iconSize,
                      color: Colors.black,
                    ),
                    title: Text(variable.strDeleteAccountTitle,
                        style: TextStyle(fontSize: subtitle)),
                  ),
                )
              ],
            )),
        Divider(),
        Center(
            child: Text(
          version != null ? 'v' + version : '',
          style: TextStyle(color: Colors.grey),
        )),
      ],
    );
  }

  Future<bool?> _handleGoogleFit() async {
    bool? ret = false;
    bool _isSignedIn = await _deviceDataHelper.isGoogleFitSignedIn();
    if (_isGFActive == _isSignedIn) {
      ret = _isGFActive;
    } else {
      if (_isGFActive!) {
        _isGFActive = await _deviceDataHelper.activateGoogleFit();
      } else {
        _isGFActive = !await _deviceDataHelper.deactivateGoogleFit();
      }
    }
    PreferenceUtil.saveString(Constants.activateGF, _isGFActive.toString());
    return ret;
  }

  Future _confirmDeletion() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(strDeleteAccountDes),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                PreferenceUtil.saveEnableDeleteAccount(
                  deleteAccountStatus: false,
                );
              });
            },
            child: Text(strNo),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _retrieveData();
            },
            child: Text(strYes),
          ),
        ],
      ),
    );
  }

  Future _retrieveData() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(strNotRetrieveDataDes),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                PreferenceUtil.saveEnableDeleteAccount(
                  deleteAccountStatus: false,
                );
              });
            },
            child: Text(strCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              _sendOtpDetails();
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OTPRemoveAccount(
                            PhoneNumber:
                                (myProfile!.result!.userContactCollection3 !=
                                            null &&
                                        myProfile!.result!
                                            .userContactCollection3!.isNotEmpty)
                                    ? myProfile!
                                            .result!
                                            .userContactCollection3![0]!
                                            .phoneNumber ??
                                        ''
                                    : '',
                            from: strFromLogin,
                            userConfirm: false,
                            // dataForResendOtp: dataForResendOtp,
                            forFamilyMember: false,
                            // isVirtualNumber: isVirtualNumber,
                          )));
              // Reset the toggle
              setState(() {
                PreferenceUtil.saveEnableDeleteAccount(
                  deleteAccountStatus: false,
                );
              });
            },
            child: Text(strConfirm),
          ),
        ],
      ),
    );
  }

/**
 * Set a commonmethod to navigate to eithe terms screen or status
 */
  void navigateToTermsOrStatusScreen() {
    if (superAdminAllowedVoiceCloningModule &&
        providerAllowedVoiceCloningModule) {
      if (voiceCloningStatus == strInActive && voiceCloning) {
        Navigator.pushNamed(
          context,
          router.rt_VoiceCloneTerms,
        ).then((value) {
          setState(() {});
        });
      } else if (voiceCloningStatus != strApproved && voiceCloning) {
        Navigator.pushNamed(context, router.rt_VoiceCloningStatus,
                arguments: VoiceCloneStatusArguments(fromMenu: true))
            .then((value) {
          setState(() {});
        });
      } else if (voiceCloningStatus == strApproved && voiceCloning) {
        Navigator.pushNamed(context, router.rt_VoiceCloningStatus,
                arguments: VoiceCloneStatusArguments(fromMenu: true))
            .then((value) {
          setState(() {});
        });
      }
    }
  }

/** 
 * Created this method to decrease the time for navigation from menu 
 * screen on click of toggle button
 */
  void setVoiceCloneValue(GetDeviceSelectionModel getDeviceSelectionModel) {
    //status of the voice cloning toggle button
    voiceCloning =
        getDeviceSelectionModel.result![0].profileSetting!.voiceCloning ??
            false;
    useClonedVoice = getDeviceSelectionModel.result![0].profileSetting!.useClonedVoice ??
        false;
    isVoiceAssigned = getDeviceSelectionModel.result![0].profileSetting!.voiceCloneAssigned ?? false;
    //set the bool value when provider has allowed the permssion
    providerAllowedVoiceCloningModule = getDeviceSelectionModel
            .result![0]
            .primaryProvider
            ?.additionalInfo
            ?.providerAllowedVoiceCloningModule ??
        false;

    //set the bool value when super admin has allowed the permssion
    superAdminAllowedVoiceCloningModule = getDeviceSelectionModel
            .result![0]
            .primaryProvider
            ?.additionalInfo
            ?.superAdminAllowedVoiceCloningModule ??
        false;

    var statusValue =
        getDeviceSelectionModel.result![0].profileSetting!.voiceCloningStatus ??
            '';

    //value of the voice cloning status
    voiceCloningStatus = superAdminAllowedVoiceCloningModule
        ? providerAllowedVoiceCloningModule
            ? ((statusValue != "" && statusValue != null)
                ? statusValue
                : strInActive)
            : strInActive
        : strInActive;

    //Conditon when to show the voice clonng UI
    showVoiceCloningUI = superAdminAllowedVoiceCloningModule
        ? providerAllowedVoiceCloningModule
            ? true
            : false
        : false;
  }

  void handleVoiceCloneSwitch(bool isEnabled) {
    if (isEnabled == false) {
      _confirmVoiceCloneDisable(isEnabled);
    } else {
      handleVoiceCloneSwitchAction(isEnabled);
    }
  }

  Future<void> handleUseClonedVoiceSwitch(bool isEnabled) async {
    if(!isVoiceAssigned && !useClonedVoice){
      toast.getToast(variable.strVoiceCloneNotSetByYourCaregiver, Colors.red);
    }else{
      useClonedVoice = isEnabled;
      await updateDeviceSelectionModel(preColor, greColor);
      setState(() {
      });
    }
  }

  Future<void> handleVoiceCloneSwitchAction(bool isEnabled) async {
    if (superAdminAllowedVoiceCloningModule &&
        providerAllowedVoiceCloningModule) {
      setState(() {
        isSkillIntegration = true;
        isCareGiverCommunication = false;
        isVitalPreferences = false;
        isDisplayPreference = false;
        isSheelaNotificationPref = false;
        isTouched = true;
        isVoiceCloningChanged = true;
        voiceCloning = isEnabled;
      });
      await createAppColorSelection(
        preColor,
        greColor,
      );
      //to set toggle button value when app opened for the first tym
      setState(() {});
      //get the values of status to initiate navigation
      await getAppColorValues(forNavigation: true);
      if (isVoiceCloningChanged ?? false) {
        navigateToTermsOrStatusScreen();
      }
    }
  }

  Future _confirmVoiceCloneDisable(bool isEnabled) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text(
              strConfirmation,
              style: TextStyle(
                color: mAppThemeProvider.primaryColor,
                fontSize: 18.0.sp,
              ),
            ),
          ),
          content: Text(
            strConfirmationVoiceCloneDisable,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => closeDialog(),
              child: const Text(
                strCancel,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: tabHeader4,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                closeDialog();
                await handleVoiceCloneSwitchAction(isEnabled);
              },
              child: Text(
                strConfirm,
                style: TextStyle(
                  color: mAppThemeProvider.primaryColor,
                  fontSize: tabHeader4,
                ),
              ),
            )
          ],
        ),
      );

  ///Only for family members
  Widget _useClonedVoiceWidget(){
   return  Visibility(
     visible:CommonUtil.isUSRegion(),
       child: Column(
         children: [
           Divider(),
           ListTile(
              leading: ImageIcon(
                AssetImage(variable.icon_voice_cloning),
                size: iconSize,
                color: Colors.black,
              ),
              title: Text(variable.strUseClonedVoice,
                  style: TextStyle(
                      fontSize: subtitle,)),
              subtitle: Text(
                variable.strUseClonedVoiceDesc,
                maxLines: 2,
                style: TextStyle(
                    fontSize: title4, color: Colors.grey),
              ),
              trailing: Transform.scale(
                scale: switchTrail,
                child: Switch(
                  value: useClonedVoice,
                  activeColor:mAppThemeProvider.primaryColor,
                  onChanged: handleUseClonedVoiceSwitch,
                ),
              ),),
         ],
       ),
     );
  }
  void closeDialog() => Navigator.of(
        context,
      ).pop();
}
