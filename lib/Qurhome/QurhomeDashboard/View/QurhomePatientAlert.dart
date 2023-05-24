import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurhomeDashboard.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/dynamicfieldmodel.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/patient_alert_data.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';

class QurhomePatientALert extends StatefulWidget {
  @override
  _QurhomePatientALertState createState() => _QurhomePatientALertState();
}

class _QurhomePatientALertState extends State<QurhomePatientALert> {
  final controller = Get.put(QurhomeDashboardController());
  final qurhomeRegimenController = Get.put(QurhomeRegimenController());
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    controller.getPatientAlertList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    qurhomeRegimenController.getUserDetails();
    qurhomeRegimenController.getCareCoordinatorId();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Obx(() => controller.loadingPatientData.isTrue
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GetBuilder<QurhomeDashboardController>(
            id: "newUpdate",
            builder: (val) {
              return getDataFromAPI(val, isPortrait);
            }));
  }

  getDataFromAPI(QurhomeDashboardController val, var isPortrait) {
    return (val.patientAlert?.result?.data?.length != 0 &&
            val.patientAlert?.result != null)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Container(
              child: PageView.builder(
                itemCount: val.patientAlert!.result!.data!.length + 1,
                scrollDirection: Axis.vertical,
                onPageChanged: (int index) {
                  setState(() {
                    controller.currentIndex = index;
                  });
                },
                controller: PageController(
                    initialPage: 1,
                    viewportFraction: 1 / (isPortrait == true ? 5 : 3)),
                itemBuilder: (BuildContext context, int itemIndex) {
                  if (itemIndex == (val.patientAlert!.result!.data!.length)) {
                    return SizedBox();
                  } else {
                    bool isSameDate = true;
                    final DateTime? date =
                        val.patientAlert!.result!.data![itemIndex].createdOn;
                    final item = val.patientAlert!.result!.data![itemIndex];
                    if (itemIndex == 0) {
                      isSameDate = false;
                    } else {
                      final DateTime? prevDateString = val
                          .patientAlert!.result!.data![itemIndex - 1].createdOn;

                      isSameDate = checkDateSame(prevDateString, date) ?? false;
                    }
                    if (itemIndex == 0 || !(isSameDate)) {
                      return Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Text(
                            qurhomeRegimenController.getFormatedDate(
                                date: date.toString()),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        _buildCarouselItem(
                            context,
                            itemIndex,
                            val.patientAlert!.result!.data![itemIndex],
                            val.nextAlertPosition,
                            isPortrait)
                      ]);
                    } else {
                      return _buildCarouselItem(
                          context,
                          itemIndex,
                          val.patientAlert!.result!.data![itemIndex],
                          val.nextAlertPosition,
                          isPortrait);
                    }
                  }
                },
              ),
            ),
          )
        : Center(
            child: Text(noAlert),
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

  bool checkDateSame(DateTime? other, DateTime? date) {
    return date?.year == other?.year &&
        date?.month == other?.month &&
        date?.day == other?.day;
  }

  _buildCarouselItem(BuildContext context, int itemIndex,
      PatientAlertData patientAlertData, int nextAlertPosition, isPortrait) {
    return InkWell(
      onTap: () {
        showRegimenDialog(patientAlertData, itemIndex);
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
              color: getCardBackgroundColor(itemIndex, nextAlertPosition),
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
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          patientAlertData.createdOn != null
                              ? DateFormat('hh:mm a')
                                  .format(patientAlertData.createdOn!)
                              : '',
                          style: TextStyle(
                              color: getTextAndIconColor(
                                  itemIndex, nextAlertPosition),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Center(
                          child: Text(
                            CommonUtil().capitalizeFirstofEach(
                                CommonUtil().getFormattedString(
                              patientAlertData.additionalInfo?.title ?? '',
                              patientAlertData?.typeName ?? '',
                              patientAlertData?.additionalInfo?.uformname ?? '',
                              12,
                              forDetails: false,
                            )),
                            maxLines: 2,
                            style: TextStyle(
                                color: getTextAndIconColor(
                                    itemIndex, nextAlertPosition),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: ImageIcon(
                              getIcons(patientAlertData.typeCode ?? ''),
                              color: getTextAndIconColor(
                                  itemIndex, nextAlertPosition)),
                          onPressed: () async {},
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

  Color getTextAndIconColor(int itemIndex, int nextRegimenPosition) {
    if (controller.currentIndex == itemIndex) {
      return Color(
        CommonUtil().getQurhomePrimaryColor(),
      );
    } else if (nextRegimenPosition == itemIndex) {
      if (itemIndex == 0) {
        return Colors.grey;
      } else
        return Colors.white;
    } else {
      return Colors.grey;
    }
  }

  Color getCardBackgroundColor(int itemIndex, int nextRegimenPosition) {
    if (controller.currentIndex == itemIndex) {
      return Colors.white;
    } else if (nextRegimenPosition == itemIndex) {
      if (itemIndex == 0) {
        return Colors.white;
      } else {
        return Color(
          CommonUtil().getQurhomePrimaryColor(),
        );
      }
    } else {
      return Colors.white;
    }
  }

  AssetImage getIcons(String activityCode) {
    AssetImage? icon;
    switch (activityCode) {
      case CODE_MAND:
        icon = AssetImage(
          MISSED_MAND_ACTIVITES,
        );
        break;
      case CODE_VITAL:
        icon = AssetImage(
          VITAL_ALERTS,
        );
        break;
      case CODE_MEDI:
        icon = AssetImage(
          MISSED_MEDICATION_ALERTS,
        );
        break;
      case CODE_RULE:
        icon = AssetImage(
          RULE_BASED_ALERTS,
        );
        break;
      case CODE_SYM:
        icon = AssetImage(
          SYMPTOMS_ALERTS,
        );
        break;
    }

    return icon ?? AssetImage(myFHB_logo);
  }

  String getTypeName(String type, PatientAlertData result) {
    if (type.toLowerCase() == "symptom" || type.toLowerCase() == "symptoms") {
      if (result?.additionalInfo?.eid == "0" ||
          result?.additionalInfo?.eid == "" ||
          result?.additionalInfo?.eid == null) {
        return "New symptom";
      }
    } else {
      return type ?? '';
    }
    return '';
  }

  void showRegimenDialog(PatientAlertData patientAlertData, int itemIndex) {
    showDialog(
        context: context,
        builder: (__) {
          return StatefulBuilder(builder: (_, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: Container(
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
                              size: 30.0,
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
                            ImageIcon(getIcons(patientAlertData.typeCode ?? ''),
                                color: Colors.grey),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(children: [
                              Center(
                                child: Text(
                                  patientAlertData?.typeName ?? '',
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Color(
                                        CommonUtil().getQurhomeGredientColor(),
                                      ),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Center(
                                child: Text(
                                  patientAlertData.createdOn != null
                                      ? DateFormat('hh:mm a')
                                          .format(patientAlertData.createdOn!)
                                      : '',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ])),
                          ],
                        )),
                    Divider(
                      height: CommonUtil().isTablet! ? 3.0 : 10.0,
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          left: 15.0,
                          right: 15.0,
                          bottom: 20.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              CommonUtil().capitalizeFirstofEach(
                                  CommonUtil().getFormattedString(
                                patientAlertData.additionalInfo?.title ?? '',
                                patientAlertData?.typeName ?? '',
                                patientAlertData?.additionalInfo?.uformname ??
                                    '',
                                12,
                                forDetails: false,
                              )),
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                            if (patientAlertData?.typeCode == CODE_VITAL) ...{
                              Text(
                                getValuesOfVital(patientAlertData) ?? '',
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              )
                            }
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: CommonUtil().isTablet! ? 3.0 : 10.0,
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
                                CommonUtil().showSingleLoadingDialog(context);
                                bool response =
                                    await controller.careGiverOkAction(
                                        controller.careGiverPatientListResult);
                                if (response)
                                  CommonUtil().hideLoadingDialog(context);
                                else {
                                  CommonUtil().hideLoadingDialog(context);

                                  FlutterToast().getToast(
                                      "Error in Acknowledging", Colors.red);
                                }
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Image.asset(
                                      icon_ok,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Text(strOK,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Color(CommonUtil()
                                              .getQurhomePrimaryColor()))),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  qurhomeRegimenController
                                      .careCoordinatorId.value = controller
                                          .careGiverPatientListResult
                                          ?.childId ??
                                      '';
                                  qurhomeRegimenController
                                      .careCoordinatorName.value = (controller
                                              .careGiverPatientListResult
                                              ?.firstName ??
                                          ' ') +
                                      (controller.careGiverPatientListResult
                                              ?.lastName ??
                                          '');
                                  qurhomeRegimenController
                                      .callSOSEmergencyServices(1);
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                        icon_call,
                                        width: 40,
                                        height: 40,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(strCall,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.green)),
                                  ],
                                )),
                            InkWell(
                              onTap: () async {
                                CommonUtil().showSingleLoadingDialog(context);
                                bool response = await controller
                                    .caregiverEscalateAction(patientAlertData);
                                if (response)
                                  CommonUtil().hideLoadingDialog(context);
                                else {
                                  CommonUtil().hideLoadingDialog(context);

                                  FlutterToast().getToast(
                                      "Error in Acknowledging", Colors.red);
                                }
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Image.asset(
                                      icon_escalate,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Text(strEscalate,
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.red)),
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

  getValuesOfVital(PatientAlertData patientAlertData) {
    String vitalValue = ' ';
    try {
      List<DynamicFieldModel> dynamicFieldModelList =
          patientAlertData?.additionalInfo?.dynamicFieldModel ?? [];
      if (dynamicFieldModelList.length > 0) {
        for (DynamicFieldModel dynamicFieldModelObj in dynamicFieldModelList)
          if (dynamicFieldModelObj != null &&
              dynamicFieldModelObj.value != null &&
              dynamicFieldModelObj.value != "") {
            if (dynamicFieldModelObj?.description?.toLowerCase() == "weight" ||
                dynamicFieldModelObj?.description?.toLowerCase() ==
                    "temperature") {
              vitalValue += dynamicFieldModelObj.value;
            } else {
              vitalValue += dynamicFieldModelObj.description +
                  " " +
                  dynamicFieldModelObj.value;
              vitalValue += "   ";
            }

            vitalValue += "   ";
            print(vitalValue);
          }
      } else {
        List<DynamicFieldModel> dynamicFieldModelList =
            patientAlertData?.additionalInfo?.dynamicFieldModelfromUForm ?? [];
        if (dynamicFieldModelList.length > 0) {
          for (DynamicFieldModel dynamicFieldModelObj in dynamicFieldModelList)
            if (dynamicFieldModelObj != null &&
                dynamicFieldModelObj.value != null &&
                dynamicFieldModelObj.value != "") {
              if (dynamicFieldModelObj?.description?.toLowerCase() ==
                      "weight" ||
                  dynamicFieldModelObj?.description?.toLowerCase() ==
                      "temperature") {
                vitalValue += dynamicFieldModelObj.value;
              } else {
                vitalValue += dynamicFieldModelObj.description +
                    " " +
                    dynamicFieldModelObj.value;
                vitalValue += "   ";
              }
            }
        }
      }
    } catch (e) {
      return vitalValue;
    }

    return vitalValue;
  }
}
