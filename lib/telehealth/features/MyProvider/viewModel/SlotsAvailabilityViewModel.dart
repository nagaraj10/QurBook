import 'package:myfhb/telehealth/features/MyProvider/model/AvailableTimeSlotsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/SlotsResultModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/services/slotsAvailabilityService.dart';

class SlotsAvailabilityViewModel{

  SlotsAvailabilityService slotsAvailabilityService = new SlotsAvailabilityService();
  SlotsResultModel sessionList = new SlotsResultModel();


  Future<SlotsResultModel> fetchTimeSlots(String date, String doctorId) async {
    try {
      AvailableTimeSlotsModel doctorTimeSlotsModel =
      await slotsAvailabilityService.getTelehealthSlotsList(date, doctorId);
      sessionList = doctorTimeSlotsModel.result;
      return sessionList;
    } catch (e) {}
  }
}
