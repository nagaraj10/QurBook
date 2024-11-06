
import 'dart:async';
import 'dart:typed_data';

import 'package:myfhb/claim/model/claimmodel/ClaimSuccess.dart';
import 'package:myfhb/common/CommonUtil.dart';

import '../../../record_detail/model/DoctorImageResponse.dart';
import '../../../record_detail/model/ImageDocumentResponse.dart';
import '../../../record_detail/model/MetaDataMovedResponse.dart';
import '../../../record_detail/model/UpdateMediaResponse.dart';
import '../Authentication/LoginBloc.dart';
import '../../model/Health/DigitRecogResponse.dart';
import '../../model/Health/MediaMasterIds.dart';
import '../../model/Health/PostImageResponse.dart';
import '../../model/Health/SavedMetaDataResponse.dart';
import '../../model/Health/MediaMetaInfo.dart';
import '../../model/Health/UserHealthResponseList.dart';
import '../../model/Health/asgard/health_record_list.dart';
import '../../model/Health/asgard/health_record_success.dart';

import '../../resources/network/ApiResponse.dart';
import '../../resources/repository/health/HealthReportListForUserRepository.dart';

import '../../../constants/variable_constant.dart' as variable;

class HealthReportListForUserBlock implements BaseBloc {
  late HealthReportListForUserRepository _healthReportListForUserRepository;
  StreamController? _categoryListControlller;
  StreamController? _healthListControlllers;

  StreamController? _doctorsProfileImageControlller;
  StreamController? _metaDataController;
  StreamController? _imageDataController;

  StreamController? _moveDataController;
  StreamController? _metaDataUpdateController;
  StreamController? _imageListController;

  StreamController? _healthRecordController;
  StreamController? _claimController;

  StreamSink<ApiResponse<UserHealthResponseList>> get healthReportListSink =>
      _categoryListControlller!.sink as StreamSink<ApiResponse<UserHealthResponseList>>;
  Stream<ApiResponse<UserHealthResponseList>> get healthReportStream =>
      _categoryListControlller!.stream as Stream<ApiResponse<UserHealthResponseList>>;

  //modified for asgard
  StreamSink<ApiResponse<HealthRecordList>> get healthReportListSinks =>
      _healthListControlllers!.sink as StreamSink<ApiResponse<HealthRecordList>>;
  Stream<ApiResponse<HealthRecordList>> get healthReportStreams =>
      _healthListControlllers!.stream as Stream<ApiResponse<HealthRecordList>>;

  StreamSink<ApiResponse<Uint8List>> get profileImageSink =>
      _doctorsProfileImageControlller!.sink as StreamSink<ApiResponse<Uint8List>>;
  Stream<ApiResponse<Uint8List>> get profileImageStream =>
      _doctorsProfileImageControlller!.stream as Stream<ApiResponse<Uint8List>>;

  StreamSink<ApiResponse<HealthRecordSuccess>> get metadataListSink =>
      _metaDataController!.sink as StreamSink<ApiResponse<HealthRecordSuccess>>;
  Stream<ApiResponse<HealthRecordSuccess>> get metaDataStream =>
      _metaDataController!.stream as Stream<ApiResponse<HealthRecordSuccess>>;
  StreamSink<ApiResponse<PostImageResponse>> get imageDataSink =>
      _imageDataController!.sink as StreamSink<ApiResponse<PostImageResponse>>;
  Stream<ApiResponse<PostImageResponse>> get imageDataStream =>
      _imageDataController!.stream as Stream<ApiResponse<PostImageResponse>>;

  StreamSink<ApiResponse<MetaDataMovedResponse>> get moveMetaDataSInk =>
      _moveDataController!.sink as StreamSink<ApiResponse<MetaDataMovedResponse>>;
  Stream<ApiResponse<MetaDataMovedResponse>> get imoveMetaDataStream =>
      _moveDataController!.stream as Stream<ApiResponse<MetaDataMovedResponse>>;

  StreamSink<ApiResponse<UpdateMediaResponse>> get metaDataUpdateSink =>
      _metaDataUpdateController!.sink as StreamSink<ApiResponse<UpdateMediaResponse>>;
  Stream<ApiResponse<UpdateMediaResponse>> get metaDataUpdateStream =>
      _metaDataUpdateController!.stream as Stream<ApiResponse<UpdateMediaResponse>>;

  StreamSink<ApiResponse<List<ImageDocumentResponse>>> get imageListSink =>
      _imageListController!.sink as StreamSink<ApiResponse<List<ImageDocumentResponse>>>;
  Stream<ApiResponse<List<ImageDocumentResponse>>> get imageListStream =>
      _imageListController!.stream as Stream<ApiResponse<List<ImageDocumentResponse>>>;

  StreamSink<ApiResponse<HealthRecordSuccess>> get healthRecordSink =>
      _healthRecordController!.sink as StreamSink<ApiResponse<HealthRecordSuccess>>;
  Stream<ApiResponse<HealthRecordSuccess>> get healthRecordStream =>
      _healthRecordController!.stream as Stream<ApiResponse<HealthRecordSuccess>>;

  StreamSink<ApiResponse<ClaimSuccess>> get claimSink => _claimController!.sink as StreamSink<ApiResponse<ClaimSuccess>>;
  Stream<ApiResponse<ClaimSuccess>> get claimStream => _claimController!.stream as Stream<ApiResponse<ClaimSuccess>>;

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
    _claimController?.close();
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
    _claimController = StreamController<ApiResponse<ClaimSuccess>>();
  }

  Future<UserHealthResponseList?> getHelthReportList({bool? condtion}) async {
    UserHealthResponseList? userHealthResponseList;
    healthReportListSink
        .add(ApiResponse.loading(variable.strGettingHealthRecords));
    try {
      userHealthResponseList = await _healthReportListForUserRepository
          .getHealthReportList(condition: condtion ?? false);
      healthReportListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      healthReportListSink.add(ApiResponse.error(e.toString()));
    }
    return userHealthResponseList;
  }

  Future<SavedMetaDataResponse?> submit(String jsonData) async {
    SavedMetaDataResponse? saveMetaDataResponse;
    metadataListSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      saveMetaDataResponse =
          await _healthReportListForUserRepository.postMediaData(jsonData);
      // metadataListSink.add(ApiResponse.completed(saveMetaDataResponse));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      metadataListSink.add(ApiResponse.error(e.toString()));
    }
    return saveMetaDataResponse;
  }

  Future<DoctorImageResponse?> getProfilePic(String doctorsId) async {
    try {
      var userHealthResponseList =
          await _healthReportListForUserRepository.getDoctorProfile(doctorsId);
      return userHealthResponseList;
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Future<ImageDocumentResponse?> getDocumentImage(String metaMasterId) async {
    try {
      final userHealthResponseList = await _healthReportListForUserRepository
          .getDocumentImage(metaMasterId);
      return userHealthResponseList;
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Future<PostImageResponse?> saveImage(
      String fileName, String metaID, String jsonData) async {
    PostImageResponse? postImageResponse;
    imageDataSink.add(ApiResponse.loading(variable.strSavingImg));
    try {
      postImageResponse = await _healthReportListForUserRepository.postImage(
          fileName, metaID, jsonData);
      imageDataSink.add(ApiResponse.completed(postImageResponse));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      imageDataSink.add(ApiResponse.error(e.toString()));
    }
    return postImageResponse;
  }

  Future<DigitRecogResponse?> saveDeviceImage(
      List<String?> fileName, String metaID, String jsonData) async {
    DigitRecogResponse? digitRecogResponse;
    imageDataSink.add(ApiResponse.loading(variable.strSavingImg));
    try {
      digitRecogResponse = await _healthReportListForUserRepository
          .postDevicesData(fileName, metaID, jsonData);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      imageDataSink.add(ApiResponse.error(e.toString()));
    }
    return digitRecogResponse;
  }

  Future<MetaDataMovedResponse?> switchDataToOtherUser(
      String? familyMemberID, String? metaId) async {
    MetaDataMovedResponse? metaDataMovedResponse;
    moveMetaDataSInk.add(ApiResponse.loading(variable.strMoveData));
    try {
      metaDataMovedResponse = await _healthReportListForUserRepository
          .moveDataToOtherUser(familyMemberID, metaId);
      moveMetaDataSInk.add(ApiResponse.completed(metaDataMovedResponse));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      metadataListSink.add(ApiResponse.error(e.toString()));
    }
    return metaDataMovedResponse;
  }

  Future<UpdateMediaResponse?> updateMedia(
      String jsonData, String metaInfoId) async {
    UpdateMediaResponse? updateMediaResponse;
    metaDataUpdateSink.add(ApiResponse.loading(variable.strUpdateData));
    try {
      updateMediaResponse = await _healthReportListForUserRepository
          .updateMediaData(jsonData, metaInfoId);
      metaDataUpdateSink.add(ApiResponse.completed(updateMediaResponse));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

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
    } catch (e,stackTrace) {
      imageListSink.add(ApiResponse.error(e.toString()));
    }

    return userHealthResponseList;
  }*/

  Future<List<ImageDocumentResponse>?> getDocumentImageList(
      List<MediaMasterIds> metaMasterIdList) async {
    List<ImageDocumentResponse>? userHealthResponseList;
    imageListSink.add(ApiResponse.loading(variable.strUpdateData));

    try {
      userHealthResponseList = await _healthReportListForUserRepository
          .getDocumentImageList(metaMasterIdList);

      imageListSink.add(ApiResponse.completed(userHealthResponseList));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      imageListSink.add(ApiResponse.error(e.toString()));
    }

    return userHealthResponseList;
  }

  Future<HealthRecordList?> getHelthReportLists({String? userID}) async {
    HealthRecordList? userHealthResponseList;
    healthReportListSinks
        .add(ApiResponse.loading(variable.strGettingHealthRecords));
    try {
      userHealthResponseList = await _healthReportListForUserRepository
          .getHealthReportLists(commonUserId: userID);
      healthReportListSinks.add(ApiResponse.completed(userHealthResponseList));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      healthReportListSink.add(ApiResponse.error(e.toString()));
    }
    return userHealthResponseList;
  }

  Future<HealthRecordSuccess?> createHealtRecords(
      String jsonData, List<String?>? imagePaths, String? audioPath,
      {bool isVital = false}) async {
    HealthRecordSuccess? healthRecordSuccess;
    healthRecordSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      healthRecordSuccess = await _healthReportListForUserRepository
          .createMediaData(jsonData, imagePaths, audioPath, isVital: isVital);
      // healthRecordSink.add(ApiResponse.completed(healthRecordSuccess));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      healthRecordSink.add(ApiResponse.error(e.toString()));
    }
    return healthRecordSuccess;
  }

  Future<HealthRecordSuccess?> createHealtRecordsClaims(
      String jsonData, List<String?>? imagePaths, String? audioPath) async {
    HealthRecordSuccess? healthRecordSuccess;
    healthRecordSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      healthRecordSuccess = await _healthReportListForUserRepository
          .createMediaDataClaim(jsonData, imagePaths, audioPath);
      // healthRecordSink.add(ApiResponse.completed(healthRecordSuccess));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      healthRecordSink.add(ApiResponse.error(e.toString()));
    }
    return healthRecordSuccess;
  }

  Future<HealthRecordSuccess?> updateHealthRecords(String jsonData,
      List<String?>? imagePaths, String? audioPath, String? metaId) async {
    HealthRecordSuccess? healthRecordSuccess;
    healthRecordSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      healthRecordSuccess = await _healthReportListForUserRepository
          .updateHealthRecords(jsonData, imagePaths, audioPath, metaId);
      // healthRecordSink.add(ApiResponse.completed(healthRecordSuccess));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      healthRecordSink.add(ApiResponse.error(e.toString()));
    }
    return healthRecordSuccess;
  }

  Future<HealthRecordSuccess?> updateFiles(
      String? audioPath, HealthResult healthResult) async {
    HealthRecordSuccess? healthRecordSuccess;
    healthRecordSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      healthRecordSuccess = await _healthReportListForUserRepository
          .updateFileInRecords(audioPath, healthResult);
      // healthRecordSink.add(ApiResponse.completed(healthRecordSuccess));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      healthRecordSink.add(ApiResponse.error(e.toString()));
    }
    return healthRecordSuccess;
  }

  Future<ClaimSuccess?> createClaim(String jsonData) async {
    ClaimSuccess? claimSuccess;
    claimSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      claimSuccess =
          await _healthReportListForUserRepository.createClaimRecord(jsonData);
      // healthRecordSink.add(ApiResponse.completed(healthRecordSuccess));
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      claimSink.add(ApiResponse.error(e.toString()));
    }
    return claimSuccess;
  }
}
