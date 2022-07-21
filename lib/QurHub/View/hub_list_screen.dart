import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/ClipImage/ClipOvalImage.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/QurHub/Models/hub_list_response.dart';
import 'package:myfhb/QurHub/View/add_network_view.dart';
import 'package:myfhb/QurHub/Controller/hub_list_controller.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../colors/fhb_colors.dart' as fhbColors;

import 'add_device_screen.dart';
import '../../../constants/variable_constant.dart' as variable;

class HubListScreen extends StatefulWidget {
  const HubListScreen({Key key}) : super(key: key);

  @override
  _HubListScreenState createState() => _HubListScreenState();
}

class _HubListScreenState extends State<HubListScreen> {
  final controller = Get.put(HubListController());
  FlutterToast toast = FlutterToast();

  @override
  void initState() {
    try {
      controller.getHubList();
      super.initState();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 24.0.sp,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(/*'Connected Hub'*/variable.strConnectedDevices),
      centerTitle: false,
      elevation: 0,
    ),
    body: Obx(() => controller.loadingData.isTrue
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : GetBuilder<HubListController>(
        id: "newUpdate",
        builder: (val) {
          return val.hubListResponse == null
              ? const Center(
            child: Text(
              'Please re-try after some time',
            ),
          )
              : !controller.isFromQurHomeinQurBook.value
              ? Container(
            child: val.hubListResponse.isSuccess
                ? val.hubListResponse.result != null &&
                val.hubListResponse.result.hub
                    .additionalDetails !=
                    null &&
                !val.hubListResponse.result.hub
                    .additionalDetails.isVirtualHub
                ? Stack(children: [
              SingleChildScrollView(
                child: listContent(
                    val.hubListResponse.result),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddDeviceScreen(
                                    hubId: val
                                        .hubListResponse
                                        .result
                                        .id)),
                      ).then((value) => {
                        controller.getHubList()
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            15.0),
                      ),
                      color: Color(CommonUtil()
                          .getMyPrimaryColor()),
                      child: Padding(
                        padding:
                        const EdgeInsets.all(
                            10.0),
                        child: Text(
                          variable.strAddNewDevice,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ])
                : pairNewDeviveBtn()
                : pairNewDeviveBtn(),
          )
              : Container(
            child: val.hubListResponse.isSuccess
                ? val.hubListResponse.result != null &&
                val.hubListResponse.result.hub
                    .additionalDetails !=
                    null &&val.hubListResponse.result.userDeviceCollection!=null&&val.hubListResponse.result.userDeviceCollection.length>0
            /*val.hubListResponse.result.hub
                                              .additionalDetails.isVirtualHub*/
                ? Stack(children: [
              SingleChildScrollView(
                child: listContent(
                    val.hubListResponse.result),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                  EdgeInsets.only(bottom: 20.0),
                  child: Obx(
                        () => Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        controller
                            .searchingBleDevice
                            .isTrue
                            ? Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceAround,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 8,
                            ),
                            FittedBox(
                              child: Text(
                                ScanningForDevices,
                              ),
                            )
                          ],
                        )
                            : InkWell(
                          onTap: () async {
                            try {
                              controller.hubId
                                  .value =
                                  val
                                      .hubListResponse
                                      .result
                                      .id;
                              controller
                                  .checkForConnectedDevices();
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Card(
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  15.0),
                            ),
                            color: Color(
                                CommonUtil()
                                    .getMyPrimaryColor()),
                            child: Padding(
                              padding:
                              const EdgeInsets
                                  .all(
                                  10.0),
                              child: Text(
                                variable.strAddNewDevice,
                                style:
                                TextStyle(
                                  color: Colors
                                      .white,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ])
                : pairNewVirtualHubBtn()
                : pairNewVirtualHubBtn(),
          );
        })),
  );

  Widget pairNewDeviveBtn() {
    final pairNewDeviveWithGesture = InkWell(
      onTap: () async {
        try {
          if (Platform.isIOS) {
            Get.to(
                  () => AddNetWorkView(),
            );
          } else {
            bool serviceEnabled = await CommonUtil().checkGPSIsOn();
            /*var permissionStatus =
                await CommonUtil.askPermissionForLocation(isLocation: false);*/
            if (!serviceEnabled) {
              FlutterToast().getToast(
                  'Please turn on your GPS location services and try again',
                  Colors.red);
              return;
            } else {
              Get.to(
                    () => AddNetWorkView(),
              );
            }
          }
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: 250.0.w,
        height: 48.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Pair New Hub",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
    return Center(
      child: pairNewDeviveWithGesture,
    );
  }

  Widget pairNewVirtualHubBtn() {
    final pairNewVirtualHubWithGesture = InkWell(
      onTap: () async
      {
        try {
          if(controller.hubListResponse.result != null &&
              controller.hubListResponse.result.hub
                  .additionalDetails !=
                  null&&controller.hubListResponse.result.hub
              .additionalDetails.isVirtualHub)
          {
            controller.hubId
                .value =
                controller
                    .hubListResponse
                    .result
                    .id;
            controller
                .checkForConnectedDevices();
          }else{
            controller
                .checkForConnectedDevices(isHaveVirtualHub: false);
          }
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: 260.0.w,
        height: 48.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            variable.strAddNewDevice,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
    return Center(
        child: Obx(() =>controller
            .searchingBleDevice
            .isTrue
            ? Row(
          mainAxisAlignment:
          MainAxisAlignment
              .center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 20,
            ),
            FittedBox(
              child: Text(
                controller.searchingBleDeviceMsg
                    .value,
              ),
            )
          ],
        )
            :pairNewVirtualHubWithGesture,
        ));
  }

  Widget listContent(Result result) {
    return Column(
      children: [
        /*Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/ur_hub.png',
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(height: 5),
                      Text(
                        validString(result.nickName),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Hub Id',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ),
                              Text(
                                validString(result.hub.serialNumber),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Paired On',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ),
                              Text(
                                changeDateFormat(validString(result.createdOn)),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      unPairDialog(
                          type: 'hub',
                          hubId: validString(result.id),
                          idName: validString(result.hub.name));
                    },
                    child: Card(
                      color: Color(CommonUtil().getMyPrimaryColor()),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Unpair',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        ),*/
        result.userDeviceCollection.length != 0
            ? Column(
          children: [
            /*Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Connected Devices',
                      style: TextStyle(
                          color: Color(CommonUtil().getMyPrimaryColor()),
                          fontSize: 16),
                    ),
                  ),*/
            ListView.builder(
                itemCount: result.userDeviceCollection.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipOval(
                                child: result.userDeviceCollection[
                                index] !=
                                    null
                                    ? getProfilePicWidget(
                                    CommonUtil().validString(result
                                        .userDeviceCollection[index]
                                        .user
                                        .profilePicThumbnailUrl),
                                    CommonUtil().validString(result
                                        .userDeviceCollection[index]
                                        .user
                                        .firstName),
                                    CommonUtil().validString(result
                                        .userDeviceCollection[index]
                                        .user
                                        .lastName),
                                    Color(CommonUtil()
                                        .getMyPrimaryColor()))
                                    : Container(
                                    width: 50.0.h,
                                    height: 50.0.h,
                                    padding: EdgeInsets.all(12),
                                    color: Color(
                                        fhbColors.bgColorContainer))),
                            SizedBox(
                              width: 10,
                            ),
                            getDeviceImage(result
                                .userDeviceCollection[index]
                                .device
                                .deviceType
                                .code),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result.userDeviceCollection[index].user
                                          .firstName ??
                                          '',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Device Id ',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12),
                                        ),
                                        Expanded(
                                          child: Text(
                                            CommonUtil().validString(result
                                                .userDeviceCollection[index]
                                                .device
                                                .serialNumber),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Connected ${changeDateFormat(CommonUtil().validString(result.userDeviceCollection[index].createdOn))}',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12),
                                    )
                                  ],
                                )),
                            InkWell(
                              onTap: () {
                                unPairDialog(
                                    type: 'device',
                                    deviceId: result
                                        .userDeviceCollection[index].id,
                                    idName: "Device");
                              },
                              child: Card(
                                color: Color(
                                    CommonUtil().getMyPrimaryColor()),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Unpair',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        )
            : Container()
      ],
    );
  }

  Widget getDeviceImage(String deviceCode) {
    String path = '';
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
          color: Color(CommonUtil().getMyPrimaryColor())),
      height: 50,
      width: 50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Image.asset(
            path,
            height: 50,
            width: 50,
          ),
        ),
      ),
    );
  }

  Future<Widget> unPairDialog(
      {String type, String deviceId, String hubId, String idName}) =>
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Wrap(
                  children: [
                    Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Image.asset('assets/warning_icon.png',
                                    height: 30, width: 30),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                    '${type == 'hub' ? 'Unmapping your QurHub router will lose connection to all your mapped devices and you\'ll not be able to connect again. Are you sure you want to do this?' : 'Are you sure you want to unpair this device from the hub?'}'),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (type == 'hub') {
                                            controller.unPairHub(hubId);
                                            Navigator.pop(context);
                                          } else {
                                            controller.unPairDevice(deviceId);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Card(
                                            color: Colors.red,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0,
                                                  bottom: 5.0,
                                                  left: 20.0,
                                                  right: 20.0),
                                              child: Text(
                                                'Yes',
                                                style:
                                                TextStyle(color: Colors.white),
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Card(
                                            color: Colors.green,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0,
                                                  bottom: 5.0,
                                                  left: 20.0,
                                                  right: 20.0),
                                              child: Text(
                                                'No',
                                                style:
                                                TextStyle(color: Colors.white),
                                              ),
                                            )),
                                      )
                                    ])
                              ],
                            ),
                          ),
                        ))
                  ],
                ));
          });

}
