import 'package:myfhb/plan_dashboard/model/UpdatePaymentStatusSubscribe.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/PaymentFailureRetryModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/UpdatePaymentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/services/updatePaymentService.dart';

class UpdatePaymentViewModel {
  UpdatePaymentModel updatePaymentModel = UpdatePaymentModel();
  UpdatePaymentService updatePaymentService = new UpdatePaymentService();
  UpdatePaymentStatusSubscribe updatePaymentStatusModel =
      new UpdatePaymentStatusSubscribe();
  PaymentFailureRetryModel paymentFailureRetryModel =
  new PaymentFailureRetryModel();

  Future<UpdatePaymentModel> updatePaymentStatus(
      String paymentId,
      String paymentOrderId,
      String paymentRequestId,
      bool isFromRazor,
      String signature) async {
    try {
      UpdatePaymentModel _updatePaymentModel =
          await updatePaymentService.updatePayment(paymentId, paymentOrderId,
              paymentRequestId, isFromRazor, signature);
      updatePaymentModel = _updatePaymentModel;
      return updatePaymentModel;
    } catch (e) {}
  }

  Future<UpdatePaymentStatusSubscribe> updatePaymentSubscribe(
      String paymentId,
      String paymentOrderId,
      String paymentRequestId,
      bool isFromRazor,
      String signature) async {
    try {
      UpdatePaymentStatusSubscribe _updatePaymentStatusSubscribe =
          await updatePaymentService.updatePaymentForSubscribe(paymentId,
              paymentOrderId, paymentRequestId, isFromRazor, signature);
      updatePaymentStatusModel = _updatePaymentStatusSubscribe;
      return updatePaymentStatusModel;
    } catch (e) {}
  }

  Future<PaymentFailureRetryModel> checkSlotsRetry(
      String appointmentId,
      ) async {
    try {
      PaymentFailureRetryModel paymentFailure =
      await updatePaymentService.failureRetry(appointmentId);
      paymentFailureRetryModel = paymentFailure;
      return paymentFailureRetryModel;
    } catch (e) {}
  }
}
