class AddNetworkModel {
  String result;
  String hubId;
  bool isSuccess;
  String message;
  Diagnostics diagnostics;

  AddNetworkModel(
      {this.result,
      this.hubId,
      this.isSuccess,
      this.message,
      this.diagnostics});

  AddNetworkModel.fromJson(Map<String, dynamic> json) {
    try {
      result = json['result'];
      hubId = json['hubId'];
      isSuccess = json['isSuccess'];
      message = json['message'];
      diagnostics = json['diagnostics'] != null
          ? new Diagnostics.fromJson(json['diagnostics'])
          : null;
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['result'] = this.result;
      data['hubId'] = this.hubId;
      data['isSuccess'] = this.isSuccess;
      data['message'] = this.message;
      if (this.diagnostics != null) {
        data['diagnostics'] = this.diagnostics.toJson();
      }
    } catch (e) {
      print(e);
    }
    return data;
  }
}

class Diagnostics {
  Diagnostics.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
