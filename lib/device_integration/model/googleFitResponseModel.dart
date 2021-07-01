import 'dart:convert';
import '../../constants/fhb_parameters.dart';
import 'googleFitBucket.dart';

GoogleFitResponseModel ResponseFromJson(String str) =>
    GoogleFitResponseModel.fromJson(json.decode(str));

String RequestToJson(GoogleFitResponseModel data) => json.encode(data.toJson());

class GoogleFitResponseModel {
  GoogleFitResponseModel({
    this.bucket,
  });

  List<Bucket> bucket;

  factory GoogleFitResponseModel.fromJson(Map<String, dynamic> json) =>
      GoogleFitResponseModel(
        bucket:
            List<Bucket>.from(json[gfbucket].map((x) => Bucket.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        gfbucket: List<dynamic>.from(bucket.map((x) => x.toJson())),
      };
}
