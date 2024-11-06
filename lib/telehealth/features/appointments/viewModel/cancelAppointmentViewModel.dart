
import 'package:flutter/cupertino.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/services/cancel_appointment_service.dart';

class CancelAppointmentViewModel extends ChangeNotifier {
  CancelAppointmentsService cancelAppointmentsService = CancelAppointmentsService();
  CancelAppointmentModel cancelAppointmentModel = CancelAppointmentModel();


  Future<CancelAppointmentModel?> fetchCancelAppointment(
      List<String?> bookingId,List<String?> date) async {
    try {
      CancelAppointmentModel cancelAppointment =
      await cancelAppointmentsService.getCancelAppointment(bookingId,date);
      cancelAppointmentModel = cancelAppointment;
      return cancelAppointmentModel;
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      print(e);
    }
  }
}
