import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/device_integration/model/LastMeasureSync.dart';
import 'package:myfhb/device_integration/viewModel/getGFDataFromFHBRepo.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class VitalListController extends GetxController {
  final GetGFDataFromFHBRepo _helperRepo = GetGFDataFromFHBRepo();
  ApiBaseHelper _helper = ApiBaseHelper();
  var loadingData = false.obs;
  var userId = ''.obs;

  Future<LastMeasureSyncValues?> fetchDeviceDetails() async {
    try {
      var resp = await _helperRepo.getLatestDeviceHealthRecord(userId:userId.value);
      final res = json.encode(resp);
      final response = lastMeasureSyncFromJson(res);
      final result = response.result;
      return result;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<GetDeviceSelectionModel> getDeviceSelection() async {
    final response = await _helper.getDeviceSelection(query.qr_user_profile +
        query.qr_user +
        query.qr_my_profile +
        query.qr_member_id +
        userId.value);
    return GetDeviceSelectionModel.fromJson(response);
  }
}
