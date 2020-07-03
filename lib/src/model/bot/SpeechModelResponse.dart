import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class SpeechModelResponse {
  String recipientId;
  String text;
  bool endOfConv;
  String imageURL;

  SpeechModelResponse({this.recipientId, this.text,this.endOfConv,this.imageURL});

  //setter
  SpeechModelResponse.fromJson(Map<String, dynamic> json) {
    recipientId = json[parameters.strReceiptId];
    text = json[parameters.strText];
    imageURL = json.containsKey(parameters.strSpeechImageURL)?json[parameters.strSpeechImageURL]:null;
    endOfConv =json[parameters.strEndOfConv];
  }

  //getter
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strReceiptId] = this.recipientId;
    data[parameters.strText] = this.text;
    data[parameters.strEndOfConv] = this.endOfConv;
    data[parameters.strSpeechImageURL] = this.imageURL;
    return data;
  }
}