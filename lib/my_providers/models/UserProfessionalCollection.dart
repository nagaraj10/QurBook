class DoctorProfessionalDetailCollection {
  String id;
  QualificationInfo qualificationInfo;
  MedicalCouncilInfo medicalCouncilInfo;
  MedicalCouncilInfo specialty;
  List<ClinicName> clinicName;
  String aboutMe;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  DoctorProfessionalDetailCollection(
      {this.id,
        this.qualificationInfo,
        this.medicalCouncilInfo,
        this.specialty,
        this.clinicName,
        this.aboutMe,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  DoctorProfessionalDetailCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qualificationInfo = json['qualificationInfo'] != null
        ? new QualificationInfo.fromJson(json['qualificationInfo'])
        : null;
    medicalCouncilInfo = json['medicalCouncilInfo'] != null
        ? new MedicalCouncilInfo.fromJson(json['medicalCouncilInfo'])
        : null;
    specialty = json['specialty'] != null
        ? new MedicalCouncilInfo.fromJson(json['specialty'])
        : null;
    if (json['clinicName'] != null) {
      clinicName = new List<ClinicName>();
      json['clinicName'].forEach((v) {
        clinicName.add(new ClinicName.fromJson(v));
      });
    }
    aboutMe = json['aboutMe'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.qualificationInfo != null) {
      data['qualificationInfo'] = this.qualificationInfo.toJson();
    }
    if (this.medicalCouncilInfo != null) {
      data['medicalCouncilInfo'] = this.medicalCouncilInfo.toJson();
    }
    if (this.specialty != null) {
      data['specialty'] = this.specialty.toJson();
    }
    if (this.clinicName != null) {
      data['clinicName'] = this.clinicName.map((v) => v.toJson()).toList();
    }
    data['aboutMe'] = this.aboutMe;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class QualificationInfo {
  List<Degree> degree;
  List<Degree> university;

  QualificationInfo({this.degree, this.university});

  QualificationInfo.fromJson(Map<String, dynamic> json) {
    if (json['degree'] != null) {
      degree = new List<Degree>();
      json['degree'].forEach((v) {
        degree.add(new Degree.fromJson(v));
      });
    }
    if (json['university'] != null) {
      university = new List<Degree>();
      json['university'].forEach((v) {
        university.add(new Degree.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.degree != null) {
      data['degree'] = this.degree.map((v) => v.toJson()).toList();
    }
    if (this.university != null) {
      data['university'] = this.university.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Degree {
  String id;
  String name;
  bool isActive;

  Degree({this.id, this.name, this.isActive});

  Degree.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    return data;
  }
}

class MedicalCouncilInfo {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String description;
  String lastModifiedOn;

  MedicalCouncilInfo(
      {this.id,
        this.name,
        this.isActive,
        this.createdOn,
        this.description,
        this.lastModifiedOn});

  MedicalCouncilInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    description = json['description'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['description'] = this.description;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class ClinicName {
  String name;

  ClinicName({this.name});

  ClinicName.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}