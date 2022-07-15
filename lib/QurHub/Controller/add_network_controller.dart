import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:esptouch_flutter/esptouch_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mdns_plugin/flutter_mdns_plugin.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/QurHub/ApiProvider/hub_api_provider.dart';
import 'package:myfhb/QurHub/Models/add_network_model.dart';
import 'package:myfhb/QurHub/View/hubid_config_view.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;

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
  var apiReqNum = 0;

  getCurrentWifiDetailsInIOS() async {
    try {
      errorMessage.value = "";
      isLoading.value = true;
      var response = await iOSMethodChannel.invokeMethod(getWifiDetailsMethod);
      print(response);
      if (response is Map) {
        qurHubWifiRouter = WifiNetwork.fromJson({});
        qurHubWifiRouter.ssid = response['SSID'] ?? "";
        qurHubWifiRouter.bssid = response['BSSID'] ?? "";
        strSSID.value = qurHubWifiRouter.ssid;
        ssidList.value.add(qurHubWifiRouter);
      } else if (response is String) {
        if ((response ?? "").isNotEmpty) {
          errorMessage.value =
              "Please turn on your location services and re-try again";
        }
      } else {
        errorMessage.value = "Please connect your phone to Wi-Fi";
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = "${e.toString()}";
    }
  }

  getWifiList() async {
    try {
      errorMessage.value = "";
      isLoading.value = true;
      WiFiForIoTPlugin.isEnabled().then((val) async {
        if (val) {
          WiFiForIoTPlugin.isConnected().then((val) {
            qurHubWifiRouter = WifiNetwork.fromJson({});
            WiFiForIoTPlugin.getSSID().then((val) {
              if (CommonUtil().validString(val).toLowerCase().contains("unknown ssid")) {
                getWifiList();
              } else {
                qurHubWifiRouter.ssid = val;
                strSSID.value = qurHubWifiRouter.ssid;
              }
            });
            WiFiForIoTPlugin.getBSSID().then((val) {
              qurHubWifiRouter.bssid = val;
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
                if (ssids.ssid.toLowerCase() == strSSID.value.toLowerCase()) {
                  qurHubWifiRouter = ssids;
                  ssidList.value = [];
                  ssidList.value.add(qurHubWifiRouter);
                }
              });
            } catch (e) {
              isLoading.value = false;
              errorMessage.value = "Failed to get the list";
            }
          } else {
            ssidList.value = [];
            errorMessage.value = "Please connect your phone to Wi-Fi";
            /*toast.getToastForLongTime(
                "Please connect your phone to Wi-Fi", Colors.red);*/
          }
          isLoading.value = false;
        } else {
          isLoading.value = false;
          errorMessage.value = "Please connect your phone to Wi-Fi";
          /*toast.getToastForLongTime(
              "Please connect your phone to Wi-Fi", Colors.red);*/
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
        strHubId.value = CommonUtil().validString(addNetworkModel.hubId);
        final http.Response response =
            await _apiProvider.callConnectWifi(wifiName, password);
        isBtnLoading.value = false;
        response != null
            ? Get.to(
                () => HubIdConfigView(),
              )
            : toast.getToast(
            CommonUtil().validString(json.decode(response.body)), Colors.red);
      } else {
        isBtnLoading.value = false;
        toast.getToast(
            CommonUtil().validString(json.decode(responseCallHubId.body)), Colors.red);
      }
    } catch (e) {
      isBtnLoading.value = false;
      printError(info: e.toString());
    }
  }

  selectedWifiName(String strName) {
    try {
      strSSID.value = strName;
      ssidList.value.forEach((ssids) {
        if (ssids.ssid.toLowerCase() == strSSID.value.toLowerCase()) {
          qurHubWifiRouter = ssids;
        }
      });
    } catch (e) {}
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
          toast.getToast(CommonUtil().validString(addNetworkModel.message), Colors.green);
          hubListController.getHubList();
          int times = 2;
          Get.close(times);
        } else {
          toast.getToast(CommonUtil().validString(addNetworkModel.message), Colors.red);
        }
      } else {
        isSaveBtnLoading.value = false;
        toast.getToast(CommonUtil().validString(response.body), Colors.red);
      }
    } catch (e) {
      isSaveBtnLoading.value = false;
      toast.getToast(CommonUtil().validString(e.toString()), Colors.red);
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
          if (CommonUtil().validString(info.name)
              .toLowerCase()
              .contains(strName.toLowerCase())) {
            strIpAddress.value = CommonUtil().validString(info.address);
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
        strHubId.value = CommonUtil().validString(addNetworkModel.hubId);
        toast.getToast(
            "Your HubId is " + CommonUtil().validString(strHubId.value), Colors.green);
        await 1.delay();
        isBtnLoading.value = false;
        Get.to(
          HubIdConfigView(),
        );
      } else {
        isBtnLoading.value = false;
        toast.getToast(
            CommonUtil().validString(json.decode(responseCallHubId.body)), Colors.red);
      }
    } catch (e) {
      isBtnLoading.value = false;
      toast.getToast(CommonUtil().validString(e.toString()), Colors.red);
    }
  }

  Future<void> executeEsptouch() async {
    isBtnLoading.value = true;
    final task = ESPTouchTask(
      ssid: qurHubWifiRouter.ssid,
      bssid: qurHubWifiRouter.bssid,
      password: qurHubWifiRouter.password,
    );
    final Stream<ESPTouchResult> stream = task.execute();
    final sub = stream.listen((r) => print('IP: ${r.ip} MAC: ${r.bssid}'));
    Future.delayed(Duration(minutes: 1), () => sub.cancel());
    apiReqNum = 0;
    if (Platform.isIOS) {
      pingQurHub();
    } else {
      await 30.delay();
      initMDNS();
    }
  }

  void pingQurHub() async {
    print("requesting api");
    var response = await _apiProvider.callHubId();
    if (response != null) {
      if (response is String) {
        errorMessage.value =
            "Failed to get the hub id please reset your Hub to config mode and re-try";
        printError(
          info:
              "Failed to get the hub id please reset your Hub to config mode and re-try",
        );
        isBtnLoading.value = false;
      } else if (response.statusCode == 200 &&
          (response.body ?? '').isNotEmpty) {
        printInfo(info: 'Response status: ${response.statusCode}');
        printInfo(info: 'Response body: ${response.body}');
        //save id
        isBtnLoading.value = false;
        Get.to(
          HubIdConfigView(),
        );
      } else {
        retryForHubId();
      }
    } else {
      retryForHubId();
    }
  }

  void retryForHubId() async {
    if (apiReqNum < 3) {
      apiReqNum++;
      await 5.delay();
      pingQurHub();
    } else {
      isBtnLoading.value = false;
      errorMessage.value =
          "Failed to get the hub id please reset your Hub to config mode and re-try";
      printError(
        info:
            "Failed to get the hub id please reset your Hub to config mode and re-try",
      );
    }
  }
}
