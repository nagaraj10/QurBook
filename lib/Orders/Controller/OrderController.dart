import 'package:get/get.dart';
import 'package:myfhb/Orders/Model/OrderModel.dart';

class OrderController extends GetController {
  var orders = [].obs;
  var isLoading = false.obs;

  getOrders() async {
    isLoading.value = true;
    await Future.delayed(
      const Duration(
        seconds: 4,
      ),
    );
    final plan = OrderPlan(
      title: 'Inital plan',
      price: '200',
    );
    final order = OrderModel(
      orderId: "12345678",
      title: "Covid Care",
      description:
          'This plan provides you the detail discription about the covid.',
      purchaseDate: "08 July 2021",
      totalAmount: "2400",
      plans: [
        plan,
        plan,
      ],
    );
    orders.value = [];
    orders.value.addAll(
      [
        order,
        order,
        order,
        order,
        order,
        order,
      ],
    );
    isLoading.value = false;
  }
}
