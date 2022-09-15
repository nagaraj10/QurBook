
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/src/model/bot/video_links.dart';

import 'button_model.dart';

class SpeechModelResponse {
  bool isSuccess;
  Result result;

  SpeechModelResponse({this.isSuccess, this.result});

  SpeechModelResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String recipientId;
  String text;
  bool endOfConv;
  List<Buttons> buttons;
  var imageURL;
  var searchURL;
  String lang;
  var postId;
  var matchedQuestion;
  List<VideoLinks> videoLinks;
  var translatedUserText;
  bool redirect;
  bool enableMic;
  bool providerMsg;
  var redirectTo;
  bool singleuse;
  bool isActionDone;
  var eid;
  String conversationFlag;
  String sessionId;
  String relationshipId;

  Result(
      {this.recipientId,
        this.text,
        this.endOfConv,
        this.buttons,
        this.imageURL,
        this.searchURL,
        this.lang,
        this.postId,
        this.matchedQuestion,
        this.videoLinks,
        this.translatedUserText,
        this.redirect,
        this.enableMic,
        this.providerMsg,
        this.redirectTo,
        this.singleuse,
        this.isActionDone,
        this.eid,
        this.conversationFlag,
        this.sessionId,
        this.relationshipId,

      });

  Result.fromJson(Map<String, dynamic> json) {
    recipientId = json['recipient_id'];
    text = json['text'];
    endOfConv = json['endOfConv'];
    if (json[strButtons] != null) {
      buttons = List<Buttons>();
      json[strButtons].forEach((v) {
        buttons.add(Buttons.fromJson(v));
      });
    }
    imageURL = json['imageURL'];
    searchURL = json['searchURL'];
    lang = json['lang'];
    postId = json['postId'];
    matchedQuestion = json['matchedQuestion'];
    if (json[strVideoLinks] != null) {
      videoLinks = <VideoLinks>[];
      json[strVideoLinks].forEach((v) {
        videoLinks.add(VideoLinks.fromJson(v));
      });
    }
    translatedUserText = json['translated_user_text'];
    redirect = json['redirect'];
    enableMic = json['enable_mic'];
    providerMsg = json['provider_msg'];
    redirectTo = json['redirectTo'];
    singleuse = json['singleuse'];
    isActionDone = json['isActionDone'];
    eid = json['eid'];
    conversationFlag = json['conversationFlag'];
    sessionId = json['sessionId'];
    relationshipId = json['relationshipId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipient_id'] = this.recipientId;
    data['text'] = this.text;
    data['endOfConv'] = this.endOfConv;
    data['imageURL'] = this.imageURL;
    data['searchURL'] = this.searchURL;
    data['lang'] = this.lang;
    data['postId'] = this.postId;
    data['matchedQuestion'] = this.matchedQuestion;
    if (buttons != null) {
      data[strButtons] = buttons.map((v) => v.toJson()).toList();
    }
    if (videoLinks != null) {
      data[strVideoLinks] =
          videoLinks.map((v) => v.toJson()).toList();
    }
    data['translated_user_text'] = this.translatedUserText;
    data['redirect'] = this.redirect;
    data['enable_mic'] = this.enableMic;
    data['provider_msg'] = this.providerMsg;
    data['redirectTo'] = this.redirectTo;
    data['singleuse'] = this.singleuse;
    data['isActionDone'] = this.isActionDone;
    data['eid'] = this.eid;
    data['conversationFlag'] = this.conversationFlag;
    data['sessionId'] = this.sessionId;
    data['relationshipId'] = this.relationshipId;
    return data;
  }
}