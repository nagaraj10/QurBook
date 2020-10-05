import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class HealthRecord {
  HealthRecord({
    this.notes,
    this.voice,
    this.associatedRecords,
    this.bills,
    this.others,
    this.prescription,
  });

  String notes;
  String voice;
  List<dynamic> associatedRecords;
  List<String> bills;
  List<String> others;
  List<dynamic> prescription;

  HealthRecord.fromJson(Map<String, dynamic> json) {
    notes = json[parameters.strnotes];
    voice = json[parameters.strVoice];
    associatedRecords = json[parameters.strAssociatedRecords] == null
        ? null
        : List<dynamic>.from(
            json[parameters.strAssociatedRecords].map((x) => x));
    bills = json[parameters.strBills] == null
        ? null
        : List<String>.from(json[parameters.strBills].map((x) => x));
    others = json[parameters.strothers] == null
        ? null
        : List<String>.from(json[parameters.strothers].map((x) => x));
    prescription = json[parameters.strPrescription] == null
        ? null
        : List<dynamic>.from(json[parameters.strPrescription].map((x) => x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strnotes] = notes;
    data[parameters.strVoice] = voice;
    data[parameters.strAssociatedRecords] =
        List<dynamic>.from(associatedRecords.map((x) => x));
    data[parameters.strBills] = List<dynamic>.from(bills.map((x) => x));
    data[parameters.strothers] = List<dynamic>.from(others.map((x) => x));
    data[parameters.strPrescription] =
        List<dynamic>.from(prescription.map((x) => x));
    return data;
  }
}
