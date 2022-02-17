import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/QurHub/ApiProvider/hub_api_provider.dart';
import 'package:myfhb/QurHub/Models/add_network_model.dart';
import 'package:myfhb/QurHub/View/hubid_config_view.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;

import '../View/hub_list_screen.dart';
import 'hub_list_controller.dart';

class AddNetworkController extends GetxController {
  var ssidList = [].obs;
  var isLoading = false.obs;
  var isBtnLoading = false.obs;
  String strWifiName = "QurHub-Config";
  var strSSID = "".obs;
  var strHubId = "".obs;
  var errorMessage = "".obs;
  FlutterToast toast = FlutterToast();
  WifiNetwork qurHubWifiRouter;
  final _apiProvider = HubApiProvider();
  final HubListController hubListController = Get.find();

  getWifiList() async {
    try {
      errorMessage.value = "";
      isLoading.value = true;
      WiFiForIoTPlugin.isEnabled().then((val) async {
        if (val) {
          WiFiForIoTPlugin.isConnected().then((val) {
            WiFiForIoTPlugin.getSSID().then((val) {
              strSSID.value = val;
            });
          });
          ssidList.value = [];
          try {
            ssidList.value = await WiFiForIoTPlugin.loadWifiList();
          } on PlatformException {
            ssidList.value = [];
          }
          if (ssidList.value != null && ssidList.value.length > 0) {
            try {
              ssidList.value.forEach((ssids) {
                if (ssids.ssid
                    .toLowerCase()
                    .contains(strWifiName.toLowerCase())) {
                  qurHubWifiRouter = ssids;
                }
              });
              if (qurHubWifiRouter != null) {
                try {
                  const platform = MethodChannel('wifiworks');
                  final int result = await platform.invokeMethod('getTest',
                      {"SSID": qurHubWifiRouter.ssid, "Password": ""});
                  if (result == 1) {
                    toast.getToastForLongTime(
                        "wifi connection successfull", Colors.green);
                  } else {
                    errorMessage.value = "Failed try again!!!";
                    toast.getToast("Failed try again!!!", Colors.red);
                  }
                } on PlatformException catch (e) {}
              } else {
                errorMessage.value =
                    "Not available QurHub-Config router around";
                toast.getToastForLongTime(
                    "Not available QurHub-Config router around", Colors.red);
              }
            } catch (e) {
              errorMessage.value = "Failed to get the list";
            }
          } else {
            ssidList.value = [];
            errorMessage.value = "Not available wifi router around";
            toast.getToastForLongTime(
                "Not available wifi router around", Colors.red);
          }
          isLoading.value = false;
        } else {
          isLoading.value = false;
          errorMessage.value =
              "Please enable wifi!!! and re-try after some time";
          toast.getToastForLongTime(
              "Please enable wifi!!! and re-try after some time", Colors.red);
        }
      });
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = "${e.toString()}";
    }
  }

  getConnectWifi(String wifiName, String password) async {
    try {
      isBtnLoading.value = true;
      callHubId(wifiName, password);
    } catch (e) {
      isBtnLoading.value = false;
    }
  }

  callHubId(String wifiName, String password) async {
    try {
      strHubId.value = "";
      http.Response responseCallHubId = await _apiProvider.callHubId();

      if (responseCallHubId != null) {
        AddNetworkModel addNetworkModel =
            AddNetworkModel.fromJson(json.decode(responseCallHubId.body));
        strHubId.value = validString(addNetworkModel.hubId);
        http.Response response =
            await _apiProvider.callConnectWifi(wifiName, password);
        if (response != null) {
          const platform = MethodChannel('wifiworks');
          final int result = await platform.invokeMethod(
              'getTest', {"SSID": wifiName, "Password": password});
          if (result == 1) {
            await 1.delay();
            isBtnLoading.value = false;
            Get.to(
              HubIdConfigView(),
            );
          } else {
            await 1.delay();
            isBtnLoading.value = false;
            toast.getToast("wifiName and password missmatch!!!", Colors.red);
          }
        } else {
          isBtnLoading.value = false;
          toast.getToast(validString(json.decode(response.body)), Colors.red);
        }
      } else {
        isBtnLoading.value = false;
        toast.getToast(
            validString(json.decode(responseCallHubId.body)), Colors.red);
      }
    } catch (e) {
      isBtnLoading.value = false;
    }
  }

  selectedWifiName(String strName) {
    try {
      strSSID.value = strName;
    } catch (e) {}
  }

  String validString(String strText) {
    try {
      if (strText == null)
        return "";
      else if (strText.trim().isEmpty)
        return "";
      else
        return strText.trim();
    } catch (e) {}
    return "";
  }

  callSaveHubIdConfig(
      String hubId, String nickName, BuildContext context) async {
    try {
      isBtnLoading.value = true;
      http.Response response =
          await _apiProvider.callHubIdConfig(hubId, nickName);
      if (response.statusCode == 200)
      {
        isBtnLoading.value = false;
        AddNetworkModel addNetworkModel =
            AddNetworkModel.fromJson(json.decode(response.body));
        if (addNetworkModel.isSuccess)
        {
          toast.getToast(validString(addNetworkModel.message), Colors.green);
          hubListController.getHubList();
          Navigator.pop(
            context,
          );
          Get.off(HubListScreen());
        } else {
          toast.getToast(validString(addNetworkModel.message), Colors.red);
        }
      } else {
        isBtnLoading.value = false;
        toast.getToast(validString(response.body), Colors.red);
      }
    } catch (e) {
      isBtnLoading.value = false;
    }
  }
}
