/** 
 * Class for voice clone status arguments which contains
 * param that allows navigation
 */
class VoiceCloneStatusArguments {
  final bool fromMenu;
  final String? voiceCloneId;

  const VoiceCloneStatusArguments({
    required this.fromMenu,
    this.voiceCloneId,
  });
}
