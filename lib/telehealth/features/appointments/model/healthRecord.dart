import 'notesModel.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

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
    prescription = json[parameters.strPrescription] == null
        ? null
        : List<Notes>.from(
            json[parameters.strPrescription].map((x) => Notes.fromJson(x)));
    notes = json[parameters.strnotes] == null
        ? null
        : Notes.fromJson(json[parameters.strnotes]);
    voice = json[parameters.strVoice] == null
        ? null
        : Notes.fromJson(json[parameters.strVoice]);
    rx = json[parameters.strrx] == null ? null : json[parameters.strrx];
    others = json[parameters.strothers] == null
        ? null
        : List<String>.from(json[parameters.strothers].map((x) => x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strPrescription] =
        List<dynamic>.from(prescription.map((x) => x.toJson()));
    data[parameters.strnotes] = notes.toJson();
    data[parameters.strVoice] = voice.toJson();
    data[parameters.strrx] = List<dynamic>.from(rx.map((x) => x));
    data[parameters.strothers] =
        others == null ? null : List<dynamic>.from(others.map((x) => x));

    return data;
  }
}
