import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';

import '../../../model/user/Tags.dart';

class DeviceStatus {
  DeviceStatus({
    this.userMappingId,
    this.isdigitRecognition,
    this.isdeviceRecognition,
    this.isGFActive,
    this.isHkActive,
    this.firstTym,
    this.isBpActive,
    this.isGlActive,
    this.isOxyActive,
    this.isThActive,
    this.isWsActive,
    this.isHealthFirstTime,
    this.allowAppointmentNotification,
    this.allowSymptomsNotification,
    this.allowVitalNotification,
    this.greColor,
    this.preColor,
    this.preferred_language,
    this.qa_subscription,
    this.tagsList,
    this.preferredMeasurement,
  });

  String userMappingId = '';
  bool isdigitRecognition = true;
  bool isdeviceRecognition = true;
  bool isGFActive = false;
  bool isHkActive = false;
  bool firstTym = true;
  bool isBpActive = true;
  bool isGlActive = true;
  bool isOxyActive = true;
  bool isThActive = true;
  bool isWsActive = true;
  bool isHealthFirstTime = false;
  bool allowAppointmentNotification = true;
  bool allowSymptomsNotification = true;
  bool allowVitalNotification = true;
  String preferred_language = 'undef';
  String qa_subscription = '';
  int preColor = 0xff5e1fe0;
  int greColor = 0xff753aec;
  List<Tags> tagsList = [];
  PreferredMeasurement preferredMeasurement;
}
