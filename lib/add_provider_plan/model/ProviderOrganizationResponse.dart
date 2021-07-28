class ProviderOrganisationResponse {
  bool isSuccess;
  List<Result> result;

  ProviderOrganisationResponse({this.isSuccess, this.result});

  ProviderOrganisationResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
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

class Result {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  BusinessDetail businessDetail;
  String domainUrl;
  bool isDisabled;
  String communicationEmails;
  String emailDomain;
  List<Specialty> specialty;
  bool isHealthPlansActivated;
  bool isOptCaregiveService;
  HealthOrganizationType healthOrganizationType;
  bool isBookmarked;

  Result(
      {this.id,
        this.name,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.businessDetail,
        this.domainUrl,
        this.isDisabled,
        this.communicationEmails,
        this.emailDomain,
        this.specialty,
        this.isHealthPlansActivated,
        this.isOptCaregiveService,
        this.healthOrganizationType,this.isBookmarked});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    businessDetail = json['businessDetail'] != null
        ? new BusinessDetail.fromJson(json['businessDetail'])
        : null;
    domainUrl = json['domainUrl'];
    isDisabled = json['isDisabled'];
    communicationEmails = json['communicationEmails'];
    emailDomain = json['emailDomain'];
    if (json['specialty'] != null) {
      specialty = new List<Specialty>();
      json['specialty'].forEach((v) {
        specialty.add(new Specialty.fromJson(v));
      });
    }
    isHealthPlansActivated = json['isHealthPlansActivated'];
    isOptCaregiveService = json['isOptCaregiveService'];
    healthOrganizationType = json['healthOrganizationType'] != null
        ? new HealthOrganizationType.fromJson(json['healthOrganizationType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.businessDetail != null) {
      data['businessDetail'] = this.businessDetail.toJson();
    }
    data['domainUrl'] = this.domainUrl;
    data['isDisabled'] = this.isDisabled;
    data['communicationEmails'] = this.communicationEmails;
    data['emailDomain'] = this.emailDomain;
    if (this.specialty != null) {
      data['specialty'] = this.specialty.map((v) => v.toJson()).toList();
    }
    data['isHealthPlansActivated'] = this.isHealthPlansActivated;
    data['isOptCaregiveService'] = this.isOptCaregiveService;
    if (this.healthOrganizationType != null) {
      data['healthOrganizationType'] = this.healthOrganizationType.toJson();
    }
    return data;
  }
}

class BusinessDetail {
  List<String> documents;
  String gstNumber;

  BusinessDetail({this.documents, this.gstNumber});

  BusinessDetail.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      if (json.containsKey('documents')) {
        documents = json['documents'].cast<String>();
      }
    }


    gstNumber = json['gstNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.documents != null) {
      data['documents'] = this.documents;
    }
    data['gstNumber'] = this.gstNumber;
    return data;
  }
}

class Specialty {
  String id;
  String name;

  Specialty({this.id, this.name});

  Specialty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class HealthOrganizationType {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;

  HealthOrganizationType(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.sortOrder,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedOn});

  HealthOrganizationType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    sortOrder = json['sortOrder'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    data['sortOrder'] = this.sortOrder;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}