import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';

import '../../common/CommonUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../constants/fhb_constants.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import '../Controller/OrderController.dart';
import '../Model/OrderModel.dart';
import 'AppointmentOrderTile.dart';
import 'OrderTile.dart';

class OrdersView extends StatefulWidget {
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final controller = Get.put(
    OrderController(),
  );
  @override
  void initState() {
    controller.getOrders();
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus!.unfocus();

    super.dispose();
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
        title: Text(
          'My Orders',
          style: TextStyle(
              fontSize: (CommonUtil().isTablet ?? false)
                  ? tabFontTitle
                  : mobileFontTitle),
        ),
      ),
      body: Obx(
        () {
          return controller.isLoading.value
              ? CommonCircularIndicator()
              : ShowOrders(
                  context,
                );
        },
      ),
    );
  }

  Widget ShowOrders(BuildContext context) {
    return controller.orders.value.length == 0
        ? Center(
            child: Text(
              'No Orders Placed',
              style: Theme.of(context).textTheme.headline6,
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Text("Past Orders",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: (CommonUtil().isTablet ?? false)
                            ? tabHeader1
                            : mobileHeader1)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.orders.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    OrderModel currentOrder = controller.orders.value[index];
                    return currentOrder.isAppointment!
                        ? AppointmentOrderTile(
                            order: currentOrder,
                          )
                        : OrderTile(
                            order: currentOrder,
                          );
                  },
                ),
              ),
            ],
          );
  }
}
