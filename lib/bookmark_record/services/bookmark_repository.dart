import '../model/bookmarkResponse.dart';
import '../../common/PreferenceUtil.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/webservice_call.dart';

class BookmarkRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webservicecall=WebserviceCall(); 

  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

  Future<BookmarkResponse> bookmarkRecordForIds(String json) async {
    final response =
        await _helper.bookmarkRecord(webservicecall.getQueryBookmarkRecord(), json);
    return BookmarkResponse.fromJson(response);
  }
}
