import 'package:myfhb/plan_dashboard/model/UpdatePaymentStatusSubscribe.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/UpdatePaymentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/services/updatePaymentService.dart';

class UpdatePaymentViewModel{

  UpdatePaymentModel updatePaymentModel = UpdatePaymentModel();
  UpdatePaymentService updatePaymentService = new UpdatePaymentService();
  UpdatePaymentStatusSubscribe updatePaymentStatusModel = new UpdatePaymentStatusSubscribe();

  Future<UpdatePaymentModel> updatePaymentStatus(
      String paymentId,
      String paymentOrderId,
      String paymentRequestId) async {
    try {
      UpdatePaymentModel _updatePaymentModel =
      await updatePaymentService.updatePayment(
          paymentId, paymentOrderId, paymentRequestId);
      updatePaymentModel = _updatePaymentModel;
      return updatePaymentModel;
    } catch (e) {}
  }

  Future<UpdatePaymentStatusSubscribe> updatePaymentSubscribe(
      String paymentId,
      String paymentOrderId,
      String paymentRequestId) async {
    try {
      UpdatePaymentStatusSubscribe _updatePaymentStatusSubscribe =
      await updatePaymentService.updatePaymentForSubscribe(
          paymentId, paymentOrderId, paymentRequestId);
      updatePaymentStatusModel = _updatePaymentStatusSubscribe;
      return updatePaymentStatusModel;
    } catch (e) {}
  }

}