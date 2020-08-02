

class CancelMap {
  CancelMap({
    this.updationType,
    this.updatedInfo,
  });

  String updationType;
  UpdatedInfo updatedInfo;

  CancelMap.fromJson(Map<String, dynamic> json) {
    updationType=
    json["updationType"];
    updatedInfo= UpdatedInfo.fromJson(json["updatedInfo"]
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
    "updationType":this.updationType,
    "updatedInfo": this.updatedInfo.toMap()};
  }
  }

class UpdatedInfo {
  UpdatedInfo({
    this.bookingIds,
  });

  List<String> bookingIds;

  UpdatedInfo.fromJson(Map<String, dynamic> json) {
    bookingIds=
    List<String>.from(json["bookingIds"].map((x) => x));
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
    "bookingIds": List<dynamic>.from(bookingIds.map((x) => x))};
  }
}


class CancelResponse {
  CancelResponse({
    this.status,
    this.success,
    this.message,
    this.response,
  });

  int status;
  bool success;
  String message;
  dynamic response;

  CancelResponse.fromJson(Map<String, dynamic> json) {
    status =
    json["status"]
    ;
    success = json["success"];
    message = json["message"];
    response = json
    ["response"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "status": status,
      "success": success,
      "message": message,
      "response": response,
    };
  }
}
