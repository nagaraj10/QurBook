import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/common/PreferenceUtil.dart';

class DeviceListScreen extends StatefulWidget {
  final CompleteData completeData;
  final Function callBackToRefresh;

  final String categoryName;
  final String categoryId;

  final Function(String, String) getDataForParticularLabel;

  DeviceListScreen(this.completeData, this.callBackToRefresh, this.categoryName,
      this.categoryId, this.getDataForParticularLabel);

  @override
  _DeviceListScreentState createState() => _DeviceListScreentState();
}

class _DeviceListScreentState extends State<DeviceListScreen> {
  HealthReportListForUserBlock _healthReportListForUserBlock;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _healthReportListForUserBlock = new HealthReportListForUserBlock();
    /*  WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show()); */
    widget.getDataForParticularLabel(widget.categoryName, widget.categoryId);
    PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, widget.categoryName);
    PreferenceUtil.saveString(Constants.KEY_CATEGORYID, widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getWidgetToDisplayDeviceList(widget.completeData);
  }

  Widget _getWidgetToDisplayDeviceList(CompleteData completeData) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionDevice);
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: mediaMetaInfoObj.length > 0
            ? Container(
                color: const Color(fhbColors.bgColorContainer),
                child: ListView.builder(
                  itemBuilder: (c, i) =>
                      getCardWidgetForDevice(mediaMetaInfoObj[i], i),
                  itemCount: mediaMetaInfoObj.length,
                ))
            : Container(
                color: const Color(fhbColors.bgColorContainer),
                child: Center(
                  child: Text('No Data Available'),
                ),
              ));
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    widget.callBackToRefresh();
  }

  Widget getCardWidgetForDevice(MediaMetaInfo data, int position) {
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
            //height: 70,
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
                /*  Expanded(
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
                          new FHBUtils().convertMonthFromString(data.createdOn),
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                            new FHBUtils()
                                .convertDateFromString(data.createdOn),
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            ), */

                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(fhbColors.bgColorContainer),
                  child: Image.network(
                    data.metaInfo.mediaTypeInfo.url != null
                        ? data.metaInfo.mediaTypeInfo.url
                        : Constants.BASERURL + data.metaInfo.mediaTypeInfo.logo,
                    height: 25,
                    width: 25,
                    color: Color(new CommonUtil().getMyPrimaryColor()),
                  ),

                  /* FadeInImage(
                      height: 30,
                      width: 30,
                      placeholder: NetworkImage(
                          'https://healthbook.vsolgmi.com/hb/api/v3/static/logos/categories/device-c.png'),
                      image: NetworkImage(
                        data.metaInfo.mediaTypeInfo.url != null
                            ? data.metaInfo.mediaTypeInfo.url
                            : Constants.BASERURL +
                                data.metaInfo.mediaTypeInfo.logo,
                      )), */

                  /*  FadeInImage(
                      height: 30,
                      width: 30,
                      placeholder: NetworkImage(
                          'https://healthbook.vsolgmi.com/hb/api/v3/static/logos/categories/device-c.png'),
                      image: NetworkImage(
                        data.metaInfo.mediaTypeInfo.url,
                      )), */
                  /*  child: Image.network(
                  data.metaInfo.mediaTypeInfo.url,
                  width: 30,
                  height: 30,
                  color: Colors.white,
                ):Image.network('https://healthbook.vsolgmi.com/hb/api/v3/static/logos/categories/device-c.png') */
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.metaInfo.mediaTypeInfo.name != null
                            ? data.metaInfo.mediaTypeInfo.name
                            : '',
                        style: TextStyle(fontWeight: FontWeight.w500),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      //SizedBox(height: 10.0),
                      Text(
                        /*  data.metaInfo.fileName != null
                        ? data.metaInfo.fileName
                        : '', */
                        new FHBUtils().getFormattedDateString(data.createdOn),
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w200,
                            fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
                /*  Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[getDocumentImageWidget(data)],
              ),
            ), */
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /* Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                        size: 20,
                      ),
                      SizedBox(height: 10), */
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
                          onPressed: () {
                            new CommonUtil().bookMarkRecord(data, _refresh);
                          }),
                      /*  data.metaInfo.hasVoiceNotes
                          ? Icon(
                              Icons.audiotrack,
                              color: Colors.grey,
                            )
                          : Container() */
                    ],
                  ),
                ),
              ],
            )));
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

        ///load until snapshot.hasData resolves to true
      },
    );
  }
}
