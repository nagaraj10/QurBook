import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/record_detail/model/deleteRecordResponse.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;


class DeleteRecordRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  Future<DeleteRecordResponse> deleteRecordForIds(String json) async {
    var response =
        await _helper.deleteHealthRecord(query.qr_mediameta+userID+query.qr_slash+query.qr_deletemedia, json);
    return DeleteRecordResponse.fromJson(response);
  }

  Future<DeleteRecordResponse> deleteRecordForMediaMasterIds(
      String json) async {
          String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.deleteHealthRecord(query.qr_mediameta+userID+query.qr_slash+query.qr_deletemaster, json);
    return DeleteRecordResponse.fromJson(response);
  }
}
