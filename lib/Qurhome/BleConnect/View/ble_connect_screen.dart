import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/Qurhome/BleConnect/Controller/ble_connect_controller.dart';
import 'package:myfhb/common/CommonUtil.dart';
import '../../../src/utils/screenutils/size_extensions.dart';

class BleConnectScreen extends StatefulWidget {
  const BleConnectScreen({Key key}) : super(key: key);

  @override
  _BleConnectScreenState createState() => _BleConnectScreenState();
}

class _BleConnectScreenState extends State<BleConnectScreen> {
  final controller = Get.put(BleConnectController());
  //FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color(CommonUtil().getQurhomePrimaryColor()),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text('BleConnect'),
          centerTitle: false,
          elevation: 0,
        ),
        body: Obx(
          () => controller.loadingData.isTrue
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              controller.strProgressMessage.value,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.errorMessage.value.trim().isNotEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            controller.errorMessage.value,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 0.00,
                      ),
                    if (controller.errorMessage.value.trim().isNotEmpty)
                      SizedBox(
                        height: 10.00,
                      )
                    else
                      SizedBox(
                        height: 0.00,
                      ),
                    if (controller.strBleData.value.trim().isNotEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            controller.strBleData.value,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 0.00,
                      ),
                    if (controller.strBleData.value.trim().isNotEmpty)
                      SizedBox(
                        height: 10.00,
                      )
                    else
                      SizedBox(
                        height: 0.00,
                      ),
                    bleScanBtn(),
                  ],
                ),
        ),
      );

  Widget bleScanBtn() {
    final bleScanWithGesture = InkWell(
      onTap: () async {
        try {
          if (!controller.isBleScanning.isTrue) {
            bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled) {
              FlutterToast().getToast(
                  'Please turn on your location services and re-try again',
                  Colors.red);
              return;
            }
            /*bool bluetoothEnabled = await flutterBlue.isOn;
            if (!bluetoothEnabled) {
              FlutterToast().getToast(
                  'Please turn on your bluetooth and re-try again', Colors.red);
              return;
            }*/
            controller.getBleConnectData(context);
          }
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: 200.0.w,
        height: 45.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getQurhomePrimaryColor()),
          //color: Color(CommonUtil().getMyPrimaryColor()),
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
            controller.isBleScanning.isTrue ? "Stop scan" : "Start scan",
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
      child: bleScanWithGesture,
    );
  }
}
