import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurhomeDashboard.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/patient_alert_data.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';

class QurhomePatientALert extends StatefulWidget {
  @override
  _QurhomePatientALertState createState() => _QurhomePatientALertState();
}

class _QurhomePatientALertState extends State<QurhomePatientALert> {
  final controller = Get.put(QurhomeDashboardController());
  final qurhomeRegimenController = Get.put(QurhomeRegimenController());

  @override
  void initState() {
    super.initState();
    controller.getPatientAlertList();
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
    return val.patientAlert == null
        ? const Center(
            child: Text(
              'Please re-try after some time',
            ),
          )
        : val.patientAlert!.result!.data!.length != 0
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
                        initialPage: val.nextAlertPosition,
                        viewportFraction: 1 / (isPortrait == true ? 5 : 3)),
                    itemBuilder: (BuildContext context, int itemIndex) {
                      if (itemIndex ==
                          (val.patientAlert!.result!.data!.length)) {
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
                        bool isSameDate = true;
                        final DateTime? date = val
                            .patientAlert!.result!.data![itemIndex].createdOn;
                        final item = val.patientAlert!.result!.data![itemIndex];
                        if (itemIndex == 0) {
                          isSameDate = false;
                        } else {
                          final DateTime? prevDateString = val.patientAlert!
                              .result!.data![itemIndex - 1].createdOn;

                          isSameDate =
                              checkDateSame(prevDateString, date) ?? false;
                        }
                        if (itemIndex == 0 || !(isSameDate)) {
                          return Column(children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              color: Colors.white,
                              child: Text(
                                qurhomeRegimenController.getFormatedDate(
                                    date: date.toString()),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
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

  bool checkDateSame(DateTime? other, DateTime? date) {
    return date?.year == other?.year &&
        date?.month == other?.month &&
        date?.day == other?.day;
  }

  _buildCarouselItem(BuildContext context, int itemIndex,
      PatientAlertData patientAlertData, int nextAlertPosition, isPortrait) {
    return InkWell(
      onTap: () {},
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
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                          width: 20,
                        ),
                        Expanded(
                            child: Text(
                          CommonUtil().getFormattedString(
                            patientAlertData.additionalInfo?.title ?? '',
                            patientAlertData?.typeName ?? '',
                            patientAlertData?.additionalInfo?.uformname ?? '',
                            12,
                            forDetails: false,
                          ),
                          maxLines: 2,
                          style: TextStyle(
                              color: getTextAndIconColor(
                                  itemIndex, nextAlertPosition),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )),
                        SizedBox(
                          width: 20,
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
      return Colors.white;
    } else {
      return Colors.grey;
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
}
