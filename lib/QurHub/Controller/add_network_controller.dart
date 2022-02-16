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

class AddNetworkController extends GetxController {
  var ssidList = [].obs;
  var isLoading = false.obs;
  var isBtnLoading = false.obs;
  String strWifiName = "QurHub-Config";
  var strSSID = "".obs;
  var strHubId = "".obs;
  FlutterToast toast = FlutterToast();
  WifiNetwork qurHubWifiRouter;
  final _apiProvider = HubApiProvider();

  getWifiList() async {
    try {
      isLoading.value = true;
      WiFiForIoTPlugin.isEnabled().then((val) async {
        if (val) {
          WiFiForIoTPlugin.isConnected().then((val) {
            WiFiForIoTPlugin.getSSID().then((val) {
              print("getSSID $val");
              strSSID.value = val;
            });
          });
          ssidList.value = [];
          try {
            ssidList.value = await WiFiForIoTPlugin.loadWifiList();
            print("ssidList length ${ssidList.value.length}");
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
                    callHubId();
                    toast.getToastForLongTime(
                        "wifi connection successfull", Colors.green);
                    //strSSID.value = "";
                  } else {
                    toast.getToast("Failed try again!!!", Colors.red);
                  }
                } on PlatformException catch (e) {}
              } else {
                toast.getToastForLongTime(
                    "Not available QurHub-Config router around", Colors.red);
              }
            } catch (e) {
              print("Failed to get the list ${e.toString()}");
              //FlutterToast().getToast('Failed to get the list', Colors.red);
            }
          } else {
            ssidList.value = [];
            toast.getToastForLongTime(
                "Not available wifi router around", Colors.red);
          }
          isLoading.value = false;
        } else {
          toast.getToastForLongTime(
              "Please enable wifi!!! and re-try after some time", Colors.red);
        }
      });
    } catch (e) {
      print(e.toString());
      isLoading.value = false;
    }
  }

  getConnectWifi(String wifiName, String password) async {
    try {
      isBtnLoading.value = true;
      http.Response response =
          await _apiProvider.callConnectWifi(wifiName, password);
      if (response != null) {
        isBtnLoading.value = false;
        Get.to(
          HubIdConfigView(),
        );
        /*AddNetworkModel addNetworkModel =
            AddNetworkModel.fromJson(json.decode(response.body));*/
        print(
            "getConnectWifi O/P ${validString(response.statusCode.toString())} ${validString(json.decode(response.body))}");
      } else {
        isBtnLoading.value = false;
        toast.getToast(validString(json.decode(response.body)), Colors.red);
        print(
            "getConnectWifi O/P ${validString(response.statusCode.toString())} ${validString(json.decode(response.body))}");
      }
      /*if (validString(json.decode(response.body))
          .toLowerCase()
          .contains("ok")) {
        isBtnLoading.value = false;
        Get.to(
          HubIdConfigView(),
        );
        */ /*print(
            "getConnectWifi O/P ${validString(response.statusCode.toString())} ${validString(json.decode(response.body))}");*/ /*
        */ /*AddNetworkModel addNetworkModel =
            AddNetworkModel.fromJson(json.decode(response.body));*/ /*
        //callHubId();
        print(
            "getConnectWifi O/P ${validString(response.statusCode.toString())} ${validString(json.decode(response.body))}");
      } else {
        isBtnLoading.value = false;
        toast.getToast(validString(json.decode(response.body)), Colors.red);
        print(
            "getConnectWifi O/P ${validString(response.statusCode.toString())} ${validString(json.decode(response.body))}");
      }*/
    } catch (e) {
      print(e.toString());
      isBtnLoading.value = false;
    }
  }

  callHubId() async {
    try {
      strHubId.value = "";
      http.Response response = await _apiProvider.callHubId();

      if (response != null) {
        AddNetworkModel addNetworkModel =
            AddNetworkModel.fromJson(json.decode(response.body));
        strHubId.value = validString(addNetworkModel.hubId);
        print(
            "callHubId O/P ${validString(response.statusCode.toString())} ${validString(json.decode(response.body))}");
      } else {
        toast.getToast(validString(json.decode(response.body)), Colors.red);
        print(
            "callHubId O/P ${validString(response.statusCode.toString())} ${validString(json.decode(response.body))}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  selectedWifiName(String strName) {
    try {
      strSSID.value = strName;
    } catch (e) {
      print(e);
    }
  }

  String validString(String strText) {
    try {
      if (strText == null)
        return "";
      else if (strText.trim().isEmpty)
        return "";
      else
        return strText.trim();
    } catch (e) {
      print(e);
    }
    return "";
  }

  callSaveHubIdConfig(String hubId, String nickName) async {
    try {
      isBtnLoading.value = true;
      http.Response response =
          await _apiProvider.callHubIdConfig(hubId, nickName);
      if (response.statusCode == 200) {
        isBtnLoading.value = false;
        AddNetworkModel addNetworkModel =
            AddNetworkModel.fromJson(json.decode(response.body));
        if (addNetworkModel.isSuccess) {
          toast.getToast(validString(addNetworkModel.message), Colors.green);
          print(
              "callSaveHubIdConfig O/P ${validString(response.statusCode.toString())} ${validString(addNetworkModel.message)}");
          Get.off(HubListScreen());
        } else {
          print(
              "callSaveHubIdConfig O/P ${validString(response.statusCode.toString())} ${validString(addNetworkModel.message)}");
          toast.getToast(validString(addNetworkModel.message), Colors.red);
        }
      } else {
        isBtnLoading.value = false;
        print(
            "callSaveHubIdConfig O/P ${validString(response.statusCode.toString())} ${validString(response.body.toString())}");
        toast.getToast(validString(json.decode(response.body)), Colors.red);
      }
    } catch (e) {
      print(e.toString());
      isBtnLoading.value = false;
    }
  }
}
