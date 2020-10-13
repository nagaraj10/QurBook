import 'package:flutter/cupertino.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/chat/model/GetRecordIdsFilter.dart';

class GetMediaFileViewModel extends ChangeNotifier {
  ApiBaseHelper _helper = ApiBaseHelper();
  GetRecordIdsFilter getMetaFileURLModel = new GetRecordIdsFilter();


  Future<GetRecordIdsFilter> getMediaMetaURL(
      List<String> recordIds,String patientId) async {
    try {
      GetRecordIdsFilter getMetaFileURLModel =
      await _helper.getMetaIdURL(recordIds,patientId);
      getMetaFileURLModel = getMetaFileURLModel;
      return getMetaFileURLModel;
    } catch (e) {}
  }

}
