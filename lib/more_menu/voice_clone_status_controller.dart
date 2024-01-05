import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/more_menu/models/voice_clone_status_model.dart';
import 'package:myfhb/more_menu/screens/more_menu_screen.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/voice_cloning/model/voice_clone_caregiver_assignment_response.dart';
import 'package:myfhb/voice_cloning/model/voice_clone_shared_by_users.dart';
import 'package:myfhb/voice_cloning/services/voice_clone_members_services.dart';

import '../constants/router_variable.dart';

class VoiceCloneStatusController extends GetxController {
  var loadingData = false.obs;
  var _helper = ApiBaseHelper();
  var healthOrganizationId = ''.obs;
  var voiceCloneId = ''.obs;
  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();

  VoiceCloneStatusModel? voiceCloneStatusModel;
  var listOfFamilyMembers = <VoiceCloneSharedByUsers>[].obs;
  var listOfExistingFamilyMembers = <String>[].obs;

  List<VoiceCloneCaregiverAssignmentResult> selectedFamilyMembers = [];

  final _voiceCloneMembersServices = VoiceCloneMembersServices();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadingData = true.obs;
    listOfFamilyMembers.value = [];
    selectedFamilyMembers = [];
    listOfExistingFamilyMembers.value = [];
  }

  void getStatusOfUser() {}

  void getUserHealthOrganizationId() async {
    var userId = await PreferenceUtil.getStringValue(KEY_USERID_MAIN);
    loadingData.value = true;
    await healthReportListForUserRepository
        .getDeviceSelection(userIdFromBloc: userId)
        .then((value) async {
      if (value?.isSuccess ?? false) {
        if (value?.result != null && (value?.result?.length ?? 0) > 0) {
          String id =
              value?.result![0]?.primaryProvider?.healthorganizationid ?? '';
          if (id != null && id != "") {
            healthOrganizationId.value = id;
            await getStatusFromApi(); //wait till the  next ap is also called
          }
          loadingData.value = false;
        }
        loadingData.value = false;
      }
      loadingData.value = false;
    });
  }

  getStatusFromApi() async {
    final userId = await PreferenceUtil.getStringValue(KEY_USERID_MAIN);
    final url = strURLVoiceCloneStatus +
        qr_userId +
        userId! +
        qr_organizationid +
        healthOrganizationId.value;

    final response = await _helper.getStatusOfVoiceCloning(url);
    voiceCloneStatusModel = VoiceCloneStatusModel.fromJson(response ?? '');
    voiceCloneId.value = voiceCloneStatusModel?.result?.id ?? '';
    loadingData.value = false;
    fetchFamilyMembersList(voiceCloneId.value);
  }

  revokeSubmission(bool fromMenu) async {
    loadingData.value = true;
    final body = {
      'id': voiceCloneStatusModel?.result?.id,
      'statusCode': 'VCREVOKE',
    };
    final jsonData = json.encode(body);
    final req = await _helper.revokeVoiceClone(
      strVoiceRevoke,
      jsonData,
    );
    if (req != null) {
      if (req['isSuccess']) {
        loadingData.value = false;
        setBackButton(Get.context!, fromMenu);
      } else {
        FlutterToast().getToast((req['message'].toString()), Colors.red);
      }
    }
    loadingData.value = false;
  }

  //Set back button functionlaity from mobile back button and top of the screen
  void setBackButton(BuildContext context, bool fromMenu) {
    // to enable navigation from down back button
    if (fromMenu == true) {
      Navigator.of(context).pop();
    } else {
      Navigator.popUntil(context, (route) {
        var shouldPop = false;
        if (route.settings.name == rt_more_menu) {
          shouldPop = true;
        }
        return shouldPop;
      });
    }
  }

  Future<List<VoiceCloneCaregiverAssignmentResult>?>
      fetchAlreadySelectedFamilyMembersList(String voiceCloneId) async {
    final listOfAlreadySelectedFamilyMembersList =
        await _voiceCloneMembersServices.fetchAlreadySelectedFamilyMembersList(
      voiceCloneId,
    );
    return listOfAlreadySelectedFamilyMembersList;
  }

  /// Fetch FamilyMembers list from API
  Future<void> fetchFamilyMembersList(String voiceCloneId) async {
    selectedFamilyMembers = await fetchAlreadySelectedFamilyMembersList(
          voiceCloneId,
        ) ??
        [];

    listOfExistingFamilyMembers.value =
        selectedFamilyMembers?.map((e) => e.id ?? '').toList() ?? [];
    listOfFamilyMembers.value = [];
    final _listFamilyMembers =
        await _voiceCloneMembersServices.getFamilyMembersListNew();

    var _customlistOfFamilyMembers = <VoiceCloneSharedByUsers>[];
    _listFamilyMembers.result?.sharedByUsers?.forEach((sharedByUser) {
      final existingFamilyMembers = selectedFamilyMembers
          .where((element) => element.user?.id == sharedByUser.child?.id)
          .toList();

      ;
      if (existingFamilyMembers.isNotEmpty &&
          (existingFamilyMembers[0].isActive ?? false)) {
        _customlistOfFamilyMembers.add(
          VoiceCloneSharedByUsers(
            id: sharedByUser.id,
            status: sharedByUser.status,
            nickName: sharedByUser.nickName,
            isActive: sharedByUser.isActive,
            createdOn: sharedByUser.createdOn,
            lastModifiedOn: sharedByUser.lastModifiedOn,
            relationship: sharedByUser.relationship,
            child: sharedByUser.child,
            membershipOfferedBy: sharedByUser.membershipOfferedBy,
            isCaregiver: sharedByUser.isCaregiver,
            isNewUser: sharedByUser.isNewUser,
            remainderForId: sharedByUser.remainderForId,
            remainderFor: sharedByUser.remainderFor,
            remainderMins: sharedByUser.remainderMins,
            nonAdheranceId: sharedByUser.nonAdheranceId,
            chatListItem: sharedByUser.chatListItem,
            nickNameSelf: sharedByUser.nickNameSelf,
            isSelected: existingFamilyMembers[0].isActive ?? false,
          ),
        );
      }
    });
    listOfFamilyMembers.value = _customlistOfFamilyMembers;
  }
}
