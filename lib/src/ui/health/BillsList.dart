import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:shimmer/shimmer.dart';

class BillsList extends StatefulWidget {
  final HealthRecordList completeData;
  final Function callBackToRefresh;

  final String categoryName;
  final String categoryId;

  final Function(String, String) getDataForParticularLabel;
  final Function(String, bool) mediaSelected;
  final Function(String, List<HealthRecordCollection>, bool)
      healthRecordSelected;
  final bool allowSelect;
  final List<String> mediaMeta;
  final bool isNotesSelect;
  final bool isAudioSelect;
  final bool showDetails;
  final bool allowAttach;

  BillsList(
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
  _BillsListState createState() => new _BillsListState();
}

class _BillsListState extends State<BillsList> {
  HealthReportListForUserBlock _healthReportListForUserBlock;
  List<HealthRecordCollection> mediMasterId = new List();

  FlutterToast toast = new FlutterToast();

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetToDisplayBillsList(widget.completeData);
  }

  Widget getWidgetToDisplayBillsList(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionBills);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: mediaMetaInfoObj.length > 0
          ? Container(
              color: const Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForBills(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              ))
          : Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text(
                    Constants.NO_DATA_BILLS,
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

  getCardWidgetForBills(HealthResult mediaMetaInfoObj, int i) {
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
                mediaMetaInfoObj.healthRecordCollection.length > 0) {
              mediMasterId =
                  new CommonUtil().getMetaMasterIdListNew(mediaMetaInfoObj);
              if (mediMasterId.length > 0) {
                widget.healthRecordSelected(
                    mediaMetaInfoObj.id, mediMasterId, condition);
              } else {
                toast.getToast('No Image Attached ', Colors.red);
              }
            }
          } else {
            bool condition;
            if (widget.mediaMeta.contains(mediaMetaInfoObj.id)) {
              condition = false;
            } else {
              condition = true;
            }
            mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected;

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
            )
          ],
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(fhbColors.bgColorContainer),
              child: Image.network(
                /* mediaMetaInfoObj.metadata.healthRecordType.url != null
                    ? mediaMetaInfoObj.metaInfo.mediaTypeInfo.url
                    : */
                Constants.BASE_URL +
                    mediaMetaInfoObj.metadata.healthRecordCategory.logo,
                height: 25,
                width: 25,
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
                  Text(
                    mediaMetaInfoObj.metadata.fileName != null
                        ? mediaMetaInfoObj.metadata.fileName
                        : '',
                    style: TextStyle(fontWeight: FontWeight.w500),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    mediaMetaInfoObj.createdOn != ''
                        ? new FHBUtils()
                            .getFormattedDateString(mediaMetaInfoObj.createdOn)
                        : '',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
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
                              //TODO chnage theme
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
      ),
    );
  }

  getDocumentImageWidget(MediaMetaInfo data) {
    return new FutureBuilder(
      future: _healthReportListForUserBlock
          .getDocumentImage(new CommonUtil().getMetaMasterId(data)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: 40,
            height: 60,
            child: Image.memory(snapshot.data),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          );
        } else {
          return new Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                width: 50,
                height: 50,
              ));
        }
      },
    );
  }
}
