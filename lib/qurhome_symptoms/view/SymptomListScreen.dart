import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/qurhome_symptoms/model/SymptomsListModel.dart';
import 'package:myfhb/qurhome_symptoms/viewModel/SymptomViewModel.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/view/widgets/regiment_data_card.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/utils/ImageViewer.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../constants/fhb_constants.dart';
import 'package:provider/provider.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import '../../../common/CommonUtil.dart';
import '../../../src/ui/loader_class.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class SymptomListScreen extends StatefulWidget {
  const SymptomListScreen({
    Key key,
  }) : super(key: key);

  @override
  _SymptomListScreen createState() => _SymptomListScreen();
}

class _SymptomListScreen extends State<SymptomListScreen> {
  String userId;

  Future<RegimentDataModel> symptomsList;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    userId = PreferenceUtil.getStringValue(KEY_USERID);

    symptomsList = Provider.of<SymptomViewModel>(context, listen: false)
        .getSymptomListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      children: [
        Expanded(
          child: getSymptomList(),
        )
      ],
    )));
  }

  Widget getSymptomList() {
    return new FutureBuilder<RegimentDataModel>(
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
          if (snapshot?.hasData && snapshot?.data != null) {
            return symptomListView(snapshot?.data);
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
  }

  Widget symptomListView(RegimentDataModel regimentData) {
    if (regimentData != null) {
      List<RegimentDataModel> regimenList =
          regimentData as List<RegimentDataModel>;
      regimenList.length > 0
          ? ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                bottom: 50.0.h,
              ),
              itemBuilder: (BuildContext ctx, int i) {
                RegimentDataCard(
                  index: i,
                  title: regimentData.title,
                  time: regimentData?.estart != null
                      ? DateFormat('hh:mm\na').format(regimentData?.estart)
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
                );
              },
              itemCount: regimenList.length,
            )
          : SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: Text(noRegimentSymptomsData),
                )),
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

  dynamic getIcon(
      Activityname activityname, Uformname uformName, Metadata metadata) {
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
