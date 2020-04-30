import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class LabReportListScreen extends StatefulWidget {
  final CompleteData completeData;
  final Function callBackToRefresh;

  final String categoryName;
  final String categoryId;

  final Function(String, String) getDataForParticularLabel;

  LabReportListScreen(this.completeData, this.callBackToRefresh,
      this.categoryName, this.categoryId, this.getDataForParticularLabel);

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
    /*  PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, widget.categoryName)
        .then((value) {
      PreferenceUtil.saveString(Constants.KEY_CATEGORYID, widget.categoryId)
          .then((value) {
        widget.getDataForParticularLabel(
            widget.categoryName, widget.categoryId);
      });
    }); */
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
              color: const Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForLabReport(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              ))
          : Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text(
                    Constants.NO_DATA_LAB,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Poppins'),
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

  Widget getCardWidgetForLabReport(MediaMetaInfo mediaMetaInfo, int position) {
    //print('logo url ' + mediaMetaInfo.metaInfo.laboratory.logoThumbnail);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecordDetailScreen(
              data: mediaMetaInfo,
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
                  child: mediaMetaInfo.metaInfo.laboratory.logoThumbnail != null
                      ? Image.network(
                          Constants.BASERURL +
                              mediaMetaInfo.metaInfo.laboratory.logoThumbnail,
                          width: 50,
                          height: 50,
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          child: Image.network(
                            Constants.BASERURL +
                                mediaMetaInfo.metaInfo.categoryInfo.logo,
                            color: Color(
                              CommonUtil().getMyPrimaryColor(),
                            ),
                          ),
                          color: const Color(
                            fhbColors.bgColorContainer,
                          ),
                        )),
              SizedBox(width: 20),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mediaMetaInfo.metaInfo.laboratory.name != null
                          ? toBeginningOfSentenceCase(
                              mediaMetaInfo.metaInfo.laboratory.name)
                          : '',
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      mediaMetaInfo.metaInfo.doctor != null
                          ? toBeginningOfSentenceCase(
                              mediaMetaInfo.metaInfo.doctor.name)
                          : '',
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      new FHBUtils()
                          .getFormattedDateString(mediaMetaInfo.createdOn),
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w200,
                          fontSize: 12),
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
                        icon: mediaMetaInfo.isBookmarked
                            ? ImageIcon(
                                AssetImage(
                                    'assets/icons/record_fav_active.png'),
                                color:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                size: 20,
                              )
                            : ImageIcon(
                                AssetImage('assets/icons/record_fav.png'),
                                color: Colors.black,
                                size: 20,
                              ),
                        onPressed: () {
                          new CommonUtil()
                              .bookMarkRecord(mediaMetaInfo, _refresh);
                        }),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  getDoctorProfileImageWidget(MediaMetaInfo data) {
    print('lab id ${data.metaInfo.laboratory.id}');

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
