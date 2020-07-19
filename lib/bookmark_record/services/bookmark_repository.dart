import 'package:myfhb/bookmark_record/model/bookmarkResponse.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/webservice_call.dart';

class BookmarkRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webservicecall=new WebserviceCall(); 

  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

  Future<BookmarkResponse> bookmarkRecordForIds(String json) async {
    var response =
        await _helper.bookmarkRecord(webservicecall.getQueryBookmarkRecord(), json);
    return BookmarkResponse.fromJson(response);
  }
}
