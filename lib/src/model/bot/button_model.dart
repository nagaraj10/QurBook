class Buttons {
  String payload;
  String title;

  Buttons({this.payload, this.title});

  Buttons.fromJson(Map<String, dynamic> json) {
    payload = json['payload'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payload'] = this.payload;
    data['title'] = this.title;
    return data;
  }
}