import 'dart:async';
import 'dart:typed_data';

import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';

class HealthReportListForUserBlock implements BaseBloc {
  HealthReportListForUserRepository _healthReportListForUserRepository;
  StreamController _categoryListControlller;
  StreamController _doctorsProfileImageControlller;

  StreamSink<ApiResponse<UserHealthResponseList>> get healthReportListSink =>
      _categoryListControlller.sink;
  Stream<ApiResponse<UserHealthResponseList>> get healthReportStream =>
      _categoryListControlller.stream;

  StreamSink<ApiResponse<Uint8List>> get profileImageSink =>
      _doctorsProfileImageControlller.sink;
  Stream<ApiResponse<Uint8List>> get profileImageStream =>
      _doctorsProfileImageControlller.stream;

  @override
  void dispose() {
    _categoryListControlller?.close();
    _doctorsProfileImageControlller?.close();
  }

  HealthReportListForUserBlock() {
    _categoryListControlller =
        StreamController<ApiResponse<UserHealthResponseList>>();

    _healthReportListForUserRepository = HealthReportListForUserRepository();
  }

  getHelthReportList() async {
    healthReportListSink.add(ApiResponse.loading('Signing in user'));
    try {
      UserHealthResponseList userHealthResponseList =
          await _healthReportListForUserRepository.getHealthReportList();
      healthReportListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      healthReportListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  Future<dynamic> getProfilePic(String doctorsId) async {
    try {
      var userHealthResponseList =
          await _healthReportListForUserRepository.getDoctorProfile(doctorsId);
      return userHealthResponseList;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getDocumentImage(String metaMasterId) async {
    try {
      var userHealthResponseList = await _healthReportListForUserRepository
          .getDocumentImage(metaMasterId);
      return userHealthResponseList;
    } catch (e) {
      print(e);
    }
  }
}
