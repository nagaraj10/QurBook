class DoctorBookMarkedSucessModel {
  int status;
  bool success;
  String message;
  Response response;

  DoctorBookMarkedSucessModel(
      {this.status, this.success, this.message, this.response});

  DoctorBookMarkedSucessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  Data data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String id;
  String patientId;
  String doctorId;
  String requestedBy;
  bool isDefault;
  bool isReadable;
  bool isEditable;
  bool isDeletable;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String lastModifiedBy;

  Data(
      {this.id,
      this.patientId,
      this.doctorId,
      this.requestedBy,
      this.isDefault,
      this.isReadable,
      this.isEditable,
      this.isDeletable,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.lastModifiedBy});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patientId'];
    doctorId = json['doctorId'];
    requestedBy = json['requestedBy'];
    isDefault = json['isDefault'];
    isReadable = json['isReadable'];
    isEditable = json['isEditable'];
    isDeletable = json['isDeletable'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    lastModifiedBy = json['lastModifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patientId'] = this.patientId;
    data['doctorId'] = this.doctorId;
    data['requestedBy'] = this.requestedBy;
    data['isDefault'] = this.isDefault;
    data['isReadable'] = this.isReadable;
    data['isEditable'] = this.isEditable;
    data['isDeletable'] = this.isDeletable;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    return data;
  }
}
