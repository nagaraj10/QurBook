import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurHomeSymptoms/viewModel/SymptomListController.dart';
import 'package:myfhb/common/CommonCircularQurHome.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import 'SymptomItemCard.dart';

class SymptomListScreen extends StatefulWidget {
  @override
  _SymptomListScreen createState() => _SymptomListScreen();
}

class _SymptomListScreen extends State<SymptomListScreen> {
  final controller = Get.put(SymptomListController());

  final scrollController =
      AutoScrollController(axis: Axis.vertical, suggestedRowHeight: 150);

  // Future<RegimentResponseModel> symptomsList;

  @override
  void initState() {
    super.initState();

    Provider.of<RegimentViewModel>(Get.context, listen: false).cachedEvents =
        [];
    controller.getSymptomList(isLoading: true);

    /* symptomsList = Provider.of<SymptomViewModel>(context, listen: false)
        .getSymptomListData();*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (_, orientation) {
        if (orientation == Orientation.landscape && CommonUtil().isTablet)
          return Obx(() => controller.loadingData.isTrue
              ? CommonCircularQurHome()
              : Container(
                  color: Color(0xffefeded),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(14, 24, 14, 0),
                    child: Container(
                        child: Column(
                      children: [
                        Expanded(
                            child: controller.symptomList?.value?.length != 0
                                ? GridView.builder(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10.0.w,
                                      mainAxisSpacing: 10.0.w,
                                      childAspectRatio: 0.95,
                                    ),
                                    padding: EdgeInsets.only(
                                      bottom: 10.0.h,
                                    ),
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        controller.symptomList?.value?.length ??
                                            0,
                                    itemBuilder: (context, index) {
                                      final symptomData = (index <
                                              controller
                                                  .symptomList?.value?.length)
                                          ? controller.symptomList?.value[index]
                                          : RegimentDataModel();
                                      return SymptomItemCard(
                                        orientation: orientation,
                                        index: index,
                                        title: symptomData.title,
                                        time: symptomData?.estart != null
                                            ? DateFormat('hh:mm\na')
                                                .format(symptomData?.estart)
                                            : '',
                                        color: getColor(
                                            symptomData.activityname,
                                            symptomData.uformname,
                                            symptomData.metadata,
                                            orientation),
                                        icon: getIcon(
                                            symptomData.activityname,
                                            symptomData.uformname,
                                            symptomData.metadata,
                                            orientation),
                                        vitalsData:
                                            symptomData.uformdata?.vitalsData,
                                        eid: symptomData.eid,
                                        mediaData: symptomData.otherinfo,
                                        startTime: symptomData.estart,
                                        regimentData: symptomData,
                                        aid: symptomData.aid,
                                        uid: symptomData.uid,
                                        formId: symptomData.uformid,
                                        formName: symptomData.uformname1,
                                      );
                                    },
                                  )
                                : SafeArea(
                                    child: SizedBox(
                                      height: 1.sh / 1.3,
                                      child: Container(
                                          child: Center(
                                        child: Text(noRegimentSymptomsData),
                                      )),
                                    ),
                                  ))
                      ],
                    )),
                  ),
                ));
        else
          return Obx(() => controller.loadingData.isTrue
              ? CommonCircularQurHome()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(14, 24, 14, 0),
                  child: Container(
                      child: Column(
                    children: [
                      Expanded(
                          child: controller.symptomList?.value?.length != 0
                              ? ListView.builder(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                    bottom: 10.0.h,
                                  ),
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.symptomList?.value?.length ??
                                          0,
                                  itemBuilder: (context, index) {
                                    final symptomData = (index <
                                            controller
                                                .symptomList?.value?.length)
                                        ? controller.symptomList?.value[index]
                                        : RegimentDataModel();
                                    return SymptomItemCard(
                                      orientation: orientation,
                                      index: index,
                                      title: symptomData.title,
                                      time: symptomData?.estart != null
                                          ? DateFormat('hh:mm\na')
                                              .format(symptomData?.estart)
                                          : '',
                                      color: getColor(
                                          symptomData.activityname,
                                          symptomData.uformname,
                                          symptomData.metadata,
                                          orientation),
                                      icon: getIcon(
                                          symptomData.activityname,
                                          symptomData.uformname,
                                          symptomData.metadata,
                                          orientation),
                                      vitalsData:
                                          symptomData.uformdata?.vitalsData,
                                      eid: symptomData.eid,
                                      mediaData: symptomData.otherinfo,
                                      startTime: symptomData.estart,
                                      regimentData: symptomData,
                                      aid: symptomData.aid,
                                      uid: symptomData.uid,
                                      formId: symptomData.uformid,
                                      formName: symptomData.uformname1,
                                    );
                                  },
                                )
                              : SafeArea(
                                  child: SizedBox(
                                    height: 1.sh / 1.3,
                                    child: Container(
                                        child: Center(
                                      child: Text(noRegimentSymptomsData),
                                    )),
                                  ),
                                ))
                    ],
                  )),
                ));
      }),
    );
  }

  /*Widget getSymptomList() {
    return new FutureBuilder<RegimentResponseModel>(
      future: symptomsList,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: new Center(
                child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: CommonCircularIndicator(),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          if (snapshot.hasData) {
            if (snapshot?.data != null) {
              if (snapshot?.data?.regimentsList.length > 0) {
                final regimentsList = snapshot?.data?.regimentsList;
                return Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      bottom: 10.0.h,
                    ),
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: regimentsList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final regimentData = (index < regimentsList.length)
                          ? regimentsList[index]
                          : RegimentDataModel();
                      return SymptomItemCard(
                        index: index,
                        title: regimentData.title,
                        time: regimentData?.estart != null
                            ? DateFormat('hh:mm\na')
                                .format(regimentData?.estart)
                            : '',
                        color: getColor(regimentData.activityname,
                            regimentData.uformname, regimentData.metadata),
                        icon: getIcon(regimentData.activityname,
                            regimentData.uformname, regimentData.metadata),
                        vitalsData: regimentData.uformdata?.vitalsData,
                        eid: regimentData.eid,
                        mediaData: regimentData.otherinfo,
                        startTime: regimentData.estart,
                        regimentData: regimentData,
                        aid: regimentData.aid,
                        uid: regimentData.uid,
                        formId: regimentData.uformid,
                        formName: regimentData.uformname1,
                      );
                    },
                  ),
                );
              } else {
                return SafeArea(
                  child: SizedBox(
                    height: 1.sh / 1.3,
                    child: Container(
                        child: Center(
                      child: Text(noRegimentSymptomsData),
                    )),
                  ),
                );
              }
            } else {
              return SafeArea(
                child: SizedBox(
                  height: 1.sh / 1.3,
                  child: Container(
                      child: Center(
                    child: Text(noRegimentSymptomsData),
                  )),
                ),
              );
            }
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: Text(noRegimentSymptomsData),
                )),
              ),
            );
          }
        }
      },
    );
  }*/

  Color getColor(Activityname activityname, Uformname uformName,
      Metadata metadata, Orientation orientation) {
    Color cardColor;
    try {
      if ((metadata?.color?.length ?? 0) == 7) {
        cardColor = Color(CommonUtil().getQurhomePrimaryColor());
      } else {
        switch (activityname) {
          case Activityname.DIET:
            cardColor = Color(CommonUtil().getQurhomePrimaryColor());
            break;
          case Activityname.VITALS:
            if (uformName == Uformname.BLOODPRESSURE) {
              cardColor = Color(CommonUtil().getQurhomePrimaryColor());
            } else if (uformName == Uformname.BLOODSUGAR) {
              cardColor = Color(CommonUtil().getQurhomePrimaryColor());
            } else if (uformName == Uformname.PULSE) {
              cardColor = Color(CommonUtil().getQurhomePrimaryColor());
            } else {
              cardColor = Color(CommonUtil().getQurhomePrimaryColor());
            }
            break;
          case Activityname.MEDICATION:
            cardColor = Color(CommonUtil().getQurhomePrimaryColor());
            break;
          case Activityname.SCREENING:
            cardColor =
                cardColor = Color(CommonUtil().getQurhomePrimaryColor());
            break;
          default:
            cardColor = Color(CommonUtil().getQurhomePrimaryColor());
        }
      }
    } catch (e) {
      cardColor = Color(CommonUtil().getQurhomePrimaryColor());
    }
    return cardColor;
  }

  dynamic getIcon(Activityname activityname, Uformname uformName,
      Metadata metadata, Orientation orientation) {
    final iconSize = 40.0.sp;
    try {
      if (metadata?.icon != null) {
        if (metadata?.icon?.toLowerCase()?.contains('.svg') ?? false) {
          return SvgPicture.network(
            metadata?.icon,
            height: iconSize,
            width: iconSize,
            color: Colors.white,
          );
        } else {
          return CachedNetworkImage(
            imageUrl: metadata?.icon,
            height: iconSize,
            width: iconSize,
            color: Colors.white,
            errorWidget: (context, url, error) {
              return getDefaultIcon(
                  activityname, uformName, iconSize, orientation);
            },
          );
        }
      } else {
        return getDefaultIcon(activityname, uformName, iconSize, orientation);
      }
    } catch (e) {
      return getDefaultIcon(activityname, uformName, iconSize, orientation);
    }
  }

  dynamic getDefaultIcon(Activityname activityname, Uformname uformName,
      double iconSize, Orientation orientation) {
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
            height: isDefault ? iconSize : iconSize - 5.0.sp,
            width: isDefault ? iconSize : iconSize - 5.0.sp,
          )
        : Icon(
            cardIcon,
            size: iconSize - 5.0.sp,
            color: Colors.white,
          );
    return cardIconWidget;
  }
}
