class ReportModel {
  bool isSuccess;
  List<MyReportResult> result;

  ReportModel({this.isSuccess, this.result});

  ReportModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<MyReportResult>();
      json['result'].forEach((v) {
        result.add(new MyReportResult.fromJson(v));
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

class MyReportResult {
  String id;
  String groupId;
  String groupName;
  String reportId;
  String reportName;
  String embeddedUrl;
  String datasetId;
  List<String> roles;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  MyReportResult(
      {this.id,
        this.groupId,
        this.groupName,
        this.reportId,
        this.reportName,
        this.embeddedUrl,
        this.datasetId,
        this.roles,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  MyReportResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['groupId'];
    groupName = json['groupName'];
    reportId = json['reportId'];
    reportName = json['reportName'];
    embeddedUrl = json['embeddedUrl'];
    datasetId = json['datasetId'];
    roles = json['roles'].cast<String>();
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['groupId'] = this.groupId;
    data['groupName'] = this.groupName;
    data['reportId'] = this.reportId;
    data['reportName'] = this.reportName;
    data['embeddedUrl'] = this.embeddedUrl;
    data['datasetId'] = this.datasetId;
    data['roles'] = this.roles;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}