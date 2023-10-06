import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/GoogleTTSResponseModel.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';

class SpeechModelAPIResponse {
  bool? isSuccess;
  SheelaResponse? result;

  SpeechModelAPIResponse({this.isSuccess, this.result});

  SpeechModelAPIResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'] ?? false;
      result =
              json['result'] != null ? SheelaResponse.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class SheelaResponse {
  String? recipientId;
  String? text;
  String? audioURL;
  bool? endOfConv = true;
  bool? endOfConvDiscardDialog = false;
  List<Buttons>? buttons;
  var imageURL;
  List<String>? imageURLS;
  var searchURL;
  String? lang;
  var postId;
  var matchedQuestion;
  List<VideoLinks>? videoLinks;
  var translatedUserText;
  bool? redirect;
  bool? enableMic;
  bool? providerMsg;
  var redirectTo;
  bool? singleuse = false;
  bool? isActionDone = false;
  var eid;
  bool? directCall;
  String? recipient;
  String timeStamp =
      FHBUtils().getFormattedDateString(DateTime.now().toString());
  GoogleTTSResponseModel? ttsResponse;
  Rx<bool> isPlaying = false.obs;
  int? currentButtonPlayingIndex;
  bool? loading = false;
  String? conversationFlag;
  var additionalInfo;
  AdditionalInfoSheela? additionalInfoSheelaResponse;
  String? sessionId;
  String? relationshipId;
  String? audioFile;
  bool? playAudioInit = false;
  bool? isButtonNumber;
  String? pronunciationText;

  SheelaResponse(
      {this.recipientId,
      this.text,
      this.audioURL,
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
      this.directCall,
      this.recipient,
      this.ttsResponse,
      this.loading,
      this.conversationFlag,
      this.additionalInfo,
      this.additionalInfoSheelaResponse,
      this.sessionId,
      this.relationshipId,
      this.imageURLS,
      this.audioFile,
      this.playAudioInit,
      this.isButtonNumber,
      this.pronunciationText});

  SheelaResponse.fromJson(Map<String, dynamic> json) {
    try {
      recipientId = json['recipient_id'];
      text = json['text'];
      audioURL = json['audioURL'];
      endOfConv = json['endOfConv'];
      endOfConvDiscardDialog =
              json['endOfConv'] != null ? json['endOfConv'] : false;
      if (json['buttons'] != null) {
            buttons = <Buttons>[];
            json['buttons'].forEach((v) {
              buttons?.add(Buttons.fromJson(v));
            });
          }
      if (json['imageURL'] is List) {
            imageURLS = json['imageURL'].cast<String>();
          } else if (json['imageURL'] is String) {
            imageURL = json['imageURL'];
          }
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
      directCall = (json['directCall'] ?? false);
      recipient = json['recipient'];
      conversationFlag = json['conversationFlag'];
      additionalInfo = json['additionalInfo'];
      additionalInfoSheelaResponse =
      json['additionalInfo'] != null ? AdditionalInfoSheela.fromJson(
          json['additionalInfo']) : null;
      sessionId = json['sessionId'];
      relationshipId = json['relationshipId'];
      isButtonNumber = (json['IsButtonNumber'] ?? false);

      if (buttons != null && buttons!.length > 0) {
            List<Buttons>? buttonsList = [];
            buttons!.forEach((element) {
              if (element.hidden != sheela_hdn_btn_yes) {
                buttonsList.add(element);
              }
            });
            buttons = buttonsList;
          }
      pronunciationText = (json['pronunciationText'] ?? '');
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['recipient_id'] = this.recipientId;
    data['text'] = this.text;
    data['audioURL'] = this.audioURL;
    data['endOfConv'] = this.endOfConv;
    data['endOfConv'] = this.endOfConvDiscardDialog;
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
    data['directCall'] = this.directCall;
    data['recipient'] = this.recipient;
    data['conversationFlag'] = this.conversationFlag;
    data['additionalInfo'] = this.additionalInfo;
    data['additionalInfo'] = this.additionalInfoSheelaResponse;
    data['sessionId'] = this.sessionId;
    data['relationshipId'] = this.relationshipId;
    data['IsButtonNumber'] = this.isButtonNumber;
    data['pronunciationText'] = this.pronunciationText;
    return data;
  }
}

class Buttons {
  String? payload;
  String? title;
  String? hidden;
  String? mute;
  String? sayText;
  bool? skipTts;
  bool? relationshipIdNotRequired;
  GoogleTTSResponseModel? ttsResponse;
  Rx<bool> isPlaying = false.obs;
  bool isSelected = false;
  String? btnRedirectTo;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  List<ChatAttachments>? chatAttachments;

  Buttons({
    this.payload,
    this.title,
    this.hidden,
    this.mute,
    this.sayText,
    this.skipTts,
    this.relationshipIdNotRequired = false,
    this.ttsResponse,
    this.btnRedirectTo,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
  });

  Buttons.fromJson(Map<String, dynamic> json) {
    try {
      payload = json['payload'];
      title = json['title'];
      hidden = (json['hidden'] ?? '');
      mute = (json['mute'] ?? '');
      sayText = (json['saytext'] ?? '');
      skipTts = (json['skip_tts'] ?? false);
      relationshipIdNotRequired = (json['relationshipIdNotRequired'] ?? false);
      btnRedirectTo = (json['redirectTo'] ?? '');
      imageUrl = (json['imageUrl'] ?? '');
      videoUrl = (json['videoUrl'] ?? '');
      audioUrl = (json['audioUrl'] ?? '');
      if (json['chatAttachments'] != null) {
        chatAttachments = <ChatAttachments>[];
        json['chatAttachments'].forEach((v) {
          chatAttachments!.add(new ChatAttachments.fromJson(v));
        });
      }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['payload'] = this.payload;
    data['title'] = this.title;
    data['hidden'] = this.hidden;
    data['mute'] = this.mute;
    data['saytext'] = this.sayText;
    data['skip_tts'] = this.skipTts;
    data['relationshipIdNotRequired'] = this.relationshipIdNotRequired;
    data['redirectTo'] = this.btnRedirectTo;
    data['imageUrl'] = this.imageUrl;
    data['videoUrl'] = this.videoUrl;
    data['audioUrl'] = this.audioUrl;
    if (this.chatAttachments != null) {
      data['chatAttachments'] =
          this.chatAttachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoLinks {
  String? title;
  String? thumbnail;
  String? url;

  VideoLinks({this.title, this.thumbnail, this.url});

  VideoLinks.fromJson(Map<String, dynamic> json) {
    try {
      title = json['title'];
      thumbnail = json['thumbnail'];
      url = json['url'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['thumbnail'] = this.thumbnail;
    data['url'] = this.url;
    return data;
  }
}

class ChatAttachments {
  String? id;
  String? chatListId;
  String? deliveredDateTime;
  bool? isRead;
  int? messageType;
  Messages? messages;
  String? documentId;

  ChatAttachments(
      {this.id,
        this.chatListId,
        this.deliveredDateTime,
        this.isRead,
        this.messageType,
        this.messages,
        this.documentId});

  ChatAttachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatListId = json['chatListId'];
    deliveredDateTime = json['deliveredDateTime'];
    isRead = json['isRead'];
    messageType = json['messageType'];
    messages = json['messages'] != null
        ? new Messages.fromJson(json['messages'])
        : null;
    documentId = json['documentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chatListId'] = this.chatListId;
    data['deliveredDateTime'] = this.deliveredDateTime;
    data['isRead'] = this.isRead;
    data['messageType'] = this.messageType;
    if (this.messages != null) {
      data['messages'] = this.messages!.toJson();
    }
    data['documentId'] = this.documentId;
    return data;
  }
}

class AdditionalInfoSheela {
  dynamic? sessionTimeoutMin;

  AdditionalInfoSheela({this.sessionTimeoutMin});

  AdditionalInfoSheela.fromJson(Map<String, dynamic> json) {
    try {
      sessionTimeoutMin = json['sessionTimeoutMin'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['sessionTimeoutMin'] = this.sessionTimeoutMin;
    return data;
  }
}

class Messages {
  String? id;
  String? idTo;
  int? type;
  String? idFrom;
  bool? isread;
  String? content;
  bool? isUpload;
  bool? isPatient;
  String? chatMessageId;

  Messages(
      {this.id,
        this.idTo,
        this.type,
        this.idFrom,
        this.isread,
        this.content,
        this.isUpload,
        this.isPatient,
        this.chatMessageId});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idTo = json['idTo'];
    type = json['type'];
    idFrom = json['idFrom'];
    isread = json['isread'];
    content = json['content'];
    isUpload = json['isUpload'];
    isPatient = json['isPatient'];
    chatMessageId = json['chatMessageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idTo'] = this.idTo;
    data['type'] = this.type;
    data['idFrom'] = this.idFrom;
    data['isread'] = this.isread;
    data['content'] = this.content;
    data['isUpload'] = this.isUpload;
    data['isPatient'] = this.isPatient;
    data['chatMessageId'] = this.chatMessageId;
    return data;
  }
}
