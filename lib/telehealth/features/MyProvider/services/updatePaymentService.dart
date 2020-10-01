import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'file:///C:/Users/fmohamed/Documents/Flutter%20Projects/asgard_myfhb/lib/telehealth/features/MyProvider/model/updatePayment/UpdatePaymentModel.dart';
import 'dart:convert' as convert;

class UpdatePaymentService{

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UpdatePaymentModel> updatePayment(
      String paymentId,
      String paymentOrderId,
      String paymentRequestId) async {
    var paymentInput = {};
    paymentInput[qr_payment_id] = paymentId;
    paymentInput[qr_payment_order_id] = paymentOrderId;
    paymentInput[qr_payment_req_id] = paymentRequestId;

    var jsonString = convert.jsonEncode(paymentInput);
    final response = await _helper.updatePayment(qr_update_payment, jsonString);
    return UpdatePaymentModel.fromJson(response);
  }

}