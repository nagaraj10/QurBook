class Reminder {
  String id;
  String title;
  String desc;
  String dateTime;

  Reminder({
    this.id,
    this.title,
    this.desc,
    this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'dateTime': dateTime,
    };
  }

  Reminder.fromMap(Map<String, dynamic> map) {
    id = map['eid'];
    title = map['title'];
    desc = map['saytext'];
    dateTime = map['estart'];
  }
  @override
  bool operator ==(other) {
    return (other is Reminder) &&
        other.id == id &&
        other.title == title &&
        other.desc == desc &&
        other.dateTime == dateTime;
  }
}
