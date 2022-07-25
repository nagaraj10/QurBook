class AdditionalInfo {
  AdditionalInfo(
      {String chooseCategory,
      String chooseDoctor,
      String chooseHospital,
      String packageName,
      String preferredLabId,
      String preferredLabName}) {
    _chooseCategory = chooseCategory;
  }

  AdditionalInfo.fromJson(dynamic json) {
    _chooseCategory = json['choose_category'];
    _chooseDoctor = json['choose_doctor'];
    _chooseHospital = json['choose_hospital'];
    _packageName = json['package_name'];
    _preferredLabId = json['preferredLabId'];
    _preferredLabName = json['preferredLabName'];
  }
  String _chooseCategory;
  String _chooseDoctor;
  String _chooseHospital;
  String _packageName;
  String _preferredLabId;
  String _preferredLabName;

  String get chooseCategory => _chooseCategory;
  String get chooseDoctor => _chooseDoctor;
  String get chooseHospital => _chooseHospital;
  String get packageName => _packageName;
  String get preferredLabId => _preferredLabId;
  String get preferredLabName => _preferredLabName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['choose_category'] = _chooseCategory;
    map['choose_doctor'] = _chooseDoctor;
    map['choose_hospital'] = _chooseHospital;
    map['package_name'] = _packageName;
    map['preferredLabId'] = _preferredLabId;
    map['preferredLabName'] = _preferredLabName;

    return map;
  }
}
