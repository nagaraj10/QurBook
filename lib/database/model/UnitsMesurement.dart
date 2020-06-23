class UnitsMesurements {
  int id;
  String units;
  int minValue;
  int maxValue;

  UnitsMesurements(this.id, this.units, this.minValue, this.maxValue);

  UnitsMesurements.fromJson(Map<String, dynamic> obj) {
    id = obj["id"];
    units = obj["units"];
    minValue = obj["minValue"];
    maxValue = obj["maxValue"];
  }

  UnitsMesurements.map(dynamic obj) {
    this.id = obj["id"];
    this.units = obj["units"];
    this.minValue = obj["minValue"];
    this.maxValue = obj["maxValue"];
  }

  Map<String, dynamic> toMap() {
    var obj = new Map<String, dynamic>();

    obj["id"] = id;
    obj["units"] = units;
    obj["minValue"] = minValue;
    obj["maxValue"] = maxValue;
    return obj;
  }
}
