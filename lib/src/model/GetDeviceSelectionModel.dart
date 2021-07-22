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

  SelectionResult(
      {this.id,
        this.userId,
        this.profileSetting,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  SelectionResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    profileSetting = json['profileSetting'] != null
        ? ProfileSetting.fromJson(json['profileSetting'])
        : null;
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
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
  int preColor;
  int greColor;
  String preferred_language;
  String qa_subscription;

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
        this.qa_subscription
      });

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
    preColor = json['priColor'];
    greColor = json['greColor'];
    preferred_language = json['preferred_language'];
    qa_subscription = json['qa-subscription'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['bpMonitor'] = bpMonitor;
    data['googleFit'] = googleFit;
    data['healthFit'] = healthFit;
    data['allowDigit'] = allowDigit;
    data['glucoMeter'] = glucoMeter;
    data['weighScale'] = weighScale;
    data['allowDevice'] = allowDevice;
    data['thermoMeter'] = thermoMeter;
    data['pulseOximeter'] = pulseOximeter;
    data['priColor'] = preColor;
    data['greColor'] = greColor;
    data['preferred_language'] = preferred_language;
    data['qa-subscription'] = qa_subscription;
    return data;
  }
}