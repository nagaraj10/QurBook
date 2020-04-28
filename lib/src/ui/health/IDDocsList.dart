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

class IDDocsList extends StatefulWidget {
  final CompleteData completeData;
  final Function callBackToRefresh;
  final String categoryName;
  final String categoryId;

  final Function(String, String) getDataForParticularLabel;

  IDDocsList(this.completeData, this.callBackToRefresh, this.categoryName,
      this.categoryId, this.getDataForParticularLabel);

  @override
  _IDDocsListState createState() => new _IDDocsListState();
}

class _IDDocsListState extends State<IDDocsList> {
  HealthReportListForUserBlock _healthReportListForUserBlock;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _healthReportListForUserBlock = new HealthReportListForUserBlock();
    PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, widget.categoryName)
        .then((value) {
      PreferenceUtil.saveString(Constants.KEY_CATEGORYID, widget.categoryId)
          .then((value) {
        widget.getDataForParticularLabel(
            widget.categoryName, widget.categoryId);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetToDisplayIDDocs(widget.completeData);
  }

  Widget getWidgetToDisplayIDDocs(CompleteData completeData) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionIDDocs);
    print('IDDOcs ' + mediaMetaInfoObj.length.toString());

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
                child: Text('No Data Available'),
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

  getCardWidgetForDocs(MediaMetaInfo mediaMetaInfoObj, int i) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordDetailScreen(
                data: mediaMetaInfoObj,
              ),
            ),
          );
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
                /*     Expanded(
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
                                fontSize: 18,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            ),
            */
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(fhbColors.bgColorContainer),
                  child: Image.network(
                    mediaMetaInfoObj.metaInfo.mediaTypeInfo.url != null
                        ? mediaMetaInfoObj.metaInfo.mediaTypeInfo.url
                        : Constants.BASERURL +
                            mediaMetaInfoObj.metaInfo.categoryInfo.logo,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        mediaMetaInfoObj.metaInfo.fileName != null
                            ? mediaMetaInfoObj.metaInfo.fileName
                            : '',
                        style: TextStyle(fontWeight: FontWeight.w500),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Visibility(
                          visible:
                              mediaMetaInfoObj.metaInfo.dateOfExpiry != null
                                  ? true
                                  : false,
                          child: Text(
                            mediaMetaInfoObj.metaInfo.dateOfExpiry != null
                                ? 'Valid thru - ' +
                                    mediaMetaInfoObj.metaInfo.dateOfExpiry
                                : '',
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(color: Colors.grey),
                          )),
                      Text(
                        new FHBUtils()
                            .getFormattedDateString(mediaMetaInfoObj.createdOn),
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w200),
                      )
                    ],
                  ),
                ),
                /*  Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  getDocumentImageWidget(mediaMetaInfoObj),
                  /* Container(
                        width: 40,
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: Column(
                          children: <Widget>[
                            getDocumentImageWidget(mediaMetaInfoObj),
                          ],
                        ),
                      ), */
                ],
              ),
            ), */
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /*  Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                  SizedBox(height: 20), */
                      IconButton(
                          icon: mediaMetaInfoObj.isBookmarked
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
                            new CommonUtil()
                                .bookMarkRecord(mediaMetaInfoObj, _refresh);
                          }),
                      /*  mediaMetaInfoObj.metaInfo.hasVoiceNotes
                      ? Icon(
                          Icons.mic,
                          color: Colors.black54,
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
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Image.memory(snapshot.data),
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
