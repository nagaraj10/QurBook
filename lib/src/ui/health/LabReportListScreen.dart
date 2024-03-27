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
import '../../../constants/variable_constant.dart' as variable;
import '../../../record_detail/screens/record_detail_screen.dart';
import '../../blocs/health/HealthReportListForUserBlock.dart';
import '../../model/Health/MediaMetaInfo.dart';
import '../../model/Health/asgard/health_record_collection.dart';
import '../../model/Health/asgard/health_record_list.dart';
import '../../utils/FHBUtils.dart';
import '../../utils/screenutils/size_extensions.dart';

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
    _healthReportListForUserBlock = HealthReportListForUserBlock();
    FABService.trackCurrentScreen(FBAMyRecordsLabReportScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      _getWidgetToDisplayLabReport(widget.completeData!);

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
              color: const Color(fhbColors.bgColorContainer),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
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
            ),
    );
  }

  Future<void> _refresh() async {
    await _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
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
              mediMasterId = CommonUtil().getMetaMasterIdListNew(mediaMetaInfo);
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
              await Future.delayed(const Duration(milliseconds: 100));
              widget.callBackToRefresh();
            }
          });
        }
      },
      child: Container(
        //height: 90.0.h,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            const BoxShadow(
              color: Color(fhbColors.cardShadowColor),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 0, // has the effect of extending the shadow
            )
          ],
        ),
        child: Row(
          children: <Widget>[
            ClipOval(
                child: CircleAvatar(
              radius: CommonUtil().isTablet! ? 35 : 25,
              backgroundColor: const Color(fhbColors.bgColorContainer),
              child: Image.network(
                mediaMetaInfo.metadata!.healthRecordCategory!.logo!,
                height: 30.0.h,
                width: 30.0.h,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
                color: Color(
                  CommonUtil().getMyPrimaryColor(),
                ),
              ),
            )),
            SizedBox(width: 20.0.w),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    /// Returns the laboratory name if available, otherwise returns the file name.
                    /// Used to display the title of a lab report list item.
                    (mediaMetaInfo.metadata!.laboratory != null &&
                            mediaMetaInfo.metadata!.doctor != null)
                        ? mediaMetaInfo.metadata!.laboratory != null
                            ? toBeginningOfSentenceCase(mediaMetaInfo
                                .metadata!.laboratory!.healthOrganizationName)!
                            : ''
                        : mediaMetaInfo.metadata!.fileName ?? '',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: CommonUtil().isTablet!
                            ? tabHeader1
                            : mobileHeader1),
                  ),
                  Visibility(
                    visible: mediaMetaInfo.metadata!.doctor != null
                        ? true
                        : mediaMetaInfo.metadata!.laboratory != null
                            ? true
                            : false,
                    child: Text(
                      mediaMetaInfo.metadata!.doctor != null
                          ? (mediaMetaInfo.metadata!.doctor!.name != null &&
                                  mediaMetaInfo.metadata!.doctor!.name != '')
                              ? toBeginningOfSentenceCase(
                                  mediaMetaInfo.metadata!.doctor!.name)!
                              : mediaMetaInfo.metadata!.doctor!.firstName! +
                                  ' ' +
                                  mediaMetaInfo.metadata!.doctor!.lastName!
                          : mediaMetaInfo.metadata!.laboratory != null
                              ? mediaMetaInfo.metadata!.laboratory != null
                                  ? toBeginningOfSentenceCase(mediaMetaInfo
                                      .metadata!
                                      .laboratory!
                                      .healthOrganizationName)!
                                  : ''
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
                  ),
                  Text(
                    FHBUtils().getFormattedDateString(mediaMetaInfo.createdOn),
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
                              const AssetImage(variable.icon_record_fav_active),
                              color: Color(CommonUtil().getMyPrimaryColor()),
                              size: CommonUtil().isTablet!
                                  ? tabHeader2
                                  : mobileHeader2,
                            )
                          : ImageIcon(
                              const AssetImage(variable.icon_record_fav),
                              color: Colors.black,
                              size: CommonUtil().isTablet!
                                  ? tabHeader2
                                  : mobileHeader2,
                            ),
                      onPressed: () {
                        CommonUtil().bookMarkRecord(mediaMetaInfo, _refresh);
                      }),
                  (mediaMetaInfo.metadata!.hasVoiceNotes != null &&
                          mediaMetaInfo.metadata!.hasVoiceNotes!)
                      ? const Icon(
                          Icons.mic,
                          color: Colors.black54,
                        )
                      : Container(),
                  widget.mediaMeta!.contains(mediaMetaInfo.id)
                      ? Icon(
                          Icons.done,
                          color: Color(CommonUtil().getMyPrimaryColor()),
                        )
                      : const SizedBox(),
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
      },
    );
  }
}
