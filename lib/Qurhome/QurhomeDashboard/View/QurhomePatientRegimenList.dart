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
import 'package:myfhb/Qurhome/QurhomeDashboard/model/CareGiverPatientList.dart';
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

class QurHomePatientRegimenListScreen extends StatefulWidget {
  bool addAppBar;
  CareGiverPatientListResult? careGiverPatientListResult;

  QurHomePatientRegimenListScreen({
    this.addAppBar = false,
    this.careGiverPatientListResult
  });

  @override
  _QurHomePatientRegimenListScreenState createState() =>
      _QurHomePatientRegimenListScreenState();
}

class _QurHomePatientRegimenListScreenState
    extends State<QurHomePatientRegimenListScreen>
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
      Future.delayed(Duration.zero, () async {
        onInit();
      });

      WidgetsBinding.instance?.addObserver(this);
      controller.timer?.cancel();
      controller.timer = null;
      controller.startTimer(patientId: widget.careGiverPatientListResult!.childId);
      super.initState();
    } catch (e) {
      print(e);
    }
  }

  onInit() async {
    try {
      String strEventId = CommonUtil()
          .validString(qurhomeDashboardController.eventId.value ?? "");
      String strEStart = CommonUtil()
          .validString(qurhomeDashboardController.estart.value ?? "");
      if (CommonUtil.isUSRegion() && strEStart.trim().isNotEmpty) {
        controller.restartTimer();
        await controller.getRegimenList(isLoading: true, date: strEStart, patientId: widget.careGiverPatientListResult!.childId);
      } else {
        await controller.getRegimenList(isLoading: true, patientId: widget.careGiverPatientListResult!.childId);
      }
      await Future.delayed(Duration(milliseconds: 5));

      if (CommonUtil.isUSRegion()) {
        if (strEventId.trim().isNotEmpty &&
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
                strEventId) {
              currRegimen = regimentDataModel;
              if (regimentDataModel.activityOrgin != strAppointmentRegimen) {
                await Future.delayed(Duration(milliseconds: 2000));
                qurhomeDashboardController.eventId.value = "";
                qurhomeDashboardController.estart.value = "";
              }
              break;
            }
          }
          if (currRegimen == null) {
            FlutterToast().getToast(
              activity_removed_regimen,
              Colors.red,
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
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
                                      Get.to(CalendarMonth(patientId:widget.careGiverPatientListResult!.childId))!.then((value) {
                                        controller.restartTimer();
                                        controller.getRegimenList(
                                            isLoading: true, date: value,  patientId: widget.careGiverPatientListResult!.childId);
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
        // if (regimen.activityOrgin != strAppointmentRegimen) {
        //   showRegimenDialog(regimen, itemIndex);
        // }
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

  String removeAllWhitespaces(String string) {
    return string.replaceAll(' ', '');
  }

  String removeAllUnderscores(String string) {
    return string.replaceAll('_', '');
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

  bool checkCanEdit(RegimentDataModel regimen) {
    return regimen.estart!.difference(DateTime.now()).inMinutes <= 15 &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule;
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

  Widget callNowSOSBtn() {
    final callNowSOSWithGesture = InkWell(
      onTap: () async {
        try {
          //callNowSOS();
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
    // Get.toNamed(
    //   rt_Sheela,
    //   arguments: SheelaArgument(showUnreadMessage: true),
    // )!
    //     .then((value) {
    //   initSocketCountUnread();
    // });
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
