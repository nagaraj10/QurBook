class AddMediaRegimentModel {
  bool isSuccess;
  AddMediaRegimentResult result;

  AddMediaRegimentModel({this.isSuccess, this.result});

  AddMediaRegimentModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result = json['result'] != null
        ? new AddMediaRegimentResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['fileName'] = this.fileName;
    data['accessUrl'] = this.accessUrl;
    return data;
  }
}
