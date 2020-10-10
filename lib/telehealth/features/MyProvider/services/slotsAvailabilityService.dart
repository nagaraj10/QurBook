import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;

import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/AvailableTimeSlotsModel.dart';


class SlotsAvailabilityService{

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<AvailableTimeSlotsModel> getTelehealthSlotsList(
      String date, String doctorId,String healthOrgId) async {
    var slotInput = {};
    slotInput[qr_slotDate] = date;
    slotInput[qr_doctorid] = doctorId;
    slotInput[qr_health_org_id] = healthOrgId;

    var jsonString = convert.jsonEncode(slotInput);
    print(jsonString);
    final response = await _helper.getTimeSlotsList(qr_getSlots, jsonString);
    print(response);
    return AvailableTimeSlotsModel.fromJson(response);
  }
}
