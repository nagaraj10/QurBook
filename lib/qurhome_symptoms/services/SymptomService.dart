import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/qurhome_symptoms/model/SymptomsListModel.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class SymptomService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SymptomsListModel> getSymptomList() async {
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    final response = await _helper.getSymptomList(
        qr_list_symptom+userId+qr_is_symptom);
    return SymptomsListModel.fromJson(response);
  }
}