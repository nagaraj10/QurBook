import 'dart:convert';

import 'package:get/get.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/more_menu/models/voice_clone_status_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';

class VoiceCloneStatusController extends GetxController {
  var loadingData = false.obs;
  var _helper = ApiBaseHelper();
  var healthOrganizationId = ''.obs;
  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();

  VoiceCloneStatusModel? voiceCloneStatusModel;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadingData = true.obs;
  }

  void getStatusOfUser() {}

  void getUserHealthOrganizationId() async {
    var userId = await PreferenceUtil.getStringValue(KEY_USERID_MAIN);
    loadingData.value = true;
    await healthReportListForUserRepository
        .getDeviceSelection(userIdFromBloc: userId)
        .then((value) {
      if (value?.isSuccess ?? false) {
        if (value?.result != null && (value?.result?.length ?? 0) > 0) {
          String id =
              value?.result![0]?.primaryProvider?.healthorganizationid ?? '';
          if (id != null && id != "") {
            healthOrganizationId.value = id;
            getStatusFromApi();
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

    var response = await _helper.getStatusOfVoiceCloning(url);
    voiceCloneStatusModel = VoiceCloneStatusModel.fromJson(response ?? '');
    loadingData.value = false;
  }

  revokeSubmission() async {
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
      loadingData.value = false;
    }
    loadingData.value = false;
  }
}
