import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:shimmer/shimmer.dart';

class MedicalReportListScreen extends StatefulWidget {
  final HealthRecordList completeData;
  final Function callBackToRefresh;
  final String categoryName;
  final String categoryId;
  final Function(String, String) getDataForParticularLabel;
  final Function(String, bool) mediaSelected;
  final bool allowSelect;
  List<String> mediaMeta;
  final bool isNotesSelect;
  final bool isAudioSelect;
  final bool showDetails;

  MedicalReportListScreen(
      this.completeData,
      this.callBackToRefresh,
      this.categoryName,
      this.categoryId,
      this.getDataForParticularLabel,
      this.mediaSelected,
      this.allowSelect,
      this.mediaMeta,
      this.isNotesSelect,
      this.isAudioSelect,
      this.showDetails);

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getWidgetToDisplayMedicalrecords(widget.completeData);
  }

  Widget _getWidgetToDisplayMedicalrecords(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = new List();

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
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text(
                    Constants.NO_DATA_MEDICAL_REPORT,
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

  Widget getCardWidgetForMedicalRecords(HealthResult data, int i) {
    return InkWell(
        onLongPress: () {
          if (widget.allowSelect) {
            data.isSelected = !data.isSelected;

            setState(() {});
            widget.mediaSelected(data.id, data.isSelected);
          }
        },
        onTap: () {
          if (widget.allowSelect && widget.showDetails == false) {
            bool condition;
            if (widget.mediaMeta.contains(data.id)) {
              condition = false;
            } else {
              condition = true;
            }
            data.isSelected = !data.isSelected;

            // setState(() {});
            widget.mediaSelected(data.id, condition);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecordDetailScreen(
                  data: data,
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
                  child:
                      /* data.metadata.hospital != null
                      ? data.metadata.hospital.l != null
                          ? Image.network(
                              Constants.BASE_URL +
                                  data.metadata.hospital.logoThumbnail,
                              height: 50,
                              width: 50,
                            )
                          :*/
                      Container(
                padding: EdgeInsets.all(10),
                child: Image.network(
                  Constants.BASE_URL + data.metadata.healthRecordCategory.logo,
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
                  /*: Container(
                          height: 50,
                          width: 50,
                          color: Colors.grey[200],
                        )*/
                  ),
              SizedBox(width: 20),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    data.metadata.hospital != null
                        ? Text(
                            data.metadata.hospital.healthOrganizationName !=
                                    null
                                ? toBeginningOfSentenceCase(data
                                    .metadata.hospital.healthOrganizationName)
                                : '',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        : Text(''),
                    Text(
                      data.metadata.doctor != null
                          ? toBeginningOfSentenceCase(
                              data.metadata.doctor.name != null
                                  ? data.metadata.doctor.name
                                  : '')
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
                    IconButton(
                        icon: data.isBookmarked
                            ? ImageIcon(
                                AssetImage(variable.icon_record_fav_active),
                                //TODO chnage theme
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
                          new CommonUtil().bookMarkRecord(data, _refresh);
                        }),
                    (data.metadata.hasVoiceNotes != null &&
                            data.metadata.hasVoiceNotes)
                        ? Icon(
                            Icons.mic,
                            color: Colors.black54,
                          )
                        : Container(),
                    widget.mediaMeta.contains(data.id)
                        ? Icon(
                            Icons.done,
                            color: Color(new CommonUtil().getMyPrimaryColor()),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ));
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
