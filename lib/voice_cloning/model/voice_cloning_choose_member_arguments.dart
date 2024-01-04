import 'package:myfhb/voice_cloning/model/voice_clone_caregiver_assignment_response.dart';

class VoiceCloningChooseMemberArguments  {
  final List<VoiceCloneCaregiverAssignmentResult>? selectedFamilyMembers;
  final String voiceCloneId;

  const VoiceCloningChooseMemberArguments({
    required this.voiceCloneId,
    this.selectedFamilyMembers,
  });
}