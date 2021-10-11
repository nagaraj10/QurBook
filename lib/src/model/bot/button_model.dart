class Buttons {
  String payload;
  String title;
  bool isPlaying;
  bool skipTTS;
  bool isSelected;

  Buttons({
    this.payload,
    this.title,
    this.isPlaying,
    this.skipTTS,
    this.isSelected,
  });

  Buttons.fromJson(Map<String, dynamic> json) {
    payload = json['payload'];
    title = json['title'];
    skipTTS = json['skip_tts'] ?? false;
    isPlaying = false;
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['payload'] = payload;
    data['title'] = title;
    return data;
  }
}
