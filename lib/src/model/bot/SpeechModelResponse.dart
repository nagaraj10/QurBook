import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/bot/button_model.dart';
import 'package:myfhb/src/model/bot/video_links.dart';

class SpeechModelResponse {
  String recipientId;
  String text;
  bool endOfConv;
  String imageURL;
  String searchURL;
  String lang;
  List<Buttons> buttons;
  List<VideoLinks> videoLinks;

  SpeechModelResponse({
    this.recipientId, this.text,this.endOfConv,this.imageURL,
    this.searchURL,this.lang,this.buttons,this.videoLinks
    });

  //setter
  SpeechModelResponse.fromJson(Map<String, dynamic> json) {
    recipientId = json[parameters.strReceiptId];
    text = json[parameters.strText];
    imageURL = json.containsKey(parameters.strSpeechImageURL)?json[parameters.strSpeechImageURL]:null;
    endOfConv =json[parameters.strEndOfConv];
    searchURL = json[parameters.strSearchUrl];
    lang = json[parameters.strLanguage];
    if (json[parameters.strButtons] != null) {
      buttons = new List<Buttons>();
      json[parameters.strButtons].forEach((v) {
        buttons.add(new Buttons.fromJson(v));
      });
    }
    if (json[parameters.strVideoLinks] != null) {
      videoLinks = new List<VideoLinks>();
      json[parameters.strVideoLinks].forEach((v) {
        videoLinks.add(new VideoLinks.fromJson(v));
      });
    }
  }

  //getter
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strReceiptId] = this.recipientId;
    data[parameters.strText] = this.text;
    data[parameters.strEndOfConv] = this.endOfConv;
    data[parameters.strSpeechImageURL] = this.imageURL;
    data[parameters.strSearchUrl] = this.searchURL;
    data[parameters.strLanguage] = this.lang;
    if (this.buttons != null) {
      data[parameters.strButtons] = this.buttons.map((v) => v.toJson()).toList();
    }
    if (this.videoLinks != null) {
      data[parameters.strVideoLinks] = this.videoLinks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}