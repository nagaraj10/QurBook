
class ClaimSuccess {
  bool isSuccess;
  String message;
  String result;
  Diagnostics diagnostics;

  ClaimSuccess({this.isSuccess, this.message, this.result});

  ClaimSuccess.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json.containsKey('message')) message = json['message'];
    if (json.containsKey('result')) result = json['result'];
    if (json.containsKey('diagnostics')) {
      diagnostics = json['diagnostics'] != null
          ? Diagnostics.fromJson(json['diagnostics'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (message != null) {
      data['message'] = this.message;
    }
    if (result != null) {
      data['result'] = this.result;
    }
    if (diagnostics != null) {
      data['diagnostics'] = diagnostics.toJson();
    }
    return data;
  }
}

class Diagnostics {
  String message;

  Diagnostics({this.message});

  Diagnostics.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
