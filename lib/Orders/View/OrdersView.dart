import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/Orders/Controller/OrderController.dart';
import 'package:myfhb/Orders/View/OrderTile.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

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
          'My Orders',
        ),
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
                child: Text(
                  "Past Orders",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.orders.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OrderTile(
                      order: controller.orders.value[index],
                    );
                  },
                ),
              ),
            ],
          );
  }
}
