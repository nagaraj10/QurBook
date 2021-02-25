import 'package:flutter/foundation.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/bot/button_model.dart';
import 'package:myfhb/src/model/bot/video_links.dart';

class Conversation {
  bool isMayaSaid;
  String text;
  String imageUrl;
  String name;
  String timeStamp;
  String langCode;
  List<Buttons> buttons;
  String searchURL;
  List<VideoLinks> videoLinks;
  String screen;
  bool redirect;
  bool isSpeaking;
  Conversation({
    @required this.isMayaSaid,
    @required this.text,
    this.imageUrl,
    @required this.name,
    this.timeStamp,
    this.buttons,
    this.langCode,
    this.searchURL,
    this.videoLinks,
    this.screen,
    this.redirect,
    this.isSpeaking: false,
  });

  Conversation.fromJson(Map<String, dynamic> json) {
    isMayaSaid = json[parameters.strIsMayaSaid];
    text = json[parameters.strText];
    imageUrl = json[parameters.strImageUrl];
    name = json[parameters.strName];
    timeStamp = json[parameters.strTimeStamp];
    langCode = json[parameters.strLanguage];
    if (json[parameters.strButtons] != null) {
      buttons = new List<Buttons>();
      json[parameters.strButtons].forEach((v) {
        buttons.add(new Buttons.fromJson(v));
      });
    }
    searchURL = json[parameters.strSearchUrl];
    if (json[parameters.strVideoLinks] != null) {
      videoLinks = new List<VideoLinks>();
      json[parameters.strVideoLinks].forEach((v) {
        videoLinks.add(new VideoLinks.fromJson(v));
      });
    }
    screen = json[parameters.strScreen];
    redirect = json[parameters.strRedirect];
    isSpeaking = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strIsMayaSaid] = this.isMayaSaid;
    data[parameters.strText] = this.text;
    data[parameters.strImageUrl] = this.imageUrl;
    data[parameters.strName] = this.name;
    data[parameters.strTimeStamp] = this.timeStamp;
    data[parameters.strLanguage] = this.langCode;
    if (this.buttons != null) {
      data[parameters.strButtons] =
          this.buttons.map((v) => v.toJson()).toList();
    }
    data[parameters.strSearchUrl] = this.searchURL;
    if (this.videoLinks != null) {
      data[parameters.strVideoLinks] =
          this.videoLinks.map((v) => v.toJson()).toList();
    }
    data[parameters.strScreen] = this.screen;
    data[parameters.strRedirect] = this.redirect;
    return data;
  }
}
