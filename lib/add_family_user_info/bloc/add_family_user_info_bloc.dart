import 'dart:async';
import 'dart:io';

import 'package:myfhb/add_family_user_info/models/update_add_family_info.dart';
import 'package:myfhb/add_family_user_info/models/updated_add_family_relation_info.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/add_family_user_info/models/verify_email_response.dart';

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

  StreamSink<ApiResponse<MyProfile>> get myProfileSink =>
      _myProfileController.sink;

  Stream<ApiResponse<MyProfile>> get myProfileStream =>
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
      lastName;

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

    _myProfileController = StreamController<ApiResponse<MyProfile>>();

    _userProfileController =
        StreamController<ApiResponse<UpdateAddFamilyInfo>>();

    _updatedRelationShipController =
        StreamController<ApiResponse<UpdateAddFamilyRelationInfo>>();
    _verifyEmailController =
        StreamController<ApiResponse<VerifyEmailResponse>>();
  }

  Future<RelationShipResponseList> getCustomRoles() async {
    relationShipListSink.add(ApiResponse.loading('Fetching Custom Roles'));
    RelationShipResponseList relationShipResponseList;
    try {
      relationShipResponseList =
          await addFamilyUserInfoRepository.getCustomRoles();
    } catch (e) {
      relationShipListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }

    return relationShipResponseList;
  }

  Future<MyProfile> getMyProfileInfo() async {
    myProfileSink.add(ApiResponse.loading('Fetching Custom Roles'));
    MyProfile myProfile;

    try {
      myProfile = await addFamilyUserInfoRepository.getMyProfileInfo(userId);
    } catch (e) {
      myProfileSink.add(ApiResponse.error(e.toString()));
    }

    return myProfile;
  }

  Future<UpdateAddFamilyInfo> updateUserProfile() async {
    userProfileSink.add(ApiResponse.loading('Signing in user'));
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
              lastName);
//      userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      userProfileSink.add(ApiResponse.error(e.toString()));
      print(e);
    }

    return updateAddFamilyInfo;
  }

  Future<UpdateAddFamilyRelationInfo> updateUserRelationShip() async {
    updateRelationshipSink.add(ApiResponse.loading('Signing in user'));
    UpdateAddFamilyRelationInfo updateAddFamilyRelationInfo;

    try {
      updateAddFamilyRelationInfo = await addFamilyUserInfoRepository
          .updateRelationShip(relationshipJsonString);
//      userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      updateRelationshipSink.add(ApiResponse.error(e.toString()));
      print(e);
    }

    return updateAddFamilyRelationInfo;
  }

  Future<UpdateAddFamilyInfo> updateSelfProfile() async {
    userProfileSink.add(ApiResponse.loading('Signing in user'));
    UpdateAddFamilyInfo updateAddFamilyInfo;

    try {
      updateAddFamilyInfo =
          await addFamilyUserInfoRepository.updateSelfProfileInfo(
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
              lastName);
//      userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      userProfileSink.add(ApiResponse.error(e.toString()));
      print(e);
    }

    return updateAddFamilyInfo;
  }

  Future<VerifyEmailResponse> verifyEmail() async {
    verifyEmailSink.add(ApiResponse.loading('verify email'));
    VerifyEmailResponse verifyEmailResponse;

    try {
      verifyEmailResponse = await addFamilyUserInfoRepository.verifyEmail();
//      userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      verifyEmailSink.add(ApiResponse.error(e.toString()));
      print(e);
    }

    return verifyEmailResponse;
  }
}
