class AddProviderPlanResponse {
  bool isSuccess;
  List<AddProviderPlanResponseResult> result;

  AddProviderPlanResponse({this.isSuccess, this.result});

  AddProviderPlanResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<AddProviderPlanResponseResult>();
      json['result'].forEach((v) {
        result.add(new AddProviderPlanResponseResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddProviderPlanResponseResult {
  String providerType;
  CreatedBy createdBy;
  String createdOn;
  bool isDefault;
  bool isInvite;
  Null doctor;
  CreatedBy healthOrganization;
  CreatedBy patient;
  String startDate;
  String endDate;
  String lastModifiedOn;
  String id;
  bool isActive;

  AddProviderPlanResponseResult(
      {this.providerType,
        this.createdBy,
        this.createdOn,
        this.isDefault,
        this.isInvite,
        this.doctor,
        this.healthOrganization,
        this.patient,
        this.startDate,
        this.endDate,
        this.lastModifiedOn,
        this.id,
        this.isActive});

  AddProviderPlanResponseResult.fromJson(Map<String, dynamic> json) {
    providerType = json['providerType'];
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    createdOn = json['createdOn'];
    isDefault = json['isDefault'];
    isInvite = json['isInvite'];
    doctor = json['doctor'];
    healthOrganization = json['healthOrganization'] != null
        ? new CreatedBy.fromJson(json['healthOrganization'])
        : null;
    patient = json['patient'] != null
        ? new CreatedBy.fromJson(json['patient'])
        : null;
    startDate = json['startDate'];
    endDate = json['endDate'];
    lastModifiedOn = json['lastModifiedOn'];
    id = json['id'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerType'] = this.providerType;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy.toJson();
    }
    data['createdOn'] = this.createdOn;
    data['isDefault'] = this.isDefault;
    data['isInvite'] = this.isInvite;
    data['doctor'] = this.doctor;
    if (this.healthOrganization != null) {
      data['healthOrganization'] = this.healthOrganization.toJson();
    }
    if (this.patient != null) {
      data['patient'] = this.patient.toJson();
    }
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    return data;
  }
}

class CreatedBy {
  String id;

  CreatedBy({this.id});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}