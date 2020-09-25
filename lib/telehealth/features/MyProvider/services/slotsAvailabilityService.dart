import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/AvailableTimeSlotsModel.dart';
import 'dart:convert' as convert;


class SlotsAvailabilityService{

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<AvailableTimeSlotsModel> getTelehealthSlotsList(
      String date, String doctorId) async {
    var slotInput = {};
    slotInput[qr_slotDate] = date;
    slotInput[qr_doctorid] = doctorId;

    var jsonString = convert.jsonEncode(slotInput);
    print(jsonString);
    final response = await _helper.getTimeSlotsList(qr_getSlots, jsonString);
    print(response);
    return AvailableTimeSlotsModel.fromJson(response);
  }
}
