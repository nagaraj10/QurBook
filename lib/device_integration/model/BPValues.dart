import 'package:myfhb/constants/fhb_parameters.dart';

class BPValues {
  bool isSuccess;
  List<BPResult> result;

  BPValues({this.isSuccess, this.result});

  BPValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[is_Success];
    if (json[dataResult] != null) {
      result = new List<BPResult>();
      json[dataResult].forEach((bpvalue) {
        result.add(new BPResult.fromJson(bpvalue));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[is_Success] = this.isSuccess;
    if (this.result != null) {
      data[dataResult] =
          this.result.map((bpvalue) => bpvalue.toJson()).toList();
    }
    return data;
  }
}

class BPResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  int systolic;
  int diastolic;
  String deviceId;

  BPResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.systolic,
      this.diastolic,
      this.deviceId});

  BPResult.fromJson(Map<String, dynamic> json) {
    sourceType = json[strsourcetype];
    startDateTime = json[strStartTimeStamp];
    endDateTime = json[strEndTimeStamp];
    systolic = json[strParamSystolic];
    diastolic = json[strParamDiastolic];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strsourcetype] = this.sourceType;
    data[strStartTimeStamp] = this.startDateTime;
    data[strEndTimeStamp] = this.endDateTime;
    data[strParamSystolic] = this.systolic;
    data[strParamDiastolic] = this.diastolic;
    return data;
  }
}
