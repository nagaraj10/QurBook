import 'package:flutter/cupertino.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/chat/model/GetMetaFileURLModel.dart';

class GetMediaFileViewModel extends ChangeNotifier {
  ApiBaseHelper _helper = ApiBaseHelper();
  GetMetaFileURLModel getMetaFileURLModel = new GetMetaFileURLModel();


  Future<GetMetaFileURLModel> getMediaMetaURL(
      List<String> recordIds,String patientId) async {
    try {
      GetMetaFileURLModel getMetaFileURLModel =
      await _helper.getMetaIdURL(recordIds,patientId);
      getMetaFileURLModel = getMetaFileURLModel;
      return getMetaFileURLModel;
    } catch (e) {}
  }

}
