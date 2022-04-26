import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeRegimenResponseModel.dart';
import 'package:get/get.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';

class QurhomeRegimenController extends GetxController {

  final _apiProvider = QurHomeApiProvider();
  var loadingData = false.obs;
  // QurHomeRegimenResponseModel qurHomeRegimenResponseModel;
  RegimentResponseModel qurHomeRegimenResponseModel;
  int nextRegimenPosition=0;
  int currentIndex=0;
  getRegimenList() async {
    try {
      loadingData.value = true;

      qurHomeRegimenResponseModel=await  _apiProvider.getRegimenList("");
      loadingData.value = false;
      for (int i=0;i<qurHomeRegimenResponseModel.regimentsList.length;i++) {
          if(DateTime.now().isBefore(qurHomeRegimenResponseModel.regimentsList[i].estart)){
            if(qurHomeRegimenResponseModel.regimentsList[i].ack_local != null){
              if(qurHomeRegimenResponseModel.regimentsList.length>(i+1)){
                nextRegimenPosition=i+1;
                currentIndex=i+1;
              }else{
                nextRegimenPosition=i;
                currentIndex=i;
              }
            }else{
              nextRegimenPosition=i;
              currentIndex=i;
            }
            break;
          }
      }
      update(["newUpdate"]);
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }
}
