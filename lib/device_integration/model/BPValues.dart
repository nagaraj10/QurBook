import '../../constants/fhb_parameters.dart';

class BPValues {
  bool isSuccess;
  List<BPResult> result;

  BPValues({this.isSuccess, this.result});

  BPValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[is_Success];
    if (json[dataResult] != null) {
      result = <BPResult>[];
      json[dataResult].forEach((bpvalue) {
        result.add(BPResult.fromJson(bpvalue));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[is_Success] = isSuccess;
    if (result != null) {
      data[dataResult] =
          result.map((bpvalue) => bpvalue.toJson()).toList();
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
  var bpm;
  DateTime dateTimeValue;

  BPResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.systolic,
      this.diastolic,
      this.bpm,
      this.deviceId,
      this.dateTimeValue});

  BPResult.fromJson(Map<String, dynamic> json) {
    sourceType = json[strsourcetype];
    startDateTime = json[strStartTimeStamp];
    endDateTime = json[strEndTimeStamp];
    systolic = json[strParamSystolic];
    diastolic = json[strParamDiastolic];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[strsourcetype] = sourceType;
    data[strStartTimeStamp] = startDateTime;
    data[strEndTimeStamp] = endDateTime;
    data[strParamSystolic] = systolic;
    data[strParamDiastolic] = diastolic;
    return data;
  }
}
