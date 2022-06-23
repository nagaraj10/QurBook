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
  });
}
