import 'dart:async';
import 'dart:typed_data';

import 'package:myfhb/record_detail/model/DoctorImageResponse.dart';
import 'package:myfhb/record_detail/model/ImageDocumentResponse.dart';
import 'package:myfhb/record_detail/model/MetaDataMovedResponse.dart';
import 'package:myfhb/record_detail/model/UpdateMediaResponse.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/Health/DigitRecogResponse.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/PostImageResponse.dart';
import 'package:myfhb/src/model/Health/SavedMetaDataResponse.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_success.dart';

import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;

class HealthReportListForUserBlock implements BaseBloc {
  HealthReportListForUserRepository _healthReportListForUserRepository;
  StreamController _categoryListControlller;
  StreamController _healthListControlllers;

  StreamController _doctorsProfileImageControlller;
  StreamController _metaDataController;
  StreamController _imageDataController;

  StreamController _moveDataController;
  StreamController _metaDataUpdateController;
  StreamController _imageListController;

  StreamController _healthRecordController;

  StreamSink<ApiResponse<UserHealthResponseList>> get healthReportListSink =>
      _categoryListControlller.sink;
  Stream<ApiResponse<UserHealthResponseList>> get healthReportStream =>
      _categoryListControlller.stream;

  //modified for asgard
  StreamSink<ApiResponse<HealthRecordList>> get healthReportListSinks =>
      _healthListControlllers.sink;
  Stream<ApiResponse<HealthRecordList>> get healthReportStreams =>
      _healthListControlllers.stream;

  StreamSink<ApiResponse<Uint8List>> get profileImageSink =>
      _doctorsProfileImageControlller.sink;
  Stream<ApiResponse<Uint8List>> get profileImageStream =>
      _doctorsProfileImageControlller.stream;

  StreamSink<ApiResponse<HealthRecordSuccess>> get metadataListSink =>
      _metaDataController.sink;
  Stream<ApiResponse<HealthRecordSuccess>> get metaDataStream =>
      _metaDataController.stream;
  StreamSink<ApiResponse<PostImageResponse>> get imageDataSink =>
      _imageDataController.sink;
  Stream<ApiResponse<PostImageResponse>> get imageDataStream =>
      _imageDataController.stream;

  StreamSink<ApiResponse<MetaDataMovedResponse>> get moveMetaDataSInk =>
      _moveDataController.sink;
  Stream<ApiResponse<MetaDataMovedResponse>> get imoveMetaDataStream =>
      _moveDataController.stream;

  StreamSink<ApiResponse<UpdateMediaResponse>> get metaDataUpdateSink =>
      _metaDataUpdateController.sink;
  Stream<ApiResponse<UpdateMediaResponse>> get metaDataUpdateStream =>
      _metaDataUpdateController.stream;

  StreamSink<ApiResponse<List<ImageDocumentResponse>>> get imageListSink =>
      _imageListController.sink;
  Stream<ApiResponse<List<ImageDocumentResponse>>> get imageListStream =>
      _imageListController.stream;

  StreamSink<ApiResponse<HealthRecordSuccess>> get healthRecordSink =>
      _healthRecordController.sink;
  Stream<ApiResponse<HealthRecordSuccess>> get healthRecordStream =>
      _healthRecordController.stream;

  @override
  void dispose() {
    _categoryListControlller?.close();
    _healthListControlllers?.close();
    _doctorsProfileImageControlller?.close();
    _metaDataController?.close();
    _imageDataController?.close();

    _moveDataController?.close();
    _metaDataUpdateController?.close();
    _imageListController?.close();
    _healthRecordController?.close();
  }

  HealthReportListForUserBlock() {
    _categoryListControlller =
        StreamController<ApiResponse<UserHealthResponseList>>();
    _healthListControlllers = StreamController<ApiResponse<HealthRecordList>>();

    _healthReportListForUserRepository = HealthReportListForUserRepository();

    _metaDataController = StreamController<ApiResponse<HealthRecordSuccess>>();
    _imageDataController = StreamController<ApiResponse<PostImageResponse>>();

    _moveDataController =
        StreamController<ApiResponse<MetaDataMovedResponse>>();

    _metaDataUpdateController =
        StreamController<ApiResponse<UpdateMediaResponse>>();

    _imageListController =
        StreamController<ApiResponse<List<ImageDocumentResponse>>>();
    _healthRecordController =
        StreamController<ApiResponse<HealthRecordSuccess>>();
  }

  Future<UserHealthResponseList> getHelthReportList({bool condtion}) async {
    UserHealthResponseList userHealthResponseList;
    healthReportListSink
        .add(ApiResponse.loading(variable.strGettingHealthRecords));
    try {
      userHealthResponseList = await _healthReportListForUserRepository
          .getHealthReportList(condition: condtion ?? false);
      healthReportListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      healthReportListSink.add(ApiResponse.error(e.toString()));
    }
    return userHealthResponseList;
  }

  Future<SavedMetaDataResponse> submit(String jsonData) async {
    SavedMetaDataResponse saveMetaDataResponse;
    metadataListSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      saveMetaDataResponse =
          await _healthReportListForUserRepository.postMediaData(jsonData);
      // metadataListSink.add(ApiResponse.completed(saveMetaDataResponse));
    } catch (e) {
      metadataListSink.add(ApiResponse.error(e.toString()));
    }
    return saveMetaDataResponse;
  }

  Future<DoctorImageResponse> getProfilePic(String doctorsId) async {
    try {
      DoctorImageResponse userHealthResponseList =
          await _healthReportListForUserRepository.getDoctorProfile(doctorsId);
      return userHealthResponseList;
    } catch (e) {}
  }

  Future<ImageDocumentResponse> getDocumentImage(String metaMasterId) async {
    try {
      ImageDocumentResponse userHealthResponseList =
          await _healthReportListForUserRepository
              .getDocumentImage(metaMasterId);
      return userHealthResponseList;
    } catch (e) {}
  }

  Future<PostImageResponse> saveImage(
      String fileName, String metaID, String jsonData) async {
    PostImageResponse postImageResponse;
    imageDataSink.add(ApiResponse.loading(variable.strSavingImg));
    try {
      postImageResponse = await _healthReportListForUserRepository.postImage(
          fileName, metaID, jsonData);
      imageDataSink.add(ApiResponse.completed(postImageResponse));
    } catch (e) {
      imageDataSink.add(ApiResponse.error(e.toString()));
    }
    return postImageResponse;
  }

  Future<DigitRecogResponse> saveDeviceImage(
      String fileName, String metaID, String jsonData) async {
    DigitRecogResponse digitRecogResponse;
    imageDataSink.add(ApiResponse.loading(variable.strSavingImg));
    try {
      digitRecogResponse = await _healthReportListForUserRepository
          .postDevicesData(fileName, metaID, jsonData);
    } catch (e) {
      imageDataSink.add(ApiResponse.error(e.toString()));
    }
    return digitRecogResponse;
  }

  Future<MetaDataMovedResponse> switchDataToOtherUser(
      String familyMemberID, String metaId) async {
    MetaDataMovedResponse metaDataMovedResponse;
    moveMetaDataSInk.add(ApiResponse.loading(variable.strMoveData));
    try {
      metaDataMovedResponse = await _healthReportListForUserRepository
          .moveDataToOtherUser(familyMemberID, metaId);
      moveMetaDataSInk.add(ApiResponse.completed(metaDataMovedResponse));
    } catch (e) {
      metadataListSink.add(ApiResponse.error(e.toString()));
    }
    return metaDataMovedResponse;
  }

  Future<UpdateMediaResponse> updateMedia(
      String jsonData, String metaInfoId) async {
    UpdateMediaResponse updateMediaResponse;
    metaDataUpdateSink.add(ApiResponse.loading(variable.strUpdateData));
    try {
      updateMediaResponse = await _healthReportListForUserRepository
          .updateMediaData(jsonData, metaInfoId);
      metaDataUpdateSink.add(ApiResponse.completed(updateMediaResponse));
    } catch (e) {
      metaDataUpdateSink.add(ApiResponse.error(e.toString()));
    }
    return updateMediaResponse;
  }

  /*Future<List<dynamic>> getDocumentImageListOld(
      List<MediaMasterIds> metaMasterIdList) async {
    List<dynamic> userHealthResponseList;
    imageListSink.add(ApiResponse.loading(variable.strUpdateData));

    try {
      userHealthResponseList = await _healthReportListForUserRepository
          .getDocumentImageList(metaMasterIdList);

      imageListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      imageListSink.add(ApiResponse.error(e.toString()));
    }

    return userHealthResponseList;
  }*/

  Future<List<ImageDocumentResponse>> getDocumentImageList(
      List<MediaMasterIds> metaMasterIdList) async {
    List<ImageDocumentResponse> userHealthResponseList;
    imageListSink.add(ApiResponse.loading(variable.strUpdateData));

    try {
      userHealthResponseList = await _healthReportListForUserRepository
          .getDocumentImageList(metaMasterIdList);

      imageListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      imageListSink.add(ApiResponse.error(e.toString()));
    }

    return userHealthResponseList;
  }

  Future<HealthRecordList> getHelthReportLists() async {
    HealthRecordList userHealthResponseList;
    healthReportListSinks
        .add(ApiResponse.loading(variable.strGettingHealthRecords));
    try {
      userHealthResponseList =
          await _healthReportListForUserRepository.getHealthReportLists();
      healthReportListSinks.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      healthReportListSink.add(ApiResponse.error(e.toString()));
    }
    return userHealthResponseList;
  }

  Future<HealthRecordSuccess> createHealtRecords(
      String jsonData, List<String> imagePaths, String audioPath) async {
    HealthRecordSuccess healthRecordSuccess;
    healthRecordSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      healthRecordSuccess = await _healthReportListForUserRepository
          .createMediaData(jsonData, imagePaths, audioPath);
      // healthRecordSink.add(ApiResponse.completed(healthRecordSuccess));
    } catch (e) {
      healthRecordSink.add(ApiResponse.error(e.toString()));
    }
    return healthRecordSuccess;
  }

  Future<HealthRecordSuccess> updateHealthRecords(String jsonData,
      List<String> imagePaths, String audioPath, String metaId) async {
    HealthRecordSuccess healthRecordSuccess;
    healthRecordSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      healthRecordSuccess = await _healthReportListForUserRepository
          .updateHealthRecords(jsonData, imagePaths, audioPath, metaId);
      // healthRecordSink.add(ApiResponse.completed(healthRecordSuccess));
    } catch (e) {
      healthRecordSink.add(ApiResponse.error(e.toString()));
    }
    return healthRecordSuccess;
  }

  Future<HealthRecordSuccess> updateFiles(
      String audioPath, HealthResult healthResult) async {
    HealthRecordSuccess healthRecordSuccess;
    healthRecordSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      healthRecordSuccess = await _healthReportListForUserRepository
          .updateFileInRecords(audioPath, healthResult);
      // healthRecordSink.add(ApiResponse.completed(healthRecordSuccess));
    } catch (e) {
      healthRecordSink.add(ApiResponse.error(e.toString()));
    }
    return healthRecordSuccess;
  }
}
