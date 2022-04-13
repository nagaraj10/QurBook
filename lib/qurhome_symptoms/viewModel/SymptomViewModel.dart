import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/qurhome_symptoms/services/SymptomService.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';

class SymptomViewModel extends ChangeNotifier {
  SymptomService symptomService = new SymptomService();

  Future<RegimentResponseModel> getSymptomListData() async {
    try {

      RegimentResponseModel symptomResponse =
      await symptomService.getSymptomList();

      return symptomResponse;
    } catch (e) {
    }
  }


}
