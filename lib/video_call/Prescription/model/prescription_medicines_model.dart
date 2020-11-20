class PrescriptionMedicines {
  String medicineName;
  String beforeOrAfterFood;
  String days;
  PrescriptionMedicineSchedule schedule;
  String quantity;
  String notes;

  PrescriptionMedicines(
      {this.medicineName,
      this.beforeOrAfterFood,
      this.days,
      this.schedule,
      this.quantity,
      this.notes});

  factory PrescriptionMedicines.fromJson(Map<String, dynamic> json) {
    return PrescriptionMedicines(
        medicineName: json['medicineName'],
        beforeOrAfterFood: json['beforeOrAfterFood'],
        days: json['days'],
        notes: json['notes'],
        schedule: PrescriptionMedicineSchedule.fromJson(json['schedule']),
        quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicineName'] = this.medicineName;
    data['notes'] = this.notes;
    data['beforeOrAfterFood'] = this.beforeOrAfterFood;
    data['days'] = this.days;
    data['schedule'] = this.schedule;
    data['quantity'] = this.quantity;
    return data;
  }
}

class PrescriptionMedicineSchedule {
  String morning;
  String afternoon;
  String evening;

  PrescriptionMedicineSchedule({this.morning, this.afternoon, this.evening});

  factory PrescriptionMedicineSchedule.fromJson(Map<String, dynamic> json) {
    return PrescriptionMedicineSchedule(
        morning: json['morning'],
        afternoon: json['afternoon'],
        evening: json['evening']);
  }
}

class PrescriptionMedicinesList {
  List<PrescriptionMedicines> medicines;

  PrescriptionMedicinesList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      medicines = new List<PrescriptionMedicines>();
      json['data'].forEach((v) {
        medicines.add(new PrescriptionMedicines.fromJson(v));
      });
    }
  }
}
