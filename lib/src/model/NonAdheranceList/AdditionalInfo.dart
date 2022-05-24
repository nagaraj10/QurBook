class AdditionalInfo {
  AdditionalInfo({
      int age, 
      String height, 
      String offset, 
      String weight, 
      List<dynamic> language, 
      String mrdNumber, 
      String uhidNumber, 
      String visitReason, 
      String patientHistory,}){
    _age = age;
    _height = height;
    _offset = offset;
    _weight = weight;
    _language = language;
    _mrdNumber = mrdNumber;
    _uhidNumber = uhidNumber;
    _visitReason = visitReason;
    _patientHistory = patientHistory;
}

  AdditionalInfo.fromJson(dynamic json) {
    _age = json['age'];
    _height = json['height'];
    _offset = json['offset'];
    _weight = json['weight'];

    _mrdNumber = json['mrdNumber'];
    _uhidNumber = json['uhidNumber'];
    _visitReason = json['visitReason'];
    _patientHistory = json['patientHistory'];
  }
  int _age;
  String _height;
  String _offset;
  String _weight;
  List<dynamic> _language;
  String _mrdNumber;
  String _uhidNumber;
  String _visitReason;
  String _patientHistory;

  int get age => _age;
  String get height => _height;
  String get offset => _offset;
  String get weight => _weight;
  List<dynamic> get language => _language;
  String get mrdNumber => _mrdNumber;
  String get uhidNumber => _uhidNumber;
  String get visitReason => _visitReason;
  String get patientHistory => _patientHistory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['age'] = _age;
    map['height'] = _height;
    map['offset'] = _offset;
    map['weight'] = _weight;

    map['mrdNumber'] = _mrdNumber;
    map['uhidNumber'] = _uhidNumber;
    map['visitReason'] = _visitReason;
    map['patientHistory'] = _patientHistory;
    return map;
  }

}