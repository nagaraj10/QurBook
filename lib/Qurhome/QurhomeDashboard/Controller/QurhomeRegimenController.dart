import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeRegimenResponseModel.dart';
import 'package:get/get.dart';

class QurhomeRegimenController extends GetxController {

  final _apiProvider = QurHomeApiProvider();
  var loadingData = false.obs;
  QurHomeRegimenResponseModel qurHomeRegimenResponseModel;
  getRegimenList() async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.getRegimenList();
      if (response == null) {
        // failed to get the data, we are showing the error on UI
      } else {
        qurHomeRegimenResponseModel = QurHomeRegimenResponseModel.fromJson(json.decode(response.body));
      }
      loadingData.value = false;
      update(["newUpdate"]);
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }
}
