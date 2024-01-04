class VoiceCloningChooseMemberArguments  {
  final List<String>? selectedFamilyMembers;
  final String voiceCloneId;

  const VoiceCloningChooseMemberArguments({
    required this.voiceCloneId,
    this.selectedFamilyMembers,
  });
}