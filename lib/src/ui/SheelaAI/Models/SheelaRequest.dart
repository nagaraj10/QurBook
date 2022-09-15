import '../../../../constants/fhb_constants.dart';
import '../../../../constants/variable_constant.dart';

class SheelaRequestModel {
  String sender;
  String name;
  String message;
  String source;
  String sessionId;
  String authToken;
  String timezone;
  String lang;
  String deviceType;
  String ProviderMsg;
  Map<String, dynamic> kioskData;
  String endPoint;
  String relationshipId;
  String conversationFlag;
  String localDateTime;
  SheelaRequestModel({
    this.sender,
    this.name,
    this.message,
    this.source = strQurbookSheela,
    this.sessionId,
    this.authToken,
    this.timezone,
    this.lang,
    this.deviceType,
    this.kioskData,
    this.ProviderMsg,
    this.endPoint,
    this.relationshipId,
    this.conversationFlag,
    this.localDateTime,
  });

  SheelaRequestModel.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    name = json['Name'];
    message = json['message'];
    sessionId = json['sessionId'];
    authToken = json['authToken'];
    timezone = json['timezone'];
    lang = json['lang'];
    deviceType = json['device_type'];
    kioskData = json['kiosk_data'];
    ProviderMsg = json['provider_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['sender'] = this.sender;
    data['Name'] = this.name;
    data['message'] = this.message;
    data['source'] = this.source;
    data['sessionId'] = this.sessionId;
    data['authToken'] = this.authToken;
    data['timezone'] = this.timezone;
    data['lang'] = this.lang;
    data['device_type'] = this.deviceType;
    if (kioskData != null) {
      data['kiosk_data'] = kioskData;
    }
    data['provider_msg'] = ProviderMsg;
    data['endPoint'] = endPoint;
    data['relationshipId'] = relationshipId;
    data['conversationFlag'] = conversationFlag;
    data["localDateTime"] = localDateTime;
    return data;
  }
}
