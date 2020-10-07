import 'package:flutter/cupertino.dart';
import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/resheduleModel.dart';
import 'package:myfhb/telehealth/features/appointments/services/reshedule_appointment_service.dart';

class ResheduleAppointmentViewModel extends ChangeNotifier {
  ResheduleAppointmentsService _resheduleAppointmentsService =
      ResheduleAppointmentsService();
  ResheduleModel resheduleAppointmentModel = new ResheduleModel();

  Future<ResheduleModel> resheduleAppointment(List<String> bookingId,
      String slotNumber, String resheduleDate, String doctorSessionId) async {
    try {
      ResheduleModel resheduleAp = await _resheduleAppointmentsService.resheduleAppointment(
          bookingId, slotNumber, resheduleDate, doctorSessionId);
      resheduleAppointmentModel = resheduleAp;
      return resheduleAppointmentModel;
    } catch (e) {}
  }
}
