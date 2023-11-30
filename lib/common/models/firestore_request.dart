import 'dart:convert';

class FirestoreRequestModel {
  final List<String> recipients;
  final MessageDetails messageDetails;
  final List<String> transportMedium;
  final bool saveMessage;

  FirestoreRequestModel({
    required this.recipients,
    required this.messageDetails,
    required this.transportMedium,
    required this.saveMessage,
  });

  factory FirestoreRequestModel.fromJson(Map<String, dynamic> json) =>
      FirestoreRequestModel(
        recipients: List<String>.from(json["recipients"].map((x) => x)),
        messageDetails: MessageDetails.fromJson(json["messageDetails"]),
        transportMedium:
            List<String>.from(json["transportMedium"].map((x) => x)),
        saveMessage: json["saveMessage"],
      );

  Map<String, dynamic> toJson() => {
        "recipients": List<dynamic>.from(recipients.map((x) => x)),
        "messageDetails": messageDetails.toJson(),
        "transportMedium": List<dynamic>.from(transportMedium.map((x) => x)),
        "saveMessage": saveMessage,
      };
}

class MessageDetails {
  final RequestPayload payload;

  MessageDetails({
    required this.payload,
  });

  factory MessageDetails.fromJson(Map<String, dynamic> json) => MessageDetails(
        payload: RequestPayload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "payload": payload.toJson(),
      };
}

class RequestPayload {
  final bool isActivityRefresh;
  final bool isSosEnabled;
  final bool isVitalModuleDisable;

  RequestPayload({
    required this.isActivityRefresh,
    required this.isSosEnabled,
    required this.isVitalModuleDisable,
  });

  factory RequestPayload.fromJson(Map<String, dynamic> json) => RequestPayload(
        isActivityRefresh: json["isActivityRefresh"],
        isSosEnabled: json["isSOSEnabled"],
        isVitalModuleDisable: json["isVitalModuleDisable"],
      );

  Map<String, dynamic> toJson() => {
        "isActivityRefresh": isActivityRefresh,
        "isSOSEnabled": isSosEnabled,
        "isVitalModuleDisable": isVitalModuleDisable,
      };
}
