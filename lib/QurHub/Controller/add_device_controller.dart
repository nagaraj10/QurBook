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
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/services/FamilyMemberListRepository.dart';
import 'package:myfhb/src/model/common_response.dart';
import 'package:myfhb/src/model/common_response_model.dart';

class AddDeviceController extends GetxController {
  final _apiProvider = FamilyMemberListRepository();
  final _hubApiProvider = HubApiProvider();
  var loadingData = false.obs;
  FamilyMembers familyMembers;
  CommonResponseModel commonResponse;

  getFamilyMembers() async {
    try {
      loadingData.value = true;
      var familyMembers = await _apiProvider.getFamilyMembersListNew();
      if (familyMembers == null ) {
        // failed to get the data, we are showing the error on UI
      } else {
        this.familyMembers = familyMembers;
      }
      loadingData.value = false;
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

  saveDevice({String hubId,String deviceId,String nickName}) async {
    try {
      loadingData.value = true;
      var commonResponse = await _hubApiProvider.saveDevice(hubId, deviceId, nickName);
      if (commonResponse == null ) {
        FlutterToast().getToast('Oops Something went wrong', Colors.red);
      } else {
        this.commonResponse = CommonResponseModel.fromJson(json.decode(commonResponse.body));
      }
      loadingData.value = false;
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

}
