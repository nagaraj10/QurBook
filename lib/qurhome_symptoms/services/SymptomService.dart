import 'dart:convert';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/src/resources/network/api_services.dart';

class SymptomService {

  Future<RegimentResponseModel> getSymptomList() async {
    var response;
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    String dateSelected = CommonUtil.dateConversionToApiFormat(
      DateTime.now(),
      isIndianTime: true,
    );
    var urlForRegiment = BASE_URL + regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var currentLanguage = '';
      var lan = CommonUtil.getCurrentLanCode();
      if (lan != 'undef') {
        var langCode = lan.split('-').first;
        currentLanguage = langCode;
      } else {
        currentLanguage = 'en';
      }
      response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            "method": "get",
            "data":
                "Action=GetUserActivities&lang=$currentLanguage&date=$dateSelected&issymptom=1${qr_patientEqaul}$userId",
          },
        ),
        timeOutSeconds: 60,
      );

      if (response != null && response.statusCode == 200) {
        print(response.body);
        return RegimentResponseModel.fromJson(json.decode(response.body));
      } else {
        return RegimentResponseModel(
          regimentsList: [],
        );
      }
    } catch (e) {
      print(e.toString());

      return RegimentResponseModel(
        regimentsList: [],
      );
    }
  }
}
