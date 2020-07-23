import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/Consulting.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/Followup.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Fees {
  String doctorId;
  Consulting consulting;
  Followup followup;
  Consulting cancellation;

  Fees({this.doctorId, this.consulting, this.followup, this.cancellation});

  Fees.fromJson(Map<String, dynamic> json) {
    doctorId = json[parameters.strDoctorId];
    consulting = json[parameters.strconsulting] != null
        ? new Consulting.fromJson(json[parameters.strconsulting])
        : null;
    followup = json[parameters.strfollowup] != null
        ? new Followup.fromJson(json[parameters.strfollowup])
        : null;
    cancellation = json[parameters.strcancellation] != null
        ? new Consulting.fromJson(json[parameters.strcancellation])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strDoctorId] = this.doctorId;
    if (this.consulting != null) {
      data[parameters.strconsulting] = this.consulting.toJson();
    }
    if (this.followup != null) {
      data[parameters.strfollowup] = this.followup.toJson();
    }
    if (this.cancellation != null) {
      data[parameters.strcancellation] = this.cancellation.toJson();
    }
    return data;
  }
}