import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/CommonUtil.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/variable_constant.dart';
import '../../main.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/Notifications/constants/notification_constants.dart';
import '../Controller/HubListViewController.dart';

class HubListView extends GetView<HubListViewController> {
  @override
  Widget build(BuildContext context) {
    controller.getHubList();
    FABService.trackCurrentScreen(FBAConnectedDevicesScreen);
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            backgroundColor:mAppThemeProvider.primaryColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              strConnectedDevices,
              style: TextStyle(
                  fontSize:
                      CommonUtil().isTablet! ? tabFontTitle : mobileFontTitle),
            ),
            centerTitle: false,
            elevation: 0,
          ),
          body: controller.loadingData.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : getListWidget(),
          floatingActionButton: addNewDevice(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget getListWidget() {
    if (controller.hubListResponse == null) {
      return const Center(
        child: Text(
          'Please re-try after some time',
        ),
      );
    }
    if (((controller.hubListResponse?.result ?? []).isEmpty)) {
      return pairNewVirtualHubBtn();
    }
    if (((controller.hubListResponse?.result?.length ?? 0) > 0)) {
      return listContent();
    }
    return Container();
  }

  Widget addNewDevice() {
    if ((controller.hubListResponse?.result ?? []).length == 0) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Obx(
        () {
          if (controller.searchingBleDevice.isTrue) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                const SizedBox(
                  width: 8,
                ),
                FittedBox(
                  child: Text(
                    ScanningForDevices,
                  ),
                )
              ],
            );
          }

          return InkWell(
            onTap: () {
              if (Platform.isAndroid) {
                askPermssionLocationBleScan();
              } else {
                controller.checkForConnectedDevices();
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
              ),
              color: mAppThemeProvider.primaryColor,
              child: Padding(
                padding: EdgeInsets.all(
                  10.0,
                ),
                child: Text(
                  strAddNewDevice,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        CommonUtil().isTablet! ? tabHeader1 : mobileHeader1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget pairNewVirtualHubBtn() {
    return Center(
      child: Obx(
        () {
          if (controller.searchingBleDevice.isTrue) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                FittedBox(
                  child: Text(
                    ScanningForDevices,
                  ),
                )
              ],
            );
          }

          return InkWell(
            onTap: () async {
              if (Platform.isAndroid) {
                askPermssionLocationBleScan();
              } else {
                controller.checkForConnectedDevices();
              }
            },
            child: Container(
              width: CommonUtil().isTablet! ? 400.w : 260.0.w,
              height: CommonUtil().isTablet! ? 70.0.h : 48.0.h,
              decoration: BoxDecoration(
                color: mAppThemeProvider.primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color.fromARGB(
                      15,
                      0,
                      0,
                      0,
                    ),
                    offset: Offset(
                      0,
                      2,
                    ),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  strAddNewDevice,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        CommonUtil().isTablet! ? tabHeader1 : mobileHeader1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getDeviceImage(String? deviceCode) {
    var path;
    switch (deviceCode) {
      case 'BPMONT':
        path = 'assets/devices/bp_dashboard.png';
        break;
      case 'GLUCMT':
        path = 'assets/devices/gulcose_dashboard.png';
        break;
      case 'PULOXY':
        path = 'assets/devices/pulse_oxim.png';
        break;
      case 'THERMO':
        path = 'assets/devices/temp_dashboard.png';
        break;
      case 'WEIGHS':
        path = 'assets/devices/weight_dashboard.png';
        break;
      default:
        path = 'assets/devices/bp_dashboard.png';
    }
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      height: CommonUtil().isTablet! ? imageTabHeader : imageMobileHeader,
      width: CommonUtil().isTablet! ? imageTabHeader : imageMobileHeader,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Image.asset(
            path,
            height: CommonUtil().isTablet! ? imageTabHeader : imageMobileHeader,
            width: CommonUtil().isTablet! ? imageTabHeader : imageMobileHeader,
            color: mAppThemeProvider.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget listContent() {
    return ListView.builder(
      itemCount: (controller.hubListResponse?.result?.length ?? 0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  getDeviceImage(
                    controller.hubListResponse?.result![index].device
                            ?.deviceType?.code ??
                        "",
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CommonUtil().validString(
                            controller.hubListResponse?.result![index].user
                                    ?.firstName ??
                                "",
                          ),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: CommonUtil().isTablet!
                                  ? tabHeader1
                                  : mobileHeader1),
                        ),
                        commonWidgetForTitleValue(
                            strDeviceTypeConnectedDeviceScreen,
                            CommonUtil().validString(
                              controller.hubListResponse!.result![index].device!
                                  .deviceType!.name,
                            )),
                        commonWidgetForTitleValue(
                            strDeviceID,
                            CommonUtil().validString(
                              controller.hubListResponse!.result![index].device!
                                  .serialNumber,
                            )),
                        commonWidgetForTitleValue(strConnectedOn,
                            "${changeDateFormat(CommonUtil().validString(controller.hubListResponse?.result![index].createdOn ?? ""))}"),
                        //Paired mode
                        commonWidgetForTitleValue(
                            strPairingMode,
                            CommonUtil()
                                    .validString(
                                      (controller
                                              .hubListResponse
                                              ?.result![index]
                                              ?.device
                                              ?.deviceType
                                              ?.additionalInfo
                                              ?.connectivityType ??
                                          ''),
                                    )
                                    .trim()
                                    .toLowerCase()
                                    .contains(strBluetooth.toLowerCase())
                                ? strBluetooth
                                : strLTE),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      unPairDialog(
                        type: 'device',
                        deviceId:
                            controller.hubListResponse?.result![index].id ?? "",
                        idName: "Device",
                      );
                    },
                    child: Card(
                      color: mAppThemeProvider.primaryColor,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Unpair',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader2
                                : mobileHeader2,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Widget?> unPairDialog({
    String? type,
    String? deviceId,
    String? hubId,
    String? idName,
  }) {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          child: Wrap(
            children: [
              Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/warning_icon.png',
                          height: CommonUtil().isTablet!
                              ? tabHeader1
                              : mobileHeader1,
                          width: CommonUtil().isTablet!
                              ? tabHeader1
                              : mobileHeader1,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          unPairDevice,
                          style: TextStyle(
                              fontSize: CommonUtil().isTablet!
                                  ? tabHeader1
                                  : mobileHeader1),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.unPairDevice(
                                  deviceId!,
                                );
                                Get.back();
                              },
                              child: Card(
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: CommonUtil().isTablet!
                                            ? tabHeader2
                                            : mobileHeader2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Card(
                                color: Colors.green,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: CommonUtil().isTablet!
                                            ? tabHeader2
                                            : mobileHeader2),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> askPermssionLocationBleScan() async {
    try {
      var location = await Permission.location.status;
      var bluetoothScan = await Permission.bluetoothScan.status;
      if (location.isDenied || bluetoothScan.isDenied) {
        await CommonUtil().handleLocationBleScanConnect();
      } else {
        controller.checkForConnectedDevices();
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  commonWidgetForTitleValue(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.grey[600],
              fontSize: CommonUtil().isTablet! ? tabHeader2 : mobileHeader2),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: CommonUtil().isTablet! ? tabHeader2 : mobileHeader2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
