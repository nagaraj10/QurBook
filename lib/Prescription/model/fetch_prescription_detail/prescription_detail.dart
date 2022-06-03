class PrescriptionDetail {
  bool isSuccess;
  Result result;

  PrescriptionDetail({this.isSuccess, this.result});

  PrescriptionDetail.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String id;
  String prescriptionNo;
  String prescriptionDate;
  String notes;
  Null parentId;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  AdditionalInfo additionalInfo;
  List<PrescriptionMedicineCollection> prescriptionMedicineCollection;

  Result(
      {this.id,
      this.prescriptionNo,
      this.prescriptionDate,
      this.notes,
      this.parentId,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.additionalInfo,
      this.prescriptionMedicineCollection});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prescriptionNo = json['prescriptionNo'];
    prescriptionDate = json['prescriptionDate'];
    notes = json['notes'];
    parentId = json['parentId'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    if (json['prescriptionMedicineCollection'] != null) {
      prescriptionMedicineCollection =
          new List<PrescriptionMedicineCollection>();
      json['prescriptionMedicineCollection'].forEach((v) {
        prescriptionMedicineCollection
            .add(new PrescriptionMedicineCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prescriptionNo'] = this.prescriptionNo;
    data['prescriptionDate'] = this.prescriptionDate;
    data['notes'] = this.notes;
    data['parentId'] = this.parentId;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
    }
    if (this.prescriptionMedicineCollection != null) {
      data['prescriptionMedicineCollection'] =
          this.prescriptionMedicineCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdditionalInfo {
  dynamic height;
  dynamic weight;

  AdditionalInfo({this.height, this.weight});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['weight'] = this.weight;
    return data;
  }
}

class PrescriptionMedicineCollection {
  String id;
  String beforeOrAfterFood;
  int noOfDays;
  Schedule schedule;
  int quantity;
  String notes;
  bool isActive;
  String createdOn;
  Null lastModifiedOn;

  PrescriptionMedicineCollection(
      {this.id,
      this.beforeOrAfterFood,
      this.noOfDays,
      this.schedule,
      this.quantity,
      this.notes,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  PrescriptionMedicineCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    beforeOrAfterFood = json['beforeOrAfterFood'];
    noOfDays = json['noOfDays'];
    schedule = json['schedule'] != null
        ? new Schedule.fromJson(json['schedule'])
        : null;
    quantity = json['quantity'];
    notes = json['notes'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['beforeOrAfterFood'] = this.beforeOrAfterFood;
    data['noOfDays'] = this.noOfDays;
    if (this.schedule != null) {
      data['schedule'] = this.schedule.toJson();
    }
    data['quantity'] = this.quantity;
    data['notes'] = this.notes;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class Schedule {
  List<When> when;

  Schedule({this.when});

  Schedule.fromJson(Map<String, dynamic> json) {
    if (json['when'] != null) {
      when = new List<When>();
      json['when'].forEach((v) {
        when.add(new When.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.when != null) {
      data['when'] = this.when.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class When {
  dynamic value;

  When({this.value});

  When.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    return data;
  }
}
