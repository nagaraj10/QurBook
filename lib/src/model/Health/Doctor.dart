import '../../../constants/fhb_parameters.dart' as parameters;

class Doctor {
  int localDoctorId;
  String city;
  String description;
  String email;
  String id;
  bool isUserDefined;
  String name;
  String specialization;
  String state;

  Doctor(
      {this.localDoctorId,
      this.city,
      this.description,
      this.email,
      this.id,
      this.isUserDefined,
      this.name,
      this.specialization,
      this.state});

  Doctor.fromJson(Map<String, dynamic> json) {
    localDoctorId = json[parameters.strLocal_Doctor_Id] ?? 0;
    city = json[parameters.strCity];
    description = json[parameters.strDescription];
    email = json[parameters.strEmail] ?? '';
    id = json[parameters.strId];
    isUserDefined = json[parameters.strIsUserDefined] ?? false;
    name = json[parameters.strName];
    specialization = json[parameters.strSpecilization];
    state = json[parameters.strState];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strLocal_Doctor_Id] = localDoctorId;
    data[parameters.strCity] = city;
    data[parameters.strDescription] = description;
    data[parameters.strEmail] = email;
    data[parameters.strId] = id;
    data[parameters.strIsUserDefined] = isUserDefined;
    data[parameters.strName] = name;
    data[parameters.strSpecilization] = specialization;
    data[parameters.strState] = state;
    return data;
  }
}
