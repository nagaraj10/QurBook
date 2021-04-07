class Reminder {
  int id;
  String title;
  String desc;
  String date;
  String time;
  Reminder({
    this.id,
    this.title,
    this.desc,
    this.date,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'time': time,
    };
  }

  Reminder.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    desc = map['desc'];
    date = map['date'];
    time = map['time'];
  }
}
