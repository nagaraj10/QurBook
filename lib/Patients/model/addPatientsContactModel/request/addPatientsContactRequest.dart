import 'package:myfhb/Patients/model/addPatientsContactModel/request/contacts.dart';

class AddPatientContactRequest {
  List<Contacts> contacts;
  String healthOrganizationId;
  String doctorId;

  AddPatientContactRequest(
      {this.contacts, this.healthOrganizationId, this.doctorId});

  AddPatientContactRequest.fromJson(Map<String, dynamic> json) {
    if (json['contacts'] != null) {
      contacts = new List<Contacts>();
      json['contacts'].forEach((v) {
        contacts.add(new Contacts.fromJson(v));
      });
    }
    healthOrganizationId = json['healthOrganizationId'];
    doctorId = json['doctorId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contacts != null) {
      data['contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }
    data['healthOrganizationId'] = this.healthOrganizationId;
    data['doctorId'] = this.doctorId;
    return data;
  }
}
