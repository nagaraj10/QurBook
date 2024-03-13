import 'dart:convert';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/more_menu/models/voice_clone_status_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/voice_cloning/controller/voice_cloning_controller.dart';
import 'package:myfhb/voice_cloning/model/voice_clone_caregiver_assignment_response.dart';
import 'package:myfhb/voice_cloning/model/voice_clone_shared_by_users.dart';
import 'package:myfhb/voice_cloning/services/voice_clone_members_services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/CommonUtil.dart';
import '../constants/router_variable.dart';
import '../src/resources/network/api_services.dart';
import '../src/utils/FHBUtils.dart';

class VoiceCloneStatusController extends GetxController {
  var loadingData = false.obs;
  var isFamilyMemberLoading = false.obs;
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
  String audioURL = '';

  VoiceCloningController? voiceCloningController;
  bool isPlayWidgetClicked = false;
  var loadingAudioData = false.obs;
//to check if the audi widget is clicked to view

  late PlayerController playerVoiceStatusController;
  List<double> audioWaveVoiceStatusData = []; //new wave for downloaded music
  Rx<String> recordedPath = ''.obs;
  Rx<double> maxPlayerVoiceStatusDuration = 1.0.obs;
  Rx<double> playVoiceStatusPosition =
      0.0.obs; //new position for recorded voice

  Rx<bool> isPlayerLoading = false.obs;
  bool isFirsTymVoiceCloningStatus =
      true; //check if the player is from status screen
  Rx<bool> isPlaying = true.obs; // to update the play and pause button
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadingData = true.obs;
    listOfFamilyMembers = <VoiceCloneSharedByUsers>[].obs;
    selectedFamilyMembers = [];
    listOfExistingFamilyMembers.value = <String>[].obs;

  }

  void getStatusOfUser() {}

  getStatusFromApi() async {
    loadingData.value = true;
    var id =  PreferenceUtil.getStringValue(keyHealthOrganizationId);
    if(id!=null && id!=''){
      healthOrganizationId.value = id;
      final userId = await PreferenceUtil.getStringValue(KEY_USERID_MAIN);
      final url = strURLVoiceCloneStatus +
          qr_userId +
          userId! +
          qr_organizationid +
          healthOrganizationId.value;

      final response = await _helper.getStatusOfVoiceCloning(url);
      voiceCloneStatusModel = VoiceCloneStatusModel.fromJson(response ?? '');
      voiceCloneId.value = voiceCloneStatusModel?.result?.id ?? '';
      if (voiceCloneStatusModel?.result?.url != "")
        audioURL = voiceCloneStatusModel?.result?.url ?? '';
      //download path from url every time when api is called
      await downloadAudioFile(audioURL);
      loadingData.value = false;
      ///Fetching the Assigned family memberlist only if the status is approved as per the previous implementation
      /// This is unnecessary call because in UI List was displaying only if approved.
      if(voiceCloneStatusModel?.result?.status ==
          strApproved){
        fetchFamilyMembersList(voiceCloneId.value);
      }
    }else{
      loadingData.value = false;
    }
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
        if ([rt_notification_main, rt_more_menu]
            .contains(route.settings.name)) {
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
    try {
      isFamilyMemberLoading.value =true;
      selectedFamilyMembers = await fetchAlreadySelectedFamilyMembersList(
            voiceCloneId,
          ) ??
          [];

      listOfExistingFamilyMembers.value =
          selectedFamilyMembers.map((e) => e.id ?? '').toList();
      listOfFamilyMembers.value = [];
      final _listFamilyMembers =
          await _voiceCloneMembersServices.getFamilyMembersListNew();
      final listOfCareGiverFamilyMembers =
          (await _voiceCloneMembersServices.getCareGiverPatientList() ?? [])
              .map((e) => e?.childId ?? '')
              .toList();

      List<VoiceCloneSharedByUsers> _customlistOfFamilyMembers =
          <VoiceCloneSharedByUsers>[];
      _listFamilyMembers.result?.sharedByUsers?.forEach((sharedByUser) {
        final existingFamilyMembers = selectedFamilyMembers
            .where(
              (element) =>
                  element.user?.id == sharedByUser.child?.id &&
                  listOfCareGiverFamilyMembers.contains(sharedByUser.child?.id),
            )
            .toList();

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
    } catch (e, stackTrace) {
      CommonUtil()
          .appLogs(message: e.toString(), stackTrace: stackTrace.toString());
    }finally{
      isFamilyMemberLoading.value =false;
    }
  }

  /**
   * To download the audio url to mobile
   */
  Future<Rx<String>> downloadAudioFile(String? audioUrl) async {
    await askForStoragePermission();
    var fileName;
    var authToken = await PreferenceUtil.getStringValue(KEY_AUTHTOKEN);
    if (audioUrl != "") {
      fileName = audioUrl?.split("/").last;
    }

    final filePath = await FHBUtils.createDir(
      stAudioPath,
      fileName,
    );
    final file = File(filePath);
    if(file.existsSync()){
      recordedPath.value = filePath;
      return recordedPath;
    }
    final request = await ApiServices.get(
      audioUrl ?? '',
      headers: {
        HttpHeaders.authorizationHeader: authToken!,
        KEY_OffSet: CommonUtil().setTimeZone()
      },
      timeout: 60,
    );
    final bytes = request!.bodyBytes; //close();
    await file.writeAsBytes(bytes);
    recordedPath.value = filePath;
    print(recordedPath);

    return recordedPath;
  }

  void setValue() {
    isPlayWidgetClicked = !isPlayWidgetClicked;
  }

  void initialiseControllers() {
    playerVoiceStatusController = PlayerController();
  }

  Future<void> startVoiceStatusPlayer() async {
    setPlayerLoading(true);
    isPlaying.value = true;
    audioWaveVoiceStatusData =
        await playerVoiceStatusController.extractWaveformData(
      path: recordedPath.value,
    );
    await playerVoiceStatusController.preparePlayer(path: recordedPath.value);
    maxPlayerVoiceStatusDuration.value =
        playerVoiceStatusController.maxDuration.toDouble();
    setPlayerLoading(false);

    ///When using Finish mode pause it will allow to play and pause for every time.
    await playerVoiceStatusController.startPlayer(finishMode: FinishMode.pause);
    playerVoiceStatusController.onCompletion.listen((event) {
      playVoiceStatusPosition.value = 0.0;
      isPlaying.value = false;
    });

    playerVoiceStatusController.onCurrentDurationChanged.listen((event) {
      playVoiceStatusPosition.value = event.seconds.inSeconds.toDouble();
    });
  }

  //ask permission befor downloading file
  static Future<bool> askForStoragePermission() async {
    PermissionStatus storage = await Permission.storage.request();
    if (storage == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  //loader for startiing voice player
  void setPlayerLoading(bool value) {
    this.isPlayerLoading.value = value;
  }

  //dispose recorder
  disposeRecorder() {
    playerVoiceStatusController.dispose();
  }

//start or stop player
  Future<void> playVoiceStatusPausePlayer() async {
    if (playerVoiceStatusController.playerState.isPlaying) {
      isPlaying.value = false;
      await playerVoiceStatusController.pausePlayer();
    } else {
      isPlaying.value = true;
      await playerVoiceStatusController.startPlayer(
          finishMode: FinishMode.pause, forceRefresh: true);
    }
  }

  //format duration
  String formatPlayerDuration(double seconds) {
    ///This function will give the duration to hh:mm:ss from double value.
    Duration duration = Duration(milliseconds: seconds.toInt());
    String formattedDuration = '';

    if (duration.inHours > 0) {
      formattedDuration += '${duration.inHours.toString().padLeft(2, '0')}:';
    }
    formattedDuration +=
        '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:';
    formattedDuration +=
        (duration.inSeconds.remainder(60)).toString().padLeft(2, '0');

    return formattedDuration;
  }
}
