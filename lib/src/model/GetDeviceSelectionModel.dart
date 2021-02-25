class GetDeviceSelectionModel {
  bool isSuccess;
  List<SelectionResult> result;

  GetDeviceSelectionModel({this.isSuccess, this.result});

  GetDeviceSelectionModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<SelectionResult>();
      json['result'].forEach((v) {
        result.add(new SelectionResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
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
        ? new ProfileSetting.fromJson(json['profileSetting'])
        : null;
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    if (this.profileSetting != null) {
      data['profileSetting'] = this.profileSetting.toJson();
    }
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bpMonitor'] = this.bpMonitor;
    data['googleFit'] = this.googleFit;
    data['healthFit'] = this.healthFit;
    data['allowDigit'] = this.allowDigit;
    data['glucoMeter'] = this.glucoMeter;
    data['weighScale'] = this.weighScale;
    data['allowDevice'] = this.allowDevice;
    data['thermoMeter'] = this.thermoMeter;
    data['pulseOximeter'] = this.pulseOximeter;
    data['priColor'] = this.preColor;
    data['greColor'] = this.greColor;
    data['preferred_language'] = this.preferred_language;
    data['qa-subscription'] = this.qa_subscription;
    return data;
  }
}