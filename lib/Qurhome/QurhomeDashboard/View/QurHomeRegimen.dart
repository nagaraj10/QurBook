import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/QurHub/Controller/HubListViewController.dart';
import 'package:myfhb/Qurhome/Loaders/loader_qurhome.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/CalendarMonth.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/chat_socket/constants/const_socket.dart';
import 'package:myfhb/chat_socket/model/UnreadChatSocketNotify.dart';
import 'package:myfhb/chat_socket/viewModel/chat_socket_view_model.dart';
import 'package:myfhb/chat_socket/viewModel/getx_chat_view_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/regiment/view/widgets/regiment_webview.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'package:myfhb/src/ui/SheelaAI/Services/SheelaAIBLEServices.dart';
import 'package:myfhb/src/ui/SheelaAI/Services/SheelaAICommonTTSServices.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/view/widgets/form_data_dialog.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/reminders/QurPlanReminders.dart';
import 'package:myfhb/reminders/ReminderModel.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/variable_constant.dart' as variable;
import 'dart:convert' as convert;
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';

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

  @override
  void initState() {
    try {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        controller.dateHeader.value = controller.getFormatedDate();
      });

      controller.currLoggedEID.value = "";
      controller.isFirstTime.value = true;
      onInit();
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
      initSocketCountUnread();
      WidgetsBinding.instance?.addObserver(this);
      controller.timer?.cancel();
      controller.timer = null;
      controller.startTimer();
      qurhomeDashboardController.isQurhomeRegimenScreenActive.value = true;
      super.initState();
    } catch (e) {
      print(e);
    }
  }

  onInit() async {
    try {
      await controller.getRegimenList(
          isLoading: true, date: "2023-05-15");
      qurhomeDashboardController.enableModuleAccess();
      qurhomeDashboardController.getModuleAccess();
      if (CommonUtil.isUSRegion()) {
        if (qurhomeDashboardController.eventId.value != null &&
            qurhomeDashboardController.eventId.value.trim().isNotEmpty &&
            controller.qurHomeRegimenResponseModel?.regimentsList != null &&
            (controller.qurHomeRegimenResponseModel?.regimentsList?.length ??
                    0) >
                0) {
          RegimentDataModel? currRegimen = null;
          for (int i = 0;
              i < controller.qurHomeRegimenResponseModel!.regimentsList!.length;
              i++) {
            RegimentDataModel regimentDataModel =
                controller.qurHomeRegimenResponseModel!.regimentsList![i];
            if ((regimentDataModel.eid ?? "").toString().toLowerCase() ==
                qurhomeDashboardController.eventId.value) {
              currRegimen = regimentDataModel;
              if (regimentDataModel.activityOrgin != strAppointmentRegimen) {
                showRegimenDialog(regimentDataModel, i);
                await Future.delayed(Duration(milliseconds: 10));
                qurhomeDashboardController.eventId.value = "";
                qurhomeDashboardController.estart.value = "";
              }
              break;
            }
          }
          if (currRegimen == null) {
            controller.restartTimer();
            controller.getRegimenList(
                isLoading: true, date: qurhomeDashboardController.estart.value);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  initSocketCountUnread() {
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
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (appIsInBackground && controller.isSOSAgentCallDialogOpen.value) {
          appIsInBackground = false;
          controller.updateSOSAgentCallDialogStatus(false);
          Get.back();
        }
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
        onPanCancel: () {
          if (CommonUtil.isUSRegion()) {
            controller.restartTimer();
          }
        },
        // onTapDown: (tapDownDetails) {
        //   print('onTapDown');
        //
        // },
        // onTapUp: (tapUpDetails) {
        //   print('onTapUp');
        //
        // },
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
          body: Stack(
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
                                      controller.cancelTimer();
                                      Get.to(CalendarMonth())!.then((value) {
                                        controller.restartTimer();
                                        controller.getRegimenList(
                                            isLoading: true, date: value);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        icon_calendar,
                                        height: 26,
                                        width: 26,
                                      ),
                                    )),
                              ),
                            )
                          : Container(),
                      Container(
                          child: Expanded(
                        child: CommonUtil.isUSRegion()
                            ? GetBuilder<QurhomeRegimenController>(
                                id: "refershStatusText",
                                builder: (val) {
                                  return Visibility(
                                      visible:
                                          !controller.isTodaySelected.value,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 2000),
                                        curve: Curves.fastOutSlowIn,
                                        opacity:
                                            !controller.isTodaySelected.value
                                                ? 1
                                                : 0,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Card(
                                              color: Colors.grey,
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  controller.statusText.value,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11),
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
                        GestureDetector(
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
                            } catch (e) {
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
                        ),
                    ],
                  ),
                ),
              ),
              Obx(() => controller.loadingData.isTrue
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
                      })),
            ],
          ),
        ));
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
                ),
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

  Color getCardBackgroundColor(int itemIndex, int nextRegimenPosition) {
    if (controller.currentIndex == itemIndex) {
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
      return Color(
        CommonUtil().getQurhomePrimaryColor(),
      );
    } else if (nextRegimenPosition == itemIndex) {
      return Colors.white;
    } else {
      return Colors.grey;
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return InkWell(
      onTap: () {
        if (regimen.activityOrgin != strAppointmentRegimen) {
          showRegimenDialog(regimen, itemIndex);
        }
      },
      child: Transform.scale(
        scale: getCurrentRatio(itemIndex),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  isPortrait ? 25.0 : MediaQuery.of(context).size.width / 5,
              vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: getCardBackgroundColor(itemIndex, nextRegimenPosition),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Stack(
                children: [
                  if (regimen.ack != null) ...{
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Visibility(
                        visible: regimen.ack != null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/Qurhome/seen.png',
                              height: 12.0,
                              width: 12.0,
                              color: getTextAndIconColor(
                                  itemIndex, nextRegimenPosition),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            CommonUtil.isUSRegion()
                                ? SizedBox()
                                : Text(
                                    '${CommonUtil().regimentDateFormatV2(
                                      regimen.asNeeded
                                          ? regimen.ack ?? DateTime.now()
                                          : regimen.ack ?? DateTime.now(),
                                      isAck: true,
                                    )}',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      color: getTextAndIconColor(
                                          itemIndex, nextRegimenPosition),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  },
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          regimen.estart != null
                              ? DateFormat('hh:mm a').format(regimen.estart!)
                              : '',
                          style: TextStyle(
                              color: getTextAndIconColor(
                                  itemIndex, nextRegimenPosition),
                              fontSize: 15.h,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        getIcon(regimen.activityname, regimen.uformname,
                            regimen.metadata, itemIndex, nextRegimenPosition),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            strTitle.trim().isNotEmpty
                                ? strTitle
                                : regimen.title.toString().trim(),
                            maxLines: 2,
                            style: TextStyle(
                                color: getTextAndIconColor(
                                    itemIndex, nextRegimenPosition),
                                fontSize: 16.h,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
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

  dynamic getIcon(Activityname? activityname, Uformname? uformName,
      Metadata? metadata, int itemIndex, int nextRegimenPosition,
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
              return getDefaultIcon(activityname, uformName, iconSize,
                  itemIndex, nextRegimenPosition);
            },
          );
        }
      } else {
        return getDefaultIcon(
            activityname, uformName, iconSize, itemIndex, nextRegimenPosition);
      }
    } catch (e) {
      return getDefaultIcon(
          activityname, uformName, iconSize, itemIndex, nextRegimenPosition);
    }
  }

  dynamic getDefaultIcon(
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
        cardIcon = 'assets/Qurhome/Qurhome.png';
    }
    var cardIconWidget = (cardIcon is String)
        ? Image.asset(
            cardIcon,
            height: isDefault ? iconSize : iconSize - 5.0,
            width: isDefault ? iconSize : iconSize - 5.0,
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
    } catch (e) {
      try {
        first = title.split("|").first;
      } catch (e) {
        first = title;
      }
    }
    try {
      int startSecond = title.indexOf("[") + 1;
      int lengthSecond = title.indexOf("]");
      if (startSecond != null) {
        second = title.substring(startSecond, lengthSecond);
      }
    } catch (e) {}

    return first + second;
  }

  showRegimenDialog(RegimentDataModel regimen, int index) {
    if (regimen.ack == null)
      showDialog(
          context: context,
          builder: (__) {
            return StatefulBuilder(builder: (_, setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            padding: EdgeInsets.all(8.0),
                            icon: Icon(
                              Icons.close,
                              size: 30.0.sp,
                            ),
                            onPressed: () {
                              try {
                                Navigator.pop(context);
                              } catch (e) {
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
                          getIcon(regimen.activityname, regimen.uformname,
                              regimen.metadata, index, 0,
                              sizeOfIcon: 30),
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
                                      CommonUtil().getQurhomeGredientColor(),
                                    ),
                                    fontSize: 16,
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ])),
                          if (regimen.activityOrgin != strAppointmentRegimen)
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
                            if ((CommonUtil.isUSRegion()) &&
                                (regimen.activityOrgin != strDiet) &&
                                (regimen.activityOrgin == strSurvey)) {
                              if (checkCanEdit(regimen)) {
                                redirectToSheelaScreen(regimen, isSurvey: true);
                              } else {
                                onErrorMessage();
                              }
                            } else {
                              if (regimen.hasform!) {
                                onCardPressed(context, regimen,
                                    aid: regimen.aid,
                                    uid: regimen.uid,
                                    formId: regimen.uformid,
                                    formName: regimen.uformname);
                              } else {
                                callLogApi(regimen);
                              }
                            }
                          },
                          child: Image.asset(
                            'assets/Qurhome/accept.png',
                            height: 50,
                            width: 50,
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
                                height: 50,
                                width: 50,
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
                        reminder.activityname = regimen.activityname.toString();
                        reminder.title = regimen.title.toString();
                        reminder.description = regimen.description.toString();
                        reminder.eid = regimen.eid.toString();
                        reminder.estart = regimen.estart!
                            .add(Duration(minutes: int.parse(time[0])))
                            .toString();
                        reminder.remindin = regimen.remindin.toString();
                        reminder.remindbefore = regimen.remindin.toString();
                        List<Reminder> data = [reminder];
                        String snoozedText =
                            "Snoozed for ${int.parse(time[0]).toString()} minutes";
                        final snoozedBody = {};
                        snoozedBody['eid'] = regimen.eid.toString();
                        snoozedBody['snoozeText'] = snoozedText;
                        final jsonString = convert.jsonEncode(snoozedBody);
                        try {
                          QurHomeApiProvider.snoozeEvent(jsonString);
                        } catch (e) {}
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
              );
            });
          });
    else {
      final iconSize = 50.0.sp;
      if (CommonUtil.REGION_CODE != "IN")
        showDialog(
            context: context,
            builder: (__) {
              return StatefulBuilder(builder: (_, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              padding: EdgeInsets.all(8.0),
                              icon: Icon(
                                Icons.close,
                                size: 30.0.sp,
                              ),
                              onPressed: () {
                                try {
                                  Navigator.pop(context);
                                } catch (e) {
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
                              getIcon(regimen.activityname, regimen.uformname,
                                  regimen.metadata, index, 0,
                                  sizeOfIcon: 30),
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
                                        fontSize: 16,
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
                                        fontSize: 16,
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
                            Text(strRecorded,
                                style: TextStyle(
                                    fontSize: 24.0.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400)),
                            Text(
                              '${CommonUtil().regimentDateFormat(
                                regimen.asNeeded
                                    ? regimen.ack_local ?? DateTime.now()
                                    : regimen.ack_local ?? DateTime.now(),
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
                                    Future.delayed(Duration(milliseconds: 300),
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
                                              color: (regimen?.hasform == false)
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

  Future<void> onCardPressed(BuildContext? context, RegimentDataModel? regimen,
      {String? eventIdReturn,
      String? followEventContext,
      String? activityName,
      dynamic uid,
      dynamic aid,
      dynamic formId,
      dynamic formName,
      bool canEditMain = false,
      bool fromView = false}) async {
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
    var canEdit = regimen!.estart!.difference(DateTime.now()).inMinutes <= 15 &&
        Provider.of<RegimentViewModel>(context!, listen: false).regimentMode ==
            RegimentMode.Schedule;

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
      String trimmedTitle = removeAllWhitespaces(regimen.title);
      trimmedTitle = removeAllUnderscores(trimmedTitle);
      trimmedTitle = trimmedTitle.toLowerCase();
      if (trimmedTitle.isNotEmpty &&
          KeysForSPO2.contains(
            trimmedTitle,
          )) {
        if (checkCanEdit(regimen)) {
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
            isFromVital: false,
          );
          _sheelaBLEController.isFromRegiment = true;
          _sheelaBLEController.filteredDeviceType = 'spo2';
          _sheelaBLEController.setupListenerForReadings();
        } else {
          onErrorMessage();
        }
      } else if (trimmedTitle.isNotEmpty &&
          KeysForBP.contains(
            trimmedTitle,
          )) {
        if (checkCanEdit(regimen)) {
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
            isFromVital: false,
          );
          _sheelaBLEController.isFromRegiment = true;
          _sheelaBLEController.filteredDeviceType = 'bp';
          _sheelaBLEController.setupListenerForReadings();
        } else {
          onErrorMessage();
        }
      } else if ((trimmedTitle.isNotEmpty) && (trimmedTitle == "weight")) {
        if (checkCanEdit(regimen)) {
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
            isFromVital: false,
          );
          _sheelaBLEController.isFromRegiment = true;
          _sheelaBLEController.filteredDeviceType = 'weight';
          _sheelaBLEController.setupListenerForReadings();
        } else {
          onErrorMessage();
        }
      } else if (trimmedTitle.isNotEmpty &&
          KeysForGlucose.contains(
            trimmedTitle,
          )) {
        if (checkCanEdit(regimen)) {
          redirectToSheelaScreen(regimen);
        } else {
          onErrorMessage();
        }
      } else if (trimmedTitle.isNotEmpty && (trimmedTitle == "temperature")) {
        if (checkCanEdit(regimen)) {
          redirectToSheelaScreen(regimen);
        } else {
          onErrorMessage();
        }
      } else {
        Provider.of<RegimentViewModel>(context, listen: false)
            .updateRegimentStatus(RegimentStatus.DialogOpened);
        controller.cancelTimer();
        Get.to(FormDataDialog(
          introText: regimen.otherinfo?.introText ?? '',
          fieldsData: fieldsResponseModel.result!.fields,
          eid: eventId,
          color: Color(CommonUtil().getQurhomePrimaryColor()),
          mediaData: regimen.otherinfo,
          formTitle: getDialogTitle(context, regimen, activityName),
          showEditIcon: canEditMain,
          fromView: fromView,
          canEdit: regimen?.ack == null
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
        ))?.then(
          (value) {
            if (value != null && (value ?? false)) {
              FlutterToast().getToast(
                'Logged Successfully',
                Colors.green,
              );
              controller.showCurrLoggedRegimen(regimen);
            }
          },
        );

        /*var value = await showDialog(
          context: context,
          builder: (_) => FormDataDialog(
            introText: regimen.otherinfo?.introText ?? '',
            fieldsData: fieldsResponseModel.result!.fields,
            eid: eventId,
            color: Color(CommonUtil().getQurhomePrimaryColor()),
            mediaData: regimen.otherinfo,
            formTitle: getDialogTitle(context, regimen, activityName),
            canEdit: canEdit || isValidSymptom(context),
            isFromQurHomeSymptom: false,
            isFromQurHomeRegimen: true,
            triggerAction: (String? triggerEventId, String? followContext,
                String? activityName) {
              Provider.of<RegimentViewModel>(Get.context!, listen: false)
                  .updateRegimentStatus(RegimentStatus.DialogClosed);
              Get.back();
              onCardPressed(Get.context!, regimen,
                  eventIdReturn: triggerEventId,
                  followEventContext: followContext,
                  activityName: activityName);
            },
            followEventContext: followEventContext!,
            isFollowEvent: eventIdReturn != null,
          ),
        );*/

        QurPlanReminders.getTheRemindersFromAPI();

        Provider.of<RegimentViewModel>(context, listen: false)
            .updateRegimentStatus(RegimentStatus.DialogClosed);
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
      String? activityName) {
    String? title = '';
    if (!(regimentData.asNeeded) &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule) {
      if (activityName != null && activityName != '') {
        title = activityName.capitalizeFirstofEach;
      } else {
        title =
            '${regimentData.estart != null ? DateFormat('hh:mm a').format(regimentData.estart!) : ''},${regimentData.title}';
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
    } catch (e) {
      cardColor = Color(CommonUtil().getMyPrimaryColor());
    }
    return cardColor;
  }

  bool checkCanEdit(RegimentDataModel regimen) {
    return regimen.estart!.difference(DateTime.now()).inMinutes <= 15 &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule;
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
      onErrorMessage();
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
        FlutterToast().getToast(
            'Please turn on your GPS location services and try again',
            Colors.red);
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
      print(e);
    }
  }

  void notify() {
    try {
      if (_counter == 0) {
        callNowSOS();
      }
    } catch (e) {
      print(e);
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
    } catch (e) {
      print(e);
    }
  }

  void closeDialog() {
    try {
      if (controller.isShowTimerDialog.value) {
        Navigator.pop(context);
        _events.close();
        controller.updateisShowTimerDialog(false);
      }
    } catch (e) {
      print(e);
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
    } catch (e) {
      print(e);
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
                                        } catch (e) {
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
        } catch (e) {
          print(e);
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
        } catch (e) {
          print(e);
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
    } catch (e) {
      print(e);
    }
  }

  void redirectToSheelaUnreadMessage() {
    Get.toNamed(
      rt_Sheela,
      arguments: SheelaArgument(showUnreadMessage: true),
    )!
        .then((value) {
      initSocketCountUnread();
    });
  }

  onErrorMessage() {
    if (((Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
                RegimentMode.Symptoms)
            ? symptomsError
            : activitiesError)
        .toLowerCase()
        .contains('future activi')) {
      _showErrorAlert((Provider.of<RegimentViewModel>(context, listen: false)
                  .regimentMode ==
              RegimentMode.Symptoms)
          ? symptomsError
          : activitiesError);
    } else {
      FlutterToast().getToast(
        (Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
                RegimentMode.Symptoms)
            ? symptomsError
            : activitiesError,
        Colors.red,
      );
    }
  }

  redirectToSheelaScreen(RegimentDataModel regimen, {bool isSurvey = false}) {
    Get.toNamed(
      rt_Sheela,
      arguments: SheelaArgument(eId: regimen.eid ?? "", isSurvey: isSurvey),
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
              if (checkCanEdit(regimen)) {
                Navigator.pop(context);
                if (regimen.activityOrgin == strSurvey) {
                  redirectToSheelaScreen(regimen, isSurvey: true);
                } else {
                  redirectToSheelaScreen(regimen);
                }
              } else {
                onErrorMessage();
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
                  height: CommonUtil().isTablet! ? 60 : 50,
                  width: CommonUtil().isTablet! ? 60 : 50,
                )
              : Obx(() {
                  return Icon(
                    (regimen.isPlaying.value)
                        ? Icons.stop_circle_outlined
                        : Icons.play_circle_fill_rounded,
                    size: 30.0,
                    color: Color(CommonUtil().getQurhomePrimaryColor()),
                  );
                }),
        ),
      ),
    );
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
                    } catch (e) {
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
                    } catch (e) {
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
