import 'package:get/get.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/GoogleTTSResponseModel.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:rxdart/streams.dart';

class SpeechModelAPIResponse {
  bool isSuccess;
  SheelaResponse result;

  SpeechModelAPIResponse({this.isSuccess, this.result});

  SpeechModelAPIResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'] ?? false;
    result =
        json['result'] != null ? SheelaResponse.fromJson(json['result']) : null;
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

class SheelaResponse {
  String recipientId;
  String text;
  bool endOfConv = true;
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
  bool singleuse = false;
  bool isActionDone = false;
  var eid;
  String timeStamp =
      FHBUtils().getFormattedDateString(DateTime.now().toString());
  GoogleTTSResponseModel ttsResponse;
  Rx<bool> isPlaying = false.obs;
  int currentButtonPlayingIndex;
  bool loading = false;
  String conversationFlag;
  String sessionId;
  String relationshipId;

  SheelaResponse({
    this.recipientId,
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
    this.ttsResponse,
    this.loading,
    this.conversationFlag,
    this.sessionId,
    this.relationshipId,
  });

  SheelaResponse.fromJson(Map<String, dynamic> json) {
    recipientId = json['recipient_id'];
    text = json['text'];
    endOfConv = json['endOfConv'];
    if (json['buttons'] != null) {
      buttons = <Buttons>[];
      json['buttons'].forEach((v) {
        buttons?.add(Buttons.fromJson(v));
      });
    }
    imageURL = json['imageURL'];
    searchURL = json['searchURL'];
    lang = json['lang'];
    postId = json['postId'];
    matchedQuestion = json['matchedQuestion'];
    if (json['videoLinks'] != null) {
      videoLinks = <VideoLinks>[];
      json['videoLinks'].forEach((v) {
        videoLinks?.add(VideoLinks.fromJson(v));
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['recipient_id'] = this.recipientId;
    data['text'] = this.text;
    data['endOfConv'] = this.endOfConv;
    if (this.buttons != null) {
      data['buttons'] = this.buttons?.map((v) => v.toJson()).toList();
    }
    data['imageURL'] = this.imageURL;
    data['searchURL'] = this.searchURL;
    data['lang'] = this.lang;
    data['postId'] = this.postId;
    data['matchedQuestion'] = this.matchedQuestion;
    if (this.videoLinks != null) {
      data['videoLinks'] = this.videoLinks?.map((v) => v.toJson()).toList();
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

class Buttons {
  String payload;
  String title;
  bool skipTts;
  bool relationshipIdNotRequired;
  GoogleTTSResponseModel ttsResponse;
  Rx<bool> isPlaying = false.obs;
  bool isSelected = false;

  Buttons({
    this.payload,
    this.title,
    this.skipTts,
    this.relationshipIdNotRequired = false,
    this.ttsResponse,
  });

  Buttons.fromJson(Map<String, dynamic> json) {
    payload = json['payload'];
    title = json['title'];
    skipTts = (json['skip_tts'] ?? false);
    relationshipIdNotRequired = (json['relationshipIdNotRequired'] ?? false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['payload'] = this.payload;
    data['title'] = this.title;
    data['skip_tts'] = this.skipTts;
    data['relationshipIdNotRequired'] = this.relationshipIdNotRequired;
    return data;
  }
}

class VideoLinks {
  String title;
  String thumbnail;
  String url;

  VideoLinks({this.title, this.thumbnail, this.url});

  VideoLinks.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    thumbnail = json['thumbnail'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['thumbnail'] = this.thumbnail;
    data['url'] = this.url;
    return data;
  }
}
