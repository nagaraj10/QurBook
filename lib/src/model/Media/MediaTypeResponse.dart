class MediaTypesResponse {
  int status;
  bool success;
  String message;
  Response response;

  MediaTypesResponse({this.status, this.success, this.message, this.response});

  MediaTypesResponse.fromJson(Map<String, dynamic> json) {
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
  List<MediaData> data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = new List<MediaData>();
      json['data'].forEach((v) {
        data.add(new MediaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MediaData {
  String id;
  String name;
  String description;
  String logo;
  String categoryId;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isDisplay;
  bool isCreate;
  bool isRead;
  bool isEdit;
  bool isDelete;
  bool isManualTranscription;
  bool isAITranscription;

  MediaData(
      {this.id,
      this.name,
      this.description,
      this.logo,
      this.categoryId,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.isDisplay,
      this.isCreate,
      this.isRead,
      this.isEdit,
      this.isDelete,
      this.isManualTranscription,
      this.isAITranscription});

  MediaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logo = json['logo'];
    categoryId = json['categoryId'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isDisplay = json['isDisplay'];
    isCreate = json['isCreate'];
    isRead = json['isRead'];
    isEdit = json['isEdit'];
    isDelete = json['isDelete'];
    isManualTranscription = json['isManualTranscription'];
    isAITranscription = json['isAITranscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['logo'] = this.logo;
    data['categoryId'] = this.categoryId;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isDisplay'] = this.isDisplay;
    data['isCreate'] = this.isCreate;
    data['isRead'] = this.isRead;
    data['isEdit'] = this.isEdit;
    data['isDelete'] = this.isDelete;
    data['isManualTranscription'] = this.isManualTranscription;
    data['isAITranscription'] = this.isAITranscription;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return id +
        name +
        description +
        logo +
        categoryId +
        isActive.toString() +
        createdOn +
        lastModifiedOn +
        isDisplay.toString() +
        isCreate.toString() +
        isRead.toString() +
        isEdit.toString() +
        isDelete.toString() +
        isManualTranscription.toString() +
        isAITranscription.toString();
  }
}
