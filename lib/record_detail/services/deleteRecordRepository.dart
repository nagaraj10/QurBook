import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/record_detail/model/deleteRecordResponse.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
//import 'dart:convert' as convert;

class DeleteRecordRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  Future<DeleteRecordResponse> deleteRecordForIds(String json) async {
    //var jsonString = json.toString();
    var response =
        await _helper.deleteHealthRecord("mediameta/$userID/deletemeta/", json);
    return DeleteRecordResponse.fromJson(response);
  }
}
