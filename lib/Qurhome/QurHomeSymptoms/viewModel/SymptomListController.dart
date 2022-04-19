import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/Qurhome/QurHomeSymptoms/services/SymptomService.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:provider/provider.dart';

class SymptomListController extends GetxController {
  final _apiProvider = SymptomService();
  var loadingData = false.obs;
  RegimentResponseModel symtomListModel;
  var symptomList = [].obs;


  getSymptomList({bool isLoading}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      http.Response response = await _apiProvider.getSymptomList();
      if (response == null) {
        loadingData.value = false;
        return RegimentResponseModel(
          regimentsList: [],
        );
      } else {
        symptomList.value = [];
        try {
          symtomListModel =
              RegimentResponseModel.fromJson(json.decode(response.body));

          symptomList.value = symtomListModel.regimentsList;
        } on PlatformException {
          symptomList.value = [];
        }
      }
      loadingData.value = false;
    } catch (e) {
      loadingData.value = false;
    }
  }


  void startSymptomTTS(int index, {String staticText, String dynamicText}) {
    stopSymptomTTS();
    if (index < symptomList.value?.length) {
      Future.delayed(
          Duration(
            milliseconds: 100,
          ), () {
        symptomList.value[index].isPlaying = true;
      });
    }
    Provider.of<ChatScreenViewModel>(Get.context, listen: false)
        ?.startTTSEngine(
      textToSpeak: staticText,
      dynamicText: dynamicText,
      isRegiment: true,
      onStop: () {
        stopSymptomTTS();
      },
    );
    symptomList.refresh();
  }

  void stopSymptomTTS({bool isInitial = false}) {
    Provider.of<ChatScreenViewModel>(Get.context, listen: false)?.stopTTSEngine(
      isInitial: isInitial,
    );

    symptomList.value?.forEach((regimenData) {
      regimenData.isPlaying = false;
    });

    symptomList.refresh();
  }

}
