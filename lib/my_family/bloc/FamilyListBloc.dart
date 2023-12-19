import 'dart:async';

import 'package:myfhb/common/CommonUtil.dart';

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
  late FamilyMemberListRepository _familyResponseListRepository;

  // 1
  StreamController? _familyListController;

  StreamSink<ApiResponse<FamilyMembersList>> get familyMemberListSink =>
      _familyListController!.sink as StreamSink<ApiResponse<FamilyMembersList>>;
  Stream<ApiResponse<FamilyMembersList>> get familyMemberListStream =>
      _familyListController!.stream as Stream<ApiResponse<FamilyMembersList>>;

  late StreamController _familyController;

  StreamSink<ApiResponse<FamilyMembers>> get familyMemberListNewSink =>
      _familyController.sink as StreamSink<ApiResponse<FamilyMembers>>;
  Stream<ApiResponse<FamilyMembers>> get familyMemberListNewStream =>
      _familyController.stream as Stream<ApiResponse<FamilyMembers>>;

  // 2
  StreamController? _relationshipListController;

  StreamSink<ApiResponse<RelationShipResponseList>> get relationShipListSink =>
      _relationshipListController!.sink
          as StreamSink<ApiResponse<RelationShipResponseList>>;
  Stream<ApiResponse<RelationShipResponseList>> get relationShipStream =>
      _relationshipListController!.stream
          as Stream<ApiResponse<RelationShipResponseList>>;

  // 3
  StreamController? _userLinkingController;

  StreamSink<ApiResponse<UserLinkingResponseList>> get userLinkingSink =>
      _userLinkingController!.sink
          as StreamSink<ApiResponse<UserLinkingResponseList>>;
  Stream<ApiResponse<UserLinkingResponseList>> get userLinkingStream =>
      _userLinkingController!.stream
          as Stream<ApiResponse<UserLinkingResponseList>>;

  // 4
  StreamController? _userDeLinkingController;

  StreamSink<ApiResponse<UserLinkingResponseList>> get userDeLinkingSink =>
      _userDeLinkingController!.sink
          as StreamSink<ApiResponse<UserLinkingResponseList>>;
  Stream<ApiResponse<UserLinkingResponseList>> get userDeLinkingStream =>
      _userDeLinkingController!.stream
          as Stream<ApiResponse<UserLinkingResponseList>>;

  // 5
  StreamController? _userLinkingForPrimaryNoController;

  StreamSink<ApiResponse<AddFamilyOTPResponse>>
      get userLinkingForPrimaryNoSink =>
          _userLinkingForPrimaryNoController!.sink
              as StreamSink<ApiResponse<AddFamilyOTPResponse>>;
  Stream<ApiResponse<AddFamilyOTPResponse>> get userLinkingForPrimaryNoStream =>
      _userLinkingForPrimaryNoController!.stream
          as Stream<ApiResponse<AddFamilyOTPResponse>>;

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
    FamilyMembersList? familyResponseList;
    familyMemberListSink.add(ApiResponse.loading(variable.strFetchFamily));
    try {
      familyResponseList =
          await _familyResponseListRepository.getFamilyMembersList();
      familyMemberListSink.add(ApiResponse.completed(familyResponseList));
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      familyMemberListSink.add(ApiResponse.error(e.toString()));
    }
    return familyResponseList;
  }

  getFamilyMembersListNew() async {
    FamilyMembers? familyResponseList;
    familyMemberListNewSink.add(ApiResponse.loading(variable.strFetchFamily));
    try {
      familyResponseList =
          await _familyResponseListRepository.getFamilyMembersListNew();
      familyMemberListNewSink.add(ApiResponse.completed(familyResponseList));
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      familyMemberListNewSink.add(ApiResponse.error(e.toString()));
    }
    return familyResponseList;
  }

  Future<FamilyMembers?> getFamilyMembersInfo() async {
    FamilyMembers? familyResponseList;
    try {
      familyResponseList =
          await _familyResponseListRepository.getFamilyMembersListNew();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

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
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      relationShipListSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<UserLinkingResponseList?> postUserLinking(String jsonString) async {
    userLinkingSink.add(ApiResponse.loading(variable.strPostUserLink));

    UserLinkingResponseList? userLinking;
    try {
      userLinking =
          await _familyResponseListRepository.postUserLinking(jsonString);
//      userLinkingSink.add(ApiResponse.completed(userLinking));
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      userLinkingSink.add(ApiResponse.error(e.toString()));
    }

    return userLinking;
  }

  Future<UserDeLinkingResponseList?> postUserDeLinking(
      String jsonString) async {
    userDeLinkingSink.add(ApiResponse.loading(variable.strPostuserDelink));

    UserDeLinkingResponseList? userDeLinking;
    try {
      userDeLinking =
          await _familyResponseListRepository.postUserDeLinking(jsonString);
//      userLinkingSink.add(ApiResponse.completed(userLinking));
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      userDeLinkingSink.add(ApiResponse.error(e.toString()));
    }

    return userDeLinking;
  }

  Future<AddFamilyOTPResponse?> postUserLinkingForPrimaryNo(
      String jsonString) async {
    print(jsonString);
    userLinkingForPrimaryNoSink
        .add(ApiResponse.loading(variable.strPostUserLink));

    AddFamilyOTPResponse? addFamilyOTPResponse;
    try {
      addFamilyOTPResponse = await _familyResponseListRepository
          .postUserLinkingForPrimaryNo(jsonString);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      userLinkingForPrimaryNoSink.add(ApiResponse.error(e.toString()));
    }

    return addFamilyOTPResponse;
  }

/**
 * This gives the list of family members ,which is a combined of both 
 * sharedByUsers and sharedToUsers
 * This method combines thelist of sharedByUser and sharedToUser together
 * by checking if the parent id is not similar to child id 
 */
  List<SharedByUsers> getSharedByListList(FamilyMemberResult? data) {
    List<SharedByUsers> sharedByUsersList = [];
    List<SharedByUsers> sharedByUsersListOriginal = [];
    List<SharedToUsers> sharedToUsersList = [];

    sharedByUsersList = data?.sharedByUsers ??
        []; // arraylist to get he combined list from sharedToUser an sharedByUserList
    sharedToUsersList =
        data?.sharedToUsers ?? []; // adding the existing list to this array
    sharedByUsersListOriginal =
        data?.sharedByUsers ?? []; // arraylist to retain the original value
    bool? add;
    if (sharedToUsersList.isNotEmpty ?? false) {
      if ((sharedToUsersList.length ?? 0) > 0) {
        if ((sharedByUsersListOriginal.isNotEmpty ?? false) &&
            (sharedByUsersListOriginal.length ?? 0) > 0) {
          sharedToUsersList.forEach((sharedToUsers) {
            sharedByUsersListOriginal.any((sharedByUser) {
              //Check if the parentid and child id is similar
              add = (sharedToUsers?.parent?.id == sharedByUser?.child?.id) ??
                  false;
              return add ?? false;
            });
            //if not similar add the object to existing list
            if (add == false) {
              SharedByUsers sharedByUserObj = SharedByUsers();
              sharedByUserObj.id = sharedToUsers?.id;
              sharedByUserObj.status = sharedToUsers?.status;
              sharedByUserObj.nickName = sharedToUsers?.nickName;
              sharedByUserObj.isActive = sharedToUsers?.isActive;
              sharedByUserObj.createdOn = sharedToUsers?.createdOn;
              sharedByUserObj.lastModifiedOn = sharedToUsers?.lastModifiedOn;
              sharedByUserObj.isCaregiver = sharedToUsers?.isCaregiver;
              sharedByUserObj.isNewUser = sharedToUsers?.isNewUser;
              sharedByUserObj.remainderForId = sharedToUsers?.remainderForId;
              sharedByUserObj.remainderFor = sharedToUsers?.remainderFor;
              sharedByUserObj.remainderMins = sharedToUsers?.remainderMins;
              sharedByUserObj.nonAdheranceId = sharedToUsers?.nonAdheranceId;
              sharedByUserObj.child = sharedToUsers?.parent;
              sharedByUserObj.relationship = sharedToUsers?.relationship;
              sharedByUserObj.nickName = sharedToUsers.nickName;
              sharedByUsersList.add(sharedByUserObj);
            }
          });
        }
      }
    }
    return sharedByUsersList ?? [];
  }
}
