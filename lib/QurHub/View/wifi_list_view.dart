import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/QurHub/Controller/add_network_controller.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class WifiListView extends StatefulWidget {
  const WifiListView({Key key}) : super(key: key);

  @override
  _WifiListViewState createState() => _WifiListViewState();
}

class _WifiListViewState extends State<WifiListView> {
  final AddNetworkController controller = Get.find();

  @override
  void initState() {
    try {
      super.initState();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 24.0.sp,
            onTap: () {
              Get.back();
            },
          ),
          title: Text('Wi-Fi'),
          centerTitle: false,
          elevation: 0,
        ),
        body: Obx(() => controller.isLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : controller.ssidList.value == null ||
                    controller.ssidList.value.length == 0
                ? const Center(
                    child: Text(
                      'Not available wifi router around',
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        controller.ssidList.value.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                padding: EdgeInsets.all(10.00),
                                itemCount: controller.ssidList.value.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return itemSSID(index);
                                },
                              )
                            : Container(),
                      ],
                    ),
                  )),
      );

  Widget itemSSID(index) {
    return Column(children: <Widget>[
      ListTile(
        onTap: () {
          try {
            controller.selectedWifiName(
                validString(controller.ssidList.value[index].ssid));
            Get.back();
          } catch (e) {
            print(e);
          }
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.white),
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  '${validString(controller.ssidList.value[index].ssid)[0].toUpperCase()}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Colors.blue)),
            ],
          ),
        ),
        title: Text(
          validString(controller.ssidList.value[index].ssid),
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
          ),
        ),
        dense: true,
      ),
      Divider(),
    ]);
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
}
