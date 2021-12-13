class NotificationOntapRequest {
  List<String> logIds;
  bool isMarkAllRead;

  NotificationOntapRequest({this.logIds, this.isMarkAllRead});

  NotificationOntapRequest.fromJson(Map<String, dynamic> json) {
    logIds = json['logIds'].cast<String>();
    isMarkAllRead = json['isMarkAllRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logIds'] = this.logIds;
    data['isMarkAllRead'] = this.isMarkAllRead;
    return data;
  }
}
