import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:shimmer/shimmer.dart';

class LabReportListScreen extends StatefulWidget {
  final CompleteData completeData;
  final Function callBackToRefresh;

  LabReportListScreen(this.completeData, this.callBackToRefresh);

  @override
  _LabReportListScreenState createState() => _LabReportListScreenState();
}

class _LabReportListScreenState extends State<LabReportListScreen> {
  HealthReportListForUserBlock _healthReportListForUserBlock;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    super.initState();
    /*  WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show()); */
  }

  @override
  Widget build(BuildContext context) {
    return _getWidgetToDisplayLabReport(widget.completeData);
  }

  Widget _getWidgetToDisplayLabReport(CompleteData completeData) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionLabReport);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: mediaMetaInfoObj.length > 0
          ? Container(
              color: const Color(0xFFF7F9Fb),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForLabReport(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              ))
          : Container(
              child: Center(
                  //child: Text('No Data Available'),
                  child: Image.asset(
                'assets/norecordfound.png',
                height: 120,
                width: 120,
              )),
              color: Colors.grey[300],
            ),
    );
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    widget.callBackToRefresh();

    //network call and setState so that view will render the new values
    print("refresh");

    //_healthReportListForUserBlock.getHelthReportList();
  }

  Widget getCardWidgetForLabReport(MediaMetaInfo mediaMetaInfo, int position) {
    return Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  getDoctorProfileImageWidget(mediaMetaInfo),
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
                          new FHBUtils()
                              .convertMonthFromString(mediaMetaInfo.createdOn),
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                            new FHBUtils()
                                .convertDateFromString(mediaMetaInfo.createdOn),
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mediaMetaInfo.metaInfo.laboratory.name,
                  ),
                  SizedBox(height: 10.0),
                  Text(mediaMetaInfo.metaInfo.doctor != null
                      ? mediaMetaInfo.metaInfo.doctor.name
                      : ''),
                  SizedBox(height: 10.0),
                  Text(mediaMetaInfo.metaInfo.fileName != null
                      ? mediaMetaInfo.metaInfo.fileName
                      : ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[getDocumentImageWidget(mediaMetaInfo)],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  mediaMetaInfo.isBookmarked
                      ? Icon(
                          Icons.star,
                          color: Colors.grey,
                        )
                      : Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                  mediaMetaInfo.metaInfo.hasVoiceNotes
                      ? Icon(
                          Icons.audiotrack,
                          color: Colors.grey,
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ));
  }

  getDoctorProfileImageWidget(MediaMetaInfo data) {
    return FutureBuilder(
      future:
          _healthReportListForUserBlock.getProfilePic(data.metaInfo.doctor.id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data);
        } else {
          return new SizedBox(
            width: 50.0,
            height: 50.0,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[550],
                child:
                    Container(width: 50, height: 50, color: Colors.grey[200])),
          );
        }

        ///load until snapshot.hasData resolves to true
      },
    );
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
