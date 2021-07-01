import '../../constants/fhb_parameters.dart';

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
