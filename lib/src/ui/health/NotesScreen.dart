import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../colors/fhb_colors.dart' as fhbColors;
import '../../../common/CommonUtil.dart';
import '../../../common/FHBBasicWidget.dart';
import '../../../common/common_circular_indicator.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/fhb_constants.dart';
import '../../../constants/variable_constant.dart' as variable;
import '../../../record_detail/screens/record_detail_screen.dart';
import '../../blocs/health/HealthReportListForUserBlock.dart';
import '../../model/Health/MediaMetaInfo.dart';
import '../../model/Health/asgard/health_record_list.dart';
import '../../resources/network/ApiResponse.dart';
import '../../utils/FHBUtils.dart';
import '../../utils/screenutils/size_extensions.dart';

class NotesScreenList extends StatefulWidget {
  final HealthRecordList? completeData;
  final Function callBackToRefresh;
  final String? categoryName;
  final String? categoryId;
  final String categoryDescription;

  final Function(String, String) getDataForParticularLabel;
  final Function(String?, bool?, HealthResult) mediaSelected;
  final bool? allowSelect;
  List<String?>? mediaMeta;
  final bool? isNotesSelect;
  final bool? isAudioSelect;
  final bool? showDetails;

  NotesScreenList(
      this.completeData,
      this.callBackToRefresh,
      this.categoryName,
      this.categoryId,
      this.getDataForParticularLabel,
      this.categoryDescription,
      this.mediaSelected,
      this.allowSelect,
      this.mediaMeta,
      this.isNotesSelect,
      this.isAudioSelect,
      this.showDetails);

  @override
  _NotesScreenListState createState() => _NotesScreenListState();
}

class _NotesScreenListState extends State<NotesScreenList> {
  late HealthReportListForUserBlock _healthReportListForUserBlock;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _healthReportListForUserBlock = HealthReportListForUserBlock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetToDisplayOtherDocsList(widget.completeData!);
  }

  Widget getWidgetToDisplayOtherDocsList(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = [];

    mediaMetaInfoObj = CommonUtil().getDataForParticularCategoryDescription(
        completeData, widget.categoryDescription);

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: mediaMetaInfoObj.length > 0
          ? Container(
              color: const Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForOtherDocs(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              ))
          : Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text(
                    Constants.NO_DATA_OTHERS,
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

  getCardWidgetForOtherDocs(HealthResult mediaMetaInfoObj, int i) {
    return InkWell(
        onLongPress: () {
          if (widget.isNotesSelect!) {
            mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected!;

            setState(() {});
            widget.mediaSelected(mediaMetaInfoObj.id,
                mediaMetaInfoObj.isSelected, mediaMetaInfoObj);
          }
        },
        onTap: () {
          if (widget.isNotesSelect! && widget.showDetails == false) {
            bool condition;
            if (widget.mediaMeta!.contains(mediaMetaInfoObj.id)) {
              condition = false;
            } else {
              condition = true;
            }
            mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected!;

            // setState(() {});
            widget.mediaSelected(
                mediaMetaInfoObj.id, condition, mediaMetaInfoObj);
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
                  // has the effect of extending the shadow
                )
              ],
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: CommonUtil().isTablet! ? 35 : 25,
                  backgroundColor: const Color(fhbColors.bgColorContainer),
                  child:
                      mediaMetaInfoObj.metadata!.healthRecordCategory!.logo !=
                              null
                          ? Image.network(
                              /* mediaMetaInfoObj.metaInfo.mediaTypeInfo.url != null
                        ? mediaMetaInfoObj.metaInfo.mediaTypeInfo.url
                        :
                          Constants.BASE_URL +*/
                              mediaMetaInfoObj
                                  .metadata!.healthRecordCategory!.logo!,
                              height: 25.0.h,
                              width: 25.0.h,
                              color: Color(CommonUtil().getMyPrimaryColor()),
                              errorBuilder: (context, error, stackTrace) =>
                                  SizedBox(),
                            )
                          : SizedBox(),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0.h),
                      Text(
                        mediaMetaInfoObj.metadata!.fileName != null
                            ? mediaMetaInfoObj.metadata!.fileName!
                            : '',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader1
                                : mobileHeader1),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      Text(
                        FHBUtils()
                            .getFormattedDateString(mediaMetaInfoObj.createdOn),
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader2
                                : mobileHeader2),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: mediaMetaInfoObj.isBookmarked!
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
                              color: Color(CommonUtil().getMyPrimaryColor()),
                            )
                          : SizedBox(),
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

  Widget getNotes() {
    return StreamBuilder<ApiResponse<HealthRecordList>>(
      stream: _healthReportListForUserBlock.healthReportStreams,
      builder:
          (context, AsyncSnapshot<ApiResponse<HealthRecordList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: SizedBox(
                  child: CommonCircularIndicator(),
                  width: 30.0.h,
                  height: 30.0.h,
                )),
              );
              break;

            case Status.ERROR:
              return FHBBasicWidget.getRefreshContainerButton(
                  snapshot.data!.message, () {
                setState(() {});
              });
              break;

            case Status.COMPLETED:
              //_healthReportListForUserBlock = null;

              return getWidgetToDisplayOtherDocsList(snapshot.data!.data!);
              break;
          }
        } else {
          return Container(height: 0.0.h, color: Colors.white);
        }
      },
    );
  }
}
