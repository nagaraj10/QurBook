import '../../constants/webservice_call.dart';
import '../../my_family/models/FamilyMembersRes.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import '../model/voice_clone_caregiver_assignment_response.dart';
import '../model/voice_clone_submit_request.dart';
import '../model/voice_clone_submit_response.dart';

class VoiceCloneMembersServices {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final _webserviceCall = WebserviceCall();

  Future<FamilyMembers> getFamilyMembersListNew() async {
    final response = await _helper.getFamilyMembersListNew(
      _webserviceCall.getQueryForFamilyMemberListNew(),
    );
    return FamilyMembers.fromJson(response);
  }

  Future<VoiceCloneAssignmentResponseModel> submitVoiceCloneWithFamilyMembers(
      VoiceCloneRequest request) async {
    final response = await _helper.submitVoiceCloneWithFamilyMembers(
        'voice-clone/assign-user', request);
    return VoiceCloneAssignmentResponseModel.fromJson(response);
  }

  Future<List<VoiceCloneCaregiverAssignmentResult>?>
      fetchAlreadySelectedFamilyMembersList(String voiceCloneId) async {
    final response = await _helper.fetchAlreadySelectedFamilyMembersList(
      _webserviceCall.getQueryForAlreadySelectedFamilyMembers(
        voiceCloneId,
      ),
    );
    return VoiceCloneCaregiverAssignmentResponse.fromJson(response).result;
  }
}
