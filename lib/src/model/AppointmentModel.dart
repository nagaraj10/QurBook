import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppointmentModel{
  final String id;
  final String hName;
  final String dName;
  final String appDate;
  final String appTime;
  final String reason;


  AppointmentModel({@required this.id,@required this.hName,@required this.dName, @required this.appDate,@required this.appTime,this.reason});

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'hosname':hName,
      'docname':dName,
      'appdate':appDate,
      'apptime':appTime,
      'reason':reason
    };
  }

  @override
  String toString() {
    return 'Appointment{id:$id,hosname:$hName,docname:$dName,appdate:$appDate,appTime:$appTime,reason:$reason}';
  }


}