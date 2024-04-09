class SheelaArgument {
  bool? isSheelaAskForLang = false;
  String? langCode;
  String? sheelaInputs;
  String? rawMessage;
  bool takeActiveDeviceReadings = false;
  bool isFromBpReading = false;
  bool scheduleAppointment = false;
  bool sheelReminder = false;
  String? eId;
  bool showUnreadMessage;
  bool isJumperDevice = false;
  String? deviceType;
  bool isSheelaFollowup;
  bool isSurvey = false;
  String? message;
  String? task;
  String? action;
  String? activityName;
  String? audioMessage;
  String? textSpeechSheela;
  String? eventType;
  String? rawTitle;
  String? others;
  String? chatMessageIdSocket;
  String? eventIdViaSheela;
  bool isRetakeSurvey = false;
  bool isNeedTranslateText = false;
  bool allowBackBtnPress = false;

  bool isNeedPreferredLangauge = false;

  bool fromRegimenByTap = false;

  bool forceManualRecord = false;

  bool hideMicButton = false;

  SheelaArgument({
    this.isSheelaAskForLang,
    this.langCode,
    this.sheelaInputs,
    this.rawMessage,
    this.takeActiveDeviceReadings = false,
    this.isFromBpReading = false,
    this.scheduleAppointment = false,
    this.sheelReminder = false,
    this.eId,
    this.showUnreadMessage = false,
    this.isJumperDevice = false,
    this.deviceType,
    this.isSheelaFollowup = false,
    this.isSurvey = false,
    this.message,
    this.task,
    this.action,
    this.activityName,
    this.audioMessage,
    this.textSpeechSheela,
    this.eventType,
    this.rawTitle,
    this.others,
    this.chatMessageIdSocket,
    this.eventIdViaSheela,
    this.isRetakeSurvey = false,
    this.isNeedTranslateText = false,
    this.allowBackBtnPress = false,
    this.isNeedPreferredLangauge = false,
    this.fromRegimenByTap = false,
    this.forceManualRecord = false,
    this.hideMicButton = false,
  });
}
