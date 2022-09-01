class SheelaArgument {
  bool isSheelaAskForLang = false;
  String langCode;
  String sheelaInputs;
  String rawMessage;
  bool takeActiveDeviceReadings = false;
  bool isFromBpReading = false;
  bool scheduleAppointment = false;
  String eId;
  bool showUnreadMessage;
  bool isJumperDevice = false;
  String deviceType;
  bool isSheelaFollowup;
  String message;

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
    this.isSheelaFollowup = false,
    this.message,
  });
}
