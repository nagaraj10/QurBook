import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeRegimenResponseModel.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/src/ui/bot/view/sheela_arguments.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/models/regiment_qurhub_response_model.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/regiment/view/widgets/form_data_dialog.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/reminders/QurPlanReminders.dart';
import 'package:myfhb/reminders/ReminderModel.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:provider/provider.dart';

class QurHomeRegimenScreen extends StatefulWidget {
  const QurHomeRegimenScreen({Key key}) : super(key: key);

  @override
  _QurHomeRegimenScreenState createState() => _QurHomeRegimenScreenState();
}

class _QurHomeRegimenScreenState extends State<QurHomeRegimenScreen> {
  final controller = Get.put(QurhomeRegimenController());
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);
  String snoozeValue = "5 mins";
  List<RegimentDataModel> regimenList = [];

  var qurhomeDashboardController = Get.find<QurhomeDashboardController>();

  @override
  void initState() {
    controller.getRegimenList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Stack(
        children: [
          Align(
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
          Obx(() => controller.loadingData.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GetBuilder<QurhomeRegimenController>(
                  id: "newUpdate",
                  builder: (val) {
                    print("working builder");
                    return val.qurHomeRegimenResponseModel == null
                        ? const Center(
                            child: Text(
                              'Please re-try after some time',
                            ),
                          )
                        : val.qurHomeRegimenResponseModel.regimentsList
                                    .length !=
                                0
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 50.0),
                                child: Container(
                                  child: PageView.builder(
                                    itemCount: val.qurHomeRegimenResponseModel
                                        .regimentsList.length,
                                    scrollDirection: Axis.vertical,
                                    onPageChanged: (int index) {
                                      setState(() {
                                        controller.currentIndex = index;
                                      });
                                    },
                                    controller: PageController(
                                        initialPage: val.nextRegimenPosition,
                                        viewportFraction: 1 / (isPortrait==true?5:3)),
                                    itemBuilder:
                                        (BuildContext context, int itemIndex) {
                                      return _buildCarouselItem(
                                          context,
                                          itemIndex,
                                          val.qurHomeRegimenResponseModel
                                              .regimentsList[itemIndex],
                                          val.nextRegimenPosition,
                                          isPortrait);
                                    },
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'No activities scheduled today',
                                ),
                              );
                  })),
        ],
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
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
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
      RegimentDataModel regimen, int nextRegimenPosition,bool isPortrait) {
    return InkWell(
      onTap: () {
        showRegimenDialog(regimen, itemIndex);
      },
      child: Transform.scale(
        scale: getCurrentRatio(itemIndex),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isPortrait?25.0:MediaQuery.of(context).size.width/5, vertical: 8.0),
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
                            Text(
                              '${CommonUtil().regimentDateFormatV2(
                                regimen?.asNeeded
                                    ? regimen?.ack ?? DateTime.now()
                                    : regimen?.ack ?? DateTime.now(),
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
                              ? DateFormat('hh:mm a').format(regimen.estart)
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
                            regimen.title.toString().trim(),
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

  dynamic getIcon(Activityname activityname, Uformname uformName,
      Metadata metadata, int itemIndex, int nextRegimenPosition,
      {double sizeOfIcon}) {
    final iconSize = sizeOfIcon ?? 40.0.h;
    try {
      if (metadata?.icon != null) {
        if (metadata?.icon?.toLowerCase()?.contains('.svg') ?? false) {
          return SvgPicture.network(
            metadata?.icon,
            height: iconSize,
            width: iconSize,
            color: getTextAndIconColor(itemIndex, nextRegimenPosition),
          );
        } else {
          return CachedNetworkImage(
            imageUrl: metadata?.icon,
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
    Activityname activityname,
    Uformname uformName,
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
    showDialog(
        context: context,
        builder: (__) {
          return StatefulBuilder(builder: (_, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
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
                                  ? DateFormat('hh:mm a').format(regimen.estart)
                                  : '',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ])),
                        if (regimen?.activityOrgin != strAppointmentRegimen)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (regimen.isPlaying) {
                                    stopRegimenTTS();
                                    regimen.isPlaying = false;
                                    setState(() {});
                                  } else {
                                    stopRegimenTTS();
                                    regimen.isPlaying = true;
                                    setState(() {});
                                    Provider.of<ChatScreenViewModel>(
                                            Get.context,
                                            listen: false)
                                        ?.startTTSEngine(
                                      textToSpeak: regimen?.title ?? '',
                                      dynamicText:
                                          regimen?.sayTextDynamic ?? '',
                                      isRegiment: true,
                                      onStop: () {
                                        stopRegimenTTS();
                                        regimen.isPlaying = false;
                                        setState(() {});
                                      },
                                    );
                                  }
                                },
                                child: Icon(
                                  regimen.isPlaying
                                      ? Icons.stop_circle_outlined
                                      : Icons.play_circle_fill_rounded,
                                  size: 30.0,
                                  color: Color(
                                      CommonUtil().getQurhomePrimaryColor()),
                                ),
                              ),
                            ),
                          ),
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
                          if (regimen.hasform) {
                            onCardPressed(context, regimen,
                                aid: regimen.aid,
                                uid: regimen.uid,
                                formId: regimen.uformid,
                                formName: regimen.uformname);
                          } else {
                            callLogApi(regimen);
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
                                onChanged: (String newValue) {
                                  setState(() {
                                    snoozeValue = newValue;
                                  });
                                },
                                items: <String>[
                                  '5 mins',
                                  '10 mins',
                                  '15 mins',
                                  '20 mins'
                                ].map<DropdownMenuItem<String>>((String value) {
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
                      var time = snoozeValue.split(" ");
                      Reminder reminder = Reminder();
                      reminder.uformname = regimen.uformname.toString();
                      reminder.activityname = regimen.activityname.toString();
                      reminder.title = regimen.title.toString();
                      reminder.description = regimen.description.toString();
                      reminder.eid = regimen.eid.toString();
                      reminder.estart = regimen.estart
                          .add(Duration(minutes: int.parse(time[0])))
                          .toString();
                      reminder.remindin = regimen.remindin.toString();
                      reminder.remindbefore = regimen.remindin.toString();
                      List<Reminder> data = [reminder];
                      QurPlanReminders.updateReminderswithLocal(data);
                      Navigator.pop(context);
                    },
                    child: Text('Snooze'),
                    style: ElevatedButton.styleFrom(
                        primary: Color(CommonUtil().getQurhomePrimaryColor())),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          });
        });
  }

  String removeAllWhitespaces(String string) {
    return string.replaceAll(' ', '');
  }

  Future<void> onCardPressed(BuildContext context, RegimentDataModel regimen,
      {String eventIdReturn,
      String followEventContext,
      dynamic uid,
      dynamic aid,
      dynamic formId,
      dynamic formName}) async {
    stopRegimenTTS();
    var eventId = eventIdReturn ?? regimen.eid;
    if (eventId == null || eventId == '' || eventId == 0) {
      final response = await Provider.of<RegimentViewModel>(context,
              listen: false)
          .getEventId(uid: uid, aid: aid, formId: formId, formName: formName);
      if (response != null && response?.isSuccess && response?.result != null) {
        print('forEventId: ' + response.toJson().toString());
        eventId = response?.result?.eid.toString();
      }
    }
    var canEdit = regimen.estart.difference(DateTime.now()).inMinutes <= 15 &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule;
    // if (canEdit || isValidSymptom(context)) {
    final fieldsResponseModel =
        await Provider.of<RegimentViewModel>(context, listen: false)
            .getFormData(eid: eventId);

    if (fieldsResponseModel.isSuccess &&
        (fieldsResponseModel.result.fields.isNotEmpty ||
            regimen.otherinfo.toJson().toString().contains('1')) &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentStatus !=
            RegimentStatus.DialogOpened) {
      var dashboardController = Get.find<QurhomeDashboardController>();
      if (((regimen.title ?? '').isNotEmpty) &&
          ((removeAllWhitespaces(regimen.title).toLowerCase() == "spo2") ||
              (removeAllWhitespaces(regimen.title).toLowerCase() == "pulse"))) {
        if(checkCanEdit(regimen)){
          var dashboardController = Get.find<QurhomeDashboardController>();
          dashboardController.checkForConnectedDevices(
            false,
            eid: regimen.eid,
            uid: regimen.uid,
          );
        }else{
          FlutterToast().getToast(
            (Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
                RegimentMode.Symptoms)
                ? symptomsError
                : activitiesError,
            Colors.red,
          );
        }

      } else if (((regimen.title ?? '').isNotEmpty) &&
          (removeAllWhitespaces(regimen.title).toLowerCase() ==
              "bloodpressure")) {
        Get.toNamed(
          rt_Sheela,
          arguments: SheelaArgument(
            eId: regimen.eid,
          ),
        ).then((value) => {controller.getRegimenList()});
        /*if(checkCanEdit(regimen)){
          var dashboardController = Get.find<QurhomeDashboardController>();
          dashboardController.getGPSCheckStartBP();
        }else{
          FlutterToast().getToast(
            (Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
                RegimentMode.Symptoms)
                ? symptomsError
                : activitiesError,
            Colors.red,
          );
        }*/

      } else if (((regimen.title ?? '').isNotEmpty) &&
          (removeAllWhitespaces(regimen.title).toLowerCase() == "weight")) {
        if(checkCanEdit(regimen)){
          Get.toNamed(
            rt_Sheela,
            arguments: SheelaArgument(
              eId: regimen.eid,
            ),
          ).then((value) => {controller.getRegimenList()});
        }else{
          FlutterToast().getToast(
            (Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
                RegimentMode.Symptoms)
                ? symptomsError
                : activitiesError,
            Colors.red,
          );
        }

      } else if (((regimen.title ?? '').isNotEmpty) &&
          (removeAllWhitespaces(regimen.title).toLowerCase() == "bloodsugar")) {
        if(checkCanEdit(regimen)){
          Get.toNamed(
            rt_Sheela,
            arguments: SheelaArgument(
              eId: regimen.eid,
            ),
          ).then((value) => {controller.getRegimenList()});
        }else{
          FlutterToast().getToast(
            (Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
                RegimentMode.Symptoms)
                ? symptomsError
                : activitiesError,
            Colors.red,
          );
        }

      } else if (((regimen.title ?? '').isNotEmpty) &&
          (removeAllWhitespaces(regimen.title).toLowerCase() ==
              "temperature")) {
        if(checkCanEdit(regimen)){
          Get.toNamed(
            rt_Sheela,
            arguments: SheelaArgument(
              eId: regimen.eid,
            ),
          ).then((value) => {controller.getRegimenList()});
        }else{
          FlutterToast().getToast(
            (Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
                RegimentMode.Symptoms)
                ? symptomsError
                : activitiesError,
            Colors.red,
          );
        }

      } else {
        Provider.of<RegimentViewModel>(context, listen: false)
            .updateRegimentStatus(RegimentStatus.DialogOpened);
        var value = await showDialog(
          context: context,
          builder: (_) => FormDataDialog(
            fieldsData: fieldsResponseModel.result.fields,
            eid: eventId,
            color: Color(CommonUtil().getQurhomePrimaryColor()),
            mediaData: regimen.otherinfo,
            formTitle: getDialogTitle(context, regimen),
            canEdit: canEdit || isValidSymptom(context),
            isFromQurHomeSymptom: false,
            isFromQurHomeRegimen: true,
            triggerAction: (String triggerEventId, String followContext) {
              Provider.of<RegimentViewModel>(Get.context, listen: false)
                  .updateRegimentStatus(RegimentStatus.DialogClosed);
              Get.back();
              onCardPressed(
                Get.context,
                regimen,
                eventIdReturn: triggerEventId,
                followEventContext: followContext,
              );
            },
            followEventContext: followEventContext,
            isFollowEvent: eventIdReturn != null,
          ),
        );
        if (value != null && (value ?? false)) {
          // LoaderClass.showLoadingDialog(
          //   Get.context,
          //   canDismiss: false,
          // );
          // Future.delayed(Duration(milliseconds: 300), () async {
          //   await Provider.of<RegimentViewModel>(context, listen: false)
          //       .fetchRegimentData();
          //   LoaderClass.hideLoadingDialog(Get.context);
          // });
          controller.getRegimenList();
        }

        Provider.of<RegimentViewModel>(context, listen: false)
            .updateRegimentStatus(RegimentStatus.DialogClosed);
      }
    } else if (!regimen.hasform) {
      FlutterToast().getToast(
        tickInfo,
        Colors.black,
      );
    }
  }

  stopRegimenTTS() {
    Provider.of<RegimentViewModel>(Get.context, listen: false).stopRegimenTTS();
  }

  bool isValidSymptom(BuildContext context) {
    var currentTime = DateTime.now();
    final selectedDate = Provider.of<RegimentViewModel>(context, listen: false)
        .selectedRegimenDate;
    return (Provider.of<RegimentViewModel>(context, listen: false)
                .regimentMode ==
            RegimentMode.Symptoms) &&
        ((selectedDate?.year <= currentTime.year)
            ? (selectedDate?.month <= currentTime.month
                ? selectedDate?.day <= currentTime.day
                : false)
            : false);
  }

  String getDialogTitle(BuildContext context, RegimentDataModel regimentData) {
    String title = '';
    if (!(regimentData?.asNeeded ?? false) &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule) {
      title =
          '${regimentData?.estart != null ? DateFormat('hh:mm a').format(regimentData.estart) : ''},${regimentData.title}';
    } else {
      title = regimentData.title;
    }
    return title;
  }

  Color getColor(
      Activityname activityname, Uformname uformName, Metadata metadata) {
    Color cardColor;
    try {
      if ((metadata?.color?.length ?? 0) == 7) {
        cardColor = Color(int.parse(metadata?.color.replaceFirst('#', '0xFF')));
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

  bool checkCanEdit(RegimentDataModel regimen){
    return regimen.estart.difference(DateTime.now()).inMinutes <= 15 &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule;
  }

  Future<void> callLogApi(RegimentDataModel regimen) async {
    stopRegimenTTS();

    final canEdit = checkCanEdit(regimen);
    if (canEdit || isValidSymptom(context)) {
      LoaderClass.showLoadingDialog(
        Get.context,
        canDismiss: false,
      );
      var saveResponse =
          await Provider.of<RegimentViewModel>(context, listen: false)
              .saveFormData(
        eid: regimen.eid,
      );
      if (saveResponse?.isSuccess ?? false) {
        FlutterToast().getToast(
          'Logged Successfully',
          Colors.red,
        );
        controller.getRegimenList();

        LoaderClass.hideLoadingDialog(Get.context);
      } else {
        LoaderClass.hideLoadingDialog(Get.context);
      }
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
