import 'dart:async';

import 'package:myfhb/common/CommonUtil.dart';

import '../models/update_providers_id.dart';
import '../services/update_providers_repository.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../src/blocs/Authentication/LoginBloc.dart';
import '../../src/resources/network/ApiResponse.dart';

class UpdateProvidersBloc implements BaseBloc {
  late UpdateProvidersRepository updateProvidersRepository;
  String? providerId;
  String? providerReferenceId;
  bool? isPreferred;

  String? userId;
  List<String?>? selectedCategories = [];

  // 1
  // Doctors
  late StreamController doctorsProvidersController;

  StreamSink<ApiResponse<UpdateProvidersId>> get doctorsSink =>
      doctorsProvidersController.sink
          as StreamSink<ApiResponse<UpdateProvidersId>>;
  Stream<ApiResponse<UpdateProvidersId>> get doctorsStream =>
      doctorsProvidersController.stream
          as Stream<ApiResponse<UpdateProvidersId>>;

  // 2
  // Hospitals
  late StreamController hospitalsProvidersController;

  StreamSink<ApiResponse<UpdateProvidersId>> get hospitalsSink =>
      hospitalsProvidersController.sink
          as StreamSink<ApiResponse<UpdateProvidersId>>;
  Stream<ApiResponse<UpdateProvidersId>> get hospitalsStream =>
      hospitalsProvidersController.stream
          as Stream<ApiResponse<UpdateProvidersId>>;

  // 3
  // Labs
  StreamController? labsProvidersController;

  StreamSink<ApiResponse<UpdateProvidersId>> get labsSink =>
      hospitalsProvidersController.sink
          as StreamSink<ApiResponse<UpdateProvidersId>>;
  Stream<ApiResponse<UpdateProvidersId>> get labsStream =>
      hospitalsProvidersController.stream
          as Stream<ApiResponse<UpdateProvidersId>>;

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
//    } catch (e,stackTrace) {
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
//    } catch (e,stackTrace) {
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
//    } catch (e,stackTrace) {
//      labsSink.add(ApiResponse.error(e.toString()));
//    }
//  }

  // 1
  // Doctors
  Future<UpdateProvidersId?> updateDoctorsIdWithUserDetails(
      {bool? isPAR}) async {
    doctorsSink.add(ApiResponse.loading(variable.strUpdatingDoctor));
    UpdateProvidersId? updateProvidersId;
    try {
      updateProvidersId =
          await updateProvidersRepository.updateDoctorsIdWithUserDetailsNew(
              providerId,
              isPreferred,
              providerReferenceId,
              userId!,
              selectedCategories,
              isPAR: isPAR);
//      doctorsSink.add(ApiResponse.completed(updateProvidersId));
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      doctorsSink.add(ApiResponse.error(e.toString()));
    }

    return updateProvidersId;
  }

  // 2
  // Hospitals
  Future<UpdateProvidersId?> updateHospitalsIdWithUserDetails() async {
    hospitalsSink.add(ApiResponse.loading(variable.strUpdatingHospital));
    UpdateProvidersId? updateProvidersId;
    try {
      updateProvidersId =
          await updateProvidersRepository.updateHospitalsIdWithUserDetails(
              providerId,
              isPreferred,
              providerReferenceId,
              userId!,
              selectedCategories);
      hospitalsSink.add(ApiResponse.completed(updateProvidersId));
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      hospitalsSink.add(ApiResponse.error(e.toString()));
    }

    return updateProvidersId;
  }

  // 3
  // Labs
  Future<UpdateProvidersId?> updateLabsIdWithUserDetails() async {
    labsSink.add(ApiResponse.loading(variable.strUpdatingLab));
    UpdateProvidersId? updateProvidersId;
    try {
      updateProvidersId =
          await updateProvidersRepository.updateLabsIdWithUserDetails(
              providerId,
              isPreferred,
              providerReferenceId,
              userId!,
              selectedCategories);
      labsSink.add(ApiResponse.completed(updateProvidersId));
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      labsSink.add(ApiResponse.error(e.toString()));
    }

    return updateProvidersId;
  }

  //providerMapping after subscribe
  Future<UpdateProvidersId?> mappingHealthOrg(
      String? providerId, String userId) async {
    UpdateProvidersId? updateProvidersId;
    try {
      updateProvidersId = await updateProvidersRepository
          .updateHospitalsIdWithUserDetails(providerId, false, '', userId, []);
//      doctorsSink.add(ApiResponse.completed(updateProvidersId));
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      doctorsSink.add(ApiResponse.error(e.toString()));
    }

    return updateProvidersId;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
