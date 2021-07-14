import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/Orders/Model/OrderModel.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';

class OrderController extends GetController {
  var orders = [].obs;
  var isLoading = false.obs;

  getOrders() async {
    isLoading.value = true;
    orders.value = [];
    var response = await getMyOrders();
    if (response != null) {
      try {
        final usersOrders = OrderDataModel.fromJson(response);
        if (usersOrders.isSuccess) {
          orders.value = usersOrders.result;
        }
      } catch (e) {
        FlutterToast().getToast('Failed to get the past orders', Colors.red);
      }
    }
    isLoading.value = false;
  }

  Future<dynamic> getMyOrders() async {
    final url = BASE_URL + qr_user + qr_myOrders;
    final headers = await HeaderRequest().getRequestHeadersTimeSlotDumy();
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        FlutterToast().getToast('Failed to get the past orders', Colors.red);
        return null;
      }
    } catch (e) {
      FlutterToast().getToast('Failed to get the past orders', Colors.red);
      return null;
    }
  }
}
