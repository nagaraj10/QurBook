import 'dart:convert';

import 'dynamicfieldmodel.dart';

class AdditionalInfo {
  String? ack;
  dynamic? eid;
  dynamic? uform;
  String? cptCode;
  String? dosemeal;
  String? ackLocal;
  bool? issymptom;
  dynamic? uformdata;
  String? uformname;
  String? endDateTime;
  String? startDateTime;
  String? cptCodeDetails;
  dynamic? uid;
  String? title;
  String? linkid;
  String? activityname;
  String? activityType;
  List<DynamicFieldModel> dynamicFieldModel = [];
  List<DynamicFieldModel> dynamicFieldModelfromUForm = [];

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
      this.activityType});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    ack = json['ack'];
    eid = json['eid'];
    uform = json['uform'];
    cptCode = json['cpt_code'];
    dosemeal = json['dosemeal'];
    ackLocal = json['ack_local'];
    issymptom = json['issymptom'];
    try {
      if (json['uformdata'] != null) getDynamicFieldList(json['uformdata']);
    } catch (e) {
      print(e);

      dynamicFieldModel = [];
    }

    try {
      if (json['uform'] != null)
        getDynamicFieldListFromUfrom(jsonDecode(json['uform']));
    } catch (e) {
      print(e);

      dynamicFieldModelfromUForm = [];
    }
    uformname = json['uformname'];
    endDateTime = json['end_date_time'];
    startDateTime = json['start_date_time'];
    cptCodeDetails = json['cpt_code_details'];
    uid = json['uid'];
    title = json['title'];
    linkid = json['linkid'];
    activityname = json['activityname'];
    activityType = json['activity_type'];
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
    return data;
  }

  getDynamicFieldListFromUfrom(dynamic json) {
    json.forEach((fieldTitle, fieldData) => dynamicFieldModelfromUForm.add(
        DynamicFieldModel.fromJson(fieldTitle, fieldData) != null
            ? DynamicFieldModel.fromJson(fieldTitle, fieldData)
            : DynamicFieldModel()));
    try {
      dynamicFieldModelfromUForm?.sort((a, b) => a?.seq.compareTo(b?.seq));
    } catch (e) {}
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
      //print(e);
    }
  }
}
