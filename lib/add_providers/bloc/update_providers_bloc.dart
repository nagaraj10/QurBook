import 'dart:async';

import 'package:myfhb/add_providers/models/update_providers_id.dart';
import 'package:myfhb/add_providers/services/update_providers_repository.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

class UpdateProvidersBloc implements BaseBloc {
  UpdateProvidersRepository updateProvidersRepository;
  String providerId;
  bool isPreferred;

  // 1
  // Doctors
  StreamController doctorsProvidersController;

  StreamSink<ApiResponse<UpdateProvidersId>> get doctorsSink =>
      doctorsProvidersController.sink;
  Stream<ApiResponse<UpdateProvidersId>> get doctorsStream =>
      doctorsProvidersController.stream;

  // 2
  // Hospitals
  StreamController hospitalsProvidersController;

  StreamSink<ApiResponse<UpdateProvidersId>> get hospitalsSink =>
      hospitalsProvidersController.sink;
  Stream<ApiResponse<UpdateProvidersId>> get hospitalsStream =>
      hospitalsProvidersController.stream;

  // 3
  // Labs
  StreamController labsProvidersController;

  StreamSink<ApiResponse<UpdateProvidersId>> get labsSink =>
      hospitalsProvidersController.sink;
  Stream<ApiResponse<UpdateProvidersId>> get labsStream =>
      hospitalsProvidersController.stream;

  UpdateProvidersBloc() {
    updateProvidersRepository = UpdateProvidersRepository();

    // 1
    // Doctors
    doctorsProvidersController =
        StreamController<ApiResponse<UpdateProvidersId>>();

    // 2
    // Hospitals
    hospitalsProvidersController =
        StreamController<ApiResponse<UpdateProvidersId>>();

    // 3
    // Labs
    labsProvidersController =
        StreamController<ApiResponse<UpdateProvidersId>>();
  }

  // 1
  // Doctors
//  updateDoctorsIdWithUserDetails() async {
//    doctorsSink.add(ApiResponse.loading(variable.strUpdatingDoctor));
//    try {
//      UpdateProvidersId updateProvidersId = await updateProvidersRepository
//          .updateDoctorsIdWithUserDetails(providerId, isPreferred);
//      doctorsSink.add(ApiResponse.completed(updateProvidersId));
//    } catch (e) {
//      doctorsSink.add(ApiResponse.error(e.toString()));
//    }
//  }

  // 2
  // Hospitals
//  updateHospitalsIdWithUserDetails() async {
//    hospitalsSink.add(ApiResponse.loading(variable.strUpdatingHospital));
//    try {
//      UpdateProvidersId updateProvidersId = await updateProvidersRepository
//          .updateHospitalsIdWithUserDetails(providerId, isPreferred);
//      hospitalsSink.add(ApiResponse.completed(updateProvidersId));
//    } catch (e) {
//      hospitalsSink.add(ApiResponse.error(e.toString()));
//    }
//  }

  // 3
  // Labs
//  updateLabsIdWithUserDetails() async {
//    labsSink.add(ApiResponse.loading(variable.strUpdatingLab));
//    try {
//      UpdateProvidersId updateProvidersId = await updateProvidersRepository
//          .updateLabsIdWithUserDetails(providerId, isPreferred);
//      labsSink.add(ApiResponse.completed(updateProvidersId));
//    } catch (e) {
//      labsSink.add(ApiResponse.error(e.toString()));
//    }
//  }

  // 1
  // Doctors
  Future<UpdateProvidersId> updateDoctorsIdWithUserDetails() async {
    doctorsSink.add(ApiResponse.loading(variable.strUpdatingDoctor));
    UpdateProvidersId updateProvidersId;
    try {
      updateProvidersId = await updateProvidersRepository
          .updateDoctorsIdWithUserDetailsNew(providerId, isPreferred);
//      doctorsSink.add(ApiResponse.completed(updateProvidersId));
    } catch (e) {
      doctorsSink.add(ApiResponse.error(e.toString()));
    }

    return updateProvidersId;
  }

  // 2
  // Hospitals
  Future<UpdateProvidersId> updateHospitalsIdWithUserDetails() async {
    hospitalsSink.add(ApiResponse.loading(variable.strUpdatingHospital));
    UpdateProvidersId updateProvidersId;
    try {
      updateProvidersId = await updateProvidersRepository
          .updateHospitalsIdWithUserDetails(providerId, isPreferred);
      hospitalsSink.add(ApiResponse.completed(updateProvidersId));
    } catch (e) {
      hospitalsSink.add(ApiResponse.error(e.toString()));
    }

    return updateProvidersId;
  }

  // 3
  // Labs
  Future<UpdateProvidersId> updateLabsIdWithUserDetails() async {
    labsSink.add(ApiResponse.loading(variable.strUpdatingLab));
    UpdateProvidersId updateProvidersId;
    try {
      updateProvidersId = await updateProvidersRepository
          .updateLabsIdWithUserDetails(providerId, isPreferred);
      labsSink.add(ApiResponse.completed(updateProvidersId));
    } catch (e) {
      labsSink.add(ApiResponse.error(e.toString()));
    }

    return updateProvidersId;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
