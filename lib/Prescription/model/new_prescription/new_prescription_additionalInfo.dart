import 'package:myfhb/Prescription/constants/prescription_parameters.dart'
    as parameters;

class NewPrescriptionAdditionalInfo {
  String height;
  String weight;
  String doctorId;
  String patientId;
  String sendNotificationTo;

  NewPrescriptionAdditionalInfo(
      {this.height,
      this.weight,
      this.doctorId,
      this.patientId,
      this.sendNotificationTo});

  NewPrescriptionAdditionalInfo.fromJson(Map<String, dynamic> json) {
    height = json['height'] != null ? json['height'] : null;
    weight = json['weight'] != null ? json['weight'] : null;
    doctorId = json['doctorId'] != null ? json['doctorId'] : null;
    patientId = json['patientId'] != null ? json['patientId'] : null;
    sendNotificationTo =
        json['sendNotificationTo'] != null ? json['sendNotificationTo'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.height != null) {
      data['height'] = this.height;
    }
    if (this.weight != null) {
      data['weight'] = this.weight;
    }
    if (this.doctorId != null) {
      data['doctorId'] = this.doctorId;
    }
    if (this.patientId != null) {
      data['patientId'] = this.patientId;
    }
    if (this.sendNotificationTo != null) {
      data['sendNotificationTo'] = this.sendNotificationTo;
    }

    return data;
  }
}
