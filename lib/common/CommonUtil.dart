import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';

class CommonUtil {
  List<MediaMetaInfo> getDataForParticularCategoryDescription(
      CompleteData completeData, String categoryDescription) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();
    for (MediaMetaInfo mediaMetaInfo in completeData.mediaMetaInfo) {
      if (mediaMetaInfo.metaInfo.categoryInfo.categoryDescription ==
          categoryDescription) {
        mediaMetaInfoObj.add(mediaMetaInfo);
      }
    }
    return mediaMetaInfoObj;
  }

  MediaData getMediaTypeInfoForParticularLabel(
      String mediaId, List<MediaData> mediaDataList) {
    MediaData mediaDataObj = new MediaData();
    for (MediaData mediaData in mediaDataList) {
      if (mediaData.id == mediaId) {
        mediaDataObj = mediaData;

        // break;
      }
    }

    return mediaDataObj;
  }

  String getMetaMasterId(MediaMetaInfo data) {
    List<MediaMasterIds> mediaMasterIdsList = new List();
    if (data.mediaMasterIds.length > 0) {
      for (MediaMasterIds mediaMasterIds in data.mediaMasterIds) {
        if (mediaMasterIds.fileType == "image/jpg") {
          mediaMasterIdsList.add(mediaMasterIds);
        }
      }
    }

    print('mediaMasterID' + mediaMasterIdsList[0].id);
    return mediaMasterIdsList.length > 0 ? mediaMasterIdsList[0].id : '0';
  }
}
