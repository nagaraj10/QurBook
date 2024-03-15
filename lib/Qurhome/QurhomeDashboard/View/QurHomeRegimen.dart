import 'dart:async';
import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/QurHub/Controller/HubListViewController.dart';
import 'package:myfhb/Qurhome/Loaders/loader_qurhome.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/CalendarMonth.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/chat_socket/viewModel/getx_chat_view_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as fhbParameters;
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/view/widgets/form_data_dialog.dart';
import 'package:myfhb/regiment/view/widgets/regiment_webview.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/reminders/QurPlanReminders.dart';
import 'package:myfhb/reminders/ReminderModel.dart';
import 'package:myfhb/services/pushnotification_service.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'package:myfhb/src/ui/SheelaAI/Services/SheelaAIBLEServices.dart';
import 'package:myfhb/src/ui/SheelaAI/Services/SheelaAICommonTTSServices.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/src/utils/timezone/timezone_helper.dart';
import 'package:myfhb/src/utils/timezone/timezone_services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/CommonConstants.dart';
import '../../../constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as fhbParameters;

class QurHomeRegimenScreen extends StatefulWidget {
  bool addAppBar;

  QurHomeRegimenScreen({
    this.addAppBar = false,
  });

  @override
  _QurHomeRegimenScreenState createState() => _QurHomeRegimenScreenState();
}

class _QurHomeRegimenScreenState extends State<QurHomeRegimenScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final controller = CommonUtil().onInitQurhomeRegimenController();
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);
  String? snoozeValue = "5 mins";
  List<RegimentDataModel> regimenList = [];

  HubListViewController hubController = Get.find();
  late SheelaBLEController _sheelaBLEController;
  ChatUserListController? chatGetXController =
      CommonUtil().onInitChatUserListController();

  AnimationController? animationController;

  /// Indicates whether the getUserActivitiesHistory() method has been called.
  /// Used to prevent duplicate API requests.
  bool? isGetUserActivitiesHistoryCalled;

  int _counter = 0;
  StreamController<int> _events = StreamController<int>();
  Timer? _timer;
  bool appIsInBackground = false;
  List<String> KeysForSPO2 = [
    "spo2",
    "pulse",
    "oxygensaturation",
  ];
  List<String> KeysForBP = [
    "bloodpressure",
  ];
  List<String> KeysForGlucose = [
    "bloodsugar",
    "randombloodsugar",
    "fastingsugar",
    "bloodglucose",
    "bloodglucose",
    "fastingbloodsugar"
  ];

  var qurhomeDashboardController =
      CommonUtil().onInitQurhomeDashboardController();

  final sheelBadgeController = Get.put(SheelaAIController());

  String currentActivitiesCCProviderName = '';

  String? weightUnit = "kg", tempUnit = "F";

  @override
  void initState() {
    try {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        controller.dateHeader.value = controller.getFormatedDate();
      });
      controller.currLoggedEID.value = "";
      controller.isFirstTime.value = true;

      getUnitValue();
      Future.delayed(Duration.zero, () async {
        onInit();
        controller.initRemainderQueue();
      });
      chatGetXController!.getUnreadCountFamily().then(
        (value) {
          if (value != null) {
            if (value.isSuccess!) {
              if (value.result != null) {
                if (value.result![0].count != null) {
                  if (int.parse(value.result![0].count ?? 0 as String) > 0) {
                    if (PreferenceUtil.getIfQurhomeisAcive()) {
                      redirectToSheelaUnreadMessage();
                    }
                  }
                }
              }
            }
          }
        },
      );
      //initSocketCountUnread();
      WidgetsBinding.instance?.addObserver(this);

      super.initState();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
    }
  }

  /// Gets the weight and temperature units from shared preferences and assigns to variables.
  ///
  /// Fetches the weight unit value from shared preferences using the key 'weightUnitKey',
  /// and assigns to [weightUnit].
  ///
  /// Fetches the temperature unit value from shared preferences using the key 'tempUnitKey',
  /// and assigns to [tempUnit].
  getUnitValue() async {
    weightUnit = await PreferenceUtil.getStringValue(STR_KEY_WEIGHT);
    tempUnit = await PreferenceUtil.getStringValue(STR_KEY_TEMP);
  }

  onInit() async {
    try {
      String strEventId = CommonUtil()
          .validString(qurhomeDashboardController.eventId.value ?? "");
      String strEStart = CommonUtil()
          .validString(qurhomeDashboardController.estart.value ?? "");
      if (CommonUtil.isUSRegion() &&
          strEStart.trim().isNotEmpty &&
          !(qurhomeDashboardController.isOnceInAPlanActivity.value)) {
        await controller.getRegimenList(isLoading: true, date: strEStart);
      } else {
        await controller.getRegimenList();
      }
      await Future.delayed(Duration(milliseconds: 5));
      qurhomeDashboardController.enableModuleAccess();
      qurhomeDashboardController.getModuleAccess();
      controller.getSOSButtonStatus();
      await Future.delayed(Duration(milliseconds: 100));

      if (CommonUtil.isUSRegion() && strEventId.trim().isNotEmpty) {
        RegimentDataModel? currRegimen = null;

        if (controller.qurHomeRegimenResponseModel?.regimentsList != null &&
            (controller.qurHomeRegimenResponseModel?.regimentsList?.length ??
                    0) >
                0) {
          for (int i = 0;
              i < controller.qurHomeRegimenResponseModel!.regimentsList!.length;
              i++) {
            RegimentDataModel regimentDataModel =
                controller.qurHomeRegimenResponseModel!.regimentsList![i];
            if ((regimentDataModel.eid ?? "").toString().toLowerCase() ==
                strEventId) {
              currRegimen = regimentDataModel;
              if (regimentDataModel.activityOrgin != strAppointmentRegimen) {
                showRegimenDialog(regimentDataModel, i);
                await Future.delayed(Duration(milliseconds: 2000));
                qurhomeDashboardController.eventId.value = "";
                qurhomeDashboardController.estart.value = "";
                qurhomeDashboardController.isOnceInAPlanActivity.value = false;
              }
              break;
            }
          }
        }

        if (currRegimen == null) {
          if (qurhomeDashboardController.isOnceInAPlanActivity.value) {
            FlutterToast().getToast(
              activity_completed_regimen,
              Colors.green,
            );
            qurhomeDashboardController.isOnceInAPlanActivity.value = false;
          } else {
            FlutterToast().getToast(
              activity_removed_regimen,
              Colors.red,
            );
          }
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  // commented due to sheela auto read common
  /*initSocketCountUnread() {
    if (qurhomeDashboardController.estart.value.trim().isNotEmpty) return;
    Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
        .socket!
        .off(notifyQurhomeUser);

    Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
        .socket!
        .on(notifyQurhomeUser, (data) {
      if (data != null) {
        UnreadChatSocketNotify unreadCountNotify =
            UnreadChatSocketNotify.fromJson(data);
        if (unreadCountNotify != null) {
          if (unreadCountNotify.result != null) {
            if (unreadCountNotify.result!.isSuccess!) {
              if (PreferenceUtil.getIfQurhomeisAcive()) {
                redirectToSheelaUnreadMessage();
              }
            }
          }
        }
      }
    });
  }*/

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumeEvent();
        break;
      case AppLifecycleState.paused:
        appIsInBackground = true;
        break;
      default:
    }
    //print("the current state of the app is ${state.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      onPanUpdate: (dragUpdateDetails) {},
      onPanEnd: (panEndDetails) {},
      child: Scaffold(
        appBar: widget.addAppBar
            ? AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: CommonUtil().isTablet! ? 110.00 : null,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  strRegimen,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                leading: IconWidget(
                  icon: Icons.arrow_back_ios,
                  colors: Colors.black,
                  size: CommonUtil().isTablet! ? 38.0 : 24.0,
                  onTap: () {
                    Get.back();
                  },
                ),
                bottom: PreferredSize(
                  child: Container(
                    color: Color(
                      CommonUtil().getQurhomeGredientColor(),
                    ),
                    height: 1.0,
                  ),
                  preferredSize: Size.fromHeight(
                    1.0,
                  ),
                ),
              )
            : null,
        body: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) {
            //check whether the any interaction is happen and close the timer
            qurhomeDashboardController.getIdleTimer?.cancel();
            if(qurhomeDashboardController.isShowScreenIdleDialog.value){
              //Sheela inactive dialog exist close the dialog
              Get.back();
              qurhomeDashboardController.isShowScreenIdleDialog.value=false;
              qurhomeDashboardController.isScreenIdle.value=false;
            }
            //restart the timer for check the ideal flow
            qurhomeDashboardController.isScreenIdle.value=true;
            qurhomeDashboardController.checkScreenIdle();
          },
          child: Stack(
            children: [
              Container(
                height: 60,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      CommonUtil.isUSRegion()
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: InkWell(
                                    onTap: () {
                                      Get.to(CalendarMonth())!.then((value) {
                                        controller.getRegimenList(
                                            isLoading: true, date: value);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        icon_calendar,
                                        //Set width and height to maintain UI similar in tablet and mobile
                                        height: (CommonUtil().isTablet ?? false)
                                            ? 40
                                            : 26,
                                        width: (CommonUtil().isTablet ?? false)
                                            ? 40
                                            : 26,
                                      ),
                                    )),
                              ),
                            )
                          : Container(),
                      Container(
                          child: Expanded(
                        child: CommonUtil.isUSRegion()
                            ? GetBuilder<QurhomeRegimenController>(
                                id: strRefershStatusText,
                                builder: (val) {
                                  return Visibility(
                                      visible: !controller.isTodaySelected.value,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 2000),
                                        curve: Curves.fastOutSlowIn,
                                        opacity: !controller.isTodaySelected.value
                                            ? 1
                                            : 0,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Card(
                                              color: Color(
                                                CommonUtil()
                                                    .getQurhomePrimaryColor(),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  controller.statusText.value,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: (CommonUtil()
                                                                  .isTablet ??
                                                              false)
                                                          ? tabHeader3
                                                          : mobileHeader3),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ));
                                })
                            : Container(),
                      )),
                      if (!widget.addAppBar)
                        Obx(() => controller.isShowSOSButton.value
                            ? GestureDetector(
                                onTap: () {
                                  try {
                                    FHBUtils().check().then((intenet) async {
                                      if (intenet != null && intenet) {
                                        if (CommonUtil().isTablet! &&
                                            controller.careCoordinatorId.value
                                                .trim()
                                                .isEmpty) {
                                          await controller.getCareCoordinatorId();
                                        }
                                        initSOSCall();
                                      } else {
                                        FlutterToast().getToast(
                                          STR_NO_CONNECTIVITY,
                                          Colors.red,
                                        );
                                      }
                                    });
                                  } catch (e, stackTrace) {
                                    print(e);
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Container(
                                      height: 40.h,
                                      width: 80.h,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFB5422),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(100),
                                          bottomRight: Radius.circular(100),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'SOS',
                                          style: TextStyle(
                                              fontSize: 14.0.h,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink()),
                    ],
                  ),
                ),
              ),
              Obx(
                () => controller.loadingData.isTrue
                    ? controller.loadingDataWithoutProgress.isTrue
                        ? getDataFromAPI(controller, isPortrait)
                        : Center(
                            child: CircularProgressIndicator(),
                          )
                    : GetBuilder<QurhomeRegimenController>(
                        id: "newUpdate",
                        builder: (val) {
                          print("working builder");
                          return getDataFromAPI(val, isPortrait);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getDataFromAPI(QurhomeRegimenController val, var isPortrait) {
    return val.qurHomeRegimenResponseModel == null
        ? const Center(
            child: Text(
              'Please re-try after some time',
            ),
          )
        : val.qurHomeRegimenResponseModel!.regimentsList!.length != 0
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Container(
                    child: RawScrollbar(
                  thumbVisibility: true,
                  thumbColor: Color(
                    CommonUtil().getQurhomePrimaryColor(),
                  ),
                  radius: Radius.circular(20),
                  thickness: 5,
                  child: PageView.builder(
                    itemCount:
                        val.qurHomeRegimenResponseModel!.regimentsList!.length +
                            1,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (int index) {
                      setState(() {
                        controller.currentIndex = index;
                      });
                    },
                    controller: PageController(
                        initialPage: val.nextRegimenPosition,
                        viewportFraction: 1 / (isPortrait == true ? 5 : 3)),
                    itemBuilder: (BuildContext context, int itemIndex) {
                      if (itemIndex ==
                          (val.qurHomeRegimenResponseModel!.regimentsList!
                              .length)) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 22.0),
                          child: Column(
                            children: [
                              Image.asset(
                                noMoreActivity,
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                noMoreActivites,
                                style: TextStyle(
                                    color: Color(
                                  CommonUtil().getQurhomePrimaryColor(),
                                )),
                              )
                            ],
                          ),
                        );
                      } else {
                        return _buildCarouselItem(
                            context,
                            itemIndex,
                            val.qurHomeRegimenResponseModel!
                                .regimentsList![itemIndex],
                            val.nextRegimenPosition,
                            isPortrait);
                      }
                    },
                  ),
                )),
              )
            : const Center(
                child: Text(
                  'No activities scheduled today',
                ),
              );
  }

  getCurrentRatio(int itemIndex) {
    if (controller.currentIndex == itemIndex) {
      return 1.0;
    } else if ((controller.currentIndex - 1) == itemIndex ||
        (controller.currentIndex + 1) == itemIndex) {
      return 0.9;
    } else if ((controller.currentIndex - 2) == itemIndex ||
        (controller.currentIndex + 2) == itemIndex) {
      return 0.8;
    } else {
      return 0.8;
    }
  }

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }

  double getPaddingWidth() {
    if (getDeviceType() == 'phone') {
      return 25.0;
    } else {
      return MediaQuery.of(context).size.width * 03;
    }
  }

  Color getCardBackgroundColor(
      int itemIndex, int nextRegimenPosition, RegimentDataModel regimen) {
    if (regimen.ack != null) {
      return Color(0xff511e);
    } else if (controller.currentIndex == itemIndex) {
      return Colors.white;
    } else if (nextRegimenPosition == itemIndex) {
      return Color(
        CommonUtil().getQurhomePrimaryColor(),
      );
    } else {
      return Colors.white;
    }
  }

  Color getTextAndIconColor(int itemIndex, int nextRegimenPosition) {
    if (controller.currentIndex == itemIndex) {
      return Colors.black;
    } else if (nextRegimenPosition == itemIndex) {
      return Colors.black;
    } else {
      return Colors.black;
    }
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex,
      RegimentDataModel regimen, int nextRegimenPosition, bool isPortrait) {
    String strTitle = "";
    try {
      if (regimen.activityOrgin == strAppointmentRegimen) {
        String strServiceType = CommonUtil()
                .validString(regimen.doctorSessionId ?? "")
                .trim()
                .isNotEmpty
            ? regimen.serviceCategory?.name ?? ""
            : regimen.additionalInfo?.serviceType ?? "";
        if (strServiceType.toLowerCase() == variable.strOthers.toLowerCase()) {
          strTitle = regimen.additionalInfo?.title ?? "";
        } else {
          strTitle = strServiceType;
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        print(e);
      }
    }
    return InkWell(
      onTap: () async {
        qurhomeDashboardController.getIdleTimer!.cancel();
        qurhomeDashboardController.isScreenIdle.value=false;
        if (regimen.activityOrgin == strAppointmentRegimen) {
          if ((regimen.eid != null) && (regimen.eid != '')) {
            CommonUtil().goToAppointmentDetailScreen(regimen.eid,backFromAppointmentScreen: (value){
              //Initialize the timer when the qurhome is ideal
              qurhomeDashboardController.isScreenIdle.value=true;
              qurhomeDashboardController.checkScreenIdle();
            });
          }
        } else {
          if (CommonUtil().checkIfSkipAcknowledgemnt(regimen)) {
            redirectToSheelaScreen(regimen);
          } else {
            /// Tries to show the regimen dialog for the given regimen at
            /// the given index. Catches any errors and logs them.
            ///
            /// If the user is not in India and the regimen is read only,
            /// it will fetch the user activities history for the regimen
            /// before showing the dialog. This helps provide read only
            /// access to regimens from other providers.
            try {
              if (CommonUtil.REGION_CODE != 'IN' &&
                  (regimen.otherinfo?.isReadOnlyAccess() ?? true)) {
                /// Checks if getUserActivitiesHistory() has already been called
                /// for the current regimen.
                /// This prevents duplicate network requests.
                /// Returns immediately if it has already been called.
                if (isGetUserActivitiesHistoryCalled != null) {
                  return;
                }
                isGetUserActivitiesHistoryCalled = true;
                currentActivitiesCCProviderName =
                    await controller.getUserActivitiesHistory(regimen.eid) ??
                        '';
                isGetUserActivitiesHistoryCalled = null;
              }
              showRegimenDialog(regimen, itemIndex,onTapHideDialog: (value) {
                if(value){
                  qurhomeDashboardController.isScreenIdle.value=true;
                  qurhomeDashboardController.checkScreenIdle();
                }
              },);            } catch (error, stackTrace) {
              CommonUtil().appLogs(message: error, stackTrace: stackTrace);
            }
          }
        }
      },
      child: Transform.scale(
        scale: getCurrentRatio(itemIndex),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  isPortrait ? 12.0 : MediaQuery.of(context).size.width / 5,
              vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: getCardBackgroundColor(
                  itemIndex, nextRegimenPosition, regimen),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 2,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    regimen.estart != null
                        ? DateFormat('hh:mm a').format(regimen.estart!)
                        : '',
                    style: TextStyle(
                      color: getTextAndIconColor(
                        itemIndex,
                        nextRegimenPosition,
                      ),
                      fontSize: 15.h,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            strTitle.trim().isNotEmpty
                                ? strTitle
                                : regimen.title.toString().trim(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: getTextAndIconColor(
                                    itemIndex, nextRegimenPosition),
                                fontSize: 16.h,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Visibility(
                          /// Controls the visibility of the child text widget based on whether the
                          /// regimen's activity name matches Activityname.VITALS. Only shows the child text
                          /// if the activity name matches.
                          visible: regimen.activityname == Activityname.VITALS,
                          child: Text(
                            getValuesOfVital(regimen),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.h,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Visibility(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /* Image.asset(
                                  'assets/Qurhome/seen.png',
                                  height: 12.0,
                                  width: 12.0,
                                  color: getTextAndIconColor(
                                      itemIndex, nextRegimenPosition),
                                ),*/
                            getIcon(
                                regimen,
                                regimen.activityname,
                                regimen.uformname,
                                regimen.metadata,
                                itemIndex,
                                nextRegimenPosition),
                            const SizedBox(
                              height: 10,
                            ),
                            if (regimen.ack != null)
                              Text(
                                strCompleted,
                                style: TextStyle(
                                  fontSize: CommonUtil().isTablet!
                                      ? tabHeader1
                                      : mobileHeader1,
                                  fontWeight: FontWeight.bold,
                                  color: getTextAndIconColor(
                                      itemIndex, nextRegimenPosition),
                                ),
                              )
                            else
                              const SizedBox()
                          ],
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        if (regimen.ack != null)
                          CommonUtil.isUSRegion()
                              ? const SizedBox()
                              : const SizedBox() /*Text(
                                  '${CommonUtil().regimentDateFormatV2(
                                    regimen.asNeeded
                                        ? regimen.ack ?? DateTime.now()
                                        : regimen.ack ?? DateTime.now(),
                                    isAck: true,
                                  )}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: getTextAndIconColor(
                                        itemIndex, nextRegimenPosition),
                                  ),
                                )*/
                        else
                          const SizedBox()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  dynamic getIcon(
      RegimentDataModel regimen,
      Activityname? activityname,
      Uformname? uformName,
      Metadata? metadata,
      int itemIndex,
      int nextRegimenPosition,
      {double? sizeOfIcon}) {
    final iconSize = sizeOfIcon ?? 40.0.h;
    try {
      if (metadata?.icon != null) {
        if (metadata?.icon?.toLowerCase().contains('.svg') ?? false) {
          return SvgPicture.network(
            metadata!.icon!,
            height: iconSize,
            width: iconSize,
            color: getTextAndIconColor(itemIndex, nextRegimenPosition),
          );
        } else {
          return CachedNetworkImage(
            imageUrl: metadata!.icon!,
            height: iconSize,
            width: iconSize,
            color: getTextAndIconColor(itemIndex, nextRegimenPosition),
            errorWidget: (context, url, error) {
              return getDefaultIcon(regimen, activityname, uformName, iconSize,
                  itemIndex, nextRegimenPosition);
            },
          );
        }
      } else {
        return getDefaultIcon(regimen, activityname, uformName, iconSize,
            itemIndex, nextRegimenPosition);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return getDefaultIcon(regimen, activityname, uformName, iconSize,
          itemIndex, nextRegimenPosition);
    }
  }

  dynamic getDefaultIcon(
    RegimentDataModel regimen,
    Activityname? activityname,
    Uformname? uformName,
    double iconSize,
    int itemIndex,
    int nextRegimenPosition,
  ) {
    var isDefault = true;
    dynamic cardIcon = 'assets/launcher/myfhb.png';
    switch (activityname) {
      case Activityname.DIET:
        cardIcon = Icons.fastfood_rounded;
        break;
      case Activityname.VITALS:
        if (uformName == Uformname.BLOODPRESSURE) {
          cardIcon = 'assets/devices/bp_dashboard.png';
          isDefault = false;
        } else if (uformName == Uformname.BLOODSUGAR) {
          isDefault = false;
          cardIcon = 'assets/devices/gulcose_dashboard.png';
        } else if (uformName == Uformname.PULSE) {
          isDefault = false;
          cardIcon = 'assets/devices/os_dashboard.png';
        } else {
          cardIcon = 'assets/Qurhome/Qurhome.png';
        }
        break;
      case Activityname.MEDICATION:
        cardIcon = Icons.medical_services;
        break;
      case Activityname.SCREENING:
        cardIcon = Icons.screen_search_desktop;
        break;
      default:
        if (CommonUtil().checkIfSkipAcknowledgemnt(regimen)) {
          cardIcon = 'assets/icons/icon_acknowledgement.png';
        } else {
          cardIcon = 'assets/Qurhome/Qurhome.png';
        }
    }
    var cardIconWidget = (cardIcon is String)
        ? Image.asset(
            cardIcon,
            height: isDefault ? iconSize : iconSize - 5.0,
            width: isDefault ? iconSize : iconSize - 5.0,
            color: (CommonUtil().checkIfSkipAcknowledgemnt(regimen))
                ? getTextAndIconColor(itemIndex, nextRegimenPosition)
                : null,
          )
        : Icon(
            cardIcon,
            size: iconSize - 5.0,
            color: getTextAndIconColor(itemIndex, nextRegimenPosition),
          );
    return cardIconWidget;
  }

  String getFormatedTitle(String title) {
    String first = "";
    String second = "";
    try {
      int start = title.indexOf("{") + 1;
      int length = title.indexOf("}");
      if (start != null) {
        first = title.substring(start, length);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      try {
        first = title.split("|").first;
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        first = title;
      }
    }
    try {
      int startSecond = title.indexOf("[") + 1;
      int lengthSecond = title.indexOf("]");
      if (startSecond != null) {
        second = title.substring(startSecond, lengthSecond);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    return first + second;
  }

  showRegimenDialog(RegimentDataModel regimen, int index,{Function(bool)? onTapHideDialog}) {
    if (regimen.ack == null &&
        (regimen.otherinfo?.isReadOnlyAccess() ?? false) == false)
      showDialog(
          context: context,
          builder: (__) {
            return StatefulBuilder(builder: (_, setState) {
              return AlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  content: Container(
                    // use container to change width and height
                    width: CommonUtil().isTablet! ? 0.5.sw : 1.sw,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                                padding: EdgeInsets.all(8.0),
                                icon: Icon(
                                  Icons.close,
                                  size: CommonUtil().isTablet!
                                      ? imageCloseTab
                                      : imageCloseMobile,
                                ),
                                onPressed: () {
                                  try {
                                    Navigator.pop(context);
                                    onTapHideDialog?.call(true);
                                  } catch (e, stackTrace) {
                                    CommonUtil().appLogs(
                                        message: e, stackTrace: stackTrace);

                                    print(e);
                                  }
                                })
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                            bottom: 15.0,
                          ),
                          child: Row(
                            children: [
                              getIcon(regimen, regimen.activityname,
                                  regimen.uformname, regimen.metadata, index, 0,
                                  sizeOfIcon: CommonUtil().isTablet!
                                      ? dialogIconTab
                                      : dialogIconMobile),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(children: [
                                Center(
                                  child: Text(
                                    regimen.title.toString().trim(),
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Color(
                                          CommonUtil()
                                              .getQurhomeGredientColor(),
                                        ),
                                        fontSize: CommonUtil().isTablet!
                                            ? tabHeader1
                                            : mobileHeader1,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    regimen.estart != null
                                        ? DateFormat('hh:mm a')
                                            .format(regimen.estart!)
                                        : '',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: CommonUtil().isTablet!
                                            ? tabHeader3
                                            : mobileHeader3,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ])),
                              if (regimen.activityOrgin !=
                                  strAppointmentRegimen)
                                getSheelaIcon(regimen)
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                if ((regimen.activityOrgin != strDiet) &&
                                    (regimen.activityOrgin == strSurvey)) {
                                  if (checkCanEdit(regimen)) {
                                    redirectToSheelaScreen(regimen,
                                        isSurvey: true);
                                  } else {
                                    onErrorMessage(regimen);
                                  }
                                } else {
                                  if (regimen.hasform!) {
                                    onCardPressed(context, regimen,
                                        aid: regimen.aid,
                                        uid: regimen.uid,
                                        formId: regimen.uformid,
                                        formName: regimen.uformname);
                                  } else {
                                    callLogApi(regimen).then((value) {
                                      callQueueCountApi();
                                    });
                                  }
                                }
                              },
                              child: Image.asset(
                                'assets/Qurhome/accept.png',
                                height: CommonUtil().isTablet!
                                    ? dialogIconTab
                                    : dialogIconMobile,
                                width: CommonUtil().isTablet!
                                    ? dialogIconTab
                                    : dialogIconMobile,
                              ),
                            ))),
                            Expanded(
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Image.asset(
                                    'assets/Qurhome/remove.png',
                                    height: CommonUtil().isTablet!
                                        ? dialogIconTab
                                        : dialogIconMobile,
                                    width: CommonUtil().isTablet!
                                        ? dialogIconTab
                                        : dialogIconMobile,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text('Remind me in'),
                                  // Container(
                                  //   color: Colors.grey,
                                  //   height: 1,
                                  //   width: 110,
                                  // )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Stack(
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: snoozeValue,
                                      elevation: 16,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          snoozeValue = newValue;
                                        });
                                      },
                                      items: <String>[
                                        '5 mins',
                                        '10 mins',
                                        '15 mins',
                                        '20 mins'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 36.0),
                                    child: Container(
                                      color: Colors.grey,
                                      height: 1,
                                      width: 78,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            var time = snoozeValue!.split(" ");
                            Reminder reminder = Reminder();
                            reminder.uformname = regimen.uformname.toString();
                            reminder.activityname =
                                regimen.activityname.toString();
                            reminder.title = regimen.title.toString();
                            reminder.description =
                                regimen.description.toString();
                            reminder.eid = regimen.eid.toString();
                            reminder.estart = CommonUtil()
                                .snoozeDataFormat(
                                    DateTime.now().add(Duration(minutes: 1)))
                                .toString();
                            reminder.remindin = regimen.remindin.toString();
                            reminder.remindbefore = regimen.remindin.toString();
                            reminder.dosemeal =
                                regimen.doseMealString.toString();
                            // Calculate a unique notification ID by converting the reminder's 'eid' to a signed 32-bit integer.
                            final notificationId = toSigned32BitInt(
                                int.tryParse('${reminder?.eid}') ?? 0);

                            // Assign the calculated notification ID to the reminder's notificationListId property.
                            reminder?.notificationListId =
                                notificationId.toString();

                            // Assign the value of fhbParameters.stringRegimentScreen to the reminder's redirectTo property.
                            reminder?.redirectTo =
                                fhbParameters.stringRegimentScreen;

                            List<Reminder> data = [reminder];
                            String snoozedText =
                                "Snoozed for ${int.parse(time[0]).toString()} minutes";
                            final snoozedBody = {};
                            snoozedBody['eid'] = regimen.eid.toString();
                            snoozedBody['snoozeText'] = snoozedText;
                            final jsonString = convert.jsonEncode(snoozedBody);
                            try {
                              QurHomeApiProvider.snoozeEvent(jsonString);
                            } catch (e, stackTrace) {
                              CommonUtil()
                                  .appLogs(message: e, stackTrace: stackTrace);
                            }
                            QurPlanReminders.updateReminderswithLocal(data);
                            Navigator.pop(context);
                          },
                          child: Text('Snooze'),
                          style: ElevatedButton.styleFrom(
                              primary:
                                  Color(CommonUtil().getQurhomePrimaryColor())),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: regimen.hashtml!,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(
                                    RegimentWebView(
                                      title: regimen.title.toString().trim(),
                                      selectedUrl: regimen.htmltemplate,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    strAdditionalInstructions,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 13.h,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            });
          });
    else if (regimen.otherinfo?.isReadOnlyAccess() != null &&
        regimen.ack == null) {
      if (CommonUtil.REGION_CODE != 'IN') {
        showDialog(
          context: context,
          builder: (__) => StatefulBuilder(
            builder: (_, setState) => AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              content: Container(
                width: CommonUtil().isTablet! ? 0.5.sw : 1.sw,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            padding: const EdgeInsets.all(8),
                            icon: Icon(
                              Icons.close,
                              size: CommonUtil().isTablet!
                                  ? imageCloseTab
                                  : imageCloseMobile,
                            ),
                            onPressed: () {
                              try {
                                Navigator.pop(context);
                              } catch (e, stackTrace) {
                                CommonUtil().appLogs(
                                    message: e, stackTrace: stackTrace);

                                print(e);
                              }
                            })
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          bottom: 15,
                        ),
                        child: Row(
                          children: [
                            getIcon(regimen, regimen.activityname,
                                regimen.uformname, regimen.metadata, index, 0,
                                sizeOfIcon: CommonUtil().isTablet!
                                    ? dialogIconTab
                                    : dialogIconMobile),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(children: [
                              Center(
                                child: Text(
                                  regimen.title.toString().trim(),
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Color(
                                        CommonUtil().getQurhomeGredientColor(),
                                      ),
                                      fontSize: CommonUtil().isTablet!
                                          ? tabHeader1
                                          : mobileHeader1,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Center(
                                child: Text(
                                  regimen.estart != null
                                      ? DateFormat('hh:mm a')
                                          .format(regimen.estart!)
                                      : '',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: CommonUtil().isTablet!
                                          ? tabHeader3
                                          : mobileHeader3,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ])),
                            SizedBox(
                              height: CommonUtil().isTablet!
                                  ? dialogIconTab
                                  : dialogIconMobile,
                              width: CommonUtil().isTablet!
                                  ? dialogIconTab
                                  : dialogIconMobile,
                            ),
                          ],
                        )),
                    Divider(
                      height: CommonUtil().isTablet! ? 3.0.h : 4.0.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: 15,
                        right: 15,
                        bottom: 30,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            ImageUrlUtils.sheelaActivityNoFormdataImage,
                            width: 101.0.h,
                            height: 120.0.h,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Container(
                              width: 1,
                              height: 120.0.h,
                              color: Colors.grey[200],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strActivityYourHealthcareProvider,
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: CommonUtil().isTablet!
                                        ? tabHeader1
                                        : mobileHeader1,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  strNotifiedonceItIsDone,
                                  maxLines: 5,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: CommonUtil().isTablet!
                                        ? tabHeader1
                                        : mobileHeader1,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: CommonUtil().isTablet! ? 3.0.h : 4.0.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    } else if ((regimen.otherinfo?.isReadOnlyAccess() ?? true) &&
        CommonUtil.REGION_CODE != 'IN' &&
        regimen.ack != null) {
      showDialog(
        context: context,
        builder: (__) => StatefulBuilder(
          builder: (_, setState) => AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              width: CommonUtil().isTablet! ? 0.5.sw : 1.sw,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          padding: EdgeInsets.all(8.0),
                          icon: Icon(
                            Icons.close,
                            size: CommonUtil().isTablet!
                                ? imageCloseTab
                                : imageCloseMobile,
                          ),
                          onPressed: () {
                            try {
                              Navigator.pop(context);
                            } catch (e, stackTrace) {
                              CommonUtil()
                                  .appLogs(message: e, stackTrace: stackTrace);

                              print(e);
                            }
                          })
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        bottom: 15.0,
                      ),
                      child: Row(
                        children: [
                          getIcon(regimen, regimen.activityname,
                              regimen.uformname, regimen.metadata, index, 0,
                              sizeOfIcon: CommonUtil().isTablet!
                                  ? dialogIconTab
                                  : dialogIconMobile),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    regimen.title.toString().trim(),
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Color(
                                          CommonUtil()
                                              .getQurhomeGredientColor(),
                                        ),
                                        fontSize: CommonUtil().isTablet!
                                            ? tabHeader1
                                            : mobileHeader1,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    regimen.estart != null
                                        ? DateFormat('hh:mm a')
                                            .format(regimen.estart!)
                                        : '',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: CommonUtil().isTablet!
                                          ? tabHeader3
                                          : mobileHeader3,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: CommonUtil().isTablet!
                                ? dialogIconTab
                                : dialogIconMobile,
                            width: CommonUtil().isTablet!
                                ? dialogIconTab
                                : dialogIconMobile,
                          ),
                        ],
                      )),
                  Divider(
                    height: CommonUtil().isTablet! ? 3.0.h : 4.0.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      left: 15.0,
                      right: 15.0,
                      bottom: 30.0,
                    ),
                    child: Column(
                      children: [
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: strHasBeenRecordedBy,
                                  style: TextStyle(
                                    fontSize: 22.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: currentActivitiesCCProviderName,
                                  style: TextStyle(
                                    fontSize: 22.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: strHasBeenRecordedByAt,
                                  style: TextStyle(
                                    fontSize: 22.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )),
                        Text(
                          '${CommonUtil().regimentDateFormat(
                            regimen.asNeeded
                                ? regimen.ack ?? DateTime.now()
                                : regimen.ack ?? DateTime.now(),
                            isAck: true,
                            ackDate: true,
                          )}',
                          style: TextStyle(
                              fontSize: 26.0.sp, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: CommonUtil().isTablet! ? 3.0.h : 4.0.h,
                  ),
                  Visibility(
                      visible: regimen.hasform != false &&
                          (regimen.otherinfo?.isReadOnlyAccess() ?? false),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                          left: 15,
                          right: 15,
                          bottom: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                if (regimen.hasform!) {
                                  Navigator.pop(context);
                                  onCardPressed(context, regimen,
                                      aid: regimen.aid,
                                      uid: regimen.uid,
                                      formId: regimen.uformid,
                                      formName: regimen.uformname,
                                      canEditMain: false,
                                      fromView: true,
                                      isReadyOnly: true);
                                } else if (regimen.hasform == false) {
                                } else {
                                  Navigator.pop(context);

                                  callLogApi(regimen);
                                }
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      icon_view_eye,
                                      height: 30,
                                      width: 30,
                                      color: (regimen.hasform == false)
                                          ? Colors.grey
                                          : Color(
                                              CommonUtil()
                                                  .getQurhomePrimaryColor(),
                                            ),
                                    ),
                                  ),
                                  Text(
                                    strView,
                                    style: TextStyle(
                                      fontSize: 20.0.sp,
                                      color: (regimen.hasform == false)
                                          ? Colors.grey
                                          : Color(
                                              CommonUtil()
                                                  .getQurhomePrimaryColor(),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      final iconSize = 50.0.sp;
      if (CommonUtil.REGION_CODE != "IN")
        showDialog(
            context: context,
            builder: (__) {
              return StatefulBuilder(builder: (_, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  content: Container(
                    width: CommonUtil().isTablet! ? 0.5.sw : 1.sw,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                                padding: EdgeInsets.all(8.0),
                                icon: Icon(
                                  Icons.close,
                                  size: CommonUtil().isTablet!
                                      ? imageCloseTab
                                      : imageCloseMobile,
                                ),
                                onPressed: () {
                                  try {
                                    Navigator.pop(context);
                                  } catch (e, stackTrace) {
                                    CommonUtil().appLogs(
                                        message: e, stackTrace: stackTrace);

                                    print(e);
                                  }
                                })
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                              bottom: 15.0,
                            ),
                            child: Row(
                              children: [
                                getIcon(
                                    regimen,
                                    regimen.activityname,
                                    regimen.uformname,
                                    regimen.metadata,
                                    index,
                                    0,
                                    sizeOfIcon: CommonUtil().isTablet!
                                        ? dialogIconTab
                                        : dialogIconMobile),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Column(children: [
                                  Center(
                                    child: Text(
                                      regimen.title.toString().trim(),
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Color(
                                            CommonUtil()
                                                .getQurhomeGredientColor(),
                                          ),
                                          fontSize: CommonUtil().isTablet!
                                              ? tabHeader1
                                              : mobileHeader1,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      regimen.estart != null
                                          ? DateFormat('hh:mm a')
                                              .format(regimen.estart!)
                                          : '',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: CommonUtil().isTablet!
                                              ? tabHeader3
                                              : mobileHeader3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ])),
                                if (regimen.activityOrgin !=
                                    strAppointmentRegimen)
                                  getSheelaIcon(regimen),
                              ],
                            )),
                        Divider(
                          height: CommonUtil().isTablet! ? 3.0.h : 4.0.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 30.0,
                            left: 15.0,
                            right: 15.0,
                            bottom: 30.0,
                          ),
                          child: Column(
                            children: [
                              Text(strRecordedAt,
                                  style: TextStyle(
                                      fontSize: 24.0.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                '${CommonUtil().regimentDateFormat(
                                  regimen.asNeeded
                                      ? regimen.ack ?? DateTime.now()
                                      : regimen.ack ?? DateTime.now(),
                                  isAck: true,
                                  ackDate: true,
                                )}',
                                style: TextStyle(
                                    fontSize: 26.0.sp,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: CommonUtil().isTablet! ? 3.0.h : 4.0.h,
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              top: 30.0,
                              left: 15.0,
                              right: 15.0,
                              bottom: 30.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    LoaderQurHome.showLoadingDialog(
                                      Get.context!,
                                      canDismiss: false,
                                    );
                                    var saveResponse =
                                        await Provider.of<RegimentViewModel>(
                                                context,
                                                listen: false)
                                            .undoSaveFormData(
                                      eid: regimen.eid,
                                    );
                                    if (saveResponse.isSuccess ?? false) {
                                      Future.delayed(
                                          Duration(milliseconds: 300),
                                          () async {
                                        await controller.getRegimenList(
                                            isLoading: true,
                                            date: controller.selectedDate.value
                                                .toString());
                                        Navigator.pop(context);
                                        LoaderQurHome.hideLoadingDialog(
                                            Get.context!);
                                      });
                                    } else {
                                      LoaderQurHome.hideLoadingDialog(
                                          Get.context!);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Image.asset(icon_undo_reg,
                                            height: 30,
                                            width: 30,
                                            color: Color(CommonUtil()
                                                .getQurhomePrimaryColor())),
                                      ),
                                      Text(strUndo,
                                          style: TextStyle(
                                              fontSize: 20.0.sp,
                                              color: Color(CommonUtil()
                                                  .getQurhomePrimaryColor()))),
                                    ],
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      try {
                                        if (regimen.activityOrgin ==
                                            strSurvey) {
                                          Navigator.pop(context);
                                          redirectToSheelaScreen(regimen,
                                              isSurvey: true,
                                              isRetakeSurvey: true);
                                          return;
                                        }

                                        if (regimen.hasform!) {
                                          Navigator.pop(context);

                                          onCardPressed(context, regimen,
                                              aid: regimen.aid,
                                              uid: regimen.uid,
                                              formId: regimen.uformid,
                                              formName: regimen.uformname,
                                              canEditMain: true);
                                        } else if (regimen?.hasform == false) {
                                        } else {
                                          Navigator.pop(context);

                                          callLogApi(regimen);
                                        }
                                      } catch (e, stackTrace) {
                                        CommonUtil().appLogs(
                                            message: e, stackTrace: stackTrace);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Image.asset(icon_edit,
                                              height: 30,
                                              width: 30,
                                              color: (regimen?.hasform == false)
                                                  ? Colors.grey
                                                  : Color(CommonUtil()
                                                      .getQurhomePrimaryColor())),
                                        ),
                                        Text(strEdit,
                                            style: TextStyle(
                                                fontSize: 20.0.sp,
                                                color: (regimen?.hasform ==
                                                        false)
                                                    ? Colors.grey
                                                    : Color(CommonUtil()
                                                        .getQurhomePrimaryColor()))),
                                      ],
                                    )),
                                InkWell(
                                  onTap: () {
                                    if (regimen.hasform!) {
                                      Navigator.pop(context);

                                      onCardPressed(context, regimen,
                                          aid: regimen.aid,
                                          uid: regimen.uid,
                                          formId: regimen.uformid,
                                          formName: regimen.uformname,
                                          canEditMain: false,
                                          fromView: true);
                                    } else if (regimen?.hasform == false) {
                                    } else {
                                      Navigator.pop(context);

                                      callLogApi(regimen);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Image.asset(
                                          icon_view_eye,
                                          height: 30,
                                          width: 30,
                                          color: (regimen?.hasform == false)
                                              ? Colors.grey
                                              : Color(CommonUtil()
                                                  .getQurhomePrimaryColor()),
                                        ),
                                      ),
                                      Text(strView,
                                          style: TextStyle(
                                              fontSize: 20.0.sp,
                                              color: (regimen?.hasform == false)
                                                  ? Colors.grey
                                                  : Color(CommonUtil()
                                                      .getQurhomePrimaryColor()))),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                );
              });
            });
    }
  }

  String removeAllWhitespaces(String string) {
    return string.replaceAll(' ', '');
  }

  String removeAllUnderscores(String string) {
    return string.replaceAll('_', '');
  }

  Future<void> onCardPressed(
    BuildContext? context,
    RegimentDataModel? regimen, {
    String? eventIdReturn,
    String? followEventContext,
    String? activityName,
    dynamic uid,
    dynamic aid,
    dynamic formId,
    dynamic formName,
    bool canEditMain = false,
    bool fromView = false,
    bool isReadyOnly = false,
  }) async {
    stopRegimenTTS();
    var eventId = eventIdReturn ?? regimen!.eid;
    if (eventId == null || eventId == '' || eventId == 0) {
      final response = await Provider.of<RegimentViewModel>(context!,
              listen: false)
          .getEventId(uid: uid, aid: aid, formId: formId, formName: formName);
      if (response != null && response.isSuccess! && response.result != null) {
        print('forEventId: ' + response.toJson().toString());
        eventId = response.result?.eid.toString();
      }
    }
    var canEdit = false;

    canEdit = CommonUtil()
        .canEditRegimen(controller.selectedDate.value, regimen!, context!);

    if (regimen!.ack != null && regimen.ack != "") {
      if (fromView) {
        canEditMain = false;
      }
    }
    final fieldsResponseModel =
        await Provider.of<RegimentViewModel>(context!, listen: false)
            .getFormData(eid: eventId);

    if (fieldsResponseModel.isSuccess! &&
        (fieldsResponseModel.result!.fields!.isNotEmpty ||
            regimen.otherinfo!.toJson().toString().contains('1')) &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentStatus !=
            RegimentStatus.DialogOpened) {
      if (!Get.isRegistered<SheelaBLEController>()) {
        Get.put(SheelaBLEController());
      }
      _sheelaBLEController = Get.find();
      String trimmedTitle = removeAllWhitespaces(regimen.uformname1 ?? "");
      trimmedTitle = removeAllUnderscores(trimmedTitle);
      trimmedTitle = trimmedTitle.toLowerCase();
      if (trimmedTitle.isNotEmpty &&
          KeysForSPO2.contains(
            trimmedTitle,
          )) {
        if (checkCanEdit(regimen)) {
          if (canEditMain || fromView) {
            openFormDataDialog(
              context,
              regimen,
              canEdit,
              eventId,
              fieldsResponseModel,
              eventIdReturn: eventIdReturn,
              followEventContext: followEventContext,
              activityName: activityName,
              uid: uid,
              aid: aid,
              formId: formId,
              formName: formName,
              canEditMain: canEditMain,
              fromView: fromView,
              isReadOnly: isReadyOnly,
            );
            return;
          }
          hubController.eid = regimen.eid;
          hubController.uid = regimen.uid;
          CommonUtil().dialogForScanDevices(
            Get.context!,
            onPressManual: () {
              Get.back();
              _sheelaBLEController.stopTTS();
              _sheelaBLEController.stopScanning();
              redirectToSheelaScreen(regimen);
            },
            onPressCancel: () async {
              Get.back();
              hubController.eid = null;
              hubController.uid = null;
              _sheelaBLEController.stopTTS();
              _sheelaBLEController.stopScanning();
            },
            title: strConnectPulseMeter,
            // Determine the value for 'isVitalsManualRecordingRestricted' based on region
            isVitalsManualRecordingRestricted: CommonUtil.isUSRegion()
                ? PreferenceUtil.getBool(
                    KEY_IS_Vitals_ManualRecording_Restricted)
                : false,
          );
          _sheelaBLEController.isFromRegiment = true;
          _sheelaBLEController.filteredDeviceType = 'spo2';
          _sheelaBLEController.setupListenerForReadings();
        } else {
          onErrorMessage(regimen);
        }
      } else if (trimmedTitle.isNotEmpty &&
          KeysForBP.contains(
            trimmedTitle,
          )) {
        if (checkCanEdit(regimen)) {
          if (canEditMain || fromView) {
            openFormDataDialog(
              context,
              regimen,
              canEdit,
              eventId,
              fieldsResponseModel,
              eventIdReturn: eventIdReturn,
              followEventContext: followEventContext,
              activityName: activityName,
              uid: uid,
              aid: aid,
              formId: formId,
              formName: formName,
              canEditMain: canEditMain,
              fromView: fromView,
              isReadOnly: isReadyOnly,
            );
            return;
          }
          hubController.eid = regimen.eid;
          hubController.uid = regimen.uid;
          CommonUtil().dialogForScanDevices(
            Get.context!,
            onPressManual: () {
              Get.back();
              _sheelaBLEController.stopTTS();
              _sheelaBLEController.stopScanning();
              redirectToSheelaScreen(regimen);
            },
            onPressCancel: () async {
              Get.back();
              hubController.eid = null;
              hubController.uid = null;
              _sheelaBLEController.stopTTS();
              _sheelaBLEController.stopScanning();
            },
            title: strConnectBpMeter,
            // Determine the value for 'isVitalsManualRecordingRestricted' based on region
            isVitalsManualRecordingRestricted: CommonUtil.isUSRegion()
                ? PreferenceUtil.getBool(
                    KEY_IS_Vitals_ManualRecording_Restricted)
                : false,
          );
          _sheelaBLEController.isFromRegiment = true;
          _sheelaBLEController.filteredDeviceType = 'bp';
          _sheelaBLEController.setupListenerForReadings();
        } else {
          onErrorMessage(regimen);
        }
      } else if ((trimmedTitle.isNotEmpty) && (trimmedTitle == "weight")) {
        if (checkCanEdit(regimen)) {
          if (canEditMain || fromView) {
            openFormDataDialog(
              context,
              regimen,
              canEdit,
              eventId,
              fieldsResponseModel,
              eventIdReturn: eventIdReturn,
              followEventContext: followEventContext,
              activityName: activityName,
              uid: uid,
              aid: aid,
              formId: formId,
              formName: formName,
              canEditMain: canEditMain,
              fromView: fromView,
              isReadOnly: isReadyOnly,
            );
            return;
          }
          hubController.eid = regimen.eid;
          hubController.uid = regimen.uid;
          CommonUtil().dialogForScanDevices(
            Get.context!,
            onPressManual: () {
              Get.back();
              _sheelaBLEController.stopTTS();
              _sheelaBLEController.stopScanning();
              redirectToSheelaScreen(regimen);
            },
            onPressCancel: () async {
              Get.back();
              hubController.eid = null;
              hubController.uid = null;
              _sheelaBLEController.stopTTS();
              _sheelaBLEController.stopScanning();
            },
            title: strConnectWeighingScale,
            // Determine the value for 'isVitalsManualRecordingRestricted' based on region
            isVitalsManualRecordingRestricted: CommonUtil.isUSRegion()
                ? PreferenceUtil.getBool(
                    KEY_IS_Vitals_ManualRecording_Restricted)
                : false,
          );
          _sheelaBLEController.isFromRegiment = true;
          _sheelaBLEController.filteredDeviceType = 'weight';
          _sheelaBLEController.setupListenerForReadings();
        } else {
          onErrorMessage(regimen);
        }
      } else if (trimmedTitle.isNotEmpty &&
          KeysForGlucose.contains(
            trimmedTitle,
          )) {
        if (checkCanEdit(regimen)) {
          if (canEditMain || fromView) {
            openFormDataDialog(
              context,
              regimen,
              canEdit,
              eventId,
              fieldsResponseModel,
              eventIdReturn: eventIdReturn,
              followEventContext: followEventContext,
              activityName: activityName,
              uid: uid,
              aid: aid,
              formId: formId,
              formName: formName,
              canEditMain: canEditMain,
              fromView: fromView,
              isReadOnly: isReadyOnly,
            );
            return;
          }
          hubController.eid = regimen.eid;
          hubController.uid = regimen.uid;
          CommonUtil().dialogForScanDevices(
            Get.context!,
            onPressManual: () {
              Get.back();
              _sheelaBLEController.stopTTS();
              _sheelaBLEController.stopScanning();
              redirectToSheelaScreen(regimen);
            },
            onPressCancel: () async {
              Get.back();
              hubController.eid = null;
              hubController.uid = null;
              _sheelaBLEController.stopTTS();
              _sheelaBLEController.stopScanning();
            },
            title: strConnectBGL,
            // Determine the value for 'isVitalsManualRecordingRestricted' based on region
            isVitalsManualRecordingRestricted: CommonUtil.isUSRegion()
                ? PreferenceUtil.getBool(
                    KEY_IS_Vitals_ManualRecording_Restricted)
                : false,
          );
          _sheelaBLEController.isFromRegiment = true;
          _sheelaBLEController.filteredDeviceType = 'bgl';
          _sheelaBLEController.setupListenerForReadings();
        } else {
          onErrorMessage(regimen);
        }
      } else if (trimmedTitle.isNotEmpty && (trimmedTitle == "temperature")) {
        if (checkCanEdit(regimen)) {
          if (canEditMain || fromView) {
            openFormDataDialog(
              context,
              regimen,
              canEdit,
              eventId,
              fieldsResponseModel,
              eventIdReturn: eventIdReturn,
              followEventContext: followEventContext,
              activityName: activityName,
              uid: uid,
              aid: aid,
              formId: formId,
              formName: formName,
              canEditMain: canEditMain,
              fromView: fromView,
              isReadOnly: isReadyOnly,
            );
            return;
          }
          redirectToSheelaScreen(regimen);
        } else {
          onErrorMessage(regimen);
        }
      } else {
        openFormDataDialog(
            context, regimen, canEdit, eventId, fieldsResponseModel,
            eventIdReturn: eventIdReturn,
            followEventContext: followEventContext,
            activityName: activityName,
            uid: uid,
            aid: aid,
            formId: formId,
            formName: formName,
            canEditMain: canEditMain,
            fromView: fromView,
            isReadOnly: isReadyOnly);
      }
    } else if (!regimen.hasform!) {
      FlutterToast().getToast(
        tickInfo,
        Colors.black,
      );
    }
  }

  SheelaAICommonTTSService sheelaController = SheelaAICommonTTSService();

  stopRegimenTTS() {
    sheelaController.stopTTS();
  }

  bool isValidSymptom(BuildContext context) {
    var currentTime = DateTime.now();
    final selectedDate = Provider.of<RegimentViewModel>(context, listen: false)
        .selectedRegimenDate;
    return (Provider.of<RegimentViewModel>(context, listen: false)
                .regimentMode ==
            RegimentMode.Symptoms) &&
        ((selectedDate.year <= currentTime.year)
            ? (selectedDate.month <= currentTime.month
                ? selectedDate.day <= currentTime.day
                : false)
            : false);
  }

  String? getDialogTitle(BuildContext context, RegimentDataModel regimentData,
      String? activityName, bool isTimeNeed) {
    String? title = '';
    if (!(regimentData.asNeeded) &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule) {
      if (activityName != null && activityName != '') {
        title = activityName.capitalizeFirstofEach;
      } else {
        title = isTimeNeed
            ? '${regimentData.estart != null ? DateFormat('hh:mm a').format(regimentData.estart!) : ''},${regimentData.title}'
            : '${regimentData.title}';
      }
    } else {
      if (activityName != null && activityName != '') {
        title = activityName.capitalizeFirstofEach;
      } else {
        title = regimentData.title;
      }
    }
    return title;
  }

  Color getColor(
      Activityname activityname, Uformname uformName, Metadata metadata) {
    Color cardColor;
    try {
      if ((metadata.color?.length ?? 0) == 7) {
        cardColor = Color(int.parse(metadata.color!.replaceFirst('#', '0xFF')));
      } else {
        switch (activityname) {
          case Activityname.DIET:
            cardColor = Colors.green;
            break;
          case Activityname.VITALS:
            if (uformName == Uformname.BLOODPRESSURE) {
              cardColor = Color(0xFF059192);
            } else if (uformName == Uformname.BLOODSUGAR) {
              cardColor = Color(0xFFb70a80);
            } else if (uformName == Uformname.PULSE) {
              cardColor = Color(0xFF8600bd);
            } else {
              cardColor = Colors.lightBlueAccent;
            }
            break;
          case Activityname.MEDICATION:
            cardColor = Colors.blue;
            break;
          case Activityname.SCREENING:
            cardColor = Colors.teal;
            break;
          default:
            cardColor = Color(CommonUtil().getMyPrimaryColor());
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      cardColor = Color(CommonUtil().getMyPrimaryColor());
    }
    return cardColor;
  }

  bool checkCanEdit(RegimentDataModel regimen) {
    var canEdit = false;
    canEdit = CommonUtil()
        .canEditRegimen(controller.selectedDate.value, regimen!, context!);

    return canEdit;
  }

  Future<void> callLogApi(RegimentDataModel regimen) async {
    stopRegimenTTS();

    final canEdit = checkCanEdit(regimen);
    if (canEdit || isValidSymptom(context)) {
      LoaderClass.showLoadingDialog(
        Get.context!,
        canDismiss: false,
      );
      var saveResponse =
          await Provider.of<RegimentViewModel>(context, listen: false)
              .saveFormData(
        eid: regimen.eid,
      );
      if (saveResponse.isSuccess ?? false) {
        FlutterToast().getToast(
          'Logged Successfully',
          Colors.green,
        );
        controller.showCurrLoggedRegimen(regimen);

        LoaderClass.hideLoadingDialog(Get.context!);
      } else {
        LoaderClass.hideLoadingDialog(Get.context!);
      }
    } else {
      onErrorMessage(regimen);
    }
  }

  Future<void> _showErrorAlert(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Info'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(CommonUtil().getQurhomePrimaryColor())),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  initSOSCall() async {
    try {
      //LocationPermission permission;
      bool serviceEnabled = await CommonUtil().checkGPSIsOn();
      if (!serviceEnabled) {
        FlutterToast().getToast(strTurnOnGPS, Colors.red);
        return;
      }
      await controller.getCurrentLocation();
      /*permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          FlutterToast().getToast(
              "Location permissions are denied (actual value: $permission).",
              Colors.red);
          return;
        }
      }*/
      initSOSTimer();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
    }
  }

  /*initGeoLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          FlutterToast().getToast(
              "Location permissions are denied (actual value: $permission).",
              Colors.red);
          return;
        }
      }
      controller.getCurrentLocation();
    } catch (e,stackTrace) {
      print(e);
    }
  }*/

  void initSOSTimer() async {
    try {
      await Future.delayed(Duration(milliseconds: 50));
      controller.updateisShowTimerDialog(true);
      _counter = 0;
      _events = StreamController<int>();
      _events.add(10);
      animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 10),
      );
      animationController!.addListener(() {
        if (animationController!.isAnimating) {
          controller.updateTimerValue(animationController!.value);
        } else {
          controller.updateTimerValue(1.0);
        }
      });
      if (controller.isShowTimerDialog.value) {
        startTimer();
        showSOSTimerDialog(context);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
    }
  }

  void startTimer() {
    try {
      _counter = 10;
      if (_timer != null) {
        _timer!.cancel();
      }
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!_events.isClosed) {
          (_counter > 0) ? _counter-- : _timer!.cancel();
          _events.add(_counter);
          notify();
        } else {
          timer.cancel();
        }
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
    }
  }

  void notify() {
    try {
      if (_counter == 0) {
        callNowSOS();
      }
    } catch (e, stackTrace) {
      print(e);
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  callNowSOS() async {
    try {
      closeDialog();
      FHBUtils().check().then((intenet) async {
        if (intenet != null && intenet) {
          if (CommonUtil().isTablet!) {
            if (!controller.onGoingSOSCall.value) {
              VideoCallCommonUtils.callActions.value = CallActions.CALLING;
              controller.callSOSEmergencyServices(0);
            }
          } else {
            await controller.getSOSAgentNumber(true);
            String strSOSAgentNumber =
                CommonUtil().validString(controller.SOSAgentNumber.value);
            if (strSOSAgentNumber.trim().isNotEmpty) {
              controller.updateSOSAgentCallDialogStatus(true);
              await Get.dialog(
                SOSAgentCallWidget(
                  SOSAgentNumber: strSOSAgentNumber,
                ),
                barrierDismissible: false,
              );
            } else {
              FlutterToast().getToast(
                  CommonUtil()
                      .validString(controller.SOSAgentNumberEmptyMsg.value),
                  Colors.red);
            }
          }
        } else {
          FlutterToast().getToast(STR_NO_CONNECTIVITY, Colors.red);
        }
      });
    } catch (e, stackTrace) {
      print(e);
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  void closeDialog() {
    try {
      if (controller.isShowTimerDialog.value) {
        Navigator.pop(context);
        _events.close();
        controller.updateisShowTimerDialog(false);
      }
    } catch (e, stackTrace) {
      print(e);
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Widget startProgressIndicator(String strText) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: DottedBorder(
            borderType: BorderType.Oval,
            //radius: Radius.circular(20),
            dashPattern: [9, 5],
            color: Color(
              CommonUtil().getQurhomeGredientColor(),
            ),
            strokeWidth: 3,
            child: Container(),
          ),
        ),
        AnimatedBuilder(
          animation: animationController!,
          builder: (context, child) => Container(
            margin: EdgeInsets.only(
              top: 15.00,
              bottom: 15.00,
              left: 10.00,
              right: 10.00,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$strText",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color(
                      CommonUtil().getQurhomeGredientColor(),
                    ),
                  ),
                ),
                Text(
                  sec,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Color(
                      CommonUtil().getQurhomeGredientColor(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  showSOSTimerDialog(BuildContext context) {
    try {
      animationController!.reverse(
          from: animationController!.value == 0
              ? 1.0
              : animationController!.value);
    } catch (e, stackTrace) {
      print(e);
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async => false,
            child: OrientationBuilder(builder: (context, orientation) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                content: StreamBuilder<int>(
                    stream: _events.stream,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      //print(snapshot.data.toString());
                      return Container(
                          width: orientation == Orientation.landscape &&
                                  CommonUtil().isTablet!
                              ? 0.7.sw
                              : 1.sw,
                          height: orientation == Orientation.landscape &&
                                  CommonUtil().isTablet!
                              ? 1.sh / 2
                              : 1.sh / 2.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /*Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        size: 30.0.sp,
                                      ),
                                      onPressed: () {
                                        try {
                                          _closeDialog();
                                        } catch (e,stackTrace) {
                                          print(e);
                                        }
                                      })
                                ],
                              ),*/
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10.0.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            CallingEmergencyServiceIn,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey /*[200]*/,
                                              fontSize: 20.0.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.0.h,
                                      ),
                                      startProgressIndicator(
                                          snapshot.data.toString()),
                                      SizedBox(
                                        height: 45.0.h,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            callNowSOSBtn(),
                                            SizedBox(
                                              width: 15.0.w,
                                            ),
                                            cancelSOSBtn(),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ));
                    }),
              );
            }),
          );
        });
      },
    );
  }

  Widget callNowSOSBtn() {
    final callNowSOSWithGesture = InkWell(
      onTap: () async {
        try {
          callNowSOS();
        } catch (e, stackTrace) {
          print(e);
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
      },
      child: Container(
        width: 110.0.w,
        //height: 40.0.h,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(CommonUtil().getQurhomePrimaryColor()),
          border: Border.all(
            //width: 1.0,
            // assign the color to the border color
            color: Color(CommonUtil().getQurhomePrimaryColor()),
          ),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Center(
          child: Text(
            callNow,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
    return Center(
      child: callNowSOSWithGesture,
    );
  }

  Widget cancelSOSBtn() {
    final cancelSOSWithGesture = InkWell(
      onTap: () async {
        try {
          closeDialog();
        } catch (e, stackTrace) {
          print(e);
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
      },
      child: Container(
        width: 110.0.w,
        //height: 40.0.h,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            //width: 1.0,
            // assign the color to the border color
            color: Color(CommonUtil().getQurhomePrimaryColor()),
          ),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Center(
          child: Text(
            variable.Cancel,
            style: TextStyle(
              color: Color(CommonUtil().getQurhomePrimaryColor()),
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
    return Center(
      child: cancelSOSWithGesture,
    );
  }

  @override
  void dispose() {
    try {
      if (animationController != null) {
        animationController!.removeListener(() {});
        animationController!.dispose();
      }
      _events.close();
      WidgetsBinding.instance!.removeObserver(this);
      super.dispose();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  void redirectToSheelaUnreadMessage() {
    Get.toNamed(
      rt_Sheela,
      arguments: SheelaArgument(showUnreadMessage: true),
    )!
        .then((value) {
      //initSocketCountUnread();
    });
  }

  onErrorMessage(RegimentDataModel regimen) {
    String error = "";
    error = CommonUtil().getErrorMessage(regimen, context);
    if (error.toLowerCase().contains('future activi')) {
      _showErrorAlert(error);
    } else {
      FlutterToast().getToast(
        error,
        Colors.red,
      );
    }
  }

  redirectToSheelaScreen(RegimentDataModel regimen,
      {bool isSurvey = false, bool isRetakeSurvey = false}) {
    Get.toNamed(
      rt_Sheela,
      arguments: SheelaArgument(
          eId: regimen.eid ?? "",
          isSurvey: isSurvey,
          isRetakeSurvey: isRetakeSurvey),
    )?.then((value) => {controller.showCurrLoggedRegimen(regimen)});
  }

  getSheelaIcon(RegimentDataModel regimen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (CommonUtil.isUSRegion() && regimen.activityOrgin != strDiet) {
              // for sheela icon redirection from ack dialog in qurhome regimen
              hubController.eid = regimen.eid;
              hubController.uid = regimen.uid;
              if (checkCanEdit(regimen)) {
                Navigator.pop(context);
                if (regimen.activityOrgin == strSurvey) {
                  redirectToSheelaScreen(regimen, isSurvey: true);
                } else {
                  redirectToSheelaScreen(regimen);
                }
              } else {
                onErrorMessage(regimen);
              }
            } else {
              if (regimen.isPlaying.value) {
                stopRegimenTTS();
                regimen.isPlaying.value = false;
                setState(() {});
              } else {
                stopRegimenTTS();
                regimen.isPlaying.value = true;
                setState(() {});
                await sheelaController.playTTS(regimen.title ?? '', () {
                  sheelaController.stopTTS();
                  regimen.isPlaying.value = false;
                  setState(() {});
                });
              }
            }
          },
          child: CommonUtil.isUSRegion() && regimen.activityOrgin != strDiet
              ? Image.asset(
                  icon_mayaMain,
                  height:
                      CommonUtil().isTablet! ? dialogIconTab : dialogIconMobile,
                  width:
                      CommonUtil().isTablet! ? dialogIconTab : dialogIconMobile,
                )
              : Obx(() {
                  return Icon(
                    (regimen.isPlaying.value)
                        ? Icons.stop_circle_outlined
                        : Icons.play_circle_fill_rounded,
                    size: CommonUtil().isTablet!
                        ? dialogIconTab
                        : dialogIconMobile,
                    color: Color(CommonUtil().getQurhomePrimaryColor()),
                  );
                }),
        ),
      ),
    );
  }

  callQueueCountApi() {
    try {
      if (sheelBadgeController.sheelaIconBadgeCount.value > 0) {
        sheelBadgeController.getSheelaBadgeCount();
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      if (kDebugMode) {
        print(e);
      }
    }
  }

  openFormDataDialog(
    BuildContext? context,
    RegimentDataModel? regimen,
    dynamic canEdit,
    dynamic eventId,
    FieldsResponseModel? fieldsResponseModel, {
    String? eventIdReturn,
    String? followEventContext,
    String? activityName,
    dynamic uid,
    dynamic aid,
    dynamic formId,
    dynamic formName,
    bool canEditMain = false,
    bool fromView = false,
    bool isReadOnly = false,
  }) async {
    try {
      Provider.of<RegimentViewModel>(context!, listen: false)
          .updateRegimentStatus(RegimentStatus.DialogOpened);
      Get.to(FormDataDialog(
        introText: regimen?.otherinfo?.introText ?? '',
        fieldsData: fieldsResponseModel?.result!.fields,
        eid: eventId,
        color: Color(CommonUtil().getQurhomePrimaryColor()),
        mediaData: regimen?.otherinfo,
        formTitle: getDialogTitle(context, regimen!, activityName, true),
        showEditIcon: canEditMain,
        fromView: fromView,
        canEdit: (regimen.otherinfo?.isReadOnlyAccess() ?? false)
            ? false
            : regimen?.ack == null
                ? (canEdit || isValidSymptom(context))
                : canEditMain,
        isFromQurHomeSymptom: false,
        isFromQurHomeRegimen: true,
        triggerAction: (String? triggerEventId, String? followContext,
            String? activityName) {
          Provider.of<RegimentViewModel>(Get.context!, listen: false)
              .updateRegimentStatus(RegimentStatus.DialogClosed);
          Get.back();
          onCardPressed(Get.context, regimen,
              eventIdReturn: triggerEventId,
              followEventContext: followContext,
              activityName: activityName);
        },
        followEventContext: followEventContext,
        uformData: regimen.uformdata,
        isFollowEvent: eventIdReturn != null,
        appBarTitle: getDialogTitle(context, regimen!, activityName, false),
        regimen: regimen,
        isReadOnly: isReadOnly,
      ))?.then(
        (value) {
          if (value != null && (value ?? false)) {
            callQueueCountApi();
            FlutterToast().getToast(
              'Logged Successfully',
              Colors.green,
            );
            controller.showCurrLoggedRegimen(regimen);
          }
        },
      );
      Provider.of<RegimentViewModel>(context, listen: false)
          .updateRegimentStatus(RegimentStatus.DialogClosed);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      if (kDebugMode) {
        print(e);
      }
    }
  }

  onResumeEvent() async {
    try {
      if (appIsInBackground && controller.isSOSAgentCallDialogOpen.value) {
        appIsInBackground = false;
        controller.updateSOSAgentCallDialogStatus(false);
        Get.back();
      }
      var isTimezoneChanged = await TimezoneServices().checkUpdateTimezone(
        isUpdateTimezone: false,
      );
      if (isTimezoneChanged) {
        await controller.getRegimenList(
          isLoading: true,
          date: controller.selectedDate.value.toString(),
        );
        if (CommonUtil.isUSRegion()) {
          final currentTimezone = await TimeZoneHelper.getCurrentTimezone;
          await TimezoneServices().updateTimezone(currentTimezone);
        }
      }
      if (CommonUtil.isUSRegion()) {
        // Record the user's last access time
        CommonUtil().saveUserLastAccessTime();
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  /**
   * Gets the vital value string from the given regimen data model. 
   * Iterates through the regimen's vitals data list and concatenates the values based on description.
   * Handles special cases for weight and temperature values.
   * Returns default "NA" if error.
  */
  getValuesOfVital(RegimentDataModel regimen) {
    String vitalValue = '    ';
    try {
      List<VitalsData> dynamicFieldModelList =
          regimen?.uformdata?.vitalsData ?? [];
      if (dynamicFieldModelList.length > 0) {
        for (int i = 0; i < dynamicFieldModelList.length; i++)
          if (dynamicFieldModelList[i] != null &&
              dynamicFieldModelList[i].value != null &&
              dynamicFieldModelList[i].value != "") {
            if (dynamicFieldModelList[i]?.description?.toLowerCase() ==
                    "weight" ||
                dynamicFieldModelList[i]?.description?.toLowerCase() ==
                    "temperature" ||
                dynamicFieldModelList[i]?.description?.toLowerCase() ==
                    "body temperature") {
              if (dynamicFieldModelList[i]?.description?.toLowerCase() ==
                  "weight") {
                vitalValue +=
                    dynamicFieldModelList[i].value + " " + (weightUnit ?? "");
              } else {
                vitalValue +=
                    dynamicFieldModelList[i].value + " " + (tempUnit ?? "");
              }
            } else {
              vitalValue += dynamicFieldModelList[i].value;
              if (i != dynamicFieldModelList.length - 1) vitalValue += "/";
            }
          }
      } else {
        List<VitalsData> dynamicFieldModelList =
            regimen?.uformdata?.vitalsData ?? [];
        if (dynamicFieldModelList.length > 0) {
          for (int i = 0; i < dynamicFieldModelList.length; i++)
            if (dynamicFieldModelList[i] != null &&
                dynamicFieldModelList[i].value != null &&
                dynamicFieldModelList[i].value != "") {
              if (dynamicFieldModelList[i]?.description?.toLowerCase() ==
                      "weight" ||
                  dynamicFieldModelList[i]?.description?.toLowerCase() ==
                      "temperature" ||
                  dynamicFieldModelList[i]?.description?.toLowerCase() ==
                      "body temperature") {
                if (dynamicFieldModelList[i]?.description?.toLowerCase() ==
                    "weight") {
                  vitalValue +=
                      dynamicFieldModelList[i].value + " " + (weightUnit ?? "");
                } else {
                  vitalValue +=
                      dynamicFieldModelList[i].value + " " + (tempUnit ?? "");
                }
              } else {
                vitalValue += dynamicFieldModelList[i].value;
                if (i != dynamicFieldModelList.length - 1) vitalValue += "/";
              }
            }
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return "NA";
    }
    return vitalValue;
  }
}

class SOSAgentCallWidget extends StatelessWidget {
  SOSAgentCallWidget({
    required this.SOSAgentNumber,
  });

  String SOSAgentNumber;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        /*var regController = Get.find<QurhomeRegimenController>();
        regController.updateSOSAgentCallDialogStatus(false);*/
        return Future.value(false);
      },
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0.sp),
        ),
        contentPadding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 20.0.h,
              right: 20.0.w,
              left: 20.0.w,
            ),
            child: Text(
              strSOSCallDirect,
              style: TextStyle(
                fontSize: 15.0.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0.w,
              vertical: 15.0.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      var regController = Get.find<QurhomeRegimenController>();
                      regController.updateSOSAgentCallDialogStatus(false);
                      Get.back();
                    } catch (e, stackTrace) {
                      print(e);
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        left: 20.0,
                        right: 20.0,
                        bottom: 15.0,
                      ),
                      child: Text(
                        dismiss,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    try {
                      if (await canLaunch('tel:$SOSAgentNumber')) {
                        await launch('tel:$SOSAgentNumber');
                      }
                    } catch (e, stackTrace) {
                      print(e);
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        left: 20.0,
                        right: 20.0,
                        bottom: 15.0,
                      ),
                      child: Text(
                        accept,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                /*Center(
                  child: CallDialWidget(
                    phoneNumber: SOSAgentNumber ?? '',
                    phoneNumberName:
                    SOSAgentNumber ?? '',
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
