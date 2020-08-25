import 'package:myfhb/constants/fhb_parameters.dart';

class Value {
  Value({
    this.mapVal,
    this.fpVal,
  });

  List<dynamic> mapVal;
  var fpVal;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        mapVal: List<dynamic>.from(json[gfmapVal].map((x) => x)),
        fpVal: json[gffpVal],
      );

  Map<String, dynamic> toJson() => {
        gfmapVal: List<dynamic>.from(mapVal.map((x) => x)),
        gffpVal: fpVal,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
