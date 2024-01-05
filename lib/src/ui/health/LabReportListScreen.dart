import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:shimmer/shimmer.dart';

class LabReportListScreen extends StatefulWidget {
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

  LabReportListScreen(
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
  _LabReportListScreenState createState() => _LabReportListScreenState();
}

class _LabReportListScreenState extends State<LabReportListScreen> {
  late HealthReportListForUserBlock _healthReportListForUserBlock;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<HealthRecordCollection> mediMasterId = [];

  FlutterToast toast = FlutterToast();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    _healthReportListForUserBlock = HealthReportListForUserBlock();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'LabReports List Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getWidgetToDisplayLabReport(widget.completeData!);
  }

  Widget _getWidgetToDisplayLabReport(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = [];

    mediaMetaInfoObj = CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionLabReport);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: mediaMetaInfoObj.length > 0
          ? Container(
              color: const Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForLabReport(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              ))
          : Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text(
                    Constants.NO_DATA_LAB_REPORT,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: variable.font_poppins,
                      fontSize: CommonUtil().isTablet!
                          ? Constants.tabHeader2
                          : Constants.mobileHeader2,
                    ),
                  ),
                ),
              ),
              color: const Color(fhbColors.bgColorContainer),
            ),
    );
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    widget.callBackToRefresh();
  }

  Widget getCardWidgetForLabReport(HealthResult mediaMetaInfo, int position) {
    return InkWell(
      onLongPress: () {
        if (widget.allowSelect!) {
          mediaMetaInfo.isSelected = !mediaMetaInfo.isSelected!;

          // setState(() {});
          widget.mediaSelected(mediaMetaInfo.id, mediaMetaInfo.isSelected);
        }
      },
      onTap: () {
        if (widget.allowSelect! && widget.showDetails == false) {
          if (widget.allowAttach!) {
            bool condition;
            if (widget.mediaMeta!.contains(mediaMetaInfo.id)) {
              condition = false;
            } else {
              condition = true;
            }
            mediaMetaInfo.isSelected = !mediaMetaInfo.isSelected!;
            if (mediaMetaInfo != null &&
                (mediaMetaInfo.healthRecordCollection?.length ?? 0) > 0) {
              mediMasterId =
                  CommonUtil().getMetaMasterIdListNew(mediaMetaInfo);
              if (mediMasterId.length > 0) {
                widget.healthRecordSelected(
                    mediaMetaInfo.id, mediMasterId, condition);
              } else {
                toast.getToast('No Image Attached ', Colors.red);
              }
            } else {
              toast.getToast('No Image Attached ', Colors.red);
            }
          } else {
            bool condition;
            if (widget.mediaMeta!.contains(mediaMetaInfo.id)) {
              condition = false;
            } else {
              condition = true;
            }
            mediaMetaInfo.isSelected = !mediaMetaInfo.isSelected!;

            // setState(() {});
            widget.mediaSelected(mediaMetaInfo.id, condition);
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordDetailScreen(
                data: mediaMetaInfo,
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
        //height: 90.0.h,
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
          children: <Widget>[
            ClipOval(
                child:
                    /* data.metadata.hospital != null
                      ? data.metadata.hospital.l != null
                          ? Image.network(
                              Constants.BASE_URL +
                                  data.metadata.hospital.logoThumbnail,
                              height: 50.0.h,
                              width: 50.0.h,
                            )
                          :*/
                    CircleAvatar(
              radius: CommonUtil().isTablet! ? 35 : 25,
              backgroundColor: const Color(fhbColors.bgColorContainer),
              child: Image.network(
                /*Constants.BASE_URL +*/
                mediaMetaInfo.metadata!.healthRecordCategory!.logo!,
                height: 30.0.h,
                width: 30.0.h,
                errorBuilder: (context, error, stackTrace) => SizedBox(),
                color: Color(
                  CommonUtil().getMyPrimaryColor(),
                ),
              ),
            )
                /*: Container(
                          height: 50.0.h,
                          width: 50.0.h,
                          color: Colors.grey[200],
                        )*/
                ),
            SizedBox(width: 20.0.w),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mediaMetaInfo.metadata!.laboratory != null
                        ? toBeginningOfSentenceCase(mediaMetaInfo
                            .metadata!.laboratory!.healthOrganizationName)!
                        : '',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: CommonUtil().isTablet!
                            ? tabHeader1
                            : mobileHeader1),
                  ),
                  Text(
                    mediaMetaInfo.metadata!.doctor != null
                        ? (mediaMetaInfo.metadata!.doctor!.name != null &&
                                mediaMetaInfo.metadata!.doctor!.name != '')
                            ? toBeginningOfSentenceCase(
                                mediaMetaInfo.metadata!.doctor!.name)!
                            : mediaMetaInfo.metadata!.doctor!.firstName! +
                                ' ' +
                                mediaMetaInfo.metadata!.doctor!.lastName!
                        : '',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: CommonUtil().isTablet!
                            ? tabHeader2
                            : mobileHeader2),
                  ),
                  Text(
                    FHBUtils()
                        .getFormattedDateString(mediaMetaInfo.createdOn),
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w200,
                        fontSize: CommonUtil().isTablet!
                            ? tabHeader3
                            : mobileHeader3),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: mediaMetaInfo.isBookmarked!
                          ? ImageIcon(
                              AssetImage(variable.icon_record_fav_active),
                              color:
                                  Color(CommonUtil().getMyPrimaryColor()),
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
                        CommonUtil()
                            .bookMarkRecord(mediaMetaInfo, _refresh);
                      }),
                  (mediaMetaInfo.metadata!.hasVoiceNotes != null &&
                          mediaMetaInfo.metadata!.hasVoiceNotes!)
                      ? Icon(
                          Icons.mic,
                          color: Colors.black54,
                        )
                      : Container(),
                  widget.mediaMeta!.contains(mediaMetaInfo.id)
                      ? Icon(
                          Icons.done,
                          color: Color(CommonUtil().getMyPrimaryColor()),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDoctorProfileImageWidget(MediaMetaInfo data) {
    return FutureBuilder(
      future: _healthReportListForUserBlock
          .getProfilePic(data.metaInfo!.doctor!.id!),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data,
            height: 50.0.h,
            width: 50.0.h,
            fit: BoxFit.cover,
          );
        } else {
          return SizedBox(
            width: 50.0.h,
            height: 50.0.h,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[550]!,
                child: Container(
                    width: 50.0.h, height: 50.0.h, color: Colors.grey[200])),
          );
        }

        ///load until snapshot.hasData resolves to true
      },
    );
  }

  getDocumentImageWidget(MediaMetaInfo data) {
    return FutureBuilder(
      future: _healthReportListForUserBlock
          .getDocumentImage(CommonUtil().getMetaMasterId(data)!),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data);
        } else {
          return SizedBox(
            width: 50.0.h,
            height: 50.0.h,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[600]!,
                child: Container(
                    width: 50.0.h, height: 50.0.h, color: Colors.grey[200])),
          );
        }

        ///load until snapshot.hasData resolves to true
      },
    );
  }
}
