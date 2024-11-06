import 'dart:async';

import 'package:myfhb/common/CommonUtil.dart';

import '../models/add_doctors_providers_id.dart';
import '../models/add_hospitals_providers_id.dart';
import '../models/add_labs_providers_id.dart';
import '../services/add_providers_repository.dart';
import '../../src/blocs/Authentication/LoginBloc.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../constants/variable_constant.dart' as variable;

class AddProvidersBloc implements BaseBloc {
  late AddProvidersRepository addProvidersRepository;

  // 1
  // Doctors
  late StreamController doctorsProvidersController;

  StreamSink<ApiResponse<AddDoctorsProvidersId>> get doctorsSink =>
      doctorsProvidersController.sink
          as StreamSink<ApiResponse<AddDoctorsProvidersId>>;

  Stream<ApiResponse<AddDoctorsProvidersId>> get doctorsStream =>
      doctorsProvidersController.stream
          as Stream<ApiResponse<AddDoctorsProvidersId>>;

  late String doctorsJsonString;

  // 2
  // Hospitals
  late StreamController hospitalsProvidersController;

  StreamSink<ApiResponse<AddHospitalsProvidersId>> get hospitalsSink =>
      hospitalsProvidersController.sink
          as StreamSink<ApiResponse<AddHospitalsProvidersId>>;

  Stream<ApiResponse<AddHospitalsProvidersId>> get hospitalsStream =>
      hospitalsProvidersController.stream
          as Stream<ApiResponse<AddHospitalsProvidersId>>;

  late String hospitalsJsonString;

  // 3
  // Labs
  late StreamController labsProvidersController;

  StreamSink<ApiResponse<AddLabsProvidersId>> get labsSink =>
      labsProvidersController.sink
          as StreamSink<ApiResponse<AddLabsProvidersId>>;

  Stream<ApiResponse<AddLabsProvidersId>> get labsStream =>
      labsProvidersController.stream as Stream<ApiResponse<AddLabsProvidersId>>;

  late String labsJsonString;

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
    doctorsSink.add(ApiResponse.loading(variable.strAddingDoctors));
    try {
      final addDoctorsProvidersId =
          await addProvidersRepository.addDoctors(doctorsJsonString);
      doctorsSink.add(ApiResponse.completed(addDoctorsProvidersId));
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      doctorsSink.add(ApiResponse.error(e.toString()));
    }
  }

  // 2
  // Hospitals
  addHospitals() async {
    hospitalsSink.add(ApiResponse.loading(variable.strAddingHospital));
    try {
      var addHospitalsProvidersId =
          await addProvidersRepository.addHospitals(hospitalsJsonString);
      hospitalsSink.add(ApiResponse.completed(addHospitalsProvidersId));
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      hospitalsSink.add(ApiResponse.error(e.toString()));
    }
  }

  // 3
  // Labs
  addLabs() async {
    labsSink.add(ApiResponse.loading(variable.strAddingLab));
    try {
      var addLabProvidersId =
          await addProvidersRepository.addLabs(labsJsonString);
      labsSink.add(ApiResponse.completed(addLabProvidersId));
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      labsSink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
