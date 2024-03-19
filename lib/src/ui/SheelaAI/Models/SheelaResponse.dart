import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';
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
      result = json['result'] != null ? SheelaResponse.fromJson(json['result']) : null;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String timeStamp = FHBUtils().getFormattedDateString(DateTime.now().toString());
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
  String? imageThumbnailUrl;
  String? audioThumbnailUrl;
  String? videoThumbnailUrl;
  Uint8List? videoThumbnailUrlData; // this for the videoThumbnail avoid loading issue
  Fields? fields;
  String? ftype;

  SheelaResponse({
    this.recipientId,
    this.text,
    this.audioURL,
    this.endOfConv,
    this.endOfConvDiscardDialog,
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
    this.pronunciationText,
    this.imageThumbnailUrl,
    this.audioThumbnailUrl,
    this.videoThumbnailUrl,
    this.videoThumbnailUrlData,
    this.fields,
    this.ftype
  });

  SheelaResponse.fromJson(Map<String, dynamic> json) {
    try {
      recipientId = json['recipient_id'];
      text = json['text'];
      audioURL = json['audioURL'];
      endOfConv = json['endOfConv'];
      endOfConvDiscardDialog = json['endOfConv'] != null ? json['endOfConv'] : false;
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
      additionalInfoSheelaResponse = json['additionalInfo'] != null ? AdditionalInfoSheela.fromJson(json['additionalInfo']) : null;
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
      fields = json["fields"] == null ? null : Fields.fromJson(json["fields"]);
      ftype = json["ftype"]??'';
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
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
    data['imageThumbnailUrl'] = this.imageThumbnailUrl;
    data['audioThumbnailUrl'] = this.audioThumbnailUrl;
    data['videoThumbnailUrl'] = this.videoThumbnailUrl;
    data['fields'] = this.fields;
    data['ftype'] = this.ftype;
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
  bool? isSnoozeAction;
  List<ChatAttachments>? chatAttachments;
  String? media;
  String? mediaType;
  bool? isImageWithContent;
  bool? needPhoto;
  bool? needAudio;
  bool? needVideo;
  String? partialTitle;
  String? partialSynonym;
  List<String>? synonymsList; // list of synonyms to match the voice input
  List<String>? synonyms; // list of synonyms to match the voice input

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
    this.synonymsList,
    this.synonyms,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.isSnoozeAction = false,
    this.media,
    this.mediaType,
    this.isImageWithContent = false,
    this.needPhoto = false,
    this.needAudio = false,
    this.needVideo = false,
    this.partialSynonym,
    this.partialTitle,
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
      isSnoozeAction = (json['isSnoozeAction'] ?? false);
      needPhoto = (json['needPhoto'] ?? false);
      needAudio = (json['needAudio'] ?? false);
      needVideo = (json['needVideo'] ?? false);
      partialSynonym = (json['partialsynonym'] ?? "");
      partialTitle = (json['partialtitle'] ?? "");
      synonymsList = json["synonymsList"] != null
          ? List<String>.from(json["synonymsList"])
          : [];
      synonyms = json["synonyms"] != null
          ? List<String>.from(json["synonyms"])
          : [];
      // Assign synonymsList with an empty list if it's null, otherwise, convert the JSON list to a Dart list of strings
      if (json['chatAttachments'] != null) {
        chatAttachments = <ChatAttachments>[];
        json['chatAttachments'].forEach((v) {
          chatAttachments!.add(ChatAttachments.fromJson(v));
        });
      }
      // Set the 'isImageWithContent' status based on media and mediaType.
      getImageWithContentStatus(json);
    } catch (e, stackTrace) {
      // In case of an exception, set 'isImageWithContent' status and log the error.
      getImageWithContentStatus(json);
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
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
    data['isSnoozeAction'] = this.isSnoozeAction;
    data['needPhoto'] = this.needPhoto;
    data['needAudio'] = this.needAudio;
    data['needVideo'] = this.needVideo;
    data['synonymsList'] = this.synonymsList;
    data['synonyms'] = this.synonyms;
    data['partialtitle'] = this.partialTitle;
    data['partialsynonym'] = this.partialSynonym;
    if (this.chatAttachments != null) {
      data['chatAttachments'] = this.chatAttachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // Extracts image-related information from the provided JSON and sets the status.
  getImageWithContentStatus(Map<String, dynamic> json) {
    try {
      // Extract media and mediaType from the JSON, ensuring non-null values.
      media = CommonUtil().validString(json['media'])?.trim() ?? '';
      mediaType = CommonUtil().validString(json['mediaType'])?.trim() ?? '';

      // Check if both media and mediaType are not empty, and mediaType is 'image'.
      isImageWithContent = (media!.isNotEmpty && mediaType!.isNotEmpty && mediaType!.toLowerCase() == strImageText);
    } catch (e, stackTrace) {
      // Log any errors during the process.
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
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
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
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

  ChatAttachments({this.id, this.chatListId, this.deliveredDateTime, this.isRead, this.messageType, this.messages, this.documentId});

  ChatAttachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatListId = json['chatListId'];
    deliveredDateTime = json['deliveredDateTime'];
    isRead = json['isRead'];
    messageType = json['messageType'];
    messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    documentId = json['documentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  bool? reconfirmationFlag;
  bool? isAutoReadTTS;
  SnoozeData? snoozeData;
  DeviceData? deviceData;
  bool? isLastActivity;
  dynamic eid;
  String? uid;

  AdditionalInfoSheela({this.sessionTimeoutMin, this.reconfirmationFlag, this.snoozeData,this.isLastActivity,this.deviceData,this.eid,this.uid});

  AdditionalInfoSheela.fromJson(Map<String, dynamic> json) {
    try {
      sessionTimeoutMin = json['sessionTimeoutMin'];
      reconfirmationFlag = json['reconfirmationFlag'] ?? false;
      isAutoReadTTS = json['isAutoReRead'] ?? false;
      isLastActivity = json['isLastActivity'] ?? true;
      snoozeData = json['snoozeData'] != null
          ? SnoozeData.fromJson(json['snoozeData'])
          : null;
      deviceData = json['deviceData'] != null
          ? DeviceData.fromJson(json['deviceData'])
          : null;
      eid = json['eid'] ?? '';
      uid = json['uid'] ?? '';
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['sessionTimeoutMin'] = this.sessionTimeoutMin;
    data['reconfirmationFlag'] = this.reconfirmationFlag;
    data['isAutoReRead'] = this.isAutoReadTTS;
    data['isLastActivity'] = this.isLastActivity;
    data['snoozeData'] = this.snoozeData;
    data['deviceData'] = this.deviceData;
    data['eid'] = this.eid;
    data['uid'] = this.uid;
    return data;
  }
}

class SnoozeData {
  String? uformName;
  String? activityName;
  String? title;
  String? description;
  String? eid;
  String? estart;
  String? dosemeal;

  SnoozeData({this.uformName, this.activityName, this.title, this.description, this.eid, this.estart, this.dosemeal});

  SnoozeData.fromJson(Map<String, dynamic> json) {
    try {
      uformName = json['uformName'];
      activityName = json['activityName'];
      title = json['title'];
      description = json['description'];
      eid = json['eid'];
      estart = json['estart'];
      dosemeal = json['dosemeal'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uformName'] = this.uformName;
    data['activityName'] = this.activityName;
    data['title'] = this.title;
    data['description'] = this.description;
    data['eid'] = this.eid;
    data['estart'] = this.estart;
    data['dosemeal'] = this.dosemeal;
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

  Messages({this.id, this.idTo, this.type, this.idFrom, this.isread, this.content, this.isUpload, this.isPatient, this.chatMessageId});

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
    final Map<String, dynamic> data = Map<String, dynamic>();
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

class Fields {
  String? fdata;
  String? description;
  List<Buttons>? fdataA;

  Fields({
    this.fdata,
    this.fdataA,
    this.description,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    fdata: json["fdata"]??"",
    description: json["description"]??"",
    fdataA: json["fdataA"] == null ? [] : List<Buttons>.from(json["fdataA"]!.map((x) =>Buttons.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "fdata": fdata,
    "description": description,
    "fdataA": fdataA == null ? [] : List<dynamic>.from(fdataA!.map((x) => x.toJson())),
  };
}

class DeviceData {
  String? fullName;
  String? shortName;

  DeviceData({this.fullName, this.shortName});

  DeviceData.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    shortName = json['shortName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['shortName'] = this.shortName;
    return data;
  }
}
