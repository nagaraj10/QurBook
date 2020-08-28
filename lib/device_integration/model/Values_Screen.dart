class Values {
  final String time;
  final String value1;
  final String icon;
  final String date;
  final String title1;
  final String title2;
  final String title3;
  final String value2;
  final String value3;
  Values(
      {this.time,
      this.value1,
      this.icon,
      this.date,
      this.title1,
      this.title2,
      this.title3,
      this.value2,
      this.value3});
  factory Values.fromJson(Map<String, dynamic> json) {
    return Values(
      time: json['time'],
      value1: json['value'],
      icon: json['icon'],
      date: json['date'],
      title1: json['title1'],
      title2: json['title2'],
      title3: json['title3'],
      value2: json['value2'],
      value3: json['value3'],
    );
  }
}
