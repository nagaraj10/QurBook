import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../colors/fhb_colors.dart' as fhbColors;
import '../../../common/CommonConstants.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_parameters.dart';
import '../../../constants/fhb_parameters.dart' as parameters;
import '../../../constants/variable_constant.dart' as variable;
import '../../../record_detail/model/ImageDocumentResponse.dart';
import '../../../record_detail/screens/record_detail_screen.dart';
import '../../blocs/health/HealthReportListForUserBlock.dart';
import '../../model/Health/MediaMetaInfo.dart';
import '../../model/Health/asgard/health_record_collection.dart';
import '../../model/Health/asgard/health_record_list.dart';
import '../../utils/FHBUtils.dart';
import '../../utils/screenutils/size_extensions.dart';

class DeviceListScreen extends StatefulWidget {
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

  @override
  _DeviceListScreentState createState() => _DeviceListScreentState();
}

class _DeviceListScreentState extends State<DeviceListScreen> {
  late HealthReportListForUserBlock _healthReportListForUserBlock;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<HealthRecordCollection> mediMasterId = [];
  FlutterToast toast = FlutterToast();

  @override
  void initState() {
    _healthReportListForUserBlock = HealthReportListForUserBlock();
    FABService.trackCurrentScreen(FBAMyRecordsDevicesScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _getWidgetToDisplayDeviceList(
        widget.completeData!,
      );

  Widget _getWidgetToDisplayDeviceList(HealthRecordList completeData) {
    var mediaMetaInfoObj = <HealthResult>[];

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
                    padding: const EdgeInsets.only(left: 20, right: 20),
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
    await _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));

    widget.callBackToRefresh();
  }

  Widget getCardWidgetForDevice(HealthResult data, int position) => InkWell(
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
              await Future.delayed(const Duration(milliseconds: 100));
              widget.callBackToRefresh();
            }
          });
        }
      },
      child: Container(
          //height: 70.0.h,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(fhbColors.cardShadowColor),
                blurRadius: 16, // has the effect of softening the shadow
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
                      backgroundColor: const Color(fhbColors.bgColorContainer),
                      child: Image.network(
                        data.metadata!.healthRecordType!.logo!,
                        height: 25.0.h,
                        width: 25.0.h,
                        color: Color(CommonUtil().getMyPrimaryColor()),
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
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
                          children: <Widget>[
                            IconButton(
                                icon: data.isBookmarked!
                                    ? ImageIcon(
                                        const AssetImage(
                                            variable.icon_record_fav_active),
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor()),
                                        size: CommonUtil().isTablet!
                                            ? tabHeader2
                                            : mobileHeader2,
                                      )
                                    : ImageIcon(
                                        const AssetImage(
                                            variable.icon_record_fav),
                                        color: Colors.black,
                                        size: CommonUtil().isTablet!
                                            ? tabHeader2
                                            : mobileHeader2,
                                      ),
                                onPressed: () {
                                  CommonUtil().bookMarkRecord(data, _refresh);
                                }),
                            if (data.metadata!.hasVoiceNotes != null &&
                                data.metadata!.hasVoiceNotes!)
                              const Icon(
                                Icons.mic,
                                color: Colors.black54,
                              )
                            else
                              Container(),
                            if (widget.mediaMeta!.contains(data.id))
                              Icon(
                                Icons.done,
                                color: Color(CommonUtil().getMyPrimaryColor()),
                              )
                            else
                              const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )));

  FutureBuilder<ImageDocumentResponse?> getDocumentImageWidget(
          MediaMetaInfo data) =>
      FutureBuilder(
        future: _healthReportListForUserBlock
            .getDocumentImage(CommonUtil().getMetaMasterId(data)!),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: 40.0.w,
              height: 60.0.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Image.memory(snapshot.data),
            );
          } else {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 50.0.h,
                height: 50.0.h,
              ),
            );
          }
        },
      );

  String getCreatedDate(HealthResult data) {
    final dateTimeStampForBp = data.dateTimeValue!.toLocal();
    final dateForBp = DateFormat(parameters.strDateYMD, variable.strenUs)
        .format(dateTimeStampForBp);
    final timeForBp = DateFormat(parameters.strTimeHM, variable.strenUs)
        .format(dateTimeStampForBp);
    return '$dateForBp,$timeForBp';
  }

  Widget getDeviceReadings(
      HealthResult data, List<DeviceReadings> deviceReadings) {
    final list = <Widget>[];
    for (var i = 0; i < deviceReadings.length; i++) {
      list.add(Padding(
        padding: EdgeInsets.all(5.0.sp),
        child: Column(
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
                        : ' ' + deviceReadings[i].unit,
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
  }

  String getUnitForTemperature(String unit) {
    if (unit.toLowerCase().trim() == strParamUnitFarenheit.toLowerCase()) {
      return strParamUnitFarenheit;
    } else if (unit.toLowerCase().trim() ==
        CommonConstants.strTemperatureValue.toLowerCase()) {
      return strParamUnitFarenheit;
    } else if (unit.toLowerCase().trim() == 'c'.toLowerCase()) {
      return strParamUnitCelsius;
    } else {
      return unit;
    }
  }
}
