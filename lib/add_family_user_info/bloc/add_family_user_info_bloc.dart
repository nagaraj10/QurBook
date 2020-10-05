import 'dart:async';
import 'dart:io';

import 'package:myfhb/add_family_user_info/models/update_add_family_info.dart';
import 'package:myfhb/add_family_user_info/models/update_self_profile_model.dart';
import 'package:myfhb/add_family_user_info/models/updated_add_family_relation_info.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/State.dart';
import 'package:myfhb/src/model/user/city_list_model.dart';
import 'package:myfhb/src/model/user/state_list_model.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/add_family_user_info/models/verify_email_response.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

class AddFamilyUserInfoBloc extends BaseBloc {
  AddFamilyUserInfoRepository addFamilyUserInfoRepository;

  // 1
  StreamController _relationshipListController;

  StreamSink<ApiResponse<RelationShipResponseList>> get relationShipListSink =>
      _relationshipListController.sink;

  Stream<ApiResponse<RelationShipResponseList>> get relationShipStream =>
      _relationshipListController.stream;

  // 2
  StreamController _myProfileController;

  StreamSink<ApiResponse<MyProfileModel>> get myProfileSink =>
      _myProfileController.sink;

  Stream<ApiResponse<MyProfileModel>> get myProfileStream =>
      _myProfileController.stream;

  // 3
  StreamController _userProfileController;

  StreamSink<ApiResponse<UpdateAddFamilyInfo>> get userProfileSink =>
      _userProfileController.sink;

  Stream<ApiResponse<UpdateAddFamilyInfo>> get userProfileStream =>
      _userProfileController.stream;

  // 4
  StreamController _updatedRelationShipController;

  StreamSink<ApiResponse<UpdateAddFamilyRelationInfo>>
      get updateRelationshipSink => _updatedRelationShipController.sink;

  Stream<ApiResponse<UpdateAddFamilyRelationInfo>>
      get updateRelationshipStream => _updatedRelationShipController.stream;

//5
  StreamController _verifyEmailController;
  StreamSink<ApiResponse<VerifyEmailResponse>> get verifyEmailSink =>
      _verifyEmailController.sink;

  Stream<ApiResponse<VerifyEmailResponse>> get verifyEmailStream =>
      _verifyEmailController.stream;

  String userId;

  String name,
      phoneNo,
      email,
      gender,
      bloodGroup,
      dateOfBirth,
      relationship,
      firstName,
      middleName,
      lastName,
      addressLine1,
      addressLine2,
      cityId,
      stateId,
      zipcode;

  MyProfileModel myProfileModel;

  String relationshipJsonString;

  File profilePic, profileBanner;

  @override
  void dispose() {
    // TODO: implement dispose

    _relationshipListController.close();
    _myProfileController.close();
    _userProfileController.close();
    _updatedRelationShipController.close();
    _verifyEmailController.close();
  }

  AddFamilyUserInfoBloc() {
    addFamilyUserInfoRepository = AddFamilyUserInfoRepository();

    _relationshipListController =
        StreamController<ApiResponse<RelationShipResponseList>>();

    _myProfileController = StreamController<ApiResponse<MyProfileModel>>();

    _userProfileController =
        StreamController<ApiResponse<UpdateAddFamilyInfo>>();

    _updatedRelationShipController =
        StreamController<ApiResponse<UpdateAddFamilyRelationInfo>>();
    _verifyEmailController =
        StreamController<ApiResponse<VerifyEmailResponse>>();
  }

  Future<RelationShipResponseList> getCustomRoles() async {
    relationShipListSink.add(ApiResponse.loading(variable.strFetchRoles));
    RelationShipResponseList relationShipResponseList;
    try {
      relationShipResponseList =
          await addFamilyUserInfoRepository.getCustomRoles();
    } catch (e) {
      relationShipListSink.add(ApiResponse.error(e.toString()));
    }

    return relationShipResponseList;
  }

  Future<MyProfileModel> getMyProfileInfo() async {
    myProfileSink.add(ApiResponse.loading(variable.strFetchRoles));
    MyProfileModel myProfile;

    try {
      myProfile = await addFamilyUserInfoRepository.getMyProfileInfo(userId);
    } catch (e) {
      myProfileSink.add(ApiResponse.error(e.toString()));
    }

    return myProfile;
  }

  Future<UpdateAddFamilyInfo> updateUserProfile(bool fromFamily) async {
    userProfileSink.add(ApiResponse.loading(variable.strUpdatingProfile));
    UpdateAddFamilyInfo updateAddFamilyInfo;

    try {
      updateAddFamilyInfo =
          await addFamilyUserInfoRepository.updateUserProfileInfo(
              userId,
              name,
              phoneNo,
              email,
              gender,
              bloodGroup,
              dateOfBirth,
              profilePic,
              firstName,
              middleName,
              lastName,
              cityId,
              stateId,
              addressLine1,
              addressLine2,
              zipcode,
              fromFamily);
//      userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      userProfileSink.add(ApiResponse.error(e.toString()));
    }

    return updateAddFamilyInfo;
  }

  Future<UpdateAddFamilyRelationInfo> updateUserRelationShip() async {
    updateRelationshipSink
        .add(ApiResponse.loading(variable.strUpdateUserRelation));
    UpdateAddFamilyRelationInfo updateAddFamilyRelationInfo;

    try {
      updateAddFamilyRelationInfo = await addFamilyUserInfoRepository
          .updateRelationShip(relationshipJsonString);
//      userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      updateRelationshipSink.add(ApiResponse.error(e.toString()));
    }

    return updateAddFamilyRelationInfo;
  }

  Future<UpdateSelfProfileModel> updateSelfProfile(bool fromFamily) async {
    userProfileSink.add(ApiResponse.loading(variable.strUpdatedSelfProfile));
    UpdateSelfProfileModel updateAddFamilyInfo;

    try {
      updateAddFamilyInfo = await addFamilyUserInfoRepository.updateUserInfoNew(
          userId,
          name,
          phoneNo,
          email,
          gender,
          bloodGroup,
          dateOfBirth,
          profilePic,
          firstName,
          middleName,
          lastName,
          cityId,
          stateId,
          addressLine1,
          addressLine2,
          zipcode,
          fromFamily,
          myProfileModel);
      //userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      userProfileSink.add(ApiResponse.error(e.toString()));
    }

    return updateAddFamilyInfo;
  }

  Future<VerifyEmailResponse> verifyEmail() async {
    verifyEmailSink.add(ApiResponse.loading(variable.strVerifyingMail));
    VerifyEmailResponse verifyEmailResponse;

    try {
      verifyEmailResponse = await addFamilyUserInfoRepository.verifyEmail();
//      userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      verifyEmailSink.add(ApiResponse.error(e.toString()));
    }

    return verifyEmailResponse;
  }

  Future<List<CityResult>> getCityDataList(
      String cityname, String apibody) async {
    CityModel cityListModel;

    cityListModel = await addFamilyUserInfoRepository.getValuesBaseOnSearch(
        cityname, apibody);
    return cityListModel.result;
  }

  Future<List<State>> geStateDataList(String cityname, String apibody) async {
    StateModel stateModel;

    stateModel = await addFamilyUserInfoRepository.getStateValuesBaseOnSearch(
        cityname, apibody);
    return stateModel.result;
  }
}
