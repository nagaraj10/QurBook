class CaregiverCommunicationSetting {
  bool vitals;
  bool symptoms;
  bool appointments;

  CaregiverCommunicationSetting(
      {this.vitals, this.symptoms, this.appointments});

  CaregiverCommunicationSetting.fromJson(Map<String, dynamic> json) {
    vitals = json['vitals'];
    symptoms = json['symptoms'];
    appointments = json['appointments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vitals'] = this.vitals;
    data['symptoms'] = this.symptoms;
    data['appointments'] = this.appointments;
    return data;
  }
}