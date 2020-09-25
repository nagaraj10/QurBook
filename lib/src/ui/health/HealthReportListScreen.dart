import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/bookmark_record/bloc/bookmarkRecordBloc.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:shimmer/shimmer.dart';

class HealthReportListScreen extends StatefulWidget {
  final HealthRecordList completeData;

  final Function callBackToRefresh;

  final String categoryName;
  final String categoryId;

  final Function(String, String) getDataForParticularLabel;
  final Function(String, bool) mediaSelected;
  final bool allowSelect;
  final bool isNotesSelect;
  final bool isAudioSelect;
  final bool showDetails;

  List<String> mediaMeta;
  HealthReportListScreen(
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
    _healthReportListForUserBlock.getHelthReportLists();
    _bookmarkRecordBloc = BookmarkRecordBloc();

    PreferenceUtil.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getWidgetToDisplayHealthRecords(widget.completeData);
  }

  Widget _getWidgetToDisplayHealthRecords(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForParticularCategoryDescription(
        completeData, CommonConstants.categoryDescriptionPrescription);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: mediaMetaInfoObj.length > 0
          ? Container(
              color: const Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForPrescription(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              ))
          : Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    Constants.NO_DATA_PRESCRIPTION,
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
    await Future.delayed(Duration(milliseconds: 2));

    widget.callBackToRefresh();
  }

  Widget getCardWidgetForPrescription(
      HealthResult mediaMetaInfoObj, int position) {
    if (mediaMetaInfoObj.metadata.doctor != null)
      return InkWell(
          onLongPress: () {
            if (widget.allowSelect) {
              mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected;

              setState(() {});
              widget.mediaSelected(
                  mediaMetaInfoObj.id, mediaMetaInfoObj.isSelected);
            }
          },
          onTap: () {
            if (widget.allowSelect && widget.showDetails == false) {
              bool condition;
              if (widget.mediaMeta.contains(mediaMetaInfoObj.id)) {
                condition = false;
              } else {
                condition = true;
              }
              mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected;

              widget.mediaSelected(mediaMetaInfoObj.id, condition);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecordDetailScreen(
                    data: mediaMetaInfoObj,
                  ),
                ),
              );
            }
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
                ClipOval(
                    child: mediaMetaInfoObj.metadata.doctor != null
                        ? CommonUtil().getDoctorProfileImageWidget(
                            mediaMetaInfoObj.metadata.doctor.id)
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
                        toBeginningOfSentenceCase(
                            mediaMetaInfoObj.metadata.doctor != null
                                ? mediaMetaInfoObj.metadata.doctor.name != null
                                    ? mediaMetaInfoObj.metadata.doctor.name
                                    : ''
                                : ''),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Visibility(
                          visible: mediaMetaInfoObj.metadata.hospital != null
                              ? true
                              : false,
                          child: Text(
                            mediaMetaInfoObj.metadata.hospital != null
                                ? toBeginningOfSentenceCase(
                                    mediaMetaInfoObj.metadata.hospital.name)
                                : '',
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          )),
                      Text(
                        new FHBUtils().getFormattedDateString(
                            mediaMetaInfoObj.metadata.dateOfVisit),
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
                          icon: mediaMetaInfoObj.isBookmarked
                              ? ImageIcon(
                                  AssetImage(variable.icon_record_fav_active),
                                  color: Color(
                                      new CommonUtil().getMyPrimaryColor()),
                                  size: 20,
                                )
                              : ImageIcon(
                                  AssetImage(variable.icon_record_fav),
                                  color: Colors.black,
                                  size: 20,
                                ),
                          onPressed: () {
                            new CommonUtil()
                                .bookMarkRecord(mediaMetaInfoObj, _refresh);
                          }),
                      (mediaMetaInfoObj.metadata.hasVoiceNotes != null &&
                              mediaMetaInfoObj.metadata.hasVoiceNotes)
                          ? Icon(
                              Icons.mic,
                              color: Colors.black54,
                            )
                          : Container(),
                      widget.mediaMeta.contains(mediaMetaInfoObj.id)
                          ? Icon(
                              Icons.done,
                              color:
                                  Color(new CommonUtil().getMyPrimaryColor()),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ));
    else
      return SizedBox();
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
      imageUrl: Constants.BASE_URL +
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
      imageUrl: Constants.BASE_URL +
          query.qr_mediameta +
          usrId +
          query.qr_slash +
          query.qr_rawMedia +
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
