import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/user/Tags.dart';
import 'package:myfhb/src/ui/settings/CaregiverSettng.dart';
import 'package:myfhb/src/ui/settings/NonAdheranceSettingsScreen.dart';
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

class MoreMenuScreen extends StatefulWidget {
  final Function(bool userChanged) refresh;

  const MoreMenuScreen({this.refresh});

  @override
  _MoreMenuScreenState createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends State<MoreMenuScreen> {
  MyProfileModel myProfile;
  File profileImage;

  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();
  GetDeviceSelectionModel selectionResult;
  CreateDeviceSelectionModel createDeviceSelectionModel;
  UpdateDeviceModel updateDeviceModel;

  int preColor = 0xff5e1fe0;
  int greColor = 0xff753aec;
  var userMappingId = '';

  bool _isdigitRecognition = true;
  bool _isdeviceRecognition = true;
  bool _isGFActive;
  DevicesViewModel _deviceModel;
  bool _isHKActive = false;
  bool _firstTym = true;
  bool _isBPActive = true;
  bool _isGLActive = true;
  bool _isOxyActive = true;
  bool _isTHActive = true;
  bool _isWSActive = true;
  bool _isHealthFirstTime = false;
  String preferred_language;
  String qa_subscription;

  String selectedMaya = PreferenceUtil.getStringValue(Constants.keyMayaAsset) ??
      variable.icon_mayaMain;

  /*int selectedPrimaryColor =
      PreferenceUtil.getSavedTheme(Constants.keyPriColor) != null
          ? PreferenceUtil.getSavedTheme(Constants.keyPriColor)
          : 0xff5e1fe0;*/
  int selectedPrimaryColor = 0xff5f0cf9;

  int selectedGradientColor =
      PreferenceUtil.getSavedTheme(Constants.keyGreyColor) ?? 0xff753aec;

  String version = '';
  List<Tags> tagsList =
  new List<Tags>();

  bool allowAppointmentNotification=true;
  bool allowVitalNotification=true;
  bool allowSymptomsNotification=true;
  bool isCareGiver=false;


  @override
  void initState() {
    mInitialTime = DateTime.now();
    //getProfileImage();
    //getAppColorValues();
    PackageInfo.fromPlatform().then((packageInfo) {
      version = packageInfo.version;
    });
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

    if (myProfile.result != null) {}
  }

  Future<MyProfileModel> getMyProfile() async {
    if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) != null) {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    } else {
      myProfile = await CommonUtil().getMyProfile();
    }
    return myProfile;
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
                Navigator.pop(context);
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
                  ? Image.file(profileImage,
                      width: 50.0.h, height: 50.0.h, fit: BoxFit.cover)
                  : FHBBasicWidget().getProfilePicWidgeUsingUrl(myProfile),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  myProfile.result != null
                      ? /* toBeginningOfSentenceCase(
                              myProfile.result.firstName ?? '') +
                          ' ' +
                          toBeginningOfSentenceCase(
                              myProfile.result.lastName ?? '') */
                      myProfile?.result?.firstName?.capitalizeFirstofEach ??
                          '' ' ' +
                              myProfile
                                  ?.result?.lastName?.capitalizeFirstofEach ??
                          ''
                      : '',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  (myProfile.result.userContactCollection3 != null &&
                          myProfile.result.userContactCollection3.isNotEmpty)
                      ? myProfile
                              .result.userContactCollection3[0].phoneNumber ??
                          ''
                      : '',
                  style: TextStyle(fontSize: 14.0.sp),
                ),
                Text(
                  (myProfile.result.userContactCollection3 != null &&
                          myProfile.result.userContactCollection3.isNotEmpty)
                      ? myProfile.result.userContactCollection3[0].email ?? ''
                      : '',
                  style: TextStyle(fontSize: 13.0.sp),
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
        isCareGiver?Divider():Container(),
        isCareGiver? Column(
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
                    builder: (context) =>
                        CareGiverSettings(),
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
                    builder: (context) =>
                        NonAdheranceSettingsScreen(),
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
        ):Container(),
        /*Divider(),
        Theme(
          data: theme,
          child: ExpansionTile(
            title: Text(variable.strHelp,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black)),
            children: <Widget>[
              InkWell(
                onTap: () {
                  openWebView(Constants.FAQ, variable.file_faq, true);
                },
                child: ListTile(
                    title: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_faq),
                      color: Colors.black,
                    ),
                    SizedBox(width: 20.0.w),
                    Text(Constants.FAQ),
                  ],
                )),
              ),
              ListTile(
                title: InkWell(
                    child: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_feedback),
                      color: Colors.black,
                    ),
                    SizedBox(width: 20.0.w),
                    Text(variable.strFeedBack),
                  ],
                )),
                onTap: () {
                  Navigator.pushNamed(context, router.rt_Feedbacks)
                      .then((value) {});
                },
              ),
              InkWell(
                onTap: () {
                  openWebView(
                      Constants.terms_of_service, variable.file_terms, true);
                },
                child: ListTile(
                    title: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_term),
                      size: 20.0.sp,
                      //size: 30,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20.0.w),
                    Text(Constants.terms_of_service)
                  ],
                )),
              ),
              InkWell(
                onTap: () {
                  openWebView(
                      Constants.privacy_policy, variable.file_privacy, true);
                },
                child: ListTile(
                    title: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_privacy),
                      size: 20.0.sp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20.0.w),
                    Text(variable.strPrivacy),
                  ],
                )),
              ),
              InkWell(
                onTap: () {
                  LaunchReview.launch(
                      androidAppId: variable.strAppPackage,
                      iOSAppId: variable.iOSAppId);
                },
                child: ListTile(
                    title: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_record_fav),
                      size: 20.0.sp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20.0.w),
                    Text(variable.strRateus),
                  ],
                )),
              ),
              InkWell(
                onTap: () {
                  launchWhatsApp(
                      phone: variable.c_qurhealth_helpline,
                      message: variable.c_chat_with_whatsapp_begin_conv);
                },
                child: ListTile(
                    title: Row(
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_whatsapp),
                      color: Color(0XFF66AB5B),
                      size: 22.0.sp,
                    ),
                    SizedBox(width: 20.0.sp),
                    Text(variable.chatWithUs),
                  ],
                )),
              )
            ],
          ),
        ),*/
        /* Divider(),
        Theme(
          data: theme,
          child: ExpansionTile(
              title: Text(variable.strMaya,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: <Widget>[
                ListTile(
                    title: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  height: 80,
                  //width: 200,
                  //color: Colors.green,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: variable.mayaAssets.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        PreferenceUtil.saveString(
                            Constants.keyMayaAsset, variable.mayaAssets[index]);
                        selectedMaya = variable.mayaAssets[index];
                        HomeScreen.of(context).refresh();
                        setState(() {});
                      },
                      child: Card(
                        color: variable.mayaAssets[index] == selectedMaya
                            ? Color(new CommonUtil().getMyPrimaryColor())
                            : Colors.white,
                        margin: EdgeInsets.all(2),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Image.asset(
                            variable.mayaAssets[index] + variable.strExtImg,
                            height: 50,
                            width: 50,
                          ),
                        ),
                        elevation: 1,
                        shape: CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                      ),
                    ),
                  ),
                ))
              ]),
        ), */
        Divider(),
        Theme(
          data: theme,
          child: ExpansionTile(
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
                                widget.refresh(false);
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

  Future<GetDeviceSelectionModel> getAppColorValues() async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    await healthReportListForUserRepository.getDeviceSelection(userIdFromBloc: userId).then((value) {
      selectionResult = value;
      if (selectionResult.isSuccess) {
        if (selectionResult.result != null) {
          setValues(selectionResult);
          userMappingId = selectionResult.result[0].id;
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
          allowAppointmentNotification=true;
          allowSymptomsNotification=true;
          allowVitalNotification=true;

        }
      } else {
        userMappingId = '';
        preColor = 0xff5e1fe0;
        greColor = 0xff753aec;

        selectedPrimaryColor = 0xff5f0cf9;
        allowAppointmentNotification=true;
        allowSymptomsNotification=true;
        allowVitalNotification=true;
      }
    });
    return selectionResult;
  }

  setValues(GetDeviceSelectionModel getDeviceSelectionModel) {
    preColor = getDeviceSelectionModel.result[0].profileSetting.preColor;
    greColor = getDeviceSelectionModel.result[0].profileSetting.greColor;

    _isdeviceRecognition =
        getDeviceSelectionModel.result[0].profileSetting.allowDevice != null &&
                getDeviceSelectionModel.result[0].profileSetting.allowDevice !=
                    ''
            ? getDeviceSelectionModel.result[0].profileSetting.allowDevice
            : true;
    _isdigitRecognition =
        getDeviceSelectionModel.result[0].profileSetting.allowDigit != null &&
                getDeviceSelectionModel.result[0].profileSetting.allowDigit !=
                    ''
            ? getDeviceSelectionModel.result[0].profileSetting.allowDigit
            : true;
    _isGFActive =
        getDeviceSelectionModel.result[0].profileSetting.googleFit != null &&
                getDeviceSelectionModel.result[0].profileSetting.googleFit != ''
            ? getDeviceSelectionModel.result[0].profileSetting.googleFit
            : false;
    _isHKActive =
        getDeviceSelectionModel.result[0].profileSetting.healthFit != null &&
                getDeviceSelectionModel.result[0].profileSetting.healthFit != ''
            ? getDeviceSelectionModel.result[0].profileSetting.healthFit
            : false;
    _isBPActive =
        getDeviceSelectionModel.result[0].profileSetting.bpMonitor != null &&
                getDeviceSelectionModel.result[0].profileSetting.bpMonitor != ''
            ? getDeviceSelectionModel.result[0].profileSetting.bpMonitor
            : true;
    _isGLActive = getDeviceSelectionModel.result[0].profileSetting.glucoMeter !=
                null &&
            getDeviceSelectionModel.result[0].profileSetting.glucoMeter != ''
        ? getDeviceSelectionModel.result[0].profileSetting.glucoMeter
        : true;
    _isOxyActive = getDeviceSelectionModel
                    .result[0].profileSetting.pulseOximeter !=
                null &&
            getDeviceSelectionModel.result[0].profileSetting.pulseOximeter != ''
        ? getDeviceSelectionModel.result[0].profileSetting.pulseOximeter
        : true;
    _isWSActive = getDeviceSelectionModel.result[0].profileSetting.weighScale !=
                null &&
            getDeviceSelectionModel.result[0].profileSetting.weighScale != ''
        ? getDeviceSelectionModel.result[0].profileSetting.weighScale
        : true;
    _isTHActive =
        getDeviceSelectionModel.result[0].profileSetting.thermoMeter != null &&
                getDeviceSelectionModel.result[0].profileSetting.thermoMeter !=
                    ''
            ? getDeviceSelectionModel.result[0].profileSetting.thermoMeter
            : true;

    preferred_language = getDeviceSelectionModel
                    .result[0].profileSetting.preferred_language !=
                null &&
            getDeviceSelectionModel
                    .result[0].profileSetting.preferred_language !=
                ''
        ? getDeviceSelectionModel.result[0].profileSetting.preferred_language
        : 'undef';

    qa_subscription = getDeviceSelectionModel
                    .result[0].profileSetting.qa_subscription !=
                null &&
            getDeviceSelectionModel.result[0].profileSetting.qa_subscription !=
                ''
        ? getDeviceSelectionModel.result[0].profileSetting.qa_subscription
        : 'Y';

    selectedPrimaryColor =
        PreferenceUtil.getSavedTheme(Constants.keyPriColor) ?? preColor;

    tagsList=getDeviceSelectionModel
        .result[0].tags!=null && getDeviceSelectionModel
        .result[0].tags.length>0?getDeviceSelectionModel
        .result[0].tags:new List();

    allowAppointmentNotification =
    getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting != null &&
        getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting !=
            ''
        ? getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting?.appointments
        : true;


    allowVitalNotification =
    getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting != null &&
        getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting !=
            ''
        ? getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting?.vitals
        : true;


    allowSymptomsNotification =
    getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting != null &&
        getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting !=
            ''
        ? getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting?.symptoms
        : true;

  }

  Future<CreateDeviceSelectionModel> createAppColorSelection(
      int priColor, int greColor) async {
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
            greColor,tagsList,allowAppointmentNotification,allowVitalNotification,allowSymptomsNotification)
        .then((value) {
      createDeviceSelectionModel = value;
      if (createDeviceSelectionModel.isSuccess) {
      } else {
        if (createDeviceSelectionModel.message ==
            STR_USER_PROFILE_SETTING_ALREADY) {
          updateDeviceSelectionModel(priColor, greColor);
        }
      }
    });
    return createDeviceSelectionModel;
  }

  Future<UpdateDeviceModel> updateDeviceSelectionModel(
      int priColor, int greColor) async {
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
            greColor,tagsList,allowAppointmentNotification,allowVitalNotification,allowSymptomsNotification)
        .then((value) {
      updateDeviceModel = value;
      if (updateDeviceModel.isSuccess) {
        // app color updated
      }
    });
    return updateDeviceModel;
  }

  Widget getValuesFromSharedPrefernce() {
    final _myProfileBloc = MyProfileBloc();

    return FutureBuilder<MyProfileModel>(
      future: _myProfileBloc
          .getMyProfileData(Constants.KEY_USERID_MAIN),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CommonCircularIndicator();
        } else if (snapshot.hasError) {
          if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) != null) {
            myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
            myProfile = snapshot.data;
            isCareGiver=myProfile?.result?.isCaregiver??false;
            return getAppColorsAndDeviceValues();
          }
          return ErrorsWidget();
        } else {
          myProfile = snapshot.data;
          isCareGiver=myProfile?.result?.isCaregiver??false;
          return getAppColorsAndDeviceValues();
        }
      },
    );
  }

  Widget getAppColorsAndDeviceValues() {
    return FutureBuilder<GetDeviceSelectionModel>(
      future: getAppColorValues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CommonCircularIndicator();
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          return getBody();
        }
      },
    );
  }

  moveToLoginPage() {
    CommonUtil().moveToLoginPage();
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
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
}


