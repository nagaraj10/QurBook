import 'dart:convert';

import 'package:myfhb/common/CommonUtil.dart';

import 'dynamicfieldmodel.dart';

class AdditionalInfo {
  dynamic? ack;
  dynamic? eid;
  dynamic? uform;
  dynamic? cptCode;
  dynamic? dosemeal;
  dynamic? ackLocal;
  bool? issymptom;
  dynamic? uformdata;
  dynamic? uformname;
  dynamic? endDateTime;
  dynamic? startDateTime;
  dynamic? cptCodeDetails;
  dynamic? uid;
  dynamic? title;
  dynamic? linkid;
  dynamic? activityname;
  dynamic? activityType;
  List<DynamicFieldModel> dynamicFieldModel = [];
  List<DynamicFieldModel> dynamicFieldModelfromUForm = [];
  dynamic? comment;
  dynamic? category;
  dynamic? actionId;
  dynamic? escalatedTime;
  dynamic? escalatedById;
  dynamic? escalatedToId;
  dynamic? resolveComment;
  dynamic? escalatedByName;
  dynamic? escalatedToName;
  dynamic? escalationReceived;
  int? risklevel;
  dynamic? escalatedComment;

  AdditionalInfo(
      {this.ack,
      this.eid,
      this.uform,
      this.cptCode,
      this.dosemeal,
      this.ackLocal,
      this.issymptom,
      this.uformdata,
      this.uformname,
      this.endDateTime,
      this.startDateTime,
      this.cptCodeDetails,
      this.uid,
      this.title,
      this.linkid,
      this.activityname,
      this.activityType,
      this.comment,
      this.category,
      this.actionId,
      this.escalatedTime,
      this.escalatedById,
      this.escalatedToId,
      this.resolveComment,
      this.escalatedByName,
      this.escalatedToName,
      this.escalationReceived,
      this.risklevel,
      this.escalatedComment});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    try {
      ack = json.containsKey('ack') ? json['ack'] : '';
      eid = json.containsKey('eid') ? json['eid'] : '';
      uform = json.containsKey('uform') ? json['uform'] : '';
      cptCode = json.containsKey('cpt_code') ? json['cpt_code'] : '';
      dosemeal = json.containsKey('dosemeal') ? json['dosemeal'] : '';
      ackLocal = json.containsKey('ack_local') ? json['ack_local'] : '';
      issymptom = json.containsKey('issymptom') ? json['issymptom'] : false;
      try {
            if (json['uformdata'] != null) getDynamicFieldList(json['uformdata']);
          } catch (e) {
            print(e);
            CommonUtil().appLogs(message: e.toString());

            dynamicFieldModel = [];
          }

      try {
            if (json['uform'] != null)
              getDynamicFieldListFromUfrom(jsonDecode(json['uform']));
          } catch (e) {
            CommonUtil().appLogs(message: e.toString());

            print(e);

            dynamicFieldModelfromUForm = [];
          }
      uformname = json.containsKey('uformname') ? json['uformname'] : '';
      endDateTime =
              json.containsKey('end_date_time') ? json['end_date_time'] : '';
      startDateTime =
              json.containsKey('start_date_time') ? json['start_date_time'] : '';
      cptCodeDetails =
              json.containsKey('cpt_code_details') ? json['cpt_code_details'] : '';
      uid = json.containsKey('uid') ? json['uid'] : '';
      title = json.containsKey('title') ? json['title'] : '';
      linkid = json.containsKey('linkid') ? json['linkid'] : '';
      activityname = json.containsKey('activityname') ? json['activityname'] : '';
      activityType =
              json.containsKey('activity_type') ? json['activity_type'] : '';
      comment = json.containsKey('comment') ? json['comment'] : '';
      category = json.containsKey('category') ? json['category'] : '';
      actionId = json.containsKey('action_id') ? json['action_id'] : '';
      escalatedTime =
              json.containsKey('escalated_time') ? json['escalated_time'] : '';
      escalatedById =
              json.containsKey('escalated_by_id') ? json['escalated_by_id'] : '';
      escalatedToId =
              json.containsKey('escalated_to_id') ? json['escalated_to_id'] : '';
      resolveComment =
              json.containsKey('resolve_comment') ? json['resolve_comment'] : '';
      escalatedByName =
              json.containsKey('escalated_by_name') ? json['escalated_by_name'] : '';
      escalatedToName =
              json.containsKey('escalated_to_name') ? json['escalated_to_name'] : '';
      escalationReceived = json.containsKey('escalation_received')
              ? json['escalation_received']
              : '';
      risklevel = json.containsKey('risklevel') ? json['risklevel'] : 0;
      escalatedComment =
              json.containsKey('escalated_comment') ? json['escalated_comment'] : '';
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ack'] = this.ack;
    data['eid'] = this.eid;
    data['cpt_code'] = this.cptCode;
    data['dosemeal'] = this.dosemeal;
    data['ack_local'] = this.ackLocal;
    data['issymptom'] = this.issymptom;
    if (this.uformdata != null) {
      data['uformdata'] = this.uformdata!.toJson();
    }
    if (this.uformdata != null) {
      data['uform'] = this.uform!.toJson();
    }
    data['uformname'] = this.uformname;
    data['end_date_time'] = this.endDateTime;
    data['start_date_time'] = this.startDateTime;
    data['cpt_code_details'] = this.cptCodeDetails;
    data['uid'] = this.uid;
    data['title'] = this.title;
    data['linkid'] = this.linkid;
    data['activityname'] = this.activityname;
    data['activity_type'] = this.activityType;
    data['comment'] = this.comment;
    data['category'] = this.category;
    data['action_id'] = this.actionId;
    data['escalated_time'] = this.escalatedTime;
    data['escalated_by_id'] = this.escalatedById;
    data['escalated_to_id'] = this.escalatedToId;
    data['resolve_comment'] = this.resolveComment;
    data['escalated_by_name'] = this.escalatedByName;
    data['escalated_to_name'] = this.escalatedToName;
    data['escalation_received'] = this.escalationReceived;
    data['risklevel'] = this.risklevel;
    data['escalated_comment'] = this.escalatedComment;
    return data;
  }

  getDynamicFieldListFromUfrom(dynamic json) {
    json.forEach((fieldTitle, fieldData) => dynamicFieldModelfromUForm.add(
        DynamicFieldModel.fromJson(fieldTitle, fieldData) != null
            ? DynamicFieldModel.fromJson(fieldTitle, fieldData)
            : DynamicFieldModel()));
    try {
      dynamicFieldModelfromUForm?.sort((a, b) => a?.seq.compareTo(b?.seq));
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  getDynamicFieldList(dynamic json) {
    json?.removeWhere((key, value) => key == "#otherdata");

    json.forEach((fieldTitle, fieldData) {
      dynamicFieldModel.add(
          DynamicFieldModel.fromJson(fieldTitle, fieldData) != null
              ? DynamicFieldModel.fromJson(fieldTitle, fieldData)
              : DynamicFieldModel());
    });

    if (dynamicFieldModel.isNotEmpty && dynamicFieldModel.length > 0) {
      if (dynamicFieldModelfromUForm.length > 0 &&
          dynamicFieldModelfromUForm.isNotEmpty) {
        for (DynamicFieldModel dynamicFieldModelUform
            in dynamicFieldModelfromUForm) {
          for (DynamicFieldModel dynamicFieldModelUformData
              in dynamicFieldModel) {
            if (dynamicFieldModelUform?.description ==
                dynamicFieldModelUformData?.description) {
              dynamicFieldModelUformData.seq = dynamicFieldModelUform.seq;
              if (dynamicFieldModelUform.value == null ||
                  dynamicFieldModelUform.value ==
                      "") if (dynamicFieldModelUformData.value is String) {
                dynamicFieldModelUform.value = dynamicFieldModelUformData.value;
                dynamicFieldModelUform.commonValue =
                    dynamicFieldModelUform.value;
              } else {
                dynamicFieldModelUform.value = dynamicFieldModelUformData.value;
                dynamicFieldModelUform.commonValue =
                    dynamicFieldModelUform.value;
              }
            }
          }
        }
      }
    }
    try {
      dynamicFieldModel?.sort((a, b) => a?.seq.compareTo(b?.seq));
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }
}
