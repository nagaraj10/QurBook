class AddNetworkModel {
  String result;
  String hubId;

  AddNetworkModel({this.result, this.hubId});

  AddNetworkModel.fromJson(Map<String, dynamic> json) {
    try {
      result = json['result'];
      hubId = json['hubId'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['result'] = this.result;
      data['hubId'] = this.hubId;
    } catch (e) {
      print(e);
    }
    return data;
  }
}
