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
        ? QualificationInfo.fromJson(json['qualificationInfo'])
        : null;
    medicalCouncilInfo = json['medicalCouncilInfo'] != null
        ? MedicalCouncilInfo.fromJson(json['medicalCouncilInfo'])
        : null;
    specialty = json['specialty'] != null
        ? MedicalCouncilInfo.fromJson(json['specialty'])
        : null;
    if (json['clinicName'] != null) {
      clinicName = List<ClinicName>();
      json['clinicName'].forEach((v) {
        clinicName.add(ClinicName.fromJson(v));
      });
    }
    aboutMe = json['aboutMe'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (qualificationInfo != null) {
      data['qualificationInfo'] = qualificationInfo.toJson();
    }
    if (medicalCouncilInfo != null) {
      data['medicalCouncilInfo'] = medicalCouncilInfo.toJson();
    }
    if (specialty != null) {
      data['specialty'] = specialty.toJson();
    }
    if (clinicName != null) {
      data['clinicName'] = clinicName.map((v) => v.toJson()).toList();
    }
    data['aboutMe'] = aboutMe;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    return data;
  }
}

class QualificationInfo {
  List<Degree> degree;
  List<Degree> university;

  QualificationInfo({this.degree, this.university});

  QualificationInfo.fromJson(Map<String, dynamic> json) {
    if (json['degree'] != null) {
      degree = <Degree>[];
      json['degree'].forEach((v) {
        degree.add(Degree.fromJson(v));
      });
    }
    if (json['university'] != null) {
      university = List<Degree>();
      json['university'].forEach((v) {
        university.add(Degree.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (degree != null) {
      data['degree'] = degree.map((v) => v.toJson()).toList();
    }
    if (university != null) {
      data['university'] = university.map((v) => v.toJson()).toList();
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
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
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
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['description'] = description;
    data['lastModifiedOn'] = lastModifiedOn;
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
    final data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}