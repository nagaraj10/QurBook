import 'notesModel.dart';

class HealthRecord {
  HealthRecord({
    this.prescription,
    this.notes,
    this.voice,
    this.rx,
  });

  dynamic rx;
  List<Notes> prescription;
  Notes notes;
  Notes voice;
  List<String> others;

  HealthRecord.fromJson(Map<String, dynamic> json) {
    prescription = json["prescription"] == null
        ? null
        : List<Notes>.from(json["prescription"].map((x) => Notes.fromJson(x)));
    notes = json["notes"] == null ? null : Notes.fromJson(json["notes"]);
    voice = json["voice"] == null ? null : Notes.fromJson(json["voice"]);
    rx = json["rx"] == null ? null : json["rx"];
    others=
    json["others"] == null ? null : List<String>.from(
        json["others"].map((x) => x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["prescription"] =
    List<dynamic>.from(prescription.map((x) => x.toJson()));
    data["notes"] = notes.toJson();
    data["voice"] = voice.toJson();
    data["rx"] = List<dynamic>.from(rx.map((x) => x));
    data['others']=others == null ? null : List<dynamic>.from(others.map((x) => x));

    return data;
  }
}
