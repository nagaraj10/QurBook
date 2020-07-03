import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

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
    localDoctorId = json[parameters.strLocal_Doctor_Id]==null?0:json[parameters.strLocal_Doctor_Id];
    city = json[parameters.strCity];
    description = json[parameters.strDescription];
    email = json[parameters.strEmail]==null?'':json[parameters.strEmail];
    id = json[parameters.strId];
    isUserDefined = json[parameters.strIsUserDefined];
    name = json[parameters.strName];
    specialization = json[parameters.strSpecilization];
    state = json[parameters.strState];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strLocal_Doctor_Id] = this.localDoctorId;
    data[parameters.strCity] = this.city;
    data[parameters.strDescription] = this.description;
    data[parameters.strEmail] = this.email;
    data[parameters.strId] = this.id;
    data[parameters.strIsUserDefined] = this.isUserDefined;
    data[parameters.strName] = this.name;
    data[parameters.strSpecilization] = this.specialization;
    data[parameters.strState] = this.state;
    return data;
  }
}
