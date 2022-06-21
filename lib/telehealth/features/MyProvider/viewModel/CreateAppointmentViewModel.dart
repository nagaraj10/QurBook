import 'package:myfhb/telehealth/features/MyProvider/model/appointments/AppointmentNotificationPayment.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/CreateAppointmentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/services/createAppointmentService.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';

class CreateAppointMentViewModel {
  CreateAppointmentService createAppointmentService =
      new CreateAppointmentService();
  CreateAppointmentModel bookAppointment = CreateAppointmentModel();
  AppointmentNotificationPayment appointmentNotification = AppointmentNotificationPayment();


  Future<CreateAppointmentModel> putBookAppointment(
    String createdBy,
    String bookedFor,
    String doctorSessionId,
    String scheduleDate,
    String slotNumber,
    bool isMedicalShared,
    bool isFollowUp,
    List<String> healthRecords,
    bool isCSRDiscount, {
    Past doc,
    bool isResidentDoctorMembership = false,
  }) async {
    try {
      CreateAppointmentModel bookAppointmentModel =
          await createAppointmentService.bookAppointment(
        createdBy,
        bookedFor,
        doctorSessionId,
        scheduleDate,
        slotNumber,
        isMedicalShared,
        isFollowUp,
        healthRecords,
        isCSRDiscount,
        doc: doc,
        isResidentDoctorMembership: isResidentDoctorMembership,
      );
      bookAppointment = bookAppointmentModel;
      return bookAppointment;
    } catch (e) {}
  }

  Future<AppointmentNotificationPayment> getAppointmentDetailsUsingId(String appointmentId)async{
    try {
      AppointmentNotificationPayment appointmentNotificationModel = await createAppointmentService
          .getAppointmentDetailsUsingId(appointmentId);
      appointmentNotification = appointmentNotificationModel;
      return appointmentNotification;
    }catch(e){

    }

  }
}
