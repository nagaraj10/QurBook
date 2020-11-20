class DateSlots {
  List<DateSlotTimings> dateSlotTimings;

  DateSlots({this.dateSlotTimings});
}

class DateSlotTimings {
  String dateTimings;
  List<DateTiming> dateTimingsSlots;
  DateSlotTimings({this.dateTimings,this.dateTimingsSlots});
}

class DateTiming {
  String timeslots;
  DateTiming({this.timeslots});
}
