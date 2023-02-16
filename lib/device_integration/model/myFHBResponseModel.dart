
import 'dart:convert';

import '../../constants/fhb_parameters.dart';

LastSync lastSyncFromJson(String str) => LastSync.fromJson(json.decode(str));

String lastSyncToJson(LastSync data) => json.encode(data.toJson());

class LastSync {
  LastSync({
    this.isSuccess,
    this.result,
  });

  bool? isSuccess;
  List<LastSyncResult>? result;

  factory LastSync.fromJson(Map<String, dynamic> json) => LastSync(
        isSuccess: json[is_Success],
        result:
            List<LastSyncResult>.from(json[dataResult].map((x) => LastSyncResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        is_Success: isSuccess,
        dataResult: List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class LastSyncResult {
  LastSyncResult({
    this.lastSyncDateTime,
    this.devicedatatype,
    this.devicetype,
    this.sourcetype,
  });

  DateTime? lastSyncDateTime;
  String? devicedatatype;
  String? devicetype;
  String? sourcetype;

  factory LastSyncResult.fromJson(Map<String, dynamic> json) => LastSyncResult(
        lastSyncDateTime: DateTime.parse(json[strlastSyncDateTime]),
        devicedatatype: json[strdeviceDataType.toLowerCase()],
        devicetype: json[strdeviceType.toLowerCase()],
        sourcetype: json[strsourcetype],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastSyncDateTime,
        strdeviceDataType.toLowerCase(): devicedatatype,
        strdeviceType.toLowerCase(): devicetype,
        strsourcetype: sourcetype,
      };
}
