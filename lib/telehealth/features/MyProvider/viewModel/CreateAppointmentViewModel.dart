import 'package:myfhb/telehealth/features/MyProvider/model/appointments/CreateAppointmentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/services/createAppointmentService.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';

class CreateAppointMentViewModel {
  CreateAppointmentService createAppointmentService =
      new CreateAppointmentService();
  CreateAppointmentModel bookAppointment = CreateAppointmentModel();

  Future<CreateAppointmentModel> putBookAppointment(
      String createdBy,
      String createdFor,
      String doctorSessionId,
      String scheduleDate,
      String slotNumber,
      bool isMedicalShared,
      bool isFollowUp,
      List<String> healthRecords,
      {History doc}) async {
    try {
      CreateAppointmentModel bookAppointmentModel =
          await createAppointmentService.bookAppointment(
              createdBy,
              createdFor,
              doctorSessionId,
              scheduleDate,
              slotNumber,
              isMedicalShared,
              isFollowUp,
              healthRecords,
              doc: doc);
      bookAppointment = bookAppointmentModel;
      return bookAppointment;
    } catch (e) {}
  }
}
