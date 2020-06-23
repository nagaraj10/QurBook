import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/global_search/model/GlobalSearch.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;


class GlobalSearchrepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  Future<GlobalSearch> getSearchedMediaType(String param) async{

     final response = await _helper.getSearchMediaFromServer(
        "users/$userID/search/healthRecords?keyword=", param);
    return GlobalSearch.fromJson(response);


  }
}
