import 'package:flutter/cupertino.dart';
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

class MedicalReportListScreen extends StatefulWidget {
  final CompleteData completeData;
  final Function callBackToRefresh;
  final String categoryName;
  final String categoryId;
  final Function(String, String) getDataForParticularLabel;

  MedicalReportListScreen(this.completeData, this.callBackToRefresh,
      this.categoryName, this.categoryId, this.getDataForParticularLabel);

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
              color: const Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForMedicalRecords(mediaMetaInfoObj[i], i),
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

  Widget getCardWidgetForMedicalRecords(MediaMetaInfo data, int i) {
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
                    child: data.metaInfo.hospital != null
                        ? data.metaInfo.hospital.logoThumbnail != null
                            ? Image.network(
                                Constants.BASERURL +
                                    data.metaInfo.hospital.logoThumbnail,
                                height: 50,
                                width: 50,
                              )
                            : Container(
                                padding: EdgeInsets.all(10),
                                child: Image.network(
                                  Constants.BASERURL +
                                      data.metaInfo.categoryInfo.logo,
                                  height: 30,
                                  width: 30,
                                  color: Color(
                                    CommonUtil().getMyPrimaryColor(),
                                  ),
                                ),
                                color: const Color(
                                  fhbColors.bgColorContainer,
                                ),
                              )
                        : Container(
                            height: 50,
                            width: 50,
                            color: Colors.grey[200],
                          )),
                SizedBox(width: 20),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      data.metaInfo.hospital != null
                          ? Text(
                              data.metaInfo.hospital.name != null
                                  ? toBeginningOfSentenceCase(
                                      data.metaInfo.hospital.name)
                                  : '',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          : Text(''),
                      Text(
                        data.metaInfo.doctor != null
                            ? toBeginningOfSentenceCase(
                                data.metaInfo.doctor.name)
                            : '',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        new FHBUtils().getFormattedDateString(data.createdOn),
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
                      /*  Icon(
                        Icons.more_horiz,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20), */
                      IconButton(
                          /* icon: ImageIcon(
                            AssetImage('assets/icons/record_fav.png'),
                            color:
                                data.isBookmarked ? Colors.red : Colors.black,
                          ), */
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
      },
    );
  }
}
