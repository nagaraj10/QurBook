import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeRegimenResponseModel.dart';
import 'package:get/get.dart';

class QurhomeRegimenController extends GetxController {

  final _apiProvider = QurHomeApiProvider();
  var loadingData = false.obs;
  QurHomeRegimenResponseModel qurHomeRegimenResponseModel;
  int nextRegimenPosition=0;
  int currentIndex=0;
  getRegimenList() async {
    try {
      loadingData.value = true;
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      http.Response response = await _apiProvider.getRegimenList(formattedDate);
      if (response == null) {
        // failed to get the data, we are showing the error on UI
      } else {
        qurHomeRegimenResponseModel = QurHomeRegimenResponseModel.fromJson(json.decode(response.body));
      }
      loadingData.value = false;
      for (int i=0;i<qurHomeRegimenResponseModel.result.upcomingActivities.length;i++) {
          if(DateTime.now().isBefore(qurHomeRegimenResponseModel.result.upcomingActivities[i].estart)){
            nextRegimenPosition=i;
            currentIndex=i;
            print(DateTime.now());
            print('true date'+qurHomeRegimenResponseModel.result.upcomingActivities[i].estart.toString());
            break;
          }else{
            print('false date');
          }
      }
      update(["newUpdate"]);
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }
}
