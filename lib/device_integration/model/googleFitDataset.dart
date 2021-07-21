import 'googleFitPoint.dart';
import '../../constants/fhb_parameters.dart';

class Dataset {
  Dataset({
    this.dataSourceId,
    this.point,
  });

  String dataSourceId;
  List<Point> point;

  factory Dataset.fromJson(Map<String, dynamic> json) => Dataset(
        dataSourceId: json[gfdataSourceId],
        point: List<Point>.from(json[gfpoint].map((x) => Point.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        gfdataSourceId: dataSourceId,
        gfpoint: List<dynamic>.from(point.map((x) => x.toJson())),
      };
}
