import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/bookmark_record/bloc/bookmarkRecordBloc.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

class HealthReportListScreen extends StatefulWidget {
  final CompleteData completeData;

  final Function callBackToRefresh;

  final String categoryName;
  final String categoryId;

  final Function(String, String) getDataForParticularLabel;

  HealthReportListScreen(this.completeData, this.callBackToRefresh,
      this.categoryName, this.categoryId, this.getDataForParticularLabel);

  @override
  _HealthReportListScreenState createState() => _HealthReportListScreenState();
}

class _HealthReportListScreenState extends State<HealthReportListScreen> {
  HealthReportListForUserBlock _healthReportListForUserBlock;
  BookmarkRecordBloc _bookmarkRecordBloc;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  bool _enabled = true;
  @override
  void initState() {
    _healthReportListForUserBlock = new HealthReportListForUserBlock();
    _healthReportListForUserBlock.getHelthReportList();
    widget.getDataForParticularLabel(widget.categoryName, widget.categoryId);
    PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, widget.categoryName);
    PreferenceUtil.saveString(Constants.KEY_CATEGORYID, widget.categoryId);

    _bookmarkRecordBloc = BookmarkRecordBloc();

    PreferenceUtil.init();

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
              //print(snapshot.data.message);

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
              color: const Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                //shrinkWrap: true,
                itemBuilder: (c, i) =>
                    getCardWidgetForPrescription(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              ))
          : Container(
              child: Center(
                child: Text('No Data Available'),
              ),
              color: const Color(fhbColors.bgColorContainer),
            ),
    );
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(milliseconds: 2));

    widget.callBackToRefresh();
  }

  Widget getCardWidgetForPrescription(MediaMetaInfo data, int position) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordDetailScreen(
                data: data,
              ),
            ),
          );
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
                    child: data.metaInfo.doctor != null
                        ? getDoctorProfileImageWidget(data)
                        : Container(
                            width: 50,
                            height: 50,
                            color: const Color(fhbColors.bgColorContainer))),
                SizedBox(width: 20),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.metaInfo.doctor.name,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Visibility(
                          visible:
                              data.metaInfo.hospital != null ? true : false,
                          child: Text(
                            data.metaInfo.hospital != null
                                ? data.metaInfo.hospital.name
                                : '',
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          )),
                      Text(
                        new FHBUtils().getFormattedDateString(data.createdOn),
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w200,
                            fontSize: 12),
                      )
                      /*  Text(mediaMetaInfo.metaInfo.fileName != null
                      ? mediaMetaInfo.metaInfo.fileName
                      : ''), */
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /*   Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                      SizedBox(height: 20), */
                      IconButton(
                          icon: data.isBookmarked
                              ? ImageIcon(
                                  AssetImage(
                                      'assets/icons/record_fav_active.png'),
                                  //TODO chnage theme
                                  color: Color(
                                      new CommonUtil().getMyPrimaryColor()),
                                  size: 20,
                                )
                              : ImageIcon(
                                  AssetImage('assets/icons/record_fav.png'),
                                  color: Colors.black,
                                  size: 20,
                                ),
                          /* ImageIcon(
                            AssetImage('assets/icons/record_fav.png'),
                            color:
                                data.isBookmarked ? Colors.red : Colors.black,
                          ), */
                          onPressed: () {
                            new CommonUtil().bookMarkRecord(data, _refresh);
                          }),
                    ],
                  ),
                ),
              ],
            )));

    /*  child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
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
                  child: getDoctorProfileImageWidget(
                    data,
                  ),
                ),

                /* Column(
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
                          new FHBUtils().convertMonthFromString(data.createdOn),
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
              ), */

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
                        data.metaInfo.doctor == null
                            ? ''
                            : data.metaInfo.doctor.name,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      //SizedBox(height: 10.0),
                      Text(
                        data.metaInfo.hospital == null
                            ? 'Apollo Hospital'
                            : data.metaInfo.hospital.name,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                      //SizedBox(height: 10.0),
                      Text(
                        new FHBUtils().getFormattedDateString(data.createdOn),
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w200,
                            fontSize: 12),
                      )
                      /* Text(
                    data.metaInfo.fileName == null
                        ? ''
                        : data.metaInfo.fileName,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ), */
                    ],
                  ),
                ),
                /* Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  getDocumentImageWidget(data),
                ],
              ),
            ),
            */
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            child: Icon(
                              Icons.more_horiz,
                              size: 22,
                              color: Colors.grey,
                            ),
                            onTap: () {},
                          ),
                          SizedBox(height: 20),
                          IconButton(
                            icon: data.isBookmarked
                                ? Icon(
                                    Icons.bookmark,
                                    size: 22,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    Icons.bookmark_border,
                                    size: 22,
                                    color: Colors.grey,
                                  ),
                            onPressed: () {},
                          )

                          /*  (data.mediaMasterIds.isNotEmpty &&
                          data.metaInfo.hasVoiceNotes)
                      ? Icon(
                          Icons.mic,
                          color: Colors.black54,
                        )
                      : Container() */
                        ],
                      ),
                    )),
              ],
            )));
   */
  }

  getDoctorProfileImageWidget(MediaMetaInfo data) {
    return FutureBuilder(
      future:
          _healthReportListForUserBlock.getProfilePic(data.metaInfo.doctor.id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          );
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
      imageUrl: Constants.BASERURL +
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
    //print(data.mediaMasterIds);
    if (data.mediaMasterIds.isNotEmpty) {
      return FutureBuilder(
        future: _healthReportListForUserBlock
            .getDocumentImage(new CommonUtil().getMetaMasterId(data)),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white24),
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
                  child: Container(
                      width: 50, height: 50, color: Colors.grey[200])),
            );
          }

          ///load until snapshot.hasData resolves to true
        },
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  getDocumentImageWidgetNew(MediaMetaInfo data) {
    String usrId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    return CachedNetworkImage(
      imageUrl: Constants.BASERURL +
          "mediameta/" +
          usrId +
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

  bookMarkRecord(MediaMetaInfo data) {
    List<String> mediaIds = [];
    mediaIds.add(data.id);
    bool _isRecordBookmarked = data.isBookmarked;
    if (_isRecordBookmarked) {
      _isRecordBookmarked = false;
    } else {
      _isRecordBookmarked = true;
    }
    _bookmarkRecordBloc
        .bookMarcRecord(mediaIds, _isRecordBookmarked)
        .then((bookmarkRecordResponse) {
      if (bookmarkRecordResponse.success) {
        _refresh();
      }
    });
  }
}
