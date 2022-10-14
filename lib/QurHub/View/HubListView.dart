import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../Controller/AddDeviceViewController.dart';
import 'AddDeviceView.dart';
import '../Controller/HubListViewController.dart';
import '../../constants/fhb_constants.dart';

import '../../common/CommonUtil.dart';
import '../../constants/variable_constant.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/Notifications/constants/notification_constants.dart';

class HubListView extends GetView<HubListViewController> {
  @override
  Widget build(BuildContext context) {
    controller.getHubList();
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(
              CommonUtil().getMyPrimaryColor(),
            ),
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
    if ((controller.hubListResponse.result?.hub == null) ||
        ((controller.hubListResponse?.result?.userDeviceCollection ?? [])
            .isEmpty)) {
      return pairNewVirtualHubBtn();
    }
    if (((controller.hubListResponse.result.userDeviceCollection.length ?? 0) >
            0) &&
        (controller.hubListResponse.result.hub?.additionalDetails != null)) {
      return listContent();
    }
    return Container();
  }

  Widget addNewDevice() {
    if ((controller.hubListResponse?.result?.userDeviceCollection ?? [])
            .length ==
        0) {
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
              controller.checkForConnectedDevices();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
              ),
              color: Color(
                CommonUtil().getMyPrimaryColor(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(
                  10.0,
                ),
                child: Text(
                  strAddNewDevice,
                  style: TextStyle(
                    color: Colors.white,
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
              controller.checkForConnectedDevices();
            },
            child: Container(
              width: 260.0.w,
              height: 48.0.h,
              decoration: BoxDecoration(
                color: Color(
                  CommonUtil().getMyPrimaryColor(),
                ),
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
                    fontSize: 16.0.sp,
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

  Widget getDeviceImage(String deviceCode) {
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
      height: 60,
      width: 60,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Image.asset(
            path,
            height: 60,
            width: 60,
            color: Color(
              CommonUtil().getMyPrimaryColor(),
            ),
          ),
        ),
      ),
    );
  }

  Widget listContent() {
    return ListView.builder(
      itemCount:
          (controller.hubListResponse.result.userDeviceCollection.length ?? 0),
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
                    controller.hubListResponse.result
                        .userDeviceCollection[index].device.deviceType.code,
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
                            controller.hubListResponse.result
                                .userDeviceCollection[index].user.firstName,
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Device Type - ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                CommonUtil().validString(
                                  controller
                                      .hubListResponse
                                      .result
                                      .userDeviceCollection[index]
                                      .device
                                      .deviceType
                                      .name,
                                ),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Device ID - ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                CommonUtil().validString(
                                  controller
                                      .hubListResponse
                                      .result
                                      .userDeviceCollection[index]
                                      .device
                                      .serialNumber,
                                ),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Connected on - ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${changeDateFormat(CommonUtil().validString(controller.hubListResponse.result.userDeviceCollection[index].createdOn))}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      unPairDialog(
                        type: 'device',
                        deviceId: controller.hubListResponse.result
                            .userDeviceCollection[index].id,
                        idName: "Device",
                      );
                    },
                    child: Card(
                      color: Color(CommonUtil().getMyPrimaryColor()),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Unpair',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
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

  Future<Widget> unPairDialog({
    String type,
    String deviceId,
    String hubId,
    String idName,
  }) {
    return showDialog(
      context: Get.context,
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
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'hub',
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                // if (type == 'hub') {
                                //   controller.unPairHub(hubId);
                                // } else {
                                //   controller.unPairDevice(deviceId);
                                // }
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
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
                                    ),
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
}
