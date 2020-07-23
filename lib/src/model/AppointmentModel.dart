import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

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
      parameters.strId:id,
      parameters.strhosname:hName,
      parameters.strdocname:dName,
      parameters.strappdate:appDate,
      parameters.strapptime:appTime,
      parameters.strreason:reason
    };
  }

  @override
  String toString() {
    return 'Appointment{id:$id,hosname:$hName,docname:$dName,appdate:$appDate,appTime:$appTime,reason:$reason}';
  }


}