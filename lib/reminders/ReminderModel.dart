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
      'eid': id,
      'title': title,
      'description': desc,
      'estart': dateTime,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'eid': id,
      'title': title,
      'description': desc,
      'estart': dateTime,
    };
  }

  Reminder.fromMap(Map<String, dynamic> map) {
    id = map['eid'];
    title = map['title'];
    desc = map['description'];
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
