import '../model/Language.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import '../../constants/fhb_query.dart' as query;

class LanguageRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<LanguageModel> getLanguage() async {
    var offset = 0;
    final limit = 100;
    var response = await _helper.getLanguageList(query.qr_language);
    return LanguageModel.fromJson(response);
  }
}
