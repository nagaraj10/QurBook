import 'package:myfhb/ticket_support/model/ticket_types_model.dart';

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
    _preferredTime = json['preferredTime'];
    _modeOfService = json['modeOfService'] != null ? new FieldData.fromJson(json['modeOfService']) : null;
  }

  String _chooseCategory;
  String _chooseDoctor;
  String _chooseHospital;
  String _packageName;
  String _preferredLabId;
  String _preferredLabName;
  String _preferredTime;
  FieldData _modeOfService;

  String get chooseCategory => _chooseCategory;
  String get chooseDoctor => _chooseDoctor;
  String get chooseHospital => _chooseHospital;
  String get packageName => _packageName;
  String get preferredLabId => _preferredLabId;
  String get preferredLabName => _preferredLabName;
  String get preferredTime => _preferredTime;
  FieldData get modeOfService => _modeOfService;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['choose_category'] = _chooseCategory;
    map['choose_doctor'] = _chooseDoctor;
    map['choose_hospital'] = _chooseHospital;
    map['package_name'] = _packageName;
    map['preferredLabId'] = _preferredLabId;
    map['preferredLabName'] = _preferredLabName;
    map['preferredTime'] = _preferredTime;
    if (this._modeOfService != null) {
      map['modeOfService'] = this._modeOfService.toJson();
    }

    return map;
  }
}
