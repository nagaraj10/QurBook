import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/Orders/Controller/OrderController.dart';
import 'package:myfhb/Orders/View/OrderTile.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class OrdersView extends StatelessWidget {
  final controller = Get.put(
    OrderController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Orders'),
      ),
      body: obx(
        () {
          return controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color(
                      CommonUtil().getMyPrimaryColor(),
                    ),
                  ),
                )
              : ShowOrders();
        },
      ),
    );
  }

  Widget ShowOrders() {
    return controller.orders.value.length == 0
        ? Center(
            child: Text(
              "No Orders Placed",
            ),
          )
        : ListView.builder(
            itemCount: controller.orders.value.length,
            itemBuilder: (BuildContext context, int index) {
              return OrderTile(
                order: controller.orders.value[index],
              );
            },
          );
  }
}
