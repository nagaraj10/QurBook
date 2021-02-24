import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class MyFamilyDetailViewHospital extends StatefulWidget {
  HealthRecordList completeData;

  MyFamilyDetailViewHospital({this.completeData});

  @override
  State<StatefulWidget> createState() {
    return MyFamilyDetailViewHospitalState();
  }
}

class MyFamilyDetailViewHospitalState
    extends State<MyFamilyDetailViewHospital> {
  @override
  Widget build(BuildContext context) {
    getCategoryPreference();
    return getWidgetToDisplayIDDocs(widget.completeData);
  }

  Widget getWidgetToDisplayIDDocs(HealthRecordList completeData) {
    List<HealthResult> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForHospitals(
        completeData,
        CommonConstants.categoryDescriptionIDDocs,
        CommonConstants.CAT_JSON_HOSPITAL);

    return mediaMetaInfoObj.length > 0
        ? Container(
            color: const Color(fhbColors.bgColorContainer),
            child: ListView.builder(
              itemBuilder: (c, i) =>
                  getCardWidgetForDocs(mediaMetaInfoObj[i], i),
              itemCount: mediaMetaInfoObj.length,
            ))
        : Container(
            child: Center(
              child: Text(
                variable.strNodata,
                style: TextStyle(
                  fontSize: 14.0.sp,
                ),
              ),
            ),
            color: const Color(fhbColors.bgColorContainer),
          );
  }

  getCardWidgetForDocs(HealthResult mediaMetaInfoObj, int i) {
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
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(fhbColors.bgColorContainer),
                  child: Image.network(
                    /* mediaMetaInfoObj.metaInfo.mediaTypeInfo.url != null
                        ? mediaMetaInfoObj.metaInfo.mediaTypeInfo.url
                        : */
                    Constants.BASE_URL +
                        mediaMetaInfoObj.metadata.healthRecordCategory.logo,
                    height: 20.0.h,
                    width: 20.0.h,
                    color: Color(CommonUtil().getMyPrimaryColor()),
                  ),
                ),
                SizedBox(
                  width: 20.0.w,
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        mediaMetaInfoObj.metadata.fileName != null
                            ? mediaMetaInfoObj.metadata.fileName
                            : '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0.sp,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Visibility(
                          visible: mediaMetaInfoObj.metadata.dateOfVisit != null
                              ? true
                              : false,
                          child: Text(
                            mediaMetaInfoObj.metadata.dateOfVisit != null
                                ? variable.strValidThru +
                                    mediaMetaInfoObj.metadata.dateOfVisit
                                : '',
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0.sp,
                            ),
                          )),
                      Text(
                        new FHBUtils().getFormattedDateString(mediaMetaInfoObj
                            .metadata.healthRecordType.createdOn),
                        style: TextStyle(
                            fontSize: 12.0.sp,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w200),
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
                      /* Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                          SizedBox(height: 20.0.h,), */
                      mediaMetaInfoObj.isBookmarked
                          ? ImageIcon(
                              AssetImage(variable.icon_record_fav_active),
                              color:
                                  Color(new CommonUtil().getMyPrimaryColor()),
                              size: 20.0.sp,
                            )
                          : ImageIcon(
                              AssetImage(variable.icon_record_fav),
                              color: Colors.black,
                              size: 20.0.sp,
                            )
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

  void getCategoryPreference() {
    for (var e in PreferenceUtil.getCategoryType()) {
      if (e.categoryDescription == CommonConstants.categoryDescriptionIDDocs) {
        PreferenceUtil.saveString(Constants.KEY_DEVICENAME, null)
            .then((onValue) {
          PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, e.categoryName)
              .then((onValue) {
            PreferenceUtil.saveString(Constants.KEY_CATEGORYID, e.id)
                .then((value) {});
          });
        });
      }
    }
  }
}
