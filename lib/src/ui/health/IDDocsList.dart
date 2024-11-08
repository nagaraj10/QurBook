import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
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
import '../../utils/screenutils/size_extensions.dart';

class IDDocsList extends StatefulWidget {
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

  IDDocsList(
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
  _IDDocsListState createState() => _IDDocsListState();
}

class _IDDocsListState extends State<IDDocsList> {
  late HealthReportListForUserBlock _healthReportListForUserBlock;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<HealthRecordCollection> mediMasterId = [];

  FlutterToast toast = FlutterToast();

  @override
  void initState() {
    _healthReportListForUserBlock = HealthReportListForUserBlock();
    FABService.trackCurrentScreen(FBAMyRecordsIDDocsScreen);

    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      getWidgetToDisplayIDDocs(widget.completeData!);

  Widget getWidgetToDisplayIDDocs(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = [];

    mediaMetaInfoObj = CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionIDDocs);

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: mediaMetaInfoObj.length > 0
          ? Container(
              color: const Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForDocs(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              ))
          : Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text(
                    Constants.NO_ID_DOCS,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: variable.font_poppins,
                        fontSize: CommonUtil().isTablet!
                            ? Constants.tabHeader2
                            : Constants.mobileHeader2),
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

  getCardWidgetForDocs(HealthResult mediaMetaInfoObj, int i) {
    return InkWell(
        onLongPress: () {
          if (widget.allowSelect!) {
            mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected!;

            setState(() {});
            widget.mediaSelected(
                mediaMetaInfoObj.id, mediaMetaInfoObj.isSelected);
          }
        },
        onTap: () {
          if (widget.allowSelect! && widget.showDetails == false) {
            if (widget.allowAttach!) {
              bool condition;
              if (widget.mediaMeta!.contains(mediaMetaInfoObj.id)) {
                condition = false;
              } else {
                condition = true;
              }
              mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected!;
              if (mediaMetaInfoObj != null &&
                  (mediaMetaInfoObj.healthRecordCollection?.length ?? 0) > 0) {
                mediMasterId =
                    CommonUtil().getMetaMasterIdListNew(mediaMetaInfoObj);
                if (mediMasterId.length > 0) {
                  widget.healthRecordSelected(
                      mediaMetaInfoObj.id, mediMasterId, condition);
                } else {
                  toast.getToast('No Image Attached ', Colors.red);
                }
              } else {
                toast.getToast('No Image Attached ', Colors.red);
              }
            } else {
              bool condition;
              if (widget.mediaMeta!.contains(mediaMetaInfoObj.id)) {
                condition = false;
              } else {
                condition = true;
              }
              mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected!;

              // setState(() {});
              widget.mediaSelected(mediaMetaInfoObj.id, condition);
            }
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecordDetailScreen(
                  data: mediaMetaInfoObj,
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
              CircleAvatar(
                radius: CommonUtil().isTablet! ? 35 : 25,
                backgroundColor: const Color(fhbColors.bgColorContainer),
                child: Image.network(
                  /*mediaMetaInfoObj.metaInfo.mediaTypeInfo.url != null
                        ? mediaMetaInfoObj.metaInfo.mediaTypeInfo.url
                        :
                  Constants.BASE_URL +*/
                  mediaMetaInfoObj.metadata!.healthRecordCategory!.logo!,
                  height: 25.0.h,
                  width: 25.0.h,
                  color: mAppThemeProvider.primaryColor,
                  errorBuilder: (context, error, stackTrace) => SizedBox(),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mediaMetaInfoObj.metadata!.fileName != null
                          ? mediaMetaInfoObj.metadata!.fileName!
                          : '',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader1
                              : mobileHeader1),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Visibility(
                        visible: mediaMetaInfoObj.metadata!.dateOfVisit != null
                            ? true
                            : false,
                        child: Visibility(
                          /// Checks if the dateOfVisit field on the metadata object is not null and not empty
                          /// to determine if the dateOfVisit should be visible.
                          visible: (mediaMetaInfoObj.metadata!.dateOfVisit !=
                                      null &&
                                  mediaMetaInfoObj.metadata!.dateOfVisit != "")
                              ? true
                              : false,
                          child: Text(
                            (mediaMetaInfoObj.metadata!.dateOfVisit != null &&
                                    mediaMetaInfoObj.metadata!.dateOfVisit !=
                                        "")
                                ? variable.strValidThru +
                                    mediaMetaInfoObj.metadata!.dateOfVisit!
                                : '',
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: CommonUtil().isTablet!
                                    ? tabHeader2
                                    : mobileHeader2),
                          ),
                        )),
                    Text(
                      FHBUtils()
                          .getFormattedDateString(mediaMetaInfoObj.createdOn),
                      style: TextStyle(
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader3
                              : mobileHeader3,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w200),
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
                        icon: mediaMetaInfoObj.isBookmarked!
                            ? ImageIcon(
                                AssetImage(variable.icon_record_fav_active),
                                //TODO chnage theme
                                color: mAppThemeProvider.primaryColor,
                                size: 20,
                              )
                            : ImageIcon(
                                AssetImage(variable.icon_record_fav),
                                color: Colors.black,
                                size: 20,
                              ),
                        onPressed: () {
                          CommonUtil()
                              .bookMarkRecord(mediaMetaInfoObj, _refresh);
                        }),
                    (mediaMetaInfoObj.metadata!.hasVoiceNotes != null &&
                            mediaMetaInfoObj.metadata!.hasVoiceNotes!)
                        ? Icon(
                            Icons.mic,
                            color: Colors.black54,
                          )
                        : Container(),
                    widget.mediaMeta!.contains(mediaMetaInfoObj.id)
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

  getDocumentImageWidget(MediaMetaInfo data) {
    return FutureBuilder(
      future: _healthReportListForUserBlock
          .getDocumentImage(CommonUtil().getMetaMasterId(data)!),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: 40.0.h,
            height: 60.0.h,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Image.memory(snapshot.data),
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

        ///load until snapshot.hasData resolves to true
      },
    );
  }
}
