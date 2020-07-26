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

class DeviceListScreen extends StatefulWidget {
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


  DeviceListScreen(this.completeData, this.callBackToRefresh, this.categoryName,
      this.categoryId, this.getDataForParticularLabel,this.mediaSelected,this.allowSelect,this.mediaMeta,this.isNotesSelect,this.isAudioSelect);

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
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      Constants.NO_DATA_DEVICES,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: variable.font_poppins),
                    ),
                  ),
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
      onLongPress: () {
        if (widget.allowSelect) {
          data.isSelected = !data.isSelected;
          
          setState(() {});
          widget.mediaSelected(
              data.id, data.isSelected);
        }
      },
        onTap: () {
          if (widget.allowSelect || widget.isNotesSelect || widget.isAudioSelect) {
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
        }
        ,
        child: Container(
            //height: 70,
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration:  BoxDecoration(
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
            child:Stack(
                          alignment: Alignment.centerRight,

              children: [
               Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(fhbColors.bgColorContainer),
                  child: Image.network(
                    data.metaInfo.mediaTypeInfo.url != null
                        ? data.metaInfo.mediaTypeInfo.url
                        : Constants.BASE_URL + data.metaInfo.categoryInfo.logo,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.metaInfo.mediaTypeInfo.name != null
                            ? toBeginningOfSentenceCase(
                                data.metaInfo.mediaTypeInfo.name)
                            : '',
                        style: TextStyle(fontWeight: FontWeight.w500),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
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

                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                     
                      IconButton(
                          icon: data.isBookmarked
                              ? ImageIcon(
                                  AssetImage(
                                      variable.icon_record_fav_active),
                                  //TODO chnage theme
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
                            new CommonUtil().bookMarkRecord(data, _refresh);
                          }),
                    
                    ],
                  ),
                ),
              ],
            )
           ,  widget.mediaMeta.contains(data.id)
                  ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(new CommonUtil().getMyGredientColor()),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.done,
                          size: 16.0,
                          color: Colors.white,
                        ),
                      ))
                  : SizedBox()
            ],)));
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

      },
    );
  }
}
