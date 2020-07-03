import 'dart:async';

import 'package:myfhb/add_providers/models/add_doctors_providers_id.dart';
import 'package:myfhb/add_providers/models/add_hospitals_providers_id.dart';
import 'package:myfhb/add_providers/models/add_labs_providers_id.dart';
import 'package:myfhb/add_providers/services/add_providers_repository.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

class AddProvidersBloc implements BaseBloc {
  AddProvidersRepository addProvidersRepository;

  // 1
  // Doctors
  StreamController doctorsProvidersController;

  StreamSink<ApiResponse<AddDoctorsProvidersId>> get doctorsSink =>
      doctorsProvidersController.sink;

  Stream<ApiResponse<AddDoctorsProvidersId>> get doctorsStream =>
      doctorsProvidersController.stream;

  String doctorsJsonString;

  // 2
  // Hospitals
  StreamController hospitalsProvidersController;

  StreamSink<ApiResponse<AddHospitalsProvidersId>> get hospitalsSink =>
      hospitalsProvidersController.sink;

  Stream<ApiResponse<AddHospitalsProvidersId>> get hospitalsStream =>
      hospitalsProvidersController.stream;

  String hospitalsJsonString;

  // 3
  // Labs
  StreamController labsProvidersController;

  StreamSink<ApiResponse<AddLabsProvidersId>> get labsSink =>
      labsProvidersController.sink;

  Stream<ApiResponse<AddLabsProvidersId>> get labsStream =>
      labsProvidersController.stream;

  String labsJsonString;

  AddProvidersBloc() {
    addProvidersRepository = AddProvidersRepository();

    doctorsProvidersController =
        StreamController<ApiResponse<AddDoctorsProvidersId>>();
    hospitalsProvidersController =
        StreamController<ApiResponse<AddHospitalsProvidersId>>();
    labsProvidersController =
        StreamController<ApiResponse<AddLabsProvidersId>>();
  }

  // 1
  // Doctors
  addDoctors() async {
    doctorsSink.add(ApiResponse.loading('Signing in user'));
    try {
      AddDoctorsProvidersId addDoctorsProvidersId =
          await addProvidersRepository.addDoctors(doctorsJsonString);
      doctorsSink.add(ApiResponse.completed(addDoctorsProvidersId));
    } catch (e) {
      doctorsSink.add(ApiResponse.error(e.toString()));
    }
  }

  // 2
  // Hospitals
  addHospitals() async {
    hospitalsSink.add(ApiResponse.loading('Signing in user'));
    try {
      AddHospitalsProvidersId addHospitalsProvidersId =
          await addProvidersRepository.addHospitals(hospitalsJsonString);
      hospitalsSink.add(ApiResponse.completed(addHospitalsProvidersId));
    } catch (e) {
      hospitalsSink.add(ApiResponse.error(e.toString()));
    }
  }

  // 3
  // Labs
  addLabs() async {
    labsSink.add(ApiResponse.loading('Signing in user'));
    try {
      AddLabsProvidersId addLabProvidersId =
          await addProvidersRepository.addLabs(labsJsonString);
      labsSink.add(ApiResponse.completed(addLabProvidersId));
    } catch (e) {
      labsSink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
