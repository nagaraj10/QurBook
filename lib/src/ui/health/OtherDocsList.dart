import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class OtherDocsList extends StatefulWidget {
  final HealthRecordList completeData;
  final Function callBackToRefresh;
  final String categoryName;
  final String categoryId;
  final String categoryDescription;

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

  OtherDocsList(
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
      this.showDetails,
      this.allowAttach,
      this.healthRecordSelected);

  @override
  _OtherDocsState createState() => _OtherDocsState();
}

class _OtherDocsState extends State<OtherDocsList> {
  HealthReportListForUserBlock _healthReportListForUserBlock;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<HealthRecordCollection> mediMasterId = new List();

  FlutterToast toast = new FlutterToast();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'OtherDocs List Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetToDisplayOtherDocsList(widget.completeData);
  }

  Widget getWidgetToDisplayOtherDocsList(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForParticularCategoryDescription(
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
                    style: TextStyle(fontFamily: variable.font_poppins),
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
          if (widget.allowSelect) {
            mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected;

            setState(() {});
            widget.mediaSelected(
                mediaMetaInfoObj.id, mediaMetaInfoObj.isSelected);
          }
        },
        onTap: () {
          if (widget.allowSelect && widget.showDetails == false) {
            if (widget.allowAttach) {
              bool condition;
              if (widget.mediaMeta.contains(mediaMetaInfoObj.id)) {
                condition = false;
              } else {
                condition = true;
              }
              mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected;
              if (mediaMetaInfoObj != null &&
                  (mediaMetaInfoObj?.healthRecordCollection?.length??0) > 0) {
                mediMasterId =
                    new CommonUtil().getMetaMasterIdListNew(mediaMetaInfoObj);
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
              if (widget.mediaMeta.contains(mediaMetaInfoObj.id)) {
                condition = false;
              } else {
                condition = true;
              }
              mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected;

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
            );
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
                radius: 25,
                backgroundColor: const Color(fhbColors.bgColorContainer),
                child: Image.network(
                  /* mediaMetaInfoObj.metaInfo.mediaTypeInfo.url != null
                      ? mediaMetaInfoObj.metaInfo.mediaTypeInfo.url
                      :
                  Constants.BASE_URL +*/
                  mediaMetaInfoObj.metadata.healthRecordCategory.logo,
                  height: 25.0.h,
                  width: 25.0.h,
                  color: Color(new CommonUtil().getMyPrimaryColor()),
                ),
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
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Text(
                      mediaMetaInfoObj.metadata.fileName != null
                          ? mediaMetaInfoObj.metadata.fileName
                          : '',
                      style: TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    Text(
                      mediaMetaInfoObj.createdOn != ''
                          ? new FHBUtils().getFormattedDateString(
                              mediaMetaInfoObj.createdOn)
                          : new FHBUtils().getFormattedDateString(
                              mediaMetaInfoObj
                                  .metadata.healthRecordType.createdOn),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.0.sp,
                      ),
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
                        icon: mediaMetaInfoObj.isBookmarked
                            ? ImageIcon(
                                AssetImage(variable.icon_record_fav_active),
                                color:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                size: 20,
                              )
                            : ImageIcon(
                                AssetImage(variable.icon_record_fav),
                                color: Colors.black,
                                size: 20,
                              ),
                        onPressed: () {
                          new CommonUtil()
                              .bookMarkRecord(mediaMetaInfoObj, _refresh);
                        }),
                    (mediaMetaInfoObj.metadata.hasVoiceNotes != null &&
                            mediaMetaInfoObj.metadata.hasVoiceNotes)
                        ? Icon(
                            Icons.mic,
                            color: Colors.black54,
                          )
                        : Container(),
                    widget.mediaMeta.contains(mediaMetaInfoObj.id)
                        ? Icon(
                            Icons.done,
                            color: Color(new CommonUtil().getMyPrimaryColor()),
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
          .getDocumentImage(new CommonUtil().getMetaMasterId(data)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data);
        } else {
          return new SizedBox(
            width: 50.0.h,
            height: 50.0.h,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[600],
                child: Container(
                    width: 50.0.h, height: 50.0.h, color: Colors.grey[200])),
          );
        }

        ///load until snapshot.hasData resolves to true
      },
    );
  }
}
