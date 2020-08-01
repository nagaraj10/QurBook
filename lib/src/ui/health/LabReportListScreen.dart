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
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;

class LabReportListScreen extends StatefulWidget {
  final CompleteData completeData;
  final Function callBackToRefresh;

  final String categoryName;
  final String categoryId;

  final Function(String, String) getDataForParticularLabel;
  final Function(String, bool) mediaSelected;
  final bool allowSelect;
  List<String> mediaMeta;
  final bool isNotesSelect;
  final bool isAudioSelect;


  LabReportListScreen(
      this.completeData,
      this.callBackToRefresh,
      this.categoryName,
      this.categoryId,
      this.getDataForParticularLabel,
      this.mediaSelected,
      this.allowSelect,
      this.mediaMeta,this.isNotesSelect,this.isAudioSelect);

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
                    Constants.NO_DATA_LAB_REPORT,
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

  Widget getCardWidgetForLabReport(MediaMetaInfo mediaMetaInfo, int position) {
    return InkWell(
      onLongPress: () {
        if (widget.allowSelect) {
          mediaMetaInfo.isSelected = !mediaMetaInfo.isSelected;

          // setState(() {});
          widget.mediaSelected(mediaMetaInfo.id, mediaMetaInfo.isSelected);
        }
      },
      onTap: () {
          if (widget.allowSelect) {
            bool condition;
            if (widget.mediaMeta.contains(mediaMetaInfo.id)) {
              condition = false;
            } else {
              condition = true;
            }
            mediaMetaInfo.isSelected = !mediaMetaInfo.isSelected;

            // setState(() {});
            widget.mediaSelected(mediaMetaInfo.id, condition);
          
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordDetailScreen(
                data: mediaMetaInfo,
              ),
            ),
          );
        }
        },
      child: Container(
          //height: 90,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
             BoxShadow(
                      color: const Color(fhbColors.cardShadowColor),
                      blurRadius: 16, // has the effect of softening the shadow
                      spreadRadius: 0, // has the effect of extending the shadow
                    )
            ],
          ),
          child:
             Row(
            children: <Widget>[
              mediaMetaInfo.metaInfo.laboratory != null
                  ? ClipOval(
                      child: (mediaMetaInfo.metaInfo.laboratory.logoThumbnail !=
                                  null &&
                              mediaMetaInfo.metaInfo.laboratory.logoThumbnail !=
                                  'null' &&
                              mediaMetaInfo.metaInfo.laboratory.logoThumbnail !=
                                  '')
                          ? Image.network(
                              Constants.BASE_URL +
                                  mediaMetaInfo
                                      .metaInfo.laboratory.logoThumbnail,
                              width: 50,
                              height: 50,
                            )
                          : mediaMetaInfo.metaInfo.categoryInfo.logo != null
                              ? Container(
                                  width: 50,
                                  height: 50,
                                  padding: EdgeInsets.all(10),
                                  child: Image.network(
                                    Constants.BASE_URL +
                                        mediaMetaInfo
                                            .metaInfo.categoryInfo.logo,
                                    color: Color(
                                      CommonUtil().getMyPrimaryColor(),
                                    ),
                                  ),
                                  color: const Color(
                                    fhbColors.bgColorContainer,
                                  ),
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                ))
                  : Container(
                      width: 50,
                      height: 50,
                    ),
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
                                AssetImage(variable.icon_record_fav_active),
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
                              .bookMarkRecord(mediaMetaInfo, _refresh);
                        }),

                    (mediaMetaInfo.metaInfo.hasVoiceNotes != null &&
                        mediaMetaInfo.metaInfo.hasVoiceNotes)
                        ? Icon(
                      Icons.mic,
                      color: Colors.black54,
                    )
                        : Container(), widget.mediaMeta.contains(mediaMetaInfo.id)
                        ? Icon(Icons.done,color: Color(new CommonUtil().getMyPrimaryColor()),)
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
           ),
    );
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
