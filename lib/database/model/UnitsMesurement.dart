import '../../constants/fhb_parameters.dart' as parameters;

class UnitsMesurements {
  int id;
  String units;
  dynamic minValue;
  dynamic maxValue;
  String range;
  UnitsMesurements(this.id, this.units, this.minValue, this.maxValue,this.range);

  UnitsMesurements.fromJson(Map<String, dynamic> obj) {
    id = obj[parameters.strId];
    units = obj[parameters.strUnits];
    minValue = obj[parameters.strminValue];
    maxValue = obj[parameters.strmaxValue];
    range = obj[parameters.strRange];
  }

  UnitsMesurements.map(obj) {
     id = obj[parameters.strId];
    units = obj[parameters.strUnits];
    minValue = obj[parameters.strminValue];
    maxValue = obj[parameters.strmaxValue];
     range = obj[parameters.strRange];

  }

  Map<String, dynamic> toMap() {
    final obj = Map<String, dynamic>();

    obj[parameters.strId] = id;
    obj[parameters.strUnits] = units;
    obj[parameters.strminValue] = minValue;
    obj[parameters.strmaxValue] = maxValue;
    obj[parameters.strRange] = range;
    return obj;
  }
}
