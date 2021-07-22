import 'package:flutter/foundation.dart';

import '../../constants/fhb_parameters.dart' as parameters;


class ReminderModel{
  final String id;
  final String title;
  final String notes;
  final String date;
  final String time;
  final String interval;

  ReminderModel({@required this.title,@required this.notes,@required this.interval,this.date,this.time,this.id});


  Map<String,dynamic> toMap(){
    return {
      parameters.strId:id,
      parameters.strtitle:title,
      parameters.strnotes:notes,
      parameters.strdate:date,
      parameters.strtime:time,
      parameters.strinterval:interval
    };
  }

  @override
  String toString() {
    return 'Reminder{id:$id,title:$title,notes:$notes,date:$date,time:$time,intervel:$interval}';
  }


}