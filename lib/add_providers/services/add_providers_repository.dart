import '../models/add_doctors_providers_id.dart';
import '../models/add_hospitals_providers_id.dart';
import '../models/add_labs_providers_id.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import '../../constants/variable_constant.dart' as variable;

class AddProvidersRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  // 1
  // Doctors
  Future<AddDoctorsProvidersId> addDoctors(String jsonString) async {
    var response = await _helper.addProviders(variable.strCallDoctors, jsonString);
    return AddDoctorsProvidersId.fromJson(response);
  }

  // 2
  // Hospitals
  Future<AddHospitalsProvidersId> addHospitals(String jsonString) async {
    var response = await _helper.addProviders(variable.strCallHospital,jsonString);
    return AddHospitalsProvidersId.fromJson(response);
  }

  // 3
  // Labs
  Future<AddLabsProvidersId> addLabs(String jsonString) async {
    var response = await _helper.addProviders(variable.strCallLab,jsonString);
    return AddLabsProvidersId.fromJson(response);
  }
}

//https://healthbook.vsolgmi.com/hb/api/v3/hospitals/
