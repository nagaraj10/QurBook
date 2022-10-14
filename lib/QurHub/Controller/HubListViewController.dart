import 'dart:convert';
import 'package:gallery_saver/files.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../ApiProvider/hub_api_provider.dart';
import '../Models/hub_list_response.dart';

class HubListViewController extends GetxController {
  var loadingData = false.obs;
  var searchingBleDevice = false.obs;
  HubListResponse hubListResponse;
  final _apiProvider = HubApiProvider();

  getHubList() async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.getHubList();
      loadingData.value = false;
      if (response.statusCode != 200) {}
      hubListResponse = HubListResponse.fromJson(json.decode(response.body));
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }
}
