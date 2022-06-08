import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/record_detail/screens/device_info_card.dart';
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class DeviceListScreen extends StatefulWidget {
  final HealthRecordList completeData;
  final Function callBackToRefresh;

  final String categoryName;
  final String categoryId;

  final Function(String, String) getDataForParticularLabel;
  final Function(String, bool) mediaSelected;
  final Function(String, List<HealthRecordCollection>, bool)
      healthRecordSelected;
  final bool allowSelect;
  List<String> mediaMeta;
  final bool isNotesSelect;
  final bool isAudioSelect;
  final bool showDetails;
  final bool allowAttach;

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
  HealthReportListForUserBlock _healthReportListForUserBlock;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<HealthRecordCollection> mediMasterId = new List();
  FlutterToast toast = new FlutterToast();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    _healthReportListForUserBlock = new HealthReportListForUserBlock();
    String categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Device List Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getWidgetToDisplayDeviceList(widget.completeData);
  }

  Widget _getWidgetToDisplayDeviceList(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForParticularCategoryDescription(
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
                      style: TextStyle(fontFamily: variable.font_poppins),
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
          if (widget.allowSelect) {
            data.isSelected = !data.isSelected;

            setState(() {});
            widget.mediaSelected(data.id, data.isSelected);
          }
        },
        onTap: () {
          if (widget.allowSelect && widget.showDetails == false) {
            if (widget.allowAttach) {
              bool condition;
              if (widget.mediaMeta.contains(data.id)) {
                condition = false;
              } else {
                condition = true;
              }
              data.isSelected = !data.isSelected;
              if (data != null &&
                  (data.healthRecordCollection?.length ?? 0) > 0) {
                mediMasterId = new CommonUtil().getMetaMasterIdListNew(data);
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
              if (widget.mediaMeta.contains(data.id)) {
                condition = false;
              } else {
                condition = true;
              }
              data.isSelected = !data.isSelected;

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
            );
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
                        backgroundColor:
                            const Color(fhbColors.transparentColor),
                        child: Image.network(
                          data.metadata.healthRecordType.logo,
                          height: 25.0.h,
                          width: 25.0.h,
                          color: Color(new CommonUtil().getMyPrimaryColor()),
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              data.metadata.healthRecordType.name != null
                                  ? toBeginningOfSentenceCase(
                                      data.metadata.healthRecordType.name)
                                  : '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0.sp,
                                color:
                                    Color(new CommonUtil().getMyPrimaryColor()),
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
                            new FHBUtils().getFormattedDateStringClone(
                                data.dateTimeValue.toLocal()),
                            style: TextStyle(
                                color:
                                    Color(new CommonUtil().getMyPrimaryColor()),
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
                                data, data.metadata.deviceReadings),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: data.isBookmarked
                                      ? ImageIcon(
                                          AssetImage(
                                              variable.icon_record_fav_active),
                                          //TODO chnage theme
                                          color: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          size: 20,
                                        )
                                      : ImageIcon(
                                          AssetImage(variable.icon_record_fav),
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                  onPressed: () {
                                    new CommonUtil()
                                        .bookMarkRecord(data, _refresh);
                                  }),
                              (data.metadata.hasVoiceNotes != null &&
                                      data.metadata.hasVoiceNotes)
                                  ? Icon(
                                      Icons.mic,
                                      color: Colors.black54,
                                    )
                                  : Container(),
                              widget.mediaMeta.contains(data.id)
                                  ? Icon(
                                      Icons.done,
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
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
    return new FutureBuilder(
      future: _healthReportListForUserBlock
          .getDocumentImage(new CommonUtil().getMetaMasterId(data)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: 40.0.w,
            height: 60.0.h,
            child: Image.memory(snapshot.data),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          );
        } else {
          return new Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                width: 50.0.h,
                height: 50.0.h,
              ));
        }
      },
    );
  }

  String getCreatedDate(HealthResult data) {
    DateTime dateTimeStampForBp = data.dateTimeValue.toLocal();

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
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < deviceReadings.length; i++) {
      list.add(Padding(
        padding: EdgeInsets.all(5.0.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              deviceReadings[i].parameter != null
                  ? toBeginningOfSentenceCase(
                      deviceReadings[i].parameter.toLowerCase() ==
                              CommonConstants.strOxygenParams.toLowerCase()
                          ? CommonConstants.strOxygenParamsName.toLowerCase()
                          : deviceReadings[i].parameter.toLowerCase())
                  : '',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0.sp),
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
                      fontSize: 12.0.sp),
                ),
                Text(
                    deviceReadings[i].unit.toLowerCase() ==
                            CommonConstants.strOxygenUnits.toLowerCase()
                        ? CommonConstants.strOxygenUnitsName
                        : getUnitForTemperature(" " + deviceReadings[i].unit),
                    maxLines: 2,
                    style: TextStyle(color: Colors.black54, fontSize: 10.0.sp))
              ],
            ),
          ],
        ),
      ));
    }

    return Container(
      height: 58.0.h,
      child: new ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
    //return new Row(children: list);
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
