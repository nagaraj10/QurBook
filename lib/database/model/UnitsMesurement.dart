import '../../constants/fhb_parameters.dart' as parameters;

class UnitsMesurements {
  int id;
  String units;
  int minValue;
  int maxValue;

  UnitsMesurements(this.id, this.units, this.minValue, this.maxValue);

  UnitsMesurements.fromJson(Map<String, dynamic> obj) {
    id = obj[parameters.strId];
    units = obj[parameters.strUnits];
    minValue = obj[parameters.strminValue];
    maxValue = obj[parameters.strmaxValue];
  }

  UnitsMesurements.map(obj) {
     id = obj[parameters.strId];
    units = obj[parameters.strUnits];
    minValue = obj[parameters.strminValue];
    maxValue = obj[parameters.strmaxValue];
  }

  Map<String, dynamic> toMap() {
    final obj = Map<String, dynamic>();

    obj[parameters.strId] = id;
    obj[parameters.strUnits] = units;
    obj[parameters.strminValue] = minValue;
    obj[parameters.strmaxValue] = maxValue;
    return obj;
  }
}
