class AddMediaRegimentModel {
  bool isSuccess;
  AddMediaRegimentResult result;

  AddMediaRegimentModel({this.isSuccess, this.result});

  AddMediaRegimentModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result = json['result'] != null
        ? AddMediaRegimentResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.toJson();
    }
    return data;
  }
}

class AddMediaRegimentResult {
  String url;
  String fileName;
  String accessUrl;

  AddMediaRegimentResult({this.url, this.fileName, this.accessUrl});

  AddMediaRegimentResult.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    fileName = json['fileName'];
    accessUrl = json['accessUrl'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['url'] = url;
    data['fileName'] = fileName;
    data['accessUrl'] = accessUrl;
    return data;
  }
}
