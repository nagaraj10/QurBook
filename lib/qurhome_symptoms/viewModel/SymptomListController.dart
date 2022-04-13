import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/QurHub/ApiProvider/hub_api_provider.dart';
import 'package:myfhb/QurHub/Models/hub_list_response.dart';
import 'package:myfhb/feedback/Model/FeedbackCategoriesTypeModel.dart';
import 'package:myfhb/feedback/Model/FeedbackTypeModel.dart';
import 'package:myfhb/feedback/Provider/FeedbackApiProvider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/qurhome_symptoms/services/SymptomService.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';

class SymptomListController extends GetxController {
  final _apiProvider = SymptomService();
  var loadingData = false.obs;
  RegimentResponseModel symtomListModel;

  getSymptomList() async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.getSymptomList();
      if (response == null) {
        loadingData.value = false;
        return RegimentResponseModel(
          regimentsList: [],
        );
      } else {
        symtomListModel = RegimentResponseModel.fromJson(json.decode(response.body));
      }
      loadingData.value = false;
      //update(["newUpdate"]);
    } catch (e) {
      loadingData.value = false;
      print(e.toString());
    }
  }
}
