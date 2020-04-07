import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/record_detail/screens/record_detail_screen.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';

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
              child: Text('No Data Available'),
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
                  backgroundColor:
                      const Color(fhbColors.circleAvatarBackground),
                  child: Image.network(
                    mediaMetaInfoObj.metaInfo.mediaTypeInfo.url != null
                        ? mediaMetaInfoObj.metaInfo.mediaTypeInfo.url
                        : Constants.BASERURL +
                            mediaMetaInfoObj.metaInfo.mediaTypeInfo.logo,
                    height: 20,
                    width: 20,
                    color: Colors.white,
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
                                ? 'Valid thru - ' +
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                      SizedBox(height: 20),
                      mediaMetaInfoObj.isBookmarked
                          ? Icon(
                              Icons.bookmark,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.bookmark_border,
                              color: Colors.grey,
                            ),
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
}
