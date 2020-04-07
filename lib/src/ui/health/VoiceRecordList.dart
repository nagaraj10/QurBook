import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:shimmer/shimmer.dart';

class VoiceRecordList extends StatefulWidget {
  final CompleteData completeData;
  final Function callBackToRefresh;

  VoiceRecordList(this.completeData, this.callBackToRefresh);
  @override
  _VoiceRecordListState createState() => new _VoiceRecordListState();
}

class _VoiceRecordListState extends State<VoiceRecordList> {
  HealthReportListForUserBlock _healthReportListForUserBlock;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    /* WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show()); */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetToDisplayVoiceRecords(widget.completeData);
  }

  Widget getWidgetToDisplayVoiceRecords(CompleteData completeData) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionVoiceRecord);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: mediaMetaInfoObj.length > 0
          ? Container(
              color: const Color(0xFFF7F9Fb),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForVoiceRecords(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              ))
          : Container(
              child: Center(
                child: Text('No Data Available'),
              ),
              color: Colors.grey[300],
            ),
    );
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    widget.callBackToRefresh();
  }

  getCardWidgetForVoiceRecords(MediaMetaInfo mediaMetaInfoObj, int i) {
    return new Padding(
        padding: new EdgeInsets.only(top: 10, bottom: 5),
        child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        color: Colors.grey[200],
                        width: 50.0,
                        height: 50.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              new FHBUtils().convertMonthFromString(
                                  mediaMetaInfoObj.createdOn),
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                                new FHBUtils().convertDateFromString(
                                    mediaMetaInfoObj.createdOn),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18))
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Text(
                        mediaMetaInfoObj.metaInfo.fileName != null
                            ? mediaMetaInfoObj.metaInfo.fileName
                            : '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      mediaMetaInfoObj.isBookmarked
                          ? Icon(
                              Icons.bookmark,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.bookmark,
                              color: Colors.red,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      mediaMetaInfoObj.metaInfo.hasVoiceNotes
                          ? Icon(
                              Icons.mic,
                              color: Colors.black54,
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            )));
  }

  getDocumentImagegetDocumentImageWidget(MediaMetaInfo data) {
    return FutureBuilder(
      future: _healthReportListForUserBlock
          .getDocumentImage(new CommonUtil().getMetaMasterId(data)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data);
        } else {
          return new SizedBox(
            width: 50.0,
            height: 50.0,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[600],
                child:
                    Container(width: 50, height: 50, color: Colors.grey[200])),
          );
        }

        ///load until snapshot.hasData resolves to true
      },
    );
  }
}
