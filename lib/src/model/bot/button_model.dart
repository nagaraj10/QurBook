class Buttons {
  String payload;
  String title;
  bool isPlaying;

  Buttons({this.payload, this.title, this.isPlaying});

  Buttons.fromJson(Map<String, dynamic> json) {
    payload = json['payload'];
    title = json['title'];
    isPlaying = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payload'] = this.payload;
    data['title'] = this.title;
    return data;
  }
}
