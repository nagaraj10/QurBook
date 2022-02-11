import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/Orders/Controller/OrderController.dart';
import 'package:myfhb/Orders/Model/OrderModel.dart';
import 'package:myfhb/Orders/View/AppointmentOrderTile.dart';
import 'package:myfhb/Orders/View/OrderTile.dart';
import 'package:myfhb/QurHub/Controller/QurHubController.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

import 'AddNetworkView.dart';

class QurHubView extends StatefulWidget {
  @override
  _QurHubViewState createState() => _QurHubViewState();
}

class _QurHubViewState extends State<QurHubView> {
  final controller = Get.put(
    QurHubController(),
  );
  @override
  void initState() {
    try {
      super.initState();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    try {
      FocusManager.instance.primaryFocus.unfocus();
      fbaLog(eveName: 'qurbook_screen_event', eveParams: {
        'eventTime': '${DateTime.now()}',
        'pageName': 'QurHubView Screen',
        'screenSessionTime':
            '${DateTime.now().difference(mInitialTime).inSeconds} secs'
      });
      super.dispose();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () {
            Get.back();
          },
        ),
        title: const Text(
          'Connected Hub',
        ),
      ),
      body: Obx(
        () {
          return controller.isLoading.value
              ? CommonCircularIndicator()
              : Center(child: _showPairNewHubBtn());
        },
      ),
    );
  }

  Widget _showPairNewHubBtn() {
    final addButtonWithGesture = GestureDetector(
      onTap: () {
        Get.to(
          AddNetWorkView(),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            width: 200.0.w,
            height: 47.0.h,
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }
}
