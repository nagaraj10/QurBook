import 'package:flutter/foundation.dart';
import '../../../constants/fhb_parameters.dart' as parameters;
import 'button_model.dart';
import 'video_links.dart';

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
  bool loadingDots;
  bool provider_msg;
  bool singleuse;
  bool isActionDone;
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
    this.loadingDots: true,
    this.provider_msg: false,
    this.singleuse: true,
    this.isActionDone: false,
  });

  Conversation.fromJson(Map<String, dynamic> json) {
    isMayaSaid = json[parameters.strIsMayaSaid];
    text = json[parameters.strText];
    imageUrl = json[parameters.strImageUrl];
    name = json[parameters.strName];
    timeStamp = json[parameters.strTimeStamp];
    langCode = json[parameters.strLanguage];
    provider_msg = json[parameters.strProviderMsg];
    if (json[parameters.strButtons] != null) {
      buttons = <Buttons>[];
      json[parameters.strButtons].forEach((v) {
        buttons.add(Buttons.fromJson(v));
      });
    }
    searchURL = json[parameters.strSearchUrl];
    if (json[parameters.strVideoLinks] != null) {
      videoLinks = <VideoLinks>[];
      json[parameters.strVideoLinks].forEach((v) {
        videoLinks.add(VideoLinks.fromJson(v));
      });
    }
    screen = json[parameters.strScreen];
    redirect = json[parameters.strRedirect];
    isSpeaking = false;
    loadingDots = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strIsMayaSaid] = this.isMayaSaid;
    data[parameters.strText] = this.text;
    data[parameters.strImageUrl] = this.imageUrl;
    data[parameters.strName] = this.name;
    data[parameters.strTimeStamp] = this.timeStamp;
    data[parameters.strLanguage] = this.langCode;
    data[parameters.strProviderMsg] = this.provider_msg;
    if (this.buttons != null) {
      data[parameters.strButtons] =
          buttons.map((v) => v.toJson()).toList();
    }
    data[parameters.strSearchUrl] = searchURL;
    if (videoLinks != null) {
      data[parameters.strVideoLinks] =
          videoLinks.map((v) => v.toJson()).toList();
    }
    data[parameters.strScreen] = screen;
    data[parameters.strRedirect] = redirect;
    return data;
  }
}
