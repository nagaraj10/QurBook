import '../../common/PreferenceUtil.dart';
import '../../constants/webservice_call.dart';
import '../model/GlobalSearch.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import '../../constants/fhb_constants.dart' as Constants;



class GlobalSearchrepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
  WebserviceCall webserviceCall=WebserviceCall();

  Future<GlobalSearch> getSearchedMediaType(String param) async{

     var response = await _helper.getSearchMediaFromServer(
      webserviceCall.getQueryForMediaType() , param);
    return GlobalSearch.fromJson(response);


  }
}
