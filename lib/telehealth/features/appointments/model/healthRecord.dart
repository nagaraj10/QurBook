import 'notesModel.dart';

class HealthRecord {
  HealthRecord({
    this.prescription,
    this.notes,
    this.voice,
    this.others,
  });

  List<Notes> prescription;
  Notes notes;
  Notes voice;
  List<String> others;

  HealthRecord.fromJson(Map<String, dynamic> json) {
    prescription = List<Notes>.from(
        json["prescription"].map((x) => Notes.fromJson(x)));
    notes = Notes.fromJson(json["notes"]);
    voice = Notes.fromJson(json["voice"]);
    others = List<String>.from(json["others"].map((x) => x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["prescription"] =
    List<dynamic>.from(prescription.map((x) => x.toJson()));
    data["notes"] = notes.toJson();
    data["voice"] = voice.toJson();
    data["others"] = List<dynamic>.from(others.map((x) => x));
    return data;
  }
}