import 'dart:async';
import 'dart:typed_data';

import 'package:myfhb/record_detail/model/MetaDataMovedResponse.dart';
import 'package:myfhb/record_detail/model/UpdateMediaResponse.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/Health/DigitRecogResponse.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/PostImageResponse.dart';
import 'package:myfhb/src/model/Health/SavedMetaDataResponse.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';

import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';

class HealthReportListForUserBlock implements BaseBloc {
  HealthReportListForUserRepository _healthReportListForUserRepository;
  StreamController _categoryListControlller;
  StreamController _doctorsProfileImageControlller;
  StreamController _metaDataController;
  StreamController _imageDataController;

  StreamController _moveDataController;
  StreamController _metaDataUpdateController;
  StreamController _imageListController;

  StreamSink<ApiResponse<UserHealthResponseList>> get healthReportListSink =>
      _categoryListControlller.sink;
  Stream<ApiResponse<UserHealthResponseList>> get healthReportStream =>
      _categoryListControlller.stream;

  StreamSink<ApiResponse<Uint8List>> get profileImageSink =>
      _doctorsProfileImageControlller.sink;
  Stream<ApiResponse<Uint8List>> get profileImageStream =>
      _doctorsProfileImageControlller.stream;

  StreamSink<ApiResponse<SavedMetaDataResponse>> get metadataListSink =>
      _metaDataController.sink;
  Stream<ApiResponse<SavedMetaDataResponse>> get metaDataStream =>
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

  StreamSink<ApiResponse<List<dynamic>>> get imageListSink =>
      _imageListController.sink;
  Stream<ApiResponse<List<dynamic>>> get imageListStream =>
      _imageListController.stream;

  @override
  void dispose() {
    _categoryListControlller?.close();
    _doctorsProfileImageControlller?.close();
    _metaDataController?.close();
    _imageDataController?.close();

    _moveDataController?.close();
    _metaDataUpdateController?.close();
    _imageListController?.close();
  }

  HealthReportListForUserBlock() {
    _categoryListControlller =
        StreamController<ApiResponse<UserHealthResponseList>>();

    _healthReportListForUserRepository = HealthReportListForUserRepository();

    _metaDataController =
        StreamController<ApiResponse<SavedMetaDataResponse>>();
    _imageDataController = StreamController<ApiResponse<PostImageResponse>>();

    _moveDataController =
        StreamController<ApiResponse<MetaDataMovedResponse>>();

    _metaDataUpdateController =
        StreamController<ApiResponse<UpdateMediaResponse>>();

    _imageListController = StreamController<ApiResponse<List<dynamic>>>();
  }

  Future<UserHealthResponseList> getHelthReportList() async {
    UserHealthResponseList userHealthResponseList;
    healthReportListSink.add(ApiResponse.loading('Signing in user'));
    try {
      userHealthResponseList =
          await _healthReportListForUserRepository.getHealthReportList();
      healthReportListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      healthReportListSink.add(ApiResponse.error(e.toString()));
      
    }
    return userHealthResponseList;
  }

  Future<SavedMetaDataResponse> submit(String jsonData) async {
    SavedMetaDataResponse saveMetaDataResponse;
    metadataListSink.add(ApiResponse.loading('Signing in user'));
    try {
      saveMetaDataResponse =
          await _healthReportListForUserRepository.postMediaData(jsonData);
      metadataListSink.add(ApiResponse.completed(saveMetaDataResponse));
    } catch (e) {
      metadataListSink.add(ApiResponse.error(e.toString()));
    }
    return saveMetaDataResponse;
  }

  Future<dynamic> getProfilePic(String doctorsId) async {
    try {
      var userHealthResponseList =
          await _healthReportListForUserRepository.getDoctorProfile(doctorsId);
      return userHealthResponseList;
    } catch (e) {
    }
  }

  Future<dynamic> getDocumentImage(String metaMasterId) async {
    try {
      var userHealthResponseList = await _healthReportListForUserRepository
          .getDocumentImage(metaMasterId);
      return userHealthResponseList;
    } catch (e) {
    }
  }

  Future<PostImageResponse> saveImage(
      String fileName, String metaID, String jsonData) async {
    PostImageResponse postImageResponse;
    imageDataSink.add(ApiResponse.loading('Signing in user'));
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
    imageDataSink.add(ApiResponse.loading('Signing in user'));
    try {
      digitRecogResponse = await _healthReportListForUserRepository
          .postDevicesData(fileName, metaID, jsonData);
//      imageDataSink.add(ApiResponse.completed(postImageResponse));
    } catch (e) {
      imageDataSink.add(ApiResponse.error(e.toString()));
    }
    return digitRecogResponse;
  }

  Future<MetaDataMovedResponse> switchDataToOtherUser(
      String familyMemberID, String detailID) async {
    MetaDataMovedResponse metaDataMovedResponse;
    moveMetaDataSInk.add(ApiResponse.loading('Moving data to user'));
    try {
      metaDataMovedResponse = await _healthReportListForUserRepository
          .moveDataToOtherUser(familyMemberID, detailID);
      moveMetaDataSInk.add(ApiResponse.completed(metaDataMovedResponse));
    } catch (e) {
      metadataListSink.add(ApiResponse.error(e.toString()));
    }
    return metaDataMovedResponse;
  }

  Future<UpdateMediaResponse> updateMedia(
      String jsonData, String metaInfoId) async {
    UpdateMediaResponse updateMediaResponse;
    metaDataUpdateSink.add(ApiResponse.loading('Updating Data'));
    try {
      updateMediaResponse = await _healthReportListForUserRepository
          .updateMediaData(jsonData, metaInfoId);
      metaDataUpdateSink.add(ApiResponse.completed(updateMediaResponse));
    } catch (e) {
      metaDataUpdateSink.add(ApiResponse.error(e.toString()));
    }
    return updateMediaResponse;
  }

  Future<List<dynamic>> getDocumentImageList(
      List<MediaMasterIds> metaMasterIdList) async {
    List<dynamic> userHealthResponseList;
    imageListSink.add(ApiResponse.loading('Updating Data'));

    try {
      userHealthResponseList = await _healthReportListForUserRepository
          .getDocumentImageList(metaMasterIdList);

      imageListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e) {
      imageListSink.add(ApiResponse.error(e.toString()));

    }

    return userHealthResponseList;
  }
}
