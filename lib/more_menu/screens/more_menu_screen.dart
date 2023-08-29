import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/QurHub/Controller/HubListViewController.dart';
import 'package:myfhb/QurHub/View/HubListView.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/view/otp_remove_account_screen.dart';
import 'package:myfhb/authentication/view_model/patientauth_view_model.dart';
import 'package:myfhb/common/DeleteAccountWebScreen.dart';
import 'package:myfhb/common/DexComWebScreen.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/device_integration/view/screens/Device_Card.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/more_menu/screens/touble_shooting.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/user/Tags.dart';
import 'package:myfhb/src/ui/settings/AppleHealthSettings.dart';
import 'package:myfhb/src/ui/settings/CaregiverSettng.dart';
import 'package:myfhb/src/ui/settings/NonAdheranceSettingsScreen.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/unit/choose_unit.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../device_integration/viewModel/Device_model.dart';
import '../../landing/view/landing_screen.dart';
import '../../myfhb_weview/myfhb_webview.dart';
import '../../src/model/CreateDeviceSelectionModel.dart';
import '../../src/model/GetDeviceSelectionModel.dart';
import '../../src/model/UpdatedDeviceModel.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/model/user/user_accounts_arguments.dart';
import '../../src/resources/repository/health/HealthReportListForUserRepository.dart';
import '../../src/ui/HomeScreen.dart';
import '../../src/ui/settings/MySettings.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import 'package:myfhb/device_integration/viewModel/deviceDataHelper.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:local_auth/error_codes.dart' as auth_error;

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

  String selectedMaya = PreferenceUtil.getStringValue(Constants.keyMayaAsset) ??
      variable.icon_mayaMain;

  /*int selectedPrimaryColor =
      PreferenceUtil.getSavedTheme(Constants.keyPriColor) != null
          ? PreferenceUtil.getSavedTheme(Constants.keyPriColor)
          : 0xff5e1fe0;*/
  int? selectedPrimaryColor = 0xff5f0cf9;

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
  bool isIntegration = false;
  bool isColorPallete = false;
  bool loading = false;
  PreferredMeasurement? preferredMeasurement;

  var qurhomeDashboardController =
      CommonUtil().onInitQurhomeDashboardController();

  @override
  void initState() {
    qurhomeDashboardController.getModuleAccess();
    mInitialTime = DateTime.now();
    //getProfileImage();
    //getAppColorValues();
    if (CommonUtil.REGION_CODE == 'US') {
      getAvailableDevices();
    }
    PackageInfo.fromPlatform().then((packageInfo) {
      version = packageInfo.version + " + " + packageInfo.buildNumber;
    });
    selectedList = [];
    _deviceModel = new DevicesViewModel();
    authViewModel = AuthViewModel();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Moremenu Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
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
              //       new FHBBasicWidget().exitApp(context, () {
              //         new CommonUtil().logout(moveToLoginPage);
              //       });
              //     })
            ]),
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
              size: 16.0.sp,
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
            size: 16.0.sp,
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
                          fontWeight: FontWeight.w500, color: Colors.black)),
                  children: [
                    ListTile(
                      title: Text(variable.strCareGiverSettings,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0.sp,
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
                        size: 16.0.sp,
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
                              PreferenceUtil.saveTheme(Constants.keyPriColor,
                                  variable.myThemes[index]);
                              PreferenceUtil.saveTheme(Constants.keyGreyColor,
                                  variable.myGradient[index]);
                              selectedPrimaryColor = variable.myThemes[index];

                              createAppColorSelection(variable.myThemes[index],
                                  variable.myGradient[index]);

                              HomeScreen.of(context)?.refresh();
                              LandingScreen.of(context)?.refresh();
                              if (widget.refresh != null) {
                                widget.refresh!(false);
                              }

                              setState(() {});
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
                                  child: variable.myThemes[index] ==
                                          selectedPrimaryColor
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
          style: TextStyle(color: Colors.grey),
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
                style: TextStyle(fontWeight: FontWeight.w500)),
            trailing: Text(
              (element.isPaired! ? 'Un Pair' : 'Pair'),
              style: TextStyle(
                  color: element.isPaired! ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold),
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

  Future<GetDeviceSelectionModel?> getAppColorValues() async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    await healthReportListForUserRepository
        .getDeviceSelection(userIdFromBloc: userId)
        .then((value) {
      selectionResult = value;
      if (selectionResult!.isSuccess!) {
        if (selectionResult!.result != null) {
          setValues(selectionResult!);
          userMappingId = selectionResult!.result![0].id;
        } else {
          userMappingId = '';
          preColor = 0xff5e1fe0;
          greColor = 0xff753aec;
          _isdeviceRecognition = true;
          _isHKActive = false;
          _firstTym = true;
          _isBPActive = true;
          _isGLActive = true;
          _isOxyActive = true;
          _isTHActive = true;
          _isWSActive = true;
          _isHealthFirstTime = false;

          selectedPrimaryColor = 0xff5f0cf9;
          allowAppointmentNotification = true;
          allowSymptomsNotification = true;
          allowVitalNotification = true;
        }
      } else {
        userMappingId = '';
        preColor = 0xff5e1fe0;
        greColor = 0xff753aec;

        selectedPrimaryColor = 0xff5f0cf9;
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

    selectedPrimaryColor =
        PreferenceUtil.getSavedTheme(Constants.keyPriColor) ?? preColor;

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
  }

  Future<CreateDeviceSelectionModel?> createAppColorSelection(
      int? priColor, int? greColor) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    await healthReportListForUserRepository
        .createDeviceSelection(
            _isdigitRecognition,
            _isdeviceRecognition,
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
            allowSymptomsNotification)
        .then((value) {
      createDeviceSelectionModel = value;
      if (createDeviceSelectionModel!.isSuccess!) {
      } else {
        if (createDeviceSelectionModel!.message ==
            STR_USER_PROFILE_SETTING_ALREADY) {
          updateDeviceSelectionModel(priColor, greColor);
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
            preferredMeasurement)
        .then((value) {
      updateDeviceModel = value;
      if (updateDeviceModel!.isSuccess!) {
        // app color updated
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
              size: 16.0.sp,
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
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: [
                ListTile(
                    leading: ImageIcon(
                      AssetImage(variable.icon_digit_reco),
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text(variable.strAllowDigit),
                    subtitle: Text(
                      variable.strScanDevices,
                      style: TextStyle(fontSize: 12.0.sp),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _isdigitRecognition!,
                        activeColor:
                            Color(new CommonUtil().getMyPrimaryColor()),
                        onChanged: (bool newValue) {
                          setState(() {
                            isSkillIntegration = true;
                            isCareGiverCommunication = false;
                            isVitalPreferences = false;
                            isDisplayPreference = false;
                            isTouched = true;

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
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text(variable.strAllowDevice),
                    subtitle: Text(
                      variable.strScanAuto,
                      style: TextStyle(fontSize: 12.0.sp),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _isdeviceRecognition!,
                        activeColor:
                            Color(new CommonUtil().getMyPrimaryColor()),
                        onChanged: (bool newValue) {
                          setState(() {
                            isSkillIntegration = true;
                            isCareGiverCommunication = false;
                            isVitalPreferences = false;
                            isDisplayPreference = false;
                            isTouched = true;
                            _isdeviceRecognition = newValue;
                            createAppColorSelection(preColor, greColor);
                            /*PreferenceUtil.saveString(
                                        Constants.allowDeviceRecognition,
                                        _isdeviceRecognition.toString());*/
                          });
                        },
                      ),
                    )),
                Divider(),
                Theme(
                    data: theme,
                    child: ExpansionTile(
                      iconColor: Colors.black,
                      initiallyExpanded: isIntegration,
                      onExpansionChanged: (value) {
                        isIntegration = value;
                      },
                      title: Text(variable.strIntegration,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0.sp,
                      ),
                      children: [
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
                                        //size: 30,
                                        color: Colors.black,
                                      ),
                                      title: Text(variable.strGoogleFit),
                                      subtitle: Text(
                                        variable.strAllowGoogle,
                                        style: TextStyle(fontSize: 12.0.sp),
                                      ),
                                      trailing: Wrap(
                                        children: <Widget>[
                                          Transform.scale(
                                            scale: 0.8,
                                            child: IconButton(
                                              icon: Icon(Icons.sync),
                                              onPressed: () {
                                                _deviceDataHelper
                                                    .syncGoogleFit();
                                              },
                                            ),
                                          ),
                                          Transform.scale(
                                            scale: 0.8,
                                            child: Switch(
                                              value: _isGFActive!,
                                              activeColor: Color(
                                                  new CommonUtil()
                                                      .getMyPrimaryColor()),
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
                        (Platform.isIOS)
                            ? ListTile(
                                leading: Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                ),
                                title: Text(variable.strHealthKit),
                                subtitle: Text(
                                  variable.strAllowHealth,
                                  style: TextStyle(fontSize: 12.0.sp),
                                ),
                                trailing: Wrap(
                                  children: <Widget>[
                                    Transform.scale(
                                      scale: 0.8,
                                      child: IconButton(
                                        icon: Icon(Icons.sync),
                                        onPressed: () {
                                          _deviceDataHelper.syncHealthKit();
                                        },
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Switch(
                                        value: _isHKActive!,
                                        activeColor: Color(new CommonUtil()
                                            .getMyPrimaryColor()),
                                        onChanged: (bool newValue) {
                                          isTouched = true;
                                          if (_isHealthFirstTime) {
                                            _isHealthFirstTime = false;
                                            PreferenceUtil.saveString(
                                                Constants.isHealthFirstTime,
                                                _isHealthFirstTime.toString());

                                            newValue == true
                                                ? _deviceDataHelper
                                                    .activateHealthKit()
                                                : _deviceDataHelper
                                                    .deactivateHealthKit();
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HealthApp()),
                                            );
                                          }
                                          setState(() {
                                            _isHKActive = newValue;
                                            isIntegration = true;

                                            /*PreferenceUtil.saveString(
                                                Constants.activateHK,
                                                _isHKActive.toString());*/
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ))
                            : SizedBox.shrink(),
                        Container(
                          height: 1,
                          color: Colors.grey[200],
                        ),
                      ],
                    )),
              ],
            )),
        Divider(),
        isCareGiver
            ? Theme(
                data: theme,
                child: ExpansionTile(
                  backgroundColor: const Color(fhbColors.bgColorContainer),
                  iconColor: Colors.black,
                  title: Text(variable.strCareGiverCommunication,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black)),
                  children: [
                    ListTile(
                      leading: ImageIcon(
                        AssetImage(variable.notification_preference),
                        //size: 30,
                      ),
                      title: Text(variable.strNotificationPreference,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0.sp,
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
                        //size: 30,
                      ),
                      title: Text(variable.strNonAdherenceSettings,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0.sp,
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
                          fontWeight: FontWeight.w500, color: Colors.black)),
                  children: [
                    Theme(
                      data: theme,
                      child: ExpansionTile(
                        leading: ImageIcon(
                          AssetImage(variable.display_devices),
                          //size: 30,
                        ),
                        iconColor: Colors.black,
                        initiallyExpanded: isDisplayDevices,
                        onExpansionChanged: (value) {
                          isDisplayDevices = value;
                        },
                        title: Text(variable.strDisplayDevices,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16.0.sp,
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
                        //size: 30,
                      ),
                      title: Text(strUnitPreferences,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0.sp,
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
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: [
                ListTile(
                  leading: CommonUtil().qurHomeMainIcon(),
                  title: Text(variable.strQurHome),
                  subtitle: Text(
                    variable.strDefaultUI,
                    style: TextStyle(fontSize: 12.0.sp),
                  ),
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: PreferenceUtil.getIfQurhomeisDefaultUI(),
                      activeColor: Color(new CommonUtil().getMyPrimaryColor()),
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
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      PreferenceUtil.saveTheme(
                                          Constants.keyPriColor,
                                          variable.myThemes[index]);
                                      PreferenceUtil.saveTheme(
                                          Constants.keyGreyColor,
                                          variable.myGradient[index]);
                                      selectedPrimaryColor =
                                          variable.myThemes[index];

                                      createAppColorSelection(
                                          variable.myThemes[index],
                                          variable.myGradient[index]);

                                      HomeScreen.of(context)?.refresh();
                                      LandingScreen.of(context)?.refresh();
                                      if (widget.refresh != null) {
                                        widget.refresh!(false);
                                      }

                                      setState(() {});
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
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
                                          child: variable.myThemes[index] ==
                                                  selectedPrimaryColor
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
              ],
            ),
          ),
        if (!CommonUtil.isUSRegion()) Divider(),
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
                          fontWeight: FontWeight.w500, color: Colors.grey)),
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
                          fontWeight: FontWeight.w500, color: Colors.black)),
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
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: [
                ListTile(
                    leading: ImageIcon(
                      AssetImage(variable.icon_lock),
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text(variable.strAllowBiometric),
                    subtitle: Text(
                      variable.strEnableApplock,
                      style: TextStyle(fontSize: 12.0.sp),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: PreferenceUtil.getEnableAppLock(),
                        activeColor:
                            Color(new CommonUtil().getMyPrimaryColor()),
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
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: [
                InkWell(
                  onTap: () {
                    Get.to(DeleteAccountWebScreen());
                  },
                  child: ListTile(
                    leading: ImageIcon(
                      AssetImage(variable.remove_user),
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text(variable.strDeleteAccountTitle),
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
        Expanded(
            child: Container(
          height: 50,
        )),

        Center(
            child: GestureDetector(
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
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(CommonUtil().getMyPrimaryColor()),
            ),
            child: Center(
              child: Text('TroubleShooting',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0.sp,
                    color: ColorUtils.white,
                  )),
            ),
          ),
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
}
