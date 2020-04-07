import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:shimmer/shimmer.dart';

class MedicalReportListScreen extends StatefulWidget {
  final CompleteData completeData;
  final Function callBackToRefresh;

  MedicalReportListScreen(this.completeData, this.callBackToRefresh);
  @override
  _MedicalReportListScreenState createState() =>
      new _MedicalReportListScreenState();
}

class _MedicalReportListScreenState extends State<MedicalReportListScreen> {
  HealthReportListForUserBlock _healthReportListForUserBlock;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    /*  WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show()); */
  }

  @override
  Widget build(BuildContext context) {
    return _getWidgetToDisplayMedicalrecords(widget.completeData);
  }

  Widget _getWidgetToDisplayMedicalrecords(CompleteData completeData) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionMedicalReport);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: mediaMetaInfoObj.length > 0
          ? Container(
              color: const Color(0xFFF7F9Fb),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForMedicalRecords(mediaMetaInfoObj[i], i),
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
  }

  Widget getCardWidgetForMedicalRecords(MediaMetaInfo data, int i) {
    return Padding(
        padding: new EdgeInsets.only(top: 10, bottom: 5),
        child: Container(
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
                      getDoctorProfileImageWidget(data),
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
                                  .convertMonthFromString(data.createdOn),
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                                new FHBUtils()
                                    .convertDateFromString(data.createdOn),
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
                        data.metaInfo.hospital.name,
                      ),
                      SizedBox(height: 10.0),
                      Text(data.metaInfo.doctor != null
                          ? data.metaInfo.doctor.name
                          : ''),
                      SizedBox(height: 10.0),
                      Text(data.metaInfo.fileName != null
                          ? data.metaInfo.fileName
                          : ''),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      getDocumentImageWidget(data),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      data.isBookmarked
                          ? Icon(
                              Icons.star,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                      data.metaInfo.hasVoiceNotes
                          ? Icon(
                              Icons.audiotrack,
                              color: Colors.grey,
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            )));
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
