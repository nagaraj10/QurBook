class NotificationOntapRequest {
  List<String> logIds;

  NotificationOntapRequest({this.logIds});

  NotificationOntapRequest.fromJson(Map<String, dynamic> json) {
    logIds = json['logIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logIds'] = this.logIds;
    return data;
  }
}
