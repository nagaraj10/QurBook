import '../../common/PreferenceUtil.dart';
import '../model/deleteRecordResponse.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_query.dart' as query;

class DeleteRecordRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  Future<DeleteRecordResponse> deleteRecordForIds(String json) async {
    final response = await _helper
        .deleteHealthRecord(query.qr_health_record + query.qr_slash + json);
    return DeleteRecordResponse.fromJson(response);
  }

  Future<DeleteRecordResponse> deleteRecordForMediaMasterIds(
      String json) async {
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.deleteHealthRecord(
      query.qr_health_record +
          query.qr_slash +
          query.qr_delete_file +
          query.qr_slash +
          json,
    );
    return DeleteRecordResponse.fromJson(response);
  }
}
