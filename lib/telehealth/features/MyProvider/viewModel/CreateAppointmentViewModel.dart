import 'package:myfhb/telehealth/features/MyProvider/model/appointments/CreateAppointmentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/services/createAppointmentService.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';

class CreateAppointMentViewModel {
  CreateAppointmentService createAppointmentService =
      new CreateAppointmentService();
  CreateAppointmentModel bookAppointment = CreateAppointmentModel();

  Future<CreateAppointmentModel> putBookAppointment(
      String createdBy,
      String bookedFor,
      String doctorSessionId,
      String scheduleDate,
      String slotNumber,
      bool isMedicalShared,
      bool isFollowUp,
      List<String> healthRecords,
      bool isCSRDiscount,
      {Past doc}) async {
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
              doc: doc);
      bookAppointment = bookAppointmentModel;
      return bookAppointment;
    } catch (e) {}
  }
}
