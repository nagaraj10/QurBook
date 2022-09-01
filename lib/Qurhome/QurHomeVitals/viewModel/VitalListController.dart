import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/Qurhome/BleConnect/Controller/ble_connect_controller.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/device_integration/model/LastMeasureSync.dart';
import 'package:myfhb/device_integration/viewModel/getGFDataFromFHBRepo.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:flutter/material.dart';

class VitalListController extends GetxController {
  final GetGFDataFromFHBRepo _helperRepo = GetGFDataFromFHBRepo();
  ApiBaseHelper _helper = ApiBaseHelper();
  var loadingData = false.obs;

  Future<LastMeasureSyncValues> fetchDeviceDetails() async {
    try {
      var resp = await _helperRepo.getLatestDeviceHealthRecord();
      final res = json.encode(resp);
      final response = lastMeasureSyncFromJson(res);
      final result = response.result;
      return result;
    } catch (e) {}
  }

  Future<GetDeviceSelectionModel> getDeviceSelection(
      {String userIdFromBloc}) async {
    var userId;
    if (userIdFromBloc != null) {
      userId = userIdFromBloc;
    } else {
      userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }

    final response = await _helper.getDeviceSelection(query.qr_user_profile +
        query.qr_user +
        query.qr_my_profile +
        query.qr_member_id +
        userId);
    return GetDeviceSelectionModel.fromJson(response);
  }
}
