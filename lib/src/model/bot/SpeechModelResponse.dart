import '../../../constants/fhb_parameters.dart' as parameters;
import 'button_model.dart';
import 'video_links.dart';

class SpeechModelResponse {
  String recipientId;
  String text;
  bool endOfConv;
  String imageURL;
  String searchURL;
  String lang;
  List<Buttons> buttons;
  List<VideoLinks> videoLinks;
  bool redirect;
  bool enableMic;
  bool provider_msg;
  bool singleuse;
  bool isActionDone;
  String redirectTo;
  SpeechModelResponse({
    this.recipientId,
    this.text,
    this.endOfConv,
    this.imageURL,
    this.searchURL,
    this.lang,
    this.buttons,
    this.videoLinks,
    this.redirect,
    this.enableMic,
    this.provider_msg,
    this.singleuse: true,
    this.isActionDone: false,
    this.redirectTo,
  });

  //setter
  SpeechModelResponse.fromJson(Map<String, dynamic> json) {
    recipientId = json[parameters.strReceiptId];
    text = json[parameters.strText];
    imageURL = json.containsKey(parameters.strSpeechImageURL)
        ? json[parameters.strSpeechImageURL]
        : null;
    endOfConv = json[parameters.strEndOfConv];
    searchURL = json[parameters.strSearchUrl];
    lang = json[parameters.strLanguage];
    if (json[parameters.strButtons] != null) {
      buttons = List<Buttons>();
      json[parameters.strButtons].forEach((v) {
        buttons.add(Buttons.fromJson(v));
      });
    }
    if (json[parameters.strVideoLinks] != null) {
      videoLinks = <VideoLinks>[];
      json[parameters.strVideoLinks].forEach((v) {
        videoLinks.add(VideoLinks.fromJson(v));
      });
    }
    redirect = json[parameters.strRedirect];
    enableMic = json[parameters.strEnableMic] ?? false;
    provider_msg = json[parameters.strProviderMsg] ?? false;
    singleuse = json[parameters.strsingleuse];
    isActionDone = json[parameters.strisActionDone];
    redirectTo = json[parameters.strRedirectTo];
  }

  //getter
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strReceiptId] = recipientId;
    data[parameters.strText] = text;
    data[parameters.strEndOfConv] = endOfConv;
    data[parameters.strSpeechImageURL] = imageURL;
    data[parameters.strSearchUrl] = searchURL;
    data[parameters.strLanguage] = lang;
    if (buttons != null) {
      data[parameters.strButtons] = buttons.map((v) => v.toJson()).toList();
    }
    if (videoLinks != null) {
      data[parameters.strVideoLinks] =
          videoLinks.map((v) => v.toJson()).toList();
    }
    data[parameters.strRedirect] = this.redirect;
    data[parameters.strEnableMic] = this.enableMic;
    data[parameters.strProviderMsg] = this.provider_msg;
    data[parameters.strsingleuse] = this.singleuse;
    data[parameters.strisActionDone] = this.isActionDone;
    data[parameters.strRedirectTo] = this.redirectTo;
    return data;
  }
}
