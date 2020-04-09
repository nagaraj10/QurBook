import 'package:flutter/foundation.dart';

class AppointmentModel{
  final String id;
  final String hName;
  final String dName;
  final String appDate;
  final String reason;


  AppointmentModel({@required this.id,@required this.hName,@required this.dName, @required this.appDate,this.reason});

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'hosname':hName,
      'docname':dName,
      'appdate':appDate,
      'reason':reason
    };
  }

  @override
  String toString() {
    return 'Appointment{id:$id,hosname:$hName,docname:$dName,appdate:$appDate,reason:$reason}';
  }


}