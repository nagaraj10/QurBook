import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/device_integration/model/googleFitDataset.dart';

class Bucket {
  Bucket({
    this.startTimeMillis,
    this.endTimeMillis,
    this.dataset,
  });

  String startTimeMillis;
  String endTimeMillis;
  List<Dataset> dataset;

  factory Bucket.fromJson(Map<String, dynamic> json) => Bucket(
        startTimeMillis: json[gfstartTimeMillis],
        endTimeMillis: json[gfendTimeMillis],
        dataset:
            List<Dataset>.from(json[gfdataset].map((x) => Dataset.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        gfstartTimeMillis: startTimeMillis,
        gfendTimeMillis: endTimeMillis,
        gfdataset: List<dynamic>.from(dataset.map((x) => x.toJson())),
      };
}
