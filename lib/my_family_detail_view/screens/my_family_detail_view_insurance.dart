import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_query.dart' as query;


class MyFamilyDetailViewInsurance extends StatefulWidget {
  CompleteData completeData;

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
  Widget build(BuildContext context) {
    // TODO: implement build
    getCategoryPreference();
    return getWidgetToDisplayIDDocs(widget.completeData);
  }

  Widget getWidgetToDisplayIDDocs(CompleteData completeData) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();

    mediaMetaInfoObj = new CommonUtil().getDataForInsurance(
        completeData,
        CommonConstants.categoryDescriptionIDDocs,
        CommonConstants.CAT_JSON_INSURANCE);

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
              child: Text(variable.strNodata),
            ),
            color: const Color(fhbColors.bgColorContainer),
          );
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
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(fhbColors.bgColorContainer),
                  child: Image.network(
                    mediaMetaInfoObj.metaInfo.mediaTypeInfo.url != null
                        ? mediaMetaInfoObj.metaInfo.mediaTypeInfo.url
                        : Constants.BASE_URL +
                            mediaMetaInfoObj.metaInfo.mediaTypeInfo.logo,
                    height: 20,
                    width: 20,
                    color: Color(CommonUtil().getMyPrimaryColor()),
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
                                ? variable.strValidThru+
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
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      mediaMetaInfoObj.isBookmarked
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
