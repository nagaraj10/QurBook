import 'package:flutter/material.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/followUp/model/followUpResponse.dart';

class FollowUpViewModel extends ChangeNotifier {
  ApiBaseHelper _helper=ApiBaseHelper();
  FollowOnDate followOnDate=FollowOnDate();

  Future<FollowOnDate> followUpAppointment(
      String id,String date) async {
    try {
      FollowOnDate followOnDateAppointment =
      await _helper.followUpAppointment(id, date);
      followOnDate = followOnDateAppointment;
      return followOnDate;
    } catch (e) {}
  }
}