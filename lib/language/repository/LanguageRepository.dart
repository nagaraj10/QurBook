import 'package:myfhb/language/model/Language.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;

class LanguageRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LanguageModel> getLanguage() async {
    int offset = 0;
    int limit = 100;
    final response = await _helper.getLanguageList("${query.qr_language}");
    return LanguageModel.fromJson(response);
  }
}
