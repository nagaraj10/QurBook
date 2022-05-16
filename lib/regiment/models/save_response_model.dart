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

  Map<String, dynamic> toJson() =>
      {
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

  Map<String, dynamic> toJson() =>
      {
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
    this.input
  });

  final String type;
  final String planid;
  final String title;
  final ReturnModel returnData;
  Input input;

  factory Actions.fromJson(Map<String, dynamic> json) =>
      Actions(
        type: json['type'],
        planid: json['planid'],
        title: json['title'],
        returnData: json['ret'] is List || json['ret'] == null
            ? null
            : ReturnModel.fromJson(json['ret'] ?? {}),
        input: json['input'] != null ? new Input.fromJson(json['input']) : null,
      );

  Map<String, dynamic> toJson() =>
      {
        'type': type,
        'planid': planid,
        'title': title,
        'ret': returnData.toJson(),
        'input':input.toJson(),
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

  factory ReturnModel.fromJson(Map<String, dynamic> json) =>
      ReturnModel(
        action: json['Action'],
        message: json['Message'],
        activityName: json['ActivityName'],
        dbg: json['dbg'],
        context: json['context']?.toString(),
        eid: json['eid']?.toString(),
      );

  Map<String, dynamic> toJson() =>
      {
        'Action': action,
        'Message': message,
        'ActivityName': activityName,
        'dbg': dbg.toJson(),
        'context': context,
        'eid': eid,
      };
}

class Input {
  String action;
  String ackLocal;
  String eid;
  String patientId;
  String pfPainfulUrination;
  String source;
  String uid;
  ProviderId providerId;

  Input({this.action,
    this.ackLocal,
    this.eid,
    this.patientId,
    this.pfPainfulUrination,
    this.source,
    this.uid,
    this.providerId});

  Input.fromJson(Map<String, dynamic> json) {
    action = json['Action'];
    ackLocal = json['ack_local'];
    eid = json['eid'];
    patientId = json['patientId'];
    pfPainfulUrination = json['pf_Painful_Urination'];
    source = json['source'];
    uid = json['uid'];
    providerId = json['providerId'] != null
        ? new ProviderId.fromJson(json['providerId'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Action'] = this.action;
    data['ack_local'] = this.ackLocal;
    data['eid'] = this.eid;
    data['patientId'] = this.patientId;
    data['pf_Painful_Urination'] = this.pfPainfulUrination;
    data['source'] = this.source;
    data['uid'] = this.uid;
    if (this.providerId != null) {
      data['providerId'] = this.providerId.toJson();
    }
    return data;
  }
}

class ProviderId {
  int providerId;
  String providerName;
  String linkid;

  ProviderId({this.providerId, this.providerName, this.linkid});

  ProviderId.fromJson(Map<String, dynamic> json) {
    providerId = json['providerId'];
    providerName = json['providerName'];
    linkid = json['linkid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerId'] = this.providerId;
    data['providerName'] = this.providerName;
    data['linkid'] = this.linkid;
    return data;
  }
}
