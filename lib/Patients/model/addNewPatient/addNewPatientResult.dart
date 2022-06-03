class AddNewPatientResult {
  String patientProviderMapping;
  String patientId;

  AddNewPatientResult({this.patientProviderMapping, this.patientId});

  AddNewPatientResult.fromJson(Map<String, dynamic> json) {
    patientProviderMapping = json['patientProviderMapping'];
    patientId = json['patientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientProviderMapping'] = this.patientProviderMapping;
    data['patientId'] = this.patientId;
    return data;
  }
}
