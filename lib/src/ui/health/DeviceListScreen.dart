import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../colors/fhb_colors.dart' as fhbColors;
import '../../../common/CommonConstants.dart';
import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_parameters.dart';
import '../../../constants/fhb_parameters.dart' as parameters;
import '../../../constants/variable_constant.dart' as variable;
import '../../../record_detail/screens/record_detail_screen.dart';
import '../../blocs/health/HealthReportListForUserBlock.dart';
import '../../model/Health/MediaMetaInfo.dart';
import '../../model/Health/asgard/health_record_collection.dart';
import '../../model/Health/asgard/health_record_list.dart';
import '../../utils/FHBUtils.dart';
import '../../utils/screenutils/size_extensions.dart';

class DeviceListScreen extends StatefulWidget {
  final HealthRecordList? completeData;
  final Function callBackToRefresh;

  final String? categoryName;
  final String? categoryId;

  final Function(String, String) getDataForParticularLabel;
  final Function(String?, bool?) mediaSelected;
  final Function(String?, List<HealthRecordCollection>, bool)
      healthRecordSelected;
  final bool? allowSelect;
  List<String?>? mediaMeta;
  final bool? isNotesSelect;
  final bool? isAudioSelect;
  final bool? showDetails;
  final bool? allowAttach;

  DeviceListScreen(
      this.completeData,
      this.callBackToRefresh,
      this.categoryName,
      this.categoryId,
      this.getDataForParticularLabel,
      this.mediaSelected,
      this.allowSelect,
      this.mediaMeta,
      this.isNotesSelect,
      this.isAudioSelect,
      this.showDetails,
      this.allowAttach,
      this.healthRecordSelected);

  @override
  _DeviceListScreentState createState() => _DeviceListScreentState();
}

class _DeviceListScreentState extends State<DeviceListScreen> {
  late HealthReportListForUserBlock _healthReportListForUserBlock;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<HealthRecordCollection> mediMasterId = [];
  FlutterToast toast = FlutterToast();

  @override
  void initState() {
    _healthReportListForUserBlock = HealthReportListForUserBlock();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getWidgetToDisplayDeviceList(widget.completeData!);
  }

  Widget _getWidgetToDisplayDeviceList(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = [];

    mediaMetaInfoObj = CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionDevice);
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: mediaMetaInfoObj.length > 0
            ? Container(
                color: const Color(fhbColors.bgColorContainer),
                child: ListView.builder(
                  itemBuilder: (c, i) =>
                      getCardWidgetForDevice(mediaMetaInfoObj[i], i),
                  itemCount: mediaMetaInfoObj.length,
                ))
            : Container(
                color: const Color(fhbColors.bgColorContainer),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      Constants.NO_DATA_DEVICES,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: variable.font_poppins,
                          fontSize: CommonUtil().isTablet!
                              ? Constants.tabHeader2
                              : Constants.mobileHeader2),
                    ),
                  ),
                ),
              ));
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    widget.callBackToRefresh();
  }

  Widget getCardWidgetForDevice(HealthResult data, int position) {
    return InkWell(
        onLongPress: () {
          if (widget.allowSelect!) {
            data.isSelected = !data.isSelected!;

            setState(() {});
            widget.mediaSelected(data.id, data.isSelected);
          }
        },
        onTap: () {
          if (widget.allowSelect! && widget.showDetails == false) {
            if (widget.allowAttach!) {
              bool condition;
              if (widget.mediaMeta!.contains(data.id)) {
                condition = false;
              } else {
                condition = true;
              }
              data.isSelected = !data.isSelected!;
              if (data != null &&
                  (data.healthRecordCollection?.length ?? 0) > 0) {
                mediMasterId = CommonUtil().getMetaMasterIdListNew(data);
                print(mediMasterId.length);
                if (mediMasterId.length > 0) {
                  widget.healthRecordSelected(data.id, mediMasterId, condition);
                } else {
                  toast.getToast('No Image Attached ', Colors.red);
                }
              } else {
                toast.getToast('No Image Attached ', Colors.red);
              }
            } else {
              bool condition;
              if (widget.mediaMeta!.contains(data.id)) {
                condition = false;
              } else {
                condition = true;
              }
              data.isSelected = !data.isSelected!;

              // setState(() {});
              widget.mediaSelected(data.id, condition);
            }
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecordDetailScreen(
                  data: data,
                ),
              ),
            ).then((value) async {
              if (value ?? false) {
                await Future.delayed(Duration(milliseconds: 100));
                widget.callBackToRefresh();
              }
            });
          }
        },
        child: Container(
            //height: 70.0.h,
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(fhbColors.cardShadowColor),
                  blurRadius: 16, // has the effect of softening the shadow
                  spreadRadius: 0, // has the effect of extending the shadow
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 120.0.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: CommonUtil().isTablet! ? 35 : 25,
                        backgroundColor:
                            const Color(fhbColors.bgColorContainer),
                        child: Image.network(
                          data.metadata!.healthRecordType!.logo!,
                          height: 25.0.h,
                          width: 25.0.h,
                          color: Color(CommonUtil().getMyPrimaryColor()),
                          errorBuilder: (context, error, stackTrace) =>
                              SizedBox(),
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              data.metadata!.healthRecordType!.name != null
                                  ? toBeginningOfSentenceCase(
                                      data.metadata!.healthRecordType!.name)!
                                  : '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0.sp,
                                color: Color(CommonUtil().getMyPrimaryColor()),
                              ),
                              maxLines: 2,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            FHBUtils().getFormattedDateStringClone(
                                data.dateTimeValue!.toLocal()),
                            style: TextStyle(
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                fontWeight: FontWeight.w200,
                                fontSize: 10.0.sp),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: getDeviceReadings(
                                data, data.metadata!.deviceReadings!),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: data.isBookmarked!
                                      ? ImageIcon(
                                          AssetImage(
                                              variable.icon_record_fav_active),
                                          //TODO chnage theme
                                          color: Color(
                                              CommonUtil().getMyPrimaryColor()),
                                          size: CommonUtil().isTablet!
                                              ? tabHeader2
                                              : mobileHeader2,
                                        )
                                      : ImageIcon(
                                          AssetImage(variable.icon_record_fav),
                                          color: Colors.black,
                                          size: CommonUtil().isTablet!
                                              ? tabHeader2
                                              : mobileHeader2,
                                        ),
                                  onPressed: () {
                                    CommonUtil().bookMarkRecord(data, _refresh);
                                  }),
                              (data.metadata!.hasVoiceNotes != null &&
                                      data.metadata!.hasVoiceNotes!)
                                  ? Icon(
                                      Icons.mic,
                                      color: Colors.black54,
                                    )
                                  : Container(),
                              widget.mediaMeta!.contains(data.id)
                                  ? Icon(
                                      Icons.done,
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  getDocumentImageWidget(MediaMetaInfo data) {
    return FutureBuilder(
      future: _healthReportListForUserBlock
          .getDocumentImage(CommonUtil().getMetaMasterId(data)!),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: 40.0.w,
            height: 60.0.h,
            child: Image.memory(snapshot.data),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          );
        } else {
          return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 50.0.h,
                height: 50.0.h,
              ));
        }
      },
    );
  }

  String getCreatedDate(HealthResult data) {
    DateTime dateTimeStampForBp = data.dateTimeValue!.toLocal();

    //deviceValues.bloodPressure.entities[0].lastsyncdatetime;
    String dateForBp =
        "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStampForBp)}";
    String timeForBp =
        "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStampForBp)}";
    print(dateForBp + ',' + timeForBp);

    return dateForBp + ',' + timeForBp;
  }

  Widget getDeviceReadings(
      HealthResult data, List<DeviceReadings> deviceReadings) {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < deviceReadings.length; i++) {
      list.add(Padding(
        padding: EdgeInsets.all(5.0.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              deviceReadings[i].parameter != null
                  ? toBeginningOfSentenceCase(
                      deviceReadings[i].parameter!.toLowerCase() ==
                              CommonConstants.strOxygenParams.toLowerCase()
                          ? CommonConstants.strOxygenParamsName.toLowerCase()
                          : deviceReadings[i].parameter!.toLowerCase())!
                  : '',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize:
                      CommonUtil().isTablet! ? tabHeader2 : mobileHeader2),
              maxLines: 2,
              softWrap: true,
            ),
            Row(
              children: [
                Text(
                  deviceReadings[i].value.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: CommonUtil().isTablet!
                          ? tabHeader3
                          : Constants.mobileHeader3),
                ),
                Text(
                    deviceReadings[i].unit.toLowerCase() ==
                            CommonConstants.strOxygenUnits.toLowerCase()
                        ? CommonConstants.strOxygenUnitsName
                        : " " + deviceReadings[i].unit,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: CommonUtil().isTablet!
                            ? tabHeader3
                            : mobileHeader3))
              ],
            ),
          ],
        ),
      ));
    }

    return Container(
      height: 58.0.h,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
    //return Row(children: list);
  }

  getUnitForTemperature(String unit) {
    if (unit.toLowerCase().trim() == strParamUnitFarenheit.toLowerCase()) {
      return strParamUnitFarenheit;
    } else if (unit.toLowerCase().trim() ==
        CommonConstants.strTemperatureValue.toLowerCase()) {
      return strParamUnitFarenheit;
    } else if (unit.toLowerCase().trim() == "c".toLowerCase()) {
      return strParamUnitCelsius;
    } else {
      return unit;
    }
  }
}
