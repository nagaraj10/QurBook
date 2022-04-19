import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeRegimenResponseModel.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/models/regiment_qurhub_response_model.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';

class QurHomeRegimenScreen extends StatefulWidget {
  const QurHomeRegimenScreen({Key key}) : super(key: key);

  @override
  _QurHomeRegimenScreenState createState() => _QurHomeRegimenScreenState();
}

class _QurHomeRegimenScreenState extends State<QurHomeRegimenScreen> {
  final controller = Get.put(QurhomeRegimenController());

  int selectedIndex = 0;

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
                return val.qurHomeRegimenResponseModel == null
                    ? const Center(
                        child: Text(
                          'Please re-try after some time',
                        ),
                      )
                    : Container(
                        child: PageView.builder(
                          itemCount: val.qurHomeRegimenResponseModel.result
                              .upcomingActivities.length,
                          scrollDirection: Axis.vertical,
                          onPageChanged: (int index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          controller: PageController(viewportFraction: 0.15),
                          itemBuilder: (BuildContext context, int itemIndex) {
                            return _buildCarouselItem(
                                context,
                                10,
                                itemIndex,
                                val.qurHomeRegimenResponseModel.result
                                    .upcomingActivities[itemIndex]);
                          },
                        ),
                      );
              })),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int carouselIndex,
      int itemIndex, UpcomingActivities regimen) {
    return Transform.scale(
      scale: selectedIndex == itemIndex ? 1 : 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  regimen.estart != null
                      ? DateFormat('hh:mm a').format(regimen.estart)
                      : '',
                  style: TextStyle(color: selectedIndex == itemIndex ?Color(
                    CommonUtil()
                        .getQurhomeGredientColor(),
                  ):Colors.grey, fontSize: 16),
                ),
                SizedBox(
                  width: 20,
                ),
                getIcon(
                    regimen.activityname,
                    regimen.uformname,
                    regimen.metadata),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    getFormatedTitle(regimen.title),
                    style: TextStyle(color: selectedIndex == itemIndex ?Color(
                      CommonUtil()
                          .getQurhomeGredientColor(),
                    ):Colors.grey, fontSize: 15,fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dynamic getIcon(
      Activityname activityname, Uformname uformName, Metadata metadata) {
    final iconSize = 40.0;
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
            color: Colors.white,
          );
    return cardIconWidget;
  }

  String getFormatedTitle(String title) {
    int start = title.indexOf("{") + 1;
    int length = title.indexOf("}");
    String first = title.substring(start, length);
    String second = "";
    try {
      int startSecond = title.indexOf("[") + 1;
      int lengthSecond = title.indexOf("]");
      if (startSecond != null) {
        second = title.substring(startSecond, lengthSecond);
      }
    } catch (e) {}

    return first + second;
  }
}
