import 'dart:convert';

import 'package:myfhb/QurHub/ApiProvider/hub_api_provider.dart';
import 'package:myfhb/QurHub/Models/hub_list_response.dart';
import 'package:myfhb/feedback/Model/FeedbackCategoriesTypeModel.dart';
import 'package:myfhb/feedback/Model/FeedbackTypeModel.dart';
import 'package:myfhb/feedback/Provider/FeedbackApiProvider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/services/FamilyMemberListRepository.dart';

class AddDeviceController extends GetxController {
  final _apiProvider = FamilyMemberListRepository();
  var loadingData = false.obs;
  FamilyMembers familyMembers;

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

}
