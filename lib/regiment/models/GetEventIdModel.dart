class GetEventIdModel {
  bool isSuccess;
  Result result;

  GetEventIdModel({this.isSuccess, this.result});

  GetEventIdModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
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

class Result {
  dynamic eid;
  dynamic providerid;
  dynamic title;
  dynamic description;
  dynamic tplanid;
  dynamic teidUser;
  dynamic aid;
  dynamic activityname;
  dynamic pformid;
  dynamic uformid;
  dynamic uformname;
  dynamic estart;
  dynamic eend;
  dynamic html;
  dynamic otherinfo;
  dynamic remindin;
  dynamic remindinType;
  dynamic ack;
  dynamic alarm;
  dynamic uformdata;
  dynamic ts;
  dynamic deleted;
  dynamic evDuration;
  dynamic dosemeal;
  dynamic pformname;
  dynamic pformdata;
  dynamic pplanid;
  dynamic evDisabled;
  dynamic importance;
  dynamic evMuted;
  dynamic evSource;
  dynamic points;
  dynamic ackLocal;
  dynamic remindbefore;
  dynamic remindbeforeType;
  dynamic custform;
  dynamic langTitle;
  dynamic doserepeat;
  dynamic issymptom;
  dynamic disabled;
  dynamic pform;
  dynamic uform;
  dynamic alertdata;
  dynamic isSymptom;

  Result(
      {this.eid,
        this.providerid,
        this.title,
        this.description,
        this.tplanid,
        this.teidUser,
        this.aid,
        this.activityname,
        this.pformid,
        this.uformid,
        this.uformname,
        this.estart,
        this.eend,
        this.html,
        this.otherinfo,
        this.remindin,
        this.remindinType,
        this.ack,
        this.alarm,
        this.uformdata,
        this.ts,
        this.deleted,
        this.evDuration,
        this.dosemeal,
        this.pformname,
        this.pformdata,
        this.pplanid,
        this.evDisabled,
        this.importance,
        this.evMuted,
        this.evSource,
        this.points,
        this.ackLocal,
        this.remindbefore,
        this.remindbeforeType,
        this.custform,
        this.langTitle,
        this.doserepeat,
        this.issymptom,
        this.disabled,
        this.pform,
        this.uform,
        this.alertdata,
        this.isSymptom});

  Result.fromJson(Map<String, dynamic> json) {
    eid = json['eid'];
    providerid = json['providerid'];
    title = json['title'];
    description = json['description'];
    tplanid = json['tplanid'];
    teidUser = json['teidUser'];
    aid = json['aid'];
    activityname = json['activityname'];
    pformid = json['pformid'];
    uformid = json['uformid'];
    uformname = json['uformname'];
    estart = json['estart'];
    eend = json['eend'];
    html = json['html'];
    otherinfo = json['otherinfo'];
    remindin = json['remindin'];
    remindinType = json['remindinType'];
    ack = json['ack'];
    alarm = json['alarm'];
    uformdata = json['uformdata'];
    ts = json['ts'];
    deleted = json['deleted'];
    evDuration = json['evDuration'];
    dosemeal = json['dosemeal'];
    pformname = json['pformname'];
    pformdata = json['pformdata'];
    pplanid = json['pplanid'];
    evDisabled = json['evDisabled'];
    importance = json['importance'];
    evMuted = json['evMuted'];
    evSource = json['evSource'];
    points = json['points'];
    ackLocal = json['ackLocal'];
    remindbefore = json['remindbefore'];
    remindbeforeType = json['remindbeforeType'];
    custform = json['custform'];
    langTitle = json['langTitle'];
    doserepeat = json['doserepeat'];
    issymptom = json['issymptom'];
    disabled = json['disabled'];
    pform = json['pform'];
    uform = json['uform'];
    alertdata = json['alertdata'];
    isSymptom = json['isSymptom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eid'] = this.eid;
    data['providerid'] = this.providerid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['tplanid'] = this.tplanid;
    data['teidUser'] = this.teidUser;
    data['aid'] = this.aid;
    data['activityname'] = this.activityname;
    data['pformid'] = this.pformid;
    data['uformid'] = this.uformid;
    data['uformname'] = this.uformname;
    data['estart'] = this.estart;
    data['eend'] = this.eend;
    data['html'] = this.html;
    data['otherinfo'] = this.otherinfo;
    data['remindin'] = this.remindin;
    data['remindinType'] = this.remindinType;
    data['ack'] = this.ack;
    data['alarm'] = this.alarm;
    data['uformdata'] = this.uformdata;
    data['ts'] = this.ts;
    data['deleted'] = this.deleted;
    data['evDuration'] = this.evDuration;
    data['dosemeal'] = this.dosemeal;
    data['pformname'] = this.pformname;
    data['pformdata'] = this.pformdata;
    data['pplanid'] = this.pplanid;
    data['evDisabled'] = this.evDisabled;
    data['importance'] = this.importance;
    data['evMuted'] = this.evMuted;
    data['evSource'] = this.evSource;
    data['points'] = this.points;
    data['ackLocal'] = this.ackLocal;
    data['remindbefore'] = this.remindbefore;
    data['remindbeforeType'] = this.remindbeforeType;
    data['custform'] = this.custform;
    data['langTitle'] = this.langTitle;
    data['doserepeat'] = this.doserepeat;
    data['issymptom'] = this.issymptom;
    data['disabled'] = this.disabled;
    data['pform'] = this.pform;
    data['uform'] = this.uform;
    data['alertdata'] = this.alertdata;
    data['isSymptom'] = this.isSymptom;
    return data;
  }
}