import 'package:flutter/foundation.dart';

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
      'id':id,
      'title':title,
      'notes':notes,
      'date':date,
      'time':time,
      'interval':interval
    };
  }

  @override
  String toString() {
    return 'Reminder{id:$id,title:$title,notes:$notes,date:$date,time:$time,intervel:$interval}';
  }


}