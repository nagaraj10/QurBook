import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/plan_dashboard/model/UpdatePaymentStatusSubscribe.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;

import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/UpdatePaymentModel.dart';

class UpdatePaymentService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UpdatePaymentModel> updatePayment(
      String paymentId,
      String paymentOrderId,
      String paymentRequestId,
      bool isFromRazor,
      String signature) async {
    var paymentInput = {};
    paymentInput[qr_payment_id] = paymentId;
    paymentInput[qr_payment_order_id] = paymentOrderId;
    paymentInput[qr_payment_req_id] = paymentRequestId;
    if (isFromRazor) {
      paymentInput[qr_signature] = signature;
    }

    var jsonString = convert.jsonEncode(paymentInput);
    print(jsonString);
    final response = await _helper.updatePayment(qr_update_payment, jsonString);
    return UpdatePaymentModel.fromJson(response);
  }

  Future<UpdatePaymentStatusSubscribe> updatePaymentForSubscribe(
      String paymentId,
      String paymentOrderId,
      String paymentRequestId,
      bool isFromRazor,
      String signature) async {
    var paymentInput = {};
    paymentInput[qr_payment_id] = paymentId;
    paymentInput[qr_payment_order_id] = paymentOrderId;
    paymentInput[qr_payment_req_id] = paymentRequestId;
    if (isFromRazor) {
      paymentInput[qr_signature] = signature;
    }

    var jsonString = convert.jsonEncode(paymentInput);
    final response =
        await _helper.updatePayment(qr_update_payment_subscribe, jsonString);
    return UpdatePaymentStatusSubscribe.fromJson(response);
  }
}
