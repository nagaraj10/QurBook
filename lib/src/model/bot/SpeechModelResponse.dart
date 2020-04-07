class SpeechModelResponse {
  String recipientId;
  String text;

  SpeechModelResponse({this.recipientId, this.text});

  SpeechModelResponse.fromJson(Map<String, dynamic> json) {
    recipientId = json['recipient_id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipient_id'] = this.recipientId;
    data['text'] = this.text;
    return data;
  }
}