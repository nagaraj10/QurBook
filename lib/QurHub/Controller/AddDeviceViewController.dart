import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/CommonUtil.dart';
import '../../src/model/common_response_model.dart';
import 'HubListViewController.dart';
import '../ApiProvider/hub_api_provider.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';

class AddDeviceViewController extends GetxController {
  final deviceIdController = TextEditingController();
  final deviceTypeNameController = TextEditingController();
  final nickNameController = TextEditingController();
  final _hubApiProvider = HubApiProvider();
  RxBool loadingData = false.obs;
  String? selectedId = '';
  late HubListViewController listController;

  @override
  void onInit() {
    super.onInit();
    selectedId = PreferenceUtil.getStringValue(KEY_USERID);
    listController = Get.find();
    deviceIdController.text = listController.bleMacId!;
    deviceTypeNameController.text = listController.bleDeviceType!;
  }

  @override
  void onClose() {
    FocusManager.instance.primaryFocus!.unfocus();
    super.onClose();
  }

  saveDevice() async {
    try {
      loadingData(true);
      final data = {
        DEVICE_ID: listController.bleMacId,
        DEVICE_TYPE: listController.bleDeviceType!.toUpperCase(),
        USER_HUB_ID: listController.hubListResponse!.result!.id,
        USER_ID: selectedId,
        DEVICE_NAME: " ",
        ADDITION_DETAILS: {"manufacturer": listController.manufacturer}
      };
      final res = await _hubApiProvider.saveNewDevice(data);
      loadingData(false);
      if ((res == null)) {
        FlutterToast().getToast(
          'Oops Something went wrong',
          Colors.red,
        );
      }
      final commonResponse = CommonResponseModel.fromJson(
        json.decode(
          res.body,
        ),
      );
      if (commonResponse.isSuccess ?? false) {
        FlutterToast().getToast(
          commonResponse.message!,
          Colors.grey,
        );
        Get.back();
      } else if ((commonResponse.message ?? "").isNotEmpty) {
        FlutterToast().getToast(
          commonResponse.message!,
          Colors.red,
        );
      }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      loadingData(false);
      printError(info: e.toString());
    }
  }
}
