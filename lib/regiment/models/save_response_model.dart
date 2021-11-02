class SaveResponseModel {
  SaveResponseModel({
    this.isSuccess,
    this.result,
  });

  final bool isSuccess;
  final SaveResultModel result;

  factory SaveResponseModel.fromJson(Map<String, dynamic> json) =>
      SaveResponseModel(
        isSuccess: json['isSuccess'],
        result: SaveResultModel.fromJson(json['result'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'result': result.toJson(),
      };
}

class SaveResultModel {
  SaveResultModel({
    this.eventrow,
    this.result,
    this.missing,
    this.saved,
    this.actions,
    this.hasform,
    this.evSource,
    this.ackLocal,
  });

  final dynamic eventrow;
  final dynamic result;
  final String missing;
  final bool saved;
  final Actions actions;
  final int hasform;
  final int evSource;
  final dynamic ackLocal;

  factory SaveResultModel.fromJson(Map<String, dynamic> json) =>
      SaveResultModel(
        eventrow: json['eventrow'],
        result: json['result'],
        missing: json['missing'],
        saved: json['saved'],
        actions: json['actions'] is List
            ? null
            : Actions.fromJson(json['actions'] ?? {}),
        hasform: json['hasform'],
        evSource: json['ev_source'],
        ackLocal: json['ack_local'],
      );

  Map<String, dynamic> toJson() => {
        'eventrow': eventrow.toJson(),
        'result': result.toJson(),
        'missing': missing,
        'saved': saved,
        'actions': actions.toJson(),
        'hasform': hasform,
        'ev_source': evSource,
        'ack_local': ackLocal.toIso8601String(),
      };
}

class Actions {
  Actions({
    this.type,
    this.planid,
    this.title,
    this.returnData,
  });

  final String type;
  final String planid;
  final String title;
  final ReturnModel returnData;

  factory Actions.fromJson(Map<String, dynamic> json) => Actions(
        type: json['type'],
        planid: json['planid'],
        title: json['title'],
        returnData: json['ret'] is List || json['ret'] == null
            ? null
            : ReturnModel.fromJson(json['ret'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'planid': planid,
        'title': title,
        'ret': returnData.toJson(),
      };
}

class ReturnModel {
  ReturnModel({
    this.action,
    this.message,
    this.activityName,
    this.dbg,
    this.context,
    this.eid,
  });

  final String action;
  final String message;
  final String activityName;
  final dynamic dbg;
  final String context;
  final String eid;

  factory ReturnModel.fromJson(Map<String, dynamic> json) => ReturnModel(
        action: json['Action'],
        message: json['Message'],
        activityName: json['ActivityName'],
        dbg: json['dbg'],
        context: json['context']?.toString(),
        eid: json['eid']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'Action': action,
        'Message': message,
        'ActivityName': activityName,
        'dbg': dbg.toJson(),
        'context': context,
        'eid': eid,
      };
}
