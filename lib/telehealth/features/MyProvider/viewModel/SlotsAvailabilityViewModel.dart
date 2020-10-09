import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/AvailableTimeSlotsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotsResultModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/services/slotsAvailabilityService.dart';

class SlotsAvailabilityViewModel{

  SlotsAvailabilityService slotsAvailabilityService = new SlotsAvailabilityService();
  SlotsResultModel sessionList = new SlotsResultModel();


  Future<SlotsResultModel> fetchTimeSlots(String date, String doctorId,String healthOrgId) async {
    try {
      AvailableTimeSlotsModel doctorTimeSlotsModel =
      await slotsAvailabilityService.getTelehealthSlotsList(date, doctorId,healthOrgId);
      sessionList = doctorTimeSlotsModel.result;
      return sessionList;
    } catch (e) {}
  }
}
