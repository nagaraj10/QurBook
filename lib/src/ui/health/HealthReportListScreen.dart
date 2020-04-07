import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class HealthReportListScreen extends StatefulWidget {
  final String _baseUrl = 'https://healthbook.vsolgmi.com/hb/api/v3/';

  final CompleteData completeData;

  final Function callBackToRefresh;

  HealthReportListScreen(this.completeData, this.callBackToRefresh);
  @override
  _HealthReportListScreenState createState() => _HealthReportListScreenState();
}

class _HealthReportListScreenState extends State<HealthReportListScreen> {
  HealthReportListForUserBlock _healthReportListForUserBlock;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  bool _enabled = true;
  @override
  void initState() {
    _healthReportListForUserBlock = new HealthReportListForUserBlock();
    _healthReportListForUserBlock.getHelthReportList();
    super.initState();

    /* WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show()); */
  }

  @override
  Widget build(BuildContext context) {
    return _getWidgetToDisplayHealthRecords(widget.completeData);
  }

  Widget getResponseWithHealthRecordListWidget() {
    return StreamBuilder<ApiResponse<UserHealthResponseList>>(
      stream: _healthReportListForUserBlock.healthReportStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<UserHealthResponseList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(
                  child: SizedBox(
                child: CircularProgressIndicator(),
                width: 30,
                height: 30,
              ));
              break;

            case Status.ERROR:
              return Text('Unable To load Tabs',
                  style: TextStyle(color: Colors.red));
              break;

            case Status.COMPLETED:
              print(snapshot.data.message);

              return _getWidgetToDisplayHealthRecords(
                  snapshot.data.data.response.data);
              break;
          }
        } else {
          return Container(
            width: 0,
            height: 0,
          );
        }
      },
    );
  }

  Widget _getWidgetToDisplayHealthRecords(CompleteData completeData) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionPrescription);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: mediaMetaInfoObj.length > 0
          ? Container(
              color: const Color(0xFFF7F9Fb),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForPrescribtion(mediaMetaInfoObj[i], i),
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
    await Future.delayed(Duration(milliseconds: 2));

    widget.callBackToRefresh();
  }

  Widget getCardWidgetForPrescribtion(MediaMetaInfo data, int position) {
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      getDoctorProfileImageWidget(
                        data,
                      ),
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
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                                new FHBUtils()
                                    .convertDateFromString(data.createdOn),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500))
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.metaInfo.doctor != null
                            ? data.metaInfo.doctor.name
                            : '',
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        data.metaInfo.hospital != null
                            ? data.metaInfo.hospital.name
                            : '',
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        data.metaInfo.fileName != null
                            ? data.metaInfo.fileName
                            : '',
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                              Icons.bookmark,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.bookmark,
                              color: Colors.red,
                            ),
                      data.metaInfo.hasVoiceNotes
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

  getDoctorProfileImageWidgetNew(MediaMetaInfo data) {
    return CachedNetworkImage(
      imageUrl: widget._baseUrl +
          "doctors/" +
          data.metaInfo.doctor.id +
          "/getprofilepic",
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
        ),
      ),
      placeholder: (context, url) => new SizedBox(
          width: 50.0,
          height: 50.0,
          child: Shimmer.fromColors(
              baseColor: Colors.grey[200],
              highlightColor: Colors.grey[550],
              child:
                  Container(width: 50, height: 50, color: Colors.grey[200]))),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  getDocumentImageWidget(MediaMetaInfo data) {
    return FutureBuilder(
      future: _healthReportListForUserBlock
          .getDocumentImage(new CommonUtil().getMetaMasterId(data)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), color: Colors.white24),
            child: Image.memory(
              snapshot.data,
              width: 40,
              height: 60,
            ),
          );
        } else {
          return new SizedBox(
            width: 40.0,
            height: 60.0,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[400],
                child:
                    Container(width: 50, height: 50, color: Colors.grey[200])),
          );
        }

        ///load until snapshot.hasData resolves to true
      },
    );
  }

  getDocumentImageWidgetNew(MediaMetaInfo data) {
    return CachedNetworkImage(
      imageUrl: widget._baseUrl +
          "mediameta/" +
          Constants.USER_ID +
          "/getRawMedia/" +
          new CommonUtil().getMetaMasterId(data),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
        ),
      ),
      placeholder: (context, url) => new SizedBox(
          width: 50.0,
          height: 50.0,
          child: Shimmer.fromColors(
              baseColor: Colors.grey[200],
              highlightColor: Colors.grey[550],
              child:
                  Container(width: 50, height: 50, color: Colors.grey[200]))),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
