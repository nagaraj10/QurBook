import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeRegimenResponseModel.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/models/regiment_qurhub_response_model.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/regiment/view/widgets/form_data_dialog.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
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

  List<RegimentDataModel> regimenList = [];

  @override
  void initState() {
    controller.getRegimenList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.loadingData.isTrue
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
                    : val.qurHomeRegimenResponseModel.regimentsList.length != 0
                        ? Container(
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
                                  viewportFraction: 0.15),
                              itemBuilder:
                                  (BuildContext context, int itemIndex) {
                                return _buildCarouselItem(
                                    context,
                                    10,
                                    itemIndex,
                                    val.qurHomeRegimenResponseModel
                                        .regimentsList[itemIndex],
                                    val.nextRegimenPosition);
                              },
                            ),
                          )
                        : const Center(
                            child: Text(
                              'No activities scheduled today',
                            ),
                          );
              })),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int carouselIndex,
      int itemIndex, RegimentDataModel regimen, int nextRegimenPosition) {
    return InkWell(
      onTap: () {
        showRegimenDialog(regimen,itemIndex);
      },
      child: Transform.scale(
        scale: controller.currentIndex == itemIndex ? 1 : 0.9,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    regimen.estart != null
                        ? DateFormat('hh:mm a').format(regimen.estart)
                        : '',
                    style: TextStyle(
                        color: controller.currentIndex == itemIndex ||
                                nextRegimenPosition == itemIndex
                            ? Color(
                                CommonUtil().getQurhomeGredientColor(),
                              )
                            : Colors.grey,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  getIcon(regimen.activityname, regimen.uformname,
                      regimen.metadata),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getFormatedTitle(regimen.title),
                          maxLines: 2,
                          style: TextStyle(
                              color: controller.currentIndex == itemIndex ||
                                  nextRegimenPosition == itemIndex
                                  ? Color(
                                CommonUtil().getQurhomeGredientColor(),
                              )
                                  : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        if(regimen.ack_local != null)...{
                          Visibility(
                            visible: regimen.ack_local != null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${CommonUtil().regimentDateFormat(
                                    regimen?.asNeeded
                                        ? regimen?.ack_local ??
                                        DateTime.now()
                                        : regimen?.ack_local ??
                                        DateTime.now(),
                                    isAck: true,
                                  )}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        }


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
      Activityname activityname, Uformname uformName, Metadata metadata,
      {double sizeOfIcon}) {
    final iconSize = sizeOfIcon ?? 40.0;
    try {
      if (metadata?.icon != null) {
        if (metadata?.icon?.toLowerCase()?.contains('.svg') ?? false) {
          return SvgPicture.network(
            metadata?.icon,
            height: iconSize,
            width: iconSize,
            color: Color(
              CommonUtil().getQurhomeGredientColor(),
            ),
          );
        } else {
          return CachedNetworkImage(
            imageUrl: metadata?.icon,
            height: iconSize,
            width: iconSize,
            color: Color(
              CommonUtil().getQurhomeGredientColor(),
            ),
            errorWidget: (context, url, error) {
              return getDefaultIcon(activityname, uformName, iconSize);
            },
          );
        }
      } else {
        return getDefaultIcon(activityname, uformName, iconSize);
      }
    } catch (e) {
      return getDefaultIcon(activityname, uformName, iconSize);
    }
  }

  dynamic getDefaultIcon(
    Activityname activityname,
    Uformname uformName,
    double iconSize,
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
          cardIcon = 'assets/launcher/myfhb.png';
        }
        break;
      case Activityname.MEDICATION:
        cardIcon = Icons.medical_services;
        break;
      case Activityname.SCREENING:
        cardIcon = Icons.screen_search_desktop;
        break;
      default:
        cardIcon = 'assets/launcher/myfhb.png';
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
            color: Color(
              CommonUtil().getQurhomeGredientColor(),
            ),
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
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
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
                                regimen.metadata,
                                sizeOfIcon: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  getFormatedTitle(regimen.title),
                                  style: TextStyle(
                                      color: Color(
                                        CommonUtil().getQurhomeGredientColor(),
                                      ),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
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
                                        setState(() {
                                        });
                                      } else {
                                        stopRegimenTTS();
                                        regimen.isPlaying = true;
                                        setState(() {

                                        });
                                        Provider.of<ChatScreenViewModel>(Get.context, listen: false)
                                            ?.startTTSEngine(
                                          textToSpeak: regimen?.title ?? '',
                                          dynamicText: regimen?.sayTextDynamic ?? '',
                                          isRegiment: true,
                                          onStop: () {
                                            stopRegimenTTS();
                                            regimen.isPlaying = false;
                                            setState(() {
                                            });
                                          },
                                        );
                                      }
                                    },
                                    child: Icon(
                                      regimen.isPlaying
                                          ? Icons.stop_circle_outlined
                                          : Icons.play_circle_fill_rounded,
                                      size: 30.0,
                                      color: Color(CommonUtil().getMyPrimaryColor()),
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
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                            'assets/Qurhome/remove.png',
                            height: 50,
                            width: 50,
                          ),
                                  ),),),
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
                                    value: '5 mins',
                                    elevation: 16,
                                    onChanged: (String newValue) {
                                      // setState(() {
                                      //   dropdownValue = newValue!;
                                      // });
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
                        onPressed: () {},
                        child: Text('Snooze'),
                        style: ElevatedButton.styleFrom(
                            primary: Color(CommonUtil().getMyPrimaryColor())),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
            }
          );}
    );
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
    print(fieldsResponseModel);
    if (fieldsResponseModel.isSuccess &&
        (fieldsResponseModel.result.fields.isNotEmpty ||
            regimen.otherinfo.toJson().toString().contains('1')) &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentStatus !=
            RegimentStatus.DialogOpened) {
      var dashboardController = Get.find<QurhomeDashboardController>();
      if (((fieldsResponseModel.result.fields.first.title ?? '').isNotEmpty) &&
          (fieldsResponseModel.result.fields.first.title.toLowerCase() ==
              "oxygen".toLowerCase()) &&
          (dashboardController != null)) {
        dashboardController.checkForConnectedDevices();
      } else {Provider.of<RegimentViewModel>(context, listen: false)
          .updateRegimentStatus(RegimentStatus.DialogOpened);
      var value = await showDialog(
        context: context,
        builder: (context) =>
            FormDataDialog(
              fieldsData: fieldsResponseModel.result.fields,
              eid: eventId,
              color: Color(CommonUtil().getMyPrimaryColor()),
              mediaData: regimen.otherinfo,
              formTitle: getDialogTitle(context, regimen),
              canEdit: canEdit || isValidSymptom(context),
              isFromQurHome: false,
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
          LoaderClass.showLoadingDialog(
            Get.context,
            canDismiss: false,
          );
          Future.delayed(Duration(milliseconds: 300), () async {
            await Provider.of<RegimentViewModel>(context, listen: false)
                .fetchRegimentData();
            LoaderClass.hideLoadingDialog(Get.context);
          });
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

  Future<void> callLogApi(RegimentDataModel regimen) async {
    stopRegimenTTS();

    final canEdit = regimen.estart.difference(DateTime.now()).inMinutes <= 15 &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule;
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
