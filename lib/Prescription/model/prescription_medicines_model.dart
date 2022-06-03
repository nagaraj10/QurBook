import 'package:myfhb/Prescription/constants/prescription_parameters.dart'
    as parameters;

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
        medicineName: json[parameters.strapMedicineName],
        beforeOrAfterFood: json[parameters.strapBeforeOrAfterFood],
        days: json[parameters.strapNoOfDays],
        notes: json[parameters.strapNotes],
        schedule: PrescriptionMedicineSchedule.fromJson(
            json[parameters.strapSchedule]),
        quantity: json[parameters.strapQuantity]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strapMedicineName] = this.medicineName;
    data[parameters.strapNotes] = this.notes;
    data[parameters.strapBeforeOrAfterFood] = this.beforeOrAfterFood;
    data[parameters.strapNoOfDays] = this.days;
    data[parameters.strapSchedule] = this.schedule;
    data[parameters.strapQuantity] = this.quantity;
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
        morning: json[parameters.strapScheduleMorning],
        afternoon: json[parameters.strapScheduleAfternoon],
        evening: json[parameters.strapScheduleEvening]);
  }
}

class PrescriptionMedicinesList {
  List<PrescriptionMedicines> medicines;

  PrescriptionMedicinesList.fromJson(Map<String, dynamic> json) {
    if (json[parameters.strapData] != null) {
      medicines = new List<PrescriptionMedicines>();
      json[parameters.strapData].forEach((v) {
        medicines.add(new PrescriptionMedicines.fromJson(v));
      });
    }
  }
}
