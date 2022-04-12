import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/chat_socket/model/InitChatModel.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/qurhome_symptoms/model/SymptomsListModel.dart';
import 'package:myfhb/qurhome_symptoms/services/SymptomService.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';

class SymptomViewModel extends ChangeNotifier {
  SymptomService symptomService = new SymptomService();

  Future<RegimentDataModel> getSymptomListData() async {
    try {

      SymptomsListModel symptomsListModel =
      await symptomService.getSymptomList();

      RegimentDataModel regimentDataModel = symptomsListModel.result.data as RegimentDataModel;

      return regimentDataModel;
    } catch (e) {}
  }


}
