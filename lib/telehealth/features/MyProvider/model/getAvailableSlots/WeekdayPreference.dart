class WeekdayPreference {
  String day;
  bool isAvailable;

  WeekdayPreference({this.day, this.isAvailable});

  WeekdayPreference.fromJson(Map<String, dynamic> json) {
    day = json['Day'];
    isAvailable = json['isAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Day'] = this.day;
    data['isAvailable'] = this.isAvailable;
    return data;
  }
}