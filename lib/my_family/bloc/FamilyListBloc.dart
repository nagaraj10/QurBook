import 'dart:async';

import '../../add_family_otp/models/add_family_otp_response.dart';
import '../../constants/variable_constant.dart' as variable;
import '../models/FamilyMembersRes.dart';
import '../models/FamilyMembersResponse.dart';
import '../models/relationship_response_list.dart';
import '../models/user_delinking_response.dart';
import '../models/user_linking_response_list.dart';
import '../services/FamilyMemberListRepository.dart';
import '../../src/blocs/Authentication/LoginBloc.dart';
import '../../src/resources/network/ApiResponse.dart';

class FamilyListBloc implements BaseBloc {
  FamilyMemberListRepository _familyResponseListRepository;

  // 1
  StreamController _familyListController;

  StreamSink<ApiResponse<FamilyMembersList>> get familyMemberListSink =>
      _familyListController.sink;
  Stream<ApiResponse<FamilyMembersList>> get familyMemberListStream =>
      _familyListController.stream;

  StreamController _familyController;

  StreamSink<ApiResponse<FamilyMembers>> get familyMemberListNewSink =>
      _familyController.sink;
  Stream<ApiResponse<FamilyMembers>> get familyMemberListNewStream =>
      _familyController.stream;

  // 2
  StreamController _relationshipListController;

  StreamSink<ApiResponse<RelationShipResponseList>> get relationShipListSink =>
      _relationshipListController.sink;
  Stream<ApiResponse<RelationShipResponseList>> get relationShipStream =>
      _relationshipListController.stream;

  // 3
  StreamController _userLinkingController;

  StreamSink<ApiResponse<UserLinkingResponseList>> get userLinkingSink =>
      _userLinkingController.sink;
  Stream<ApiResponse<UserLinkingResponseList>> get userLinkingStream =>
      _userLinkingController.stream;

  // 4
  StreamController _userDeLinkingController;

  StreamSink<ApiResponse<UserLinkingResponseList>> get userDeLinkingSink =>
      _userDeLinkingController.sink;
  Stream<ApiResponse<UserLinkingResponseList>> get userDeLinkingStream =>
      _userDeLinkingController.stream;

  // 5
  StreamController _userLinkingForPrimaryNoController;

  StreamSink<ApiResponse<AddFamilyOTPResponse>>
      get userLinkingForPrimaryNoSink =>
          _userLinkingForPrimaryNoController.sink;
  Stream<ApiResponse<AddFamilyOTPResponse>> get userLinkingForPrimaryNoStream =>
      _userLinkingForPrimaryNoController.stream;

  @override
  void dispose() {
    _familyListController?.close();
    _relationshipListController?.close();
    _userDeLinkingController?.close();
    _userLinkingController?.close();
    _userLinkingForPrimaryNoController?.close();
  }

  FamilyListBloc() {
    _familyResponseListRepository = FamilyMemberListRepository();

    _familyListController = StreamController<ApiResponse<FamilyMembersList>>();
    _familyController = StreamController<ApiResponse<FamilyMembers>>();

    _relationshipListController =
        StreamController<ApiResponse<RelationShipResponseList>>();

    _userLinkingController =
        StreamController<ApiResponse<UserLinkingResponseList>>();

    _userDeLinkingController =
        StreamController<ApiResponse<UserLinkingResponseList>>();

    _userLinkingForPrimaryNoController =
        StreamController<ApiResponse<AddFamilyOTPResponse>>();
  }

  getFamilyMembersList() async {
    FamilyMembersList familyResponseList;
    familyMemberListSink.add(ApiResponse.loading(variable.strFetchFamily));
    try {
      familyResponseList =
          await _familyResponseListRepository.getFamilyMembersList();
      familyMemberListSink.add(ApiResponse.completed(familyResponseList));
    } catch (e) {
      familyMemberListSink.add(ApiResponse.error(e.toString()));
    }
    return familyResponseList;
  }

  getFamilyMembersListNew() async {
    FamilyMembers familyResponseList;
    familyMemberListNewSink.add(ApiResponse.loading(variable.strFetchFamily));
    try {
      familyResponseList =
          await _familyResponseListRepository.getFamilyMembersListNew();
      familyMemberListNewSink.add(ApiResponse.completed(familyResponseList));
    } catch (e) {
      familyMemberListNewSink.add(ApiResponse.error(e.toString()));
    }
    return familyResponseList;
  }

  Future<FamilyMembers> getFamilyMembersInfo() async {
    FamilyMembers familyResponseList;
    try {
      familyResponseList =
          await _familyResponseListRepository.getFamilyMembersListNew();
    } catch (e) {
      familyMemberListNewSink.add(ApiResponse.error(e.toString()));
    }
    return familyResponseList;
  }

  getCustomRoles() async {
    relationShipListSink.add(ApiResponse.loading(variable.strFetchRoles));
    try {
      var relationShipResponseList =
          await _familyResponseListRepository.getCustomRoles();
      relationShipListSink.add(ApiResponse.completed(relationShipResponseList));
    } catch (e) {
      relationShipListSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<UserLinkingResponseList> postUserLinking(String jsonString) async {
    userLinkingSink.add(ApiResponse.loading(variable.strPostUserLink));

    UserLinkingResponseList userLinking;
    try {
      userLinking =
          await _familyResponseListRepository.postUserLinking(jsonString);
//      userLinkingSink.add(ApiResponse.completed(userLinking));
    } catch (e) {
      userLinkingSink.add(ApiResponse.error(e.toString()));
    }

    return userLinking;
  }

  Future<UserDeLinkingResponseList> postUserDeLinking(String jsonString) async {
    userDeLinkingSink.add(ApiResponse.loading(variable.strPostuserDelink));

    UserDeLinkingResponseList userDeLinking;
    try {
      userDeLinking =
          await _familyResponseListRepository.postUserDeLinking(jsonString);
//      userLinkingSink.add(ApiResponse.completed(userLinking));
    } catch (e) {
      userDeLinkingSink.add(ApiResponse.error(e.toString()));
    }

    return userDeLinking;
  }

  Future<AddFamilyOTPResponse> postUserLinkingForPrimaryNo(
      String jsonString) async {
    print(jsonString);
    userLinkingForPrimaryNoSink
        .add(ApiResponse.loading(variable.strPostUserLink));

    AddFamilyOTPResponse addFamilyOTPResponse;
    try {
      addFamilyOTPResponse = await _familyResponseListRepository
          .postUserLinkingForPrimaryNo(jsonString);
    } catch (e) {
      userLinkingForPrimaryNoSink.add(ApiResponse.error(e.toString()));
    }

    return addFamilyOTPResponse;
  }
}
