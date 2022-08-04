class SheelaArgument {
  final bool isSheelaAskForLang;
  final String langCode;
  final String sheelaInputs;
  final String rawMessage;
  final bool takeActiveDeviceReadings;
  final bool isFromBpReading;
  final bool scheduleAppointment;
  final eId;
  final bool showUnreadMessage;
  final bool isJumperDevice;
  final String deviceType;
  final bool isSheelaFollowup;
  final String message;
  SheelaArgument({
    this.isSheelaAskForLang,
    this.langCode,
    this.sheelaInputs,
    this.rawMessage,
    this.takeActiveDeviceReadings = false,
    this.isFromBpReading = false,
    this.scheduleAppointment = false,
    this.eId,
    this.showUnreadMessage = false,
    this.isJumperDevice = false,
    this.deviceType,
    this.isSheelaFollowup=false,
    this.message,
  });
}
