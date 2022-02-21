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

class HubListController extends GetxController {
  final _apiProvider = HubApiProvider();
  var loadingData = false.obs;
  FeedbackTypeModel feedbackType;
  HubListResponse hubListResponse;
  FeedbackCategoryModel selectedType;
  var catSelected = false.obs;

  getHubList() async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.getHubList();
      if (response == null) {
        // failed to get the data, we are showing the error on UI
      } else {
        hubListResponse = HubListResponse.fromJson(json.decode(response.body));
      }
      loadingData.value = false;
      update(["newUpdate"]);
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

  unPairHub(String hubId) async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.unPairHub(hubId);
      if (response == null ) {
        FlutterToast().getToast('Oops Something went wrong', Colors.red);
      } else {
        getHubList();
      }
      loadingData.value = false;
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

  unPairDevice(String deviceId) async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.unPairDevice(deviceId);
      if (response == null ) {
        FlutterToast().getToast('Oops Something went wrong', Colors.red);
      } else {
        getHubList();
      }
      loadingData.value = false;
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

  setRecordType(FeedbackCategoryModel selected) {
    catSelected.value = false;
    selectedType = selected;
    catSelected.value = true;
  }

  removeSelectedType() {
    selectedType = null;
    catSelected.value = false;
  }
}
