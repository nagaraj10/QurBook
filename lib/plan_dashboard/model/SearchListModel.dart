class SearchListModel {
  bool isSuccess;
  List<SearchListResult> result;

  SearchListModel({this.isSuccess, this.result});

  SearchListModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<SearchListResult>();
      json['result'].forEach((v) {
        result.add(new SearchListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchListResult {
  String providerid;
  String title;
  String description;
  String linkid;

  SearchListResult({this.providerid, this.title, this.description, this.linkid});

  SearchListResult.fromJson(Map<String, dynamic> json) {
    providerid = json['providerid'];
    title = json['title'];
    description = json['description'];
    linkid = json['linkid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerid'] = this.providerid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['linkid'] = this.linkid;
    return data;
  }
}