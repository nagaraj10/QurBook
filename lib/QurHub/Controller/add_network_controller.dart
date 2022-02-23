import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mdns_plugin/flutter_mdns_plugin.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/QurHub/ApiProvider/hub_api_provider.dart';
import 'package:myfhb/QurHub/Models/add_network_model.dart';
import 'package:myfhb/QurHub/View/hubid_config_view.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;

import '../View/hub_list_screen.dart';
import 'hub_list_controller.dart';

const String discovery_service = "_http._tcp";

class AddNetworkController extends GetxController {
  var ssidList = [].obs;
  var isLoading = false.obs;
  var isBtnLoading = false.obs;
  var isSaveBtnLoading = false.obs;
  String strWifiName = "QurHub-Config";
  var strSSID = "".obs;
  var strHubId = "".obs;
  var errorMessage = "".obs;
  FlutterToast toast = FlutterToast();
  WifiNetwork qurHubWifiRouter;
  final _apiProvider = HubApiProvider();
  final HubListController hubListController = Get.find();
  FlutterMdnsPlugin mdnsPlugin;
  DiscoveryCallbacks discoveryCallbacks;
  String strName = "qurhub";
  var strIpAddress = "".obs;

  getWifiList() async {
    try {
      //initMDNS();
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
          /*final int result = await platform.invokeMethod(
              'getTest', {"SSID": wifiName, "Password": password});*/
          final int result = await platform.invokeMethod('dc');
          if (result == 1) {
            await 1.delay();
            isBtnLoading.value = false;
            Get.to(
              HubIdConfigView(),
            );
          } else {
            await 1.delay();
            isBtnLoading.value = false;
            toast.getToast("QurHub router not disconnecting", Colors.red);
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
      isSaveBtnLoading.value = true;
      http.Response response =
          await _apiProvider.callHubIdConfig(hubId, nickName);
      if (response.statusCode == 200) {
        isSaveBtnLoading.value = false;
        AddNetworkModel addNetworkModel =
            AddNetworkModel.fromJson(json.decode(response.body));
        if (addNetworkModel.isSuccess) {
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
        isSaveBtnLoading.value = false;
        toast.getToast(validString(response.body), Colors.red);
      }
    } catch (e) {
      isSaveBtnLoading.value = false;
    }
  }

  startMdnsDiscovery(String serviceType) {
    try {
      mdnsPlugin = FlutterMdnsPlugin(discoveryCallbacks: discoveryCallbacks);
      Timer(Duration(seconds: 3), () => mdnsPlugin.startDiscovery(serviceType));
    } catch (e) {
      print(e);
    }
  }

  initMDNS() {
    try {
      strIpAddress.value = "";
      discoveryCallbacks = new DiscoveryCallbacks(
        onDiscovered: (ServiceInfo info) {
          /*print("Discovered ${info.toString()}");
          setState(() {
            messageLog.insert(0, "DISCOVERY: Discovered ${info.toString()}");
          });*/
        },
        onDiscoveryStarted: () {
          /*print("Discovery started");
          setState(() {
            messageLog.insert(0, "DISCOVERY: Discovery Running");
          });*/
        },
        onDiscoveryStopped: () {
          /*print("Discovery stopped");
          setState(() {
            messageLog.insert(0, "DISCOVERY: Discovery Not Running");
          });*/
        },
        onResolved: (ServiceInfo info) {
          //TODO
          if (validString(info.name)
              .toLowerCase()
              .contains(strName.toLowerCase())) {
            strIpAddress.value = validString(info.address);
            if (strIpAddress.value.trim().isNotEmpty) {
              getHubId();
            }
          }
          /*setState(() {
            messageLog.insert(0, "DISCOVERY: Resolved ${info.toString()}");
          });*/
        },
      );
      startMdnsDiscovery(discovery_service);
    } catch (e) {
      print(e);
    }
  }

  getHubId() async {
    try {
      strHubId.value = "";
      http.Response responseCallHubId = await _apiProvider.callHubId();
      if (responseCallHubId != null) {
        AddNetworkModel addNetworkModel =
            AddNetworkModel.fromJson(json.decode(responseCallHubId.body));
        strHubId.value = validString(addNetworkModel.hubId);
        toast.getToast(
            "Your HubId is " + validString(strHubId.value), Colors.green);
        await 1.delay();
        //isBtnLoading.value = false;
        Get.to(
          HubIdConfigView(),
        );
      } else {
        //isBtnLoading.value = false;
        toast.getToast(
            validString(json.decode(responseCallHubId.body)), Colors.red);
      }
    } catch (e) {
      //isBtnLoading.value = false;
      toast.getToast(validString(e.toString()), Colors.red);
    }
  }
}
