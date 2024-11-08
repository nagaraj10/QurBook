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
import '../../../main.dart';
import '../../../record_detail/screens/record_detail_screen.dart';
import '../../blocs/health/HealthReportListForUserBlock.dart';
import '../../model/Health/MediaMetaInfo.dart';
import '../../model/Health/asgard/health_record_collection.dart';
import '../../model/Health/asgard/health_record_list.dart';
import '../../utils/FHBUtils.dart';

class MedicalReportListScreen extends StatefulWidget {
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

  MedicalReportListScreen(
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
  _MedicalReportListScreenState createState() =>
      _MedicalReportListScreenState();
}

class _MedicalReportListScreenState extends State<MedicalReportListScreen> {
  late HealthReportListForUserBlock _healthReportListForUserBlock;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<HealthRecordCollection> mediMasterId = [];

  FlutterToast toast = FlutterToast();

  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBAMyRecordsMedicalReportScreen);
    _healthReportListForUserBlock = HealthReportListForUserBlock();
  }

  @override
  Widget build(BuildContext context) =>
      _getWidgetToDisplayMedicalrecords(widget.completeData!);

  Widget _getWidgetToDisplayMedicalrecords(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = [];

    mediaMetaInfoObj = CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionMedicalReport);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: mediaMetaInfoObj.length > 0
          ? Container(
              color: const Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForMedicalRecords(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              ))
          : Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text(
                    Constants.NO_DATA_MEDICAL_REPORT,
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

  Widget getCardWidgetForMedicalRecords(HealthResult data, int i) {
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
          //height: 90,
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
                  child: CircleAvatar(
                radius: CommonUtil().isTablet! ? 35 : 25,
                backgroundColor: const Color(fhbColors.bgColorContainer),
                child: Image.network(
                  data.metadata!.healthRecordCategory!.logo!,
                  height: 30,
                  width: 30,
                  color: mAppThemeProvider.primaryColor,
                  errorBuilder: (context, error, stackTrace) => SizedBox(),
                ),
              )
                  /*: Container(
                          height: 50,
                          width: 50,
                          color: Colors.grey[200],
                        )*/
                  ),
              SizedBox(width: 20),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// Displays the hospital name if available, otherwise displays the file name.
                    /// Uses the metadata from the medical report data to check for hospital name.
                    /// Falls back to file name if hospital name is not available.
                    Text((data.metadata?.hospital != null &&
                            data.metadata!.doctor != null)
                        ? data.metadata!.hospital != null
                            ? data.metadata!.hospital!.healthOrganizationName !=
                                    null
                                ? toBeginningOfSentenceCase(data.metadata!
                                    .hospital!.healthOrganizationName)!
                                : ''
                            : ''
                        : data.metadata?.fileName ?? ''),
                    Visibility(
                      /// Determines visibility of doctor name based on metadata.
                      /// Shows doctor name if available in metadata.
                      /// Otherwise shows hospital name if available.
                      /// Falls back to hiding doctor name if neither are available.
                      visible: data.metadata!.doctor != null
                          ? true
                          : data.metadata?.hospital != null
                              ? true
                              : false,
                      child: Text(
                        data.metadata!.doctor != null
                            ? toBeginningOfSentenceCase(
                                (data.metadata!.doctor!.name != null &&
                                        data.metadata!.doctor!.name != '')
                                    ? data.metadata!.doctor!.name
                                    : data.metadata!.doctor!.firstName! +
                                        ' ' +
                                        data.metadata!.doctor!.lastName!)!
                            : data.metadata?.hospital != null
                                ? data.metadata!.hospital != null
                                    ? data.metadata!.hospital!
                                                .healthOrganizationName !=
                                            null
                                        ? toBeginningOfSentenceCase(data
                                            .metadata!
                                            .hospital!
                                            .healthOrganizationName)!
                                        : ''
                                    : ''
                                : '',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader2
                                : mobileHeader2),
                      ),
                    ),
                    Text(
                      FHBUtils().getFormattedDateString(data.createdOn),
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
                        icon: data.isBookmarked!
                            ? ImageIcon(
                                AssetImage(variable.icon_record_fav_active),
                                //TODO chnage theme
                                color: mAppThemeProvider.primaryColor,
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
                            color: mAppThemeProvider.primaryColor,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  getDoctorProfileImageWidget(MediaMetaInfo data) {
    return FutureBuilder(
      future: _healthReportListForUserBlock
          .getProfilePic(data.metaInfo!.doctor!.id!),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          );
        } else {
          return SizedBox(
            width: 50.0,
            height: 50.0,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[550]!,
                child:
                    Container(width: 50, height: 50, color: Colors.grey[200])),
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
            width: 50.0,
            height: 50.0,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[600]!,
                child:
                    Container(width: 50, height: 50, color: Colors.grey[200])),
          );
        }
      },
    );
  }
}
