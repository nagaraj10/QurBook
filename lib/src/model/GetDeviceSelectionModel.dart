import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/model/CaregiverCommunicationSettings.dart';
import 'package:myfhb/src/model/user/Tags.dart';

class GetDeviceSelectionModel {
  bool? isSuccess;
  List<SelectionResult>? result;

  GetDeviceSelectionModel({this.isSuccess, this.result});

  GetDeviceSelectionModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
        result = <SelectionResult>[];
        json['result'].forEach((v) {
          result!.add(SelectionResult.fromJson(v));
        });
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectionResult {
  String? id;
  String? userId;
  ProfileSetting? profileSetting;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  List<Tags>? tags;
  PrimaryProvider? primaryProvider;

  SelectionResult(
      {this.id,
      this.userId,
      this.profileSetting,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.tags,
      this.primaryProvider});

  SelectionResult.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      userId = json['userId'];
      profileSetting = json['profileSetting'] != null
          ? ProfileSetting.fromJson(json['profileSetting'])
          : null;
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      if (json['tags'] != null) {
        tags = <Tags>[];
        json['tags'].forEach((v) {
          tags!.add(new Tags.fromJson(v));
        });
      }
      primaryProvider = json['primaryProvider'] != null
          ? new PrimaryProvider.fromJson(json['primaryProvider'])
          : null;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toProfileSettingJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (profileSetting != null) {
      data['profileSetting'] = profileSetting!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    if (profileSetting != null) {
      data['profileSetting'] = profileSetting!.toJson();
    }
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.primaryProvider != null) {
      data['primaryProvider'] = this.primaryProvider?.toJson();
    }
    return data;
  }
}

class ProfileSetting {
  bool? bpMonitor;
  bool? googleFit;
  bool? healthFit;
  bool? allowDigit;
  bool? sheelaLiveReminders;
  bool? glucoMeter;
  bool? weighScale;
  bool? allowDevice;
  bool? thermoMeter;
  bool? pulseOximeter;
  bool? qurhomeDefaultUI;

  int? preColor;
  int? greColor;
  String? preferred_language;
  String? qa_subscription;
  String? voiceCloningStatus;
  bool? voiceCloning;

  PreferredMeasurement? preferredMeasurement;

  CaregiverCommunicationSetting? caregiverCommunicationSetting;

  ProfileSetting({
    this.bpMonitor,
    this.googleFit,
    this.healthFit,
    this.allowDigit,
    this.sheelaLiveReminders,
    this.glucoMeter,
    this.weighScale,
    this.allowDevice,
    this.thermoMeter,
    this.pulseOximeter,
    this.preColor,
    this.greColor,
    this.preferred_language,
    this.qa_subscription,
    this.caregiverCommunicationSetting,
    this.preferredMeasurement,
    this.voiceCloningStatus,
    this.voiceCloning,
  });

  ProfileSetting.fromJson(Map<String, dynamic> json) {
    try {
      bpMonitor = json['bpMonitor'];
      googleFit = json['googleFit'];
      healthFit = json['healthFit'];
      allowDigit = json['allowDigit'];
      sheelaLiveReminders = json['isSheelaLiveReminder'];
      glucoMeter = json['glucoMeter'];
      weighScale = json['weighScale'];
      allowDevice = json['allowDevice'];
      thermoMeter = json['thermoMeter'];
      pulseOximeter = json['pulseOximeter'];
      qurhomeDefaultUI = (json['qurhome_ui'] ?? false);
      preColor = json['priColor'];
      greColor = json['greColor'];
      preferred_language = json['preferred_language'];
      qa_subscription = json['qa-subscription'];
      preferredMeasurement = json['preferred_measurement'] != null
          ? new PreferredMeasurement.fromJson(json['preferred_measurement'])
          : null;
      if (json.containsKey('caregiverCommunicationSetting')) {
        caregiverCommunicationSetting =
            json['caregiverCommunicationSetting'] != null
                ? new CaregiverCommunicationSetting.fromJson(
                    json['caregiverCommunicationSetting'])
                : null;
        voiceCloningStatus =
            json['voiceCloningStatus']; //get the status of voice cloning
        voiceCloning = json[
            'voiceCloning']; // get the value if voice cloning is enabled or not
      }

      if (json.containsKey('preferred_measurement')) {
        preferredMeasurement = json['preferred_measurement'] != null
            ? new PreferredMeasurement.fromJson(json['preferred_measurement'])
            : null;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['bpMonitor'] = bpMonitor;
    data['googleFit'] = googleFit;
    data['healthFit'] = healthFit;
    data['allowDigit'] = allowDigit;
    data['isSheelaLiveReminder'] = sheelaLiveReminders;
    data['glucoMeter'] = glucoMeter;
    data['weighScale'] = weighScale;
    data['allowDevice'] = allowDevice;
    data['thermoMeter'] = thermoMeter;
    data['pulseOximeter'] = pulseOximeter;
    data['priColor'] = preColor;
    data['greColor'] = greColor;
    data['preferred_language'] = preferred_language;
    data['qa-subscription'] = qa_subscription;
    data['qurhome_ui'] = qurhomeDefaultUI;
    if (this.caregiverCommunicationSetting != null) {
      data['caregiverCommunicationSetting'] =
          this.caregiverCommunicationSetting!.toJson();
    }
    if (this.preferredMeasurement != null) {
      data['preferred_measurement'] = this.preferredMeasurement!.toJson();
    }
    data['voiceCloningStatus'] = this.voiceCloningStatus;
    data['voiceCloning'] = this.voiceCloning;

    return data;
  }
}

class PreferredMeasurement {
  Height? height;
  Height? weight;
  Height? temperature;

  PreferredMeasurement({this.height, this.weight, this.temperature});

  PreferredMeasurement.fromJson(Map<String, dynamic> json) {
    try {
      height =
          json['height'] != null ? new Height.fromJson(json['height']) : null;
      weight =
          json['weight'] != null ? new Height.fromJson(json['weight']) : null;
      temperature = json['temperature'] != null
          ? new Height.fromJson(json['temperature'])
          : null;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.height != null) {
      data['height'] = this.height!.toJson();
    }
    if (this.weight != null) {
      data['weight'] = this.weight!.toJson();
    }
    if (this.temperature != null) {
      data['temperature'] = this.temperature!.toJson();
    }
    return data;
  }
}

class Height {
  String? unitCode;
  String? unitName;

  Height({this.unitCode, this.unitName});

  Height.fromJson(Map<String, dynamic> json) {
    try {
      unitCode = json['unitCode'];
      unitName = json['unitName'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitCode'] = this.unitCode;
    data['unitName'] = this.unitName;
    return data;
  }
}

class PrimaryProvider {
  String? healthorganizationid;
  AdditionalInfoModuleAccess? additionalInfo;

  PrimaryProvider({this.healthorganizationid, this.additionalInfo});

  PrimaryProvider.fromJson(Map<String, dynamic> json) {
    try {
      healthorganizationid = json['healthorganizationid'];
      additionalInfo = json['additionalInfo'] != null
          ? new AdditionalInfoModuleAccess.fromJson(json['additionalInfo'])
          : null;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['healthorganizationid'] = this.healthorganizationid;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo?.toJson();
    }
    return data;
  }
}

class AdditionalInfoModuleAccess {
  List<ModuleAccess>? moduleAccess;
  //boolean variable to indicate whether vitals should be recorded
  bool? recordVitals;
  bool? providerAllowedVoiceCloningModule;
  bool? superAdminAllowedVoiceCloningModule;

  AdditionalInfoModuleAccess(
      {this.moduleAccess,
      this.recordVitals,
      this.providerAllowedVoiceCloningModule,
      this.superAdminAllowedVoiceCloningModule});

  AdditionalInfoModuleAccess.fromJson(Map<String, dynamic> json) {
    try {
      if (json['module-access'] != null) {
        moduleAccess = <ModuleAccess>[];
        json['module-access'].forEach((v) {
          moduleAccess?.add(new ModuleAccess.fromJson(v));
        });
      }
      // Extract and assign the 'record_vitals' value from JSON, default to false if not present
      recordVitals = (json['record_vitals'] ?? false);
      // Save the 'recordVitals' value to shared preferences
      providerAllowedVoiceCloningModule =
          json['providerAllowedVoiceCloningModule'];
      //get the value if the superadmin has enabled permisson to health organization
      superAdminAllowedVoiceCloningModule =
          json['superAdminAllowedVoiceCloningModule'];
      // get the value if the provider has enabled to caregiver

      saveIsVitalsManualRecordingRestricted(recordVitals);
    } catch (e, stackTrace) {
      // Handle exceptions by saving the 'recordVitals' value and logging the error
      saveIsVitalsManualRecordingRestricted(recordVitals);
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.moduleAccess != null) {
      data['module-access'] =
          this.moduleAccess?.map((v) => v.toJson()).toList();
    }
    data['record_vitals'] = this.recordVitals;
    data['providerAllowedVoiceCloningModule'] =
        this.providerAllowedVoiceCloningModule;
    data['superAdminAllowedVoiceCloningModule'] =
        this.superAdminAllowedVoiceCloningModule;
    return data;
  }

  // Save the boolean value indicating whether manual recording of vitals is restricted
  // to shared preferences using PreferenceUtil
  saveIsVitalsManualRecordingRestricted(bool? recordVital) {
    // Save the value to shared preferences, defaulting to false if 'recordVital' is null
    PreferenceUtil.setBool(
      KEY_IS_Vitals_ManualRecording_Restricted,
      (recordVital ?? false),
    );
  }
}

class ModuleAccess {
  String? id;
  String? name;
  String? access;

  ModuleAccess({this.id, this.name, this.access});

  ModuleAccess.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      access = json['access'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['access'] = this.access;
    return data;
  }
}
