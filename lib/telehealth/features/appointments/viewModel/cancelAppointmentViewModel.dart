
import 'package:flutter/cupertino.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/services/cancel_appointment_service.dart';

class CancelAppointmentViewModel extends ChangeNotifier {
  CancelAppointmentsService cancelAppointmentsService=CancelAppointmentsService();
  CancelAppointmentModel cancelAppointmentModel = new CancelAppointmentModel();


  Future<CancelAppointmentModel> fetchCancelAppointment(
      List<String?> bookingId,List<String?> date) async {
    try {
      CancelAppointmentModel cancelAppointment =
      await cancelAppointmentsService.getCancelAppointment(bookingId as List<String>,date as List<String>);
      cancelAppointmentModel = cancelAppointment;
      return cancelAppointmentModel;
    } catch (e) {}
  }
}
