class SpeechModelResponse {
  String recipientId;
  String text;
  bool endOfConv;
  String imageURL;

  SpeechModelResponse({this.recipientId, this.text,this.endOfConv,this.imageURL});

  //setter
  SpeechModelResponse.fromJson(Map<String, dynamic> json) {
    recipientId = json['recipient_id'];
    text = json['text'];
    imageURL = json.containsKey('imageURL')?json['imageURL']:null;
    endOfConv =json['endOfConv'];
  }

  //getter
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipient_id'] = this.recipientId;
    data['text'] = this.text;
    data['endOfConv'] = this.endOfConv;
    data['imageURL'] = this.imageURL;
    return data;
  }
}