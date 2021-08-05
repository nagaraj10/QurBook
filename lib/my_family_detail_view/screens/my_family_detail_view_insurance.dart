import 'package:flutter/material.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_constants.dart';
import '../../record_detail/screens/record_detail_screen.dart';
import '../../src/model/Health/UserHealthResponseList.dart';
import '../../src/model/Health/asgard/health_record_list.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/model/Health/CompleteData.dart';
import '../../src/model/Health/MediaMetaInfo.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../constants/fhb_query.dart' as query;
import '../../src/utils/screenutils/size_extensions.dart';

class MyFamilyDetailViewInsurance extends StatefulWidget {
  HealthRecordList completeData;

  MyFamilyDetailViewInsurance({this.completeData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState();

    return MyFamilyDetailViewInsuranceState();
  }
}

class MyFamilyDetailViewInsuranceState
    extends State<MyFamilyDetailViewInsurance> {
  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Family Provider Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getCategoryPreference();
    return getWidgetToDisplayIDDocs(widget.completeData);
  }

  Widget getWidgetToDisplayIDDocs(HealthRecordList completeData) {
    var mediaMetaInfoObj = List<HealthResult>();

    mediaMetaInfoObj = CommonUtil().getDataForInsurance(
        completeData,
        CommonConstants.categoryDescriptionIDDocs,
        CommonConstants.CAT_JSON_INSURANCE);

    return mediaMetaInfoObj.isNotEmpty
        ? Container(
            color: const Color(fhbColors.bgColorContainer),
            child: ListView.builder(
              itemBuilder: (c, i) =>
                  getCardWidgetForDocs(mediaMetaInfoObj[i], i),
              itemCount: mediaMetaInfoObj.length,
            ))
        : Container(
            color: const Color(fhbColors.bgColorContainer),
            child: Center(
              child: Text(
                variable.strNodata,
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
            ),
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
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(fhbColors.cardShadowColor),
                  blurRadius: 16, // has the effect of extending the shadow
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
                        :*/
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
                        mediaMetaInfoObj.metadata.fileName ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0.sp,
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
                              fontSize: 16.0.sp,
                            ),
                          )),
                      Text(
                        FHBUtils().getFormattedDateString(mediaMetaInfoObj
                            .metadata.healthRecordType.createdOn),
                        style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w200),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      mediaMetaInfoObj.isBookmarked
                          ? ImageIcon(
                              AssetImage(variable.icon_record_fav_active),
                              color: Color(CommonUtil().getMyPrimaryColor()),
                              size: 20.0.sp,
                            )
                          : ImageIcon(
                              AssetImage(variable.icon_record_fav),
                              color: Colors.black,
                              size: 20.0.sp,
                            ),
                    ],
                  ),
                ),
              ],
            )));
  }

  void getCategoryPreference() {
    for (final e in PreferenceUtil.getCategoryType()) {
      if (e.categoryDescription == CommonConstants.categoryDescriptionIDDocs) {
        PreferenceUtil.saveString(Constants.KEY_DEVICENAME, '').then((onValue) {
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
