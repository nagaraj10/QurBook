import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/ClipImage/ClipOvalImage.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../bookmark_record/bloc/bookmarkRecordBloc.dart';
import '../../../colors/fhb_colors.dart' as fhbColors;
import '../../../common/CommonConstants.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_query.dart' as query;
import '../../../constants/variable_constant.dart' as variable;
import '../../../record_detail/screens/record_detail_screen.dart';
import '../../blocs/health/HealthReportListForUserBlock.dart';
import '../../model/Health/MediaMetaInfo.dart';
import '../../model/Health/asgard/health_record_collection.dart';
import '../../model/Health/asgard/health_record_list.dart';
import '../../utils/FHBUtils.dart';

class HealthReportListScreen extends StatefulWidget {
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
      this.showDetails,
      this.allowAttach,
      this.healthRecordSelected);
  final HealthRecordList? completeData;

  final Function callBackToRefresh;

  final String? categoryName;
  final String? categoryId;

  final Function(String, String) getDataForParticularLabel;
  final Function(String?, bool?) mediaSelected;
  final Function(String?, List<HealthRecordCollection>, bool)
      healthRecordSelected;
  final bool? allowSelect;
  final bool? isNotesSelect;
  final bool? isAudioSelect;
  final bool? showDetails;
  final bool? allowAttach;

  List<String?>? mediaMeta;

  @override
  _HealthReportListScreenState createState() => _HealthReportListScreenState();
}

class _HealthReportListScreenState extends State<HealthReportListScreen> {
  late HealthReportListForUserBlock _healthReportListForUserBlock;
  late BookmarkRecordBloc _bookmarkRecordBloc;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<HealthRecordCollection> mediMasterId = [];

  FlutterToast toast = FlutterToast();
  String? authToken;

  bool _enabled = true;
  @override
  void initState() {
    _healthReportListForUserBlock = HealthReportListForUserBlock();
    _healthReportListForUserBlock.getHelthReportLists();
    _bookmarkRecordBloc = BookmarkRecordBloc();
    FABService.trackCurrentScreen(FBAMyRecordsPrescriptionScreen);
    PreferenceUtil.init();
    setAuthToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      _getWidgetToDisplayHealthRecords(widget.completeData!);

  Widget _getWidgetToDisplayHealthRecords(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = [];

    mediaMetaInfoObj = CommonUtil().getDataForParticularCategoryDescription(
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
              color: const Color(fhbColors.bgColorContainer),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    Constants.NO_DATA_PRESCRIPTION,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: variable.font_poppins,
                        fontSize: CommonUtil().isTablet!
                            ? Constants.tabHeader2
                            : Constants.mobileHeader2),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(milliseconds: 2));

    widget.callBackToRefresh();
  }

  Widget getCardWidgetForPrescription(
      HealthResult mediaMetaInfoObj, int position) {
    return InkWell(
        onLongPress: () {
          if (widget.allowSelect!) {
            mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected!;

            setState(() {});
            widget.mediaSelected(
                mediaMetaInfoObj.id, mediaMetaInfoObj.isSelected);
          }
        },
        onTap: () {
          if (widget.allowSelect! && widget.showDetails == false) {
            if (widget.allowAttach!) {
              bool condition;
              if (widget.mediaMeta!.contains(mediaMetaInfoObj.id)) {
                condition = false;
              } else {
                condition = true;
              }
              mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected!;
              if (mediaMetaInfoObj != null &&
                  (mediaMetaInfoObj.healthRecordCollection?.length ?? 0) > 0) {
                mediMasterId =
                    CommonUtil().getMetaMasterIdListNew(mediaMetaInfoObj);
                if (mediMasterId.length > 0) {
                  widget.healthRecordSelected(
                      mediaMetaInfoObj.id, mediMasterId, condition);
                } else {
                  toast.getToast('No Image Attached ', Colors.red);
                }
              } else {
                toast.getToast('No Image Attached ', Colors.red);
              }
            } else {
              bool condition;
              if (widget.mediaMeta!.contains(mediaMetaInfoObj.id)) {
                condition = false;
              } else {
                condition = true;
              }
              mediaMetaInfoObj.isSelected = !mediaMetaInfoObj.isSelected!;

              widget.mediaSelected(mediaMetaInfoObj.id, condition);
            }
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecordDetailScreen(
                  data: mediaMetaInfoObj,
                ),
              ),
            ).then((value) async {
              if (value ?? false) {
                await Future.delayed(const Duration(milliseconds: 100));
                widget.callBackToRefresh();
              }
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              const BoxShadow(
                color: Color(fhbColors.cardShadowColor),
                blurRadius: 16, // has the effect of softening the shadow
                spreadRadius: 0, // has the effect of extending the shadow
              )
            ],
          ),
          child: Row(
            children: <Widget>[
              ClipOval(
                  child: mediaMetaInfoObj?.metadata?.doctor != null
                      ? getProfilePicWidget(
                          mediaMetaInfoObj
                                  ?.metadata?.doctor?.profilePicThumbnailUrl ??
                              "",
                          mediaMetaInfoObj?.metadata?.doctor?.firstName ?? "",
                          mediaMetaInfoObj?.metadata?.doctor?.lastName ?? "",
                          Color(CommonUtil().getMyPrimaryColor()),
                          CommonUtil().isTablet!
                              ? imageTabHeader
                              : Constants.imageMobileHeader,
                          CommonUtil().isTablet!
                              ? tabHeader1
                              : Constants.mobileHeader1,
                          authtoken: authToken ?? "")
                      : Container(
                          child: Center(
                              child: Image.network(
                                  mediaMetaInfoObj?.metadata
                                          ?.healthRecordCategory?.logo ??
                                      '',
                                  height: 30,
                                  width: 30,
                                  color: Color(
                                    CommonUtil().getMyPrimaryColor(),
                                  ))),
                          width: CommonUtil().isTablet!
                              ? imageTabHeader
                              : Constants.imageMobileHeader,
                          height: CommonUtil().isTablet!
                              ? imageTabHeader
                              : Constants.imageMobileHeader,
                          color: const Color(fhbColors.bgColorContainer))),
              const SizedBox(width: 20),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (mediaMetaInfoObj.metadata?.doctor != null &&
                              mediaMetaInfoObj.metadata?.hospital != null)
                          ? getDoctorName(mediaMetaInfoObj)!
                          : (mediaMetaInfoObj.metadata?.fileName ?? '')!,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader1
                              : mobileHeader1),
                    ),
                    Visibility(
                        visible: mediaMetaInfoObj?.metadata?.hospital != null
                            ? true
                            : mediaMetaInfoObj.metadata?.doctor != null
                                ? true
                                : false,
                        child: Text(
                          mediaMetaInfoObj?.metadata?.hospital != null
                              ? toBeginningOfSentenceCase(mediaMetaInfoObj
                                      ?.metadata
                                      ?.hospital
                                      ?.healthOrganizationName ??
                                  '')!
                              : mediaMetaInfoObj.metadata?.doctor != null
                                  ? getDoctorName(mediaMetaInfoObj)!
                                  : '',
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: CommonUtil().isTablet!
                                  ? tabHeader2
                                  : mobileHeader2),
                        )),
                    Text(
                      FHBUtils()
                          .getFormattedDateString(mediaMetaInfoObj.createdOn),
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w200,
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader3
                              : mobileHeader3),
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
                        icon: mediaMetaInfoObj?.isBookmarked ?? false
                            ? ImageIcon(
                                const AssetImage(
                                    variable.icon_record_fav_active),
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                size: CommonUtil().isTablet!
                                    ? tabHeader2
                                    : mobileHeader2,
                              )
                            : ImageIcon(
                                const AssetImage(variable.icon_record_fav),
                                color: Colors.black,
                                size: CommonUtil().isTablet!
                                    ? tabHeader2
                                    : mobileHeader2,
                              ),
                        onPressed: () {
                          CommonUtil()
                              .bookMarkRecord(mediaMetaInfoObj, _refresh);
                        }),
                    (mediaMetaInfoObj?.metadata?.hasVoiceNotes != null &&
                            (mediaMetaInfoObj?.metadata?.hasVoiceNotes ??
                                false))
                        ? const Icon(
                            Icons.mic,
                            color: Colors.black54,
                          )
                        : Container(),
                    widget.mediaMeta!.contains(mediaMetaInfoObj.id)
                        ? Icon(
                            Icons.done,
                            color: Color(CommonUtil().getMyPrimaryColor()),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  getDoctorProfileImageWidget(MediaMetaInfo data) {
    return FutureBuilder(
      future: _healthReportListForUserBlock
          .getProfilePic(data.metaInfo?.doctor?.id ?? ''),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data,
            height: CommonUtil().isTablet! ? imageTabHeader : imageMobileHeader,
            width: CommonUtil().isTablet! ? imageTabHeader : imageMobileHeader,
            fit: BoxFit.cover,
          );
        } else {
          return SizedBox(
            width: CommonUtil().isTablet! ? imageTabHeader : imageMobileHeader,
            height: CommonUtil().isTablet! ? imageTabHeader : imageMobileHeader,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[550]!,
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
          data.metaInfo!.doctor!.id! +
          "/getprofilepic",
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter:
                  const ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
        ),
      ),
      placeholder: (context, url) => SizedBox(
          width: CommonUtil().isTablet! ? imageTabHeader : imageMobileHeader,
          height: CommonUtil().isTablet! ? imageTabHeader : imageMobileHeader,
          child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[550]!,
              child:
                  Container(width: 50, height: 50, color: Colors.grey[200]))),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  getDocumentImageWidget(MediaMetaInfo data) {
    if (data.mediaMasterIds!.isNotEmpty) {
      return FutureBuilder(
        future: _healthReportListForUserBlock
            .getDocumentImage(CommonUtil().getMetaMasterId(data)!),
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
            return SizedBox(
              width: 40.0,
              height: 60.0,
              child: Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[400]!,
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
    String usrId = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
    return CachedNetworkImage(
      imageUrl: Constants.BASE_URL +
          query.qr_mediameta +
          usrId +
          query.qr_slash +
          query.qr_rawMedia +
          CommonUtil().getMetaMasterId(data)!,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter:
                  const ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
        ),
      ),
      placeholder: (context, url) => SizedBox(
          width: 50.0,
          height: 50.0,
          child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[550]!,
              child:
                  Container(width: 50, height: 50, color: Colors.grey[200]))),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  bookMarkRecord(MediaMetaInfo data) {
    List<String?> mediaIds = [];
    mediaIds.add(data.id);
    bool _isRecordBookmarked = data.isBookmarked!;
    if (_isRecordBookmarked) {
      _isRecordBookmarked = false;
    } else {
      _isRecordBookmarked = true;
    }
    _bookmarkRecordBloc
        .bookMarcRecord(mediaIds, _isRecordBookmarked)
        .then((bookmarkRecordResponse) {
      if (bookmarkRecordResponse!.success!) {
        _refresh();
      }
    });
  }

  void setAuthToken() async {
    authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
  }

  /// Returns the doctor name for the given mediaMetaInfoObj HealthResult object.
  getDoctorName(HealthResult mediaMetaInfoObj) {
    return toBeginningOfSentenceCase(mediaMetaInfoObj.metadata!.doctor != null
        ? (mediaMetaInfoObj.metadata?.doctor?.name != null &&
                mediaMetaInfoObj.metadata?.doctor?.name != '')
            ? mediaMetaInfoObj.metadata?.doctor?.name
            : (mediaMetaInfoObj.metadata?.doctor?.firstName ?? '') +
                ' ' +
                (mediaMetaInfoObj.metadata?.doctor?.lastName ?? '')
        : '');
  }
}
