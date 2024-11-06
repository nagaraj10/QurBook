
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/AvailableTimeSlotsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotsResultModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/services/slotsAvailabilityService.dart';

class SlotsAvailabilityViewModel{

  SlotsAvailabilityService slotsAvailabilityService = SlotsAvailabilityService();
  SlotsResultModel sessionList = SlotsResultModel();


  Future<AvailableTimeSlotsModel?> fetchTimeSlots(String date, String doctorId,String healthOrgId) async {
    try {
      AvailableTimeSlotsModel doctorTimeSlotsModel =
      await slotsAvailabilityService.getTelehealthSlotsList(date, doctorId,healthOrgId);
      //sessionList = doctorTimeSlotsModel;
      return doctorTimeSlotsModel;
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }
}
