import 'RecipientReceiver.dart';
import 'Patient.dart';
import 'ReminderFor.dart';
import 'ReminderSettingLevel.dart';

class Result {
  Result({
      String id, 
      int remindAfterMins, 
      bool isActive, 
      String createdOn, 
      dynamic lastModifiedOn, 
      RecipientReceiver recipientReceiver, 
      Patient patient, 
      ReminderFor reminderFor, 
      ReminderSettingLevel reminderSettingLevel,}){
    _id = id;
    _remindAfterMins = remindAfterMins;
    _isActive = isActive;
    _createdOn = createdOn;
    _lastModifiedOn = lastModifiedOn;
    _recipientReceiver = recipientReceiver;
    _patient = patient;
    _reminderFor = reminderFor;
    _reminderSettingLevel = reminderSettingLevel;
}

  Result.fromJson(dynamic json) {
    _id = json['id'];
    _remindAfterMins = json['remindAfterMins'];
    _isActive = json['isActive'];
    _createdOn = json['createdOn'];
    _lastModifiedOn = json['lastModifiedOn'];
    _recipientReceiver = json['recipientReceiver'] != null ? RecipientReceiver.fromJson(json['recipientReceiver']) : null;
    _patient = json['patient'] != null ? Patient.fromJson(json['patient']) : null;
    _reminderFor = json['reminderFor'] != null ? ReminderFor.fromJson(json['reminderFor']) : null;
    _reminderSettingLevel = json['reminderSettingLevel'] != null ? ReminderSettingLevel.fromJson(json['reminderSettingLevel']) : null;
  }
  String _id;
  int _remindAfterMins;
  bool _isActive;
  String _createdOn;
  dynamic _lastModifiedOn;
  RecipientReceiver _recipientReceiver;
  Patient _patient;
  ReminderFor _reminderFor;
  ReminderSettingLevel _reminderSettingLevel;

  String get id => _id;
  int get remindAfterMins => _remindAfterMins;
  bool get isActive => _isActive;
  String get createdOn => _createdOn;
  dynamic get lastModifiedOn => _lastModifiedOn;
  RecipientReceiver get recipientReceiver => _recipientReceiver;
  Patient get patient => _patient;
  ReminderFor get reminderFor => _reminderFor;
  ReminderSettingLevel get reminderSettingLevel => _reminderSettingLevel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['remindAfterMins'] = _remindAfterMins;
    map['isActive'] = _isActive;
    map['createdOn'] = _createdOn;
    map['lastModifiedOn'] = _lastModifiedOn;
    if (_recipientReceiver != null) {
      map['recipientReceiver'] = _recipientReceiver.toJson();
    }
    if (_patient != null) {
      map['patient'] = _patient.toJson();
    }
    if (_reminderFor != null) {
      map['reminderFor'] = _reminderFor.toJson();
    }
    if (_reminderSettingLevel != null) {
      map['reminderSettingLevel'] = _reminderSettingLevel.toJson();
    }
    return map;
  }

}