import 'package:myfhb/src/model/user/Tags.dart';
import 'package:myfhb/src/model/CaregiverCommunicationSettings.dart';

class GetDeviceSelectionModel {
  bool isSuccess;
  List<SelectionResult> result;

  GetDeviceSelectionModel({this.isSuccess, this.result});

  GetDeviceSelectionModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = List<SelectionResult>();
      json['result'].forEach((v) {
        result.add(SelectionResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectionResult {
  String id;
  String userId;
  ProfileSetting profileSetting;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  List<Tags> tags;

  SelectionResult(
      {this.id,
      this.userId,
      this.profileSetting,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.tags});

  SelectionResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    profileSetting = json['profileSetting'] != null
        ? ProfileSetting.fromJson(json['profileSetting'])
        : null;
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    if (json['tags'] != null) {
      tags = new List<Tags>();
      json['tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toProfileSettingJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (profileSetting != null) {
      data['profileSetting'] = profileSetting.toJson();
    }
    return data;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    if (profileSetting != null) {
      data['profileSetting'] = profileSetting.toJson();
    }
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileSetting {
  bool bpMonitor;
  bool googleFit;
  bool healthFit;
  bool allowDigit;
  bool glucoMeter;
  bool weighScale;
  bool allowDevice;
  bool thermoMeter;
  bool pulseOximeter;
  bool qurhomeDefaultUI;

  int preColor;
  int greColor;
  String preferred_language;
  String qa_subscription;
  PreferredMeasurement preferredMeasurement;
  CaregiverCommunicationSetting caregiverCommunicationSetting;

  ProfileSetting(
      {this.bpMonitor,
      this.googleFit,
      this.healthFit,
      this.allowDigit,
      this.glucoMeter,
      this.weighScale,
      this.allowDevice,
      this.thermoMeter,
      this.pulseOximeter,
      this.preColor,
      this.greColor,
      this.preferred_language,
      this.qa_subscription,
      this.preferredMeasurement,
      this.caregiverCommunicationSetting});

  ProfileSetting.fromJson(Map<String, dynamic> json) {
    bpMonitor = json['bpMonitor'];
    googleFit = json['googleFit'];
    healthFit = json['healthFit'];
    allowDigit = json['allowDigit'];
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
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['googleFit'] = googleFit;
    data['healthFit'] = healthFit;
    data['glucoMeter'] = glucoMeter;
    data['allowDevice'] = allowDevice;
    data['thermoMeter'] = thermoMeter;
    data['pulseOximeter'] = pulseOximeter;
    data['priColor'] = preColor;
    data['greColor'] = greColor;
    data['preferred_language'] = preferred_language;

    if (this.preferredMeasurement != null) {
      data['preferred_measurement'] = this.preferredMeasurement.toJson();
    }
    data['qa-subscription'] = qa_subscription;
    data['qurhome_ui'] = qurhomeDefaultUI;
    if (this.caregiverCommunicationSetting != null) {
      data['caregiverCommunicationSetting'] =
          this.caregiverCommunicationSetting.toJson();
    }
    return data;
  }
}

class PreferredMeasurement {
  Height height;
  Height weight;
  Height temperature;

  PreferredMeasurement({this.height, this.weight, this.temperature});

  PreferredMeasurement.fromJson(Map<String, dynamic> json) {
    height =
        json['height'] != null ? new Height.fromJson(json['height']) : null;
    weight =
        json['weight'] != null ? new Height.fromJson(json['weight']) : null;
    temperature = json['temperature'] != null
        ? new Height.fromJson(json['temperature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.height != null) {
      data['height'] = this.height.toJson();
    }
    if (this.weight != null) {
      data['weight'] = this.weight.toJson();
    }
    if (this.temperature != null) {
      data['temperature'] = this.temperature.toJson();
    }
    return data;
  }
}

class Height {
  String unitCode;
  String unitName;

  Height({this.unitCode, this.unitName});

  Height.fromJson(Map<String, dynamic> json) {
    unitCode = json['unitCode'];
    unitName = json['unitName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitCode'] = this.unitCode;
    data['unitName'] = this.unitName;
  }
}
