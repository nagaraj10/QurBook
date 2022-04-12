class SymptomsListModel {
  bool isSuccess;
  Result result;

  SymptomsListModel({this.isSuccess, this.result});

  SymptomsListModel.fromJson(Map<String, dynamic> json) {
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
  int totalRecord;
  String currentPage;
  int totalPage;
  List<SymptomListData> data;

  Result({this.totalRecord, this.currentPage, this.totalPage, this.data});

  Result.fromJson(Map<String, dynamic> json) {
    totalRecord = json['totalRecord'];
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      data = <SymptomListData>[];
      json['data'].forEach((v) {
        data.add(new SymptomListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalRecord'] = this.totalRecord;
    data['currentPage'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SymptomListData {
  int eid;
  int providerid;
  int uid;
  String title;
  String description;
  int tplanid;
  int teidUser;
  int aid;
  String activityname;
  int pformid;
  int uformid;
  String uformname;
  String estart;
  String eend;
  String html;
  String otherinfo;
  int remindin;
  int remindinType;
  String ack;
  int alarm;
  String uformdata;
  String ts;
  int deleted;
  int evDuration;
  int dosemeal;
  String pformname;
  String pformdata;
  int pplanid;
  int evDisabled;
  int importance;
  int evMuted;
  int evSource;
  int points;
  String ackLocal;
  int remindbefore;
  int remindbeforeType;
  String custform;
  String langTitle;
  int doserepeat;
  int issymptom;
  int disabled;
  String pform;
  String uform;
  String alertdata;
  Providers providers;
  var planTemplate;
  List<Fields> fields;
  List<Doneevents> doneevents;
  String doeventUserTemplateCustform;
  String doeventUserTemplateHtml;
  PersonalPlanCollection personalPlanCollection;
  int isCustomized;
  String doeventsTemplateUserTs;
  List<Forms> forms;

  SymptomListData(
      {this.eid,
        this.providerid,
        this.uid,
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
        this.providers,
        this.planTemplate,
        this.fields,
        this.doneevents,
        this.doeventUserTemplateCustform,
        this.doeventUserTemplateHtml,
        this.personalPlanCollection,
        this.isCustomized,
        this.doeventsTemplateUserTs,
        this.forms});

  SymptomListData.fromJson(Map<String, dynamic> json) {
    eid = json['eid'];
    providerid = json['providerid'];
    uid = json['uid'];
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
    providers = json['providers'] != null
        ? new Providers.fromJson(json['providers'])
        : null;
    planTemplate = json['planTemplate'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields.add(new Fields.fromJson(v));
      });
    }
    if (json['doneevents'] != null) {
      doneevents = <Doneevents>[];
      json['doneevents'].forEach((v) {
        doneevents.add(new Doneevents.fromJson(v));
      });
    }
    doeventUserTemplateCustform = json['doevent_userTemplate_custform'];
    doeventUserTemplateHtml = json['doevent_userTemplate_html'];
    personalPlanCollection = json['personalPlanCollection'] != null
        ? new PersonalPlanCollection.fromJson(json['personalPlanCollection'])
        : null;
    isCustomized = json['isCustomized'];
    doeventsTemplateUserTs = json['doeventsTemplateUserTs'];
    if (json['forms'] != null) {
      forms = <Forms>[];
      json['forms'].forEach((v) {
        forms.add(new Forms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eid'] = this.eid;
    data['providerid'] = this.providerid;
    data['uid'] = this.uid;
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
    if (this.providers != null) {
      data['providers'] = this.providers.toJson();
    }
    data['planTemplate'] = this.planTemplate;
    if (this.fields != null) {
      data['fields'] = this.fields.map((v) => v.toJson()).toList();
    }
    if (this.doneevents = null) {
      data['doneevents'] = this.doneevents.map((v) => v.toJson()).toList();
    }
    data['doevent_userTemplate_custform'] = this.doeventUserTemplateCustform;
    data['doevent_userTemplate_html'] = this.doeventUserTemplateHtml;
    if (this.personalPlanCollection != null) {
      data['personalPlanCollection'] = this.personalPlanCollection.toJson();
    }
    data['isCustomized'] = this.isCustomized;
    data['doeventsTemplateUserTs'] = this.doeventsTemplateUserTs;
    if (this.forms != null) {
      data['forms'] = this.forms.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Providers {
  int providerid;
  String title;
  String description;
  String metadata;
  int deleted;
  String linkid;
  String ts;
  String prtags;
  var providerType;

  Providers(
      {this.providerid,
        this.title,
        this.description,
        this.metadata,
        this.deleted,
        this.linkid,
        this.ts,
        this.prtags,
        this.providerType});

  Providers.fromJson(Map<String, dynamic> json) {
    providerid = json['providerid'];
    title = json['title'];
    description = json['description'];
    metadata = json['metadata'];
    deleted = json['deleted'];
    linkid = json['linkid'];
    ts = json['ts'];
    prtags = json['prtags'];
    providerType = json['providerType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerid'] = this.providerid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['metadata'] = this.metadata;
    data['deleted'] = this.deleted;
    data['linkid'] = this.linkid;
    data['ts'] = this.ts;
    data['prtags'] = this.prtags;
    data['providerType'] = this.providerType;
    return data;
  }
}

class Fields {
  int fieldid;
  int providerid;
  int formid;
  String title;
  String description;
  int uomid;
  String fdata;
  String ftype;
  String vmin;
  String vmax;
  String amin;
  String amax;
  String validation;
  int seq;
  int depth;
  String ts;
  int deleted;

  Fields(
      {this.fieldid,
        this.providerid,
        this.formid,
        this.title,
        this.description,
        this.uomid,
        this.fdata,
        this.ftype,
        this.vmin,
        this.vmax,
        this.amin,
        this.amax,
        this.validation,
        this.seq,
        this.depth,
        this.ts,
        this.deleted});

  Fields.fromJson(Map<String, dynamic> json) {
    fieldid = json['fieldid'];
    providerid = json['providerid'];
    formid = json['formid'];
    title = json['title'];
    description = json['description'];
    uomid = json['uomid'];
    fdata = json['fdata'];
    ftype = json['ftype'];
    vmin = json['vmin'];
    vmax = json['vmax'];
    amin = json['amin'];
    amax = json['amax'];
    validation = json['validation'];
    seq = json['seq'];
    depth = json['depth'];
    ts = json['ts'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldid'] = this.fieldid;
    data['providerid'] = this.providerid;
    data['formid'] = this.formid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['uomid'] = this.uomid;
    data['fdata'] = this.fdata;
    data['ftype'] = this.ftype;
    data['vmin'] = this.vmin;
    data['vmax'] = this.vmax;
    data['amin'] = this.amin;
    data['amax'] = this.amax;
    data['validation'] = this.validation;
    data['seq'] = this.seq;
    data['depth'] = this.depth;
    data['ts'] = this.ts;
    data['deleted'] = this.deleted;
    return data;
  }
}

class Doneevents {
  int doneid;
  int eid;
  int tplanid;
  int teidUser;
  int aid;
  String activityname;
  int pformid;
  int uformid;
  String uformname;
  int alarm;
  String uformdata;
  String otherinfo;
  int remindin;
  int remindinType;
  String ts;
  int deleted;
  int evDuration;
  int dosemeal;
  int isUnDone;
  int pplanid;
  int importance;
  int evSource;
  int points;
  String ackLocal;
  int remindbefore;
  int remindbeforeType;
  int evDisabled;
  int evMuted;
  String custform;
  String langTitle;
  int doserepeat;
  int issymptom;
  int disabled;
  String pform;
  String uform;
  String alertdata;
  String ack;
  int parentTplanid;
  String description;

  Doneevents(
      {this.doneid,
        this.eid,
        this.tplanid,
        this.teidUser,
        this.aid,
        this.activityname,
        this.pformid,
        this.uformid,
        this.uformname,
        this.alarm,
        this.uformdata,
        this.otherinfo,
        this.remindin,
        this.remindinType,
        this.ts,
        this.deleted,
        this.evDuration,
        this.dosemeal,
        this.isUnDone,
        this.pplanid,
        this.importance,
        this.evSource,
        this.points,
        this.ackLocal,
        this.remindbefore,
        this.remindbeforeType,
        this.evDisabled,
        this.evMuted,
        this.custform,
        this.langTitle,
        this.doserepeat,
        this.issymptom,
        this.disabled,
        this.pform,
        this.uform,
        this.alertdata,
        this.ack,
        this.parentTplanid,
        this.description});

  Doneevents.fromJson(Map<String, dynamic> json) {
    doneid = json['doneid'];
    eid = json['eid'];
    tplanid = json['tplanid'];
    teidUser = json['teidUser'];
    aid = json['aid'];
    activityname = json['activityname'];
    pformid = json['pformid'];
    uformid = json['uformid'];
    uformname = json['uformname'];
    alarm = json['alarm'];
    uformdata = json['uformdata'];
    otherinfo = json['otherinfo'];
    remindin = json['remindin'];
    remindinType = json['remindinType'];
    ts = json['ts'];
    deleted = json['deleted'];
    evDuration = json['evDuration'];
    dosemeal = json['dosemeal'];
    isUnDone = json['isUnDone'];
    pplanid = json['pplanid'];
    importance = json['importance'];
    evSource = json['evSource'];
    points = json['points'];
    ackLocal = json['ackLocal'];
    remindbefore = json['remindbefore'];
    remindbeforeType = json['remindbeforeType'];
    evDisabled = json['evDisabled'];
    evMuted = json['evMuted'];
    custform = json['custform'];
    langTitle = json['langTitle'];
    doserepeat = json['doserepeat'];
    issymptom = json['issymptom'];
    disabled = json['disabled'];
    pform = json['pform'];
    uform = json['uform'];
    alertdata = json['alertdata'];
    ack = json['ack'];
    parentTplanid = json['parentTplanid'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doneid'] = this.doneid;
    data['eid'] = this.eid;
    data['tplanid'] = this.tplanid;
    data['teidUser'] = this.teidUser;
    data['aid'] = this.aid;
    data['activityname'] = this.activityname;
    data['pformid'] = this.pformid;
    data['uformid'] = this.uformid;
    data['uformname'] = this.uformname;
    data['alarm'] = this.alarm;
    data['uformdata'] = this.uformdata;
    data['otherinfo'] = this.otherinfo;
    data['remindin'] = this.remindin;
    data['remindinType'] = this.remindinType;
    data['ts'] = this.ts;
    data['deleted'] = this.deleted;
    data['evDuration'] = this.evDuration;
    data['dosemeal'] = this.dosemeal;
    data['isUnDone'] = this.isUnDone;
    data['pplanid'] = this.pplanid;
    data['importance'] = this.importance;
    data['evSource'] = this.evSource;
    data['points'] = this.points;
    data['ackLocal'] = this.ackLocal;
    data['remindbefore'] = this.remindbefore;
    data['remindbeforeType'] = this.remindbeforeType;
    data['evDisabled'] = this.evDisabled;
    data['evMuted'] = this.evMuted;
    data['custform'] = this.custform;
    data['langTitle'] = this.langTitle;
    data['doserepeat'] = this.doserepeat;
    data['issymptom'] = this.issymptom;
    data['disabled'] = this.disabled;
    data['pform'] = this.pform;
    data['uform'] = this.uform;
    data['alertdata'] = this.alertdata;
    data['ack'] = this.ack;
    data['parentTplanid'] = this.parentTplanid;
    data['description'] = this.description;
    return data;
  }
}

class PersonalPlanCollection {
  int pplanid;
  int providerid;
  String title;
  String description;
  int uid;
  String startdate;
  int packageduration;
  int seq;
  int depth;
  String ts;
  int deleted;
  String metadata;

  PersonalPlanCollection(
      {this.pplanid,
        this.providerid,
        this.title,
        this.description,
        this.uid,
        this.startdate,
        this.packageduration,
        this.seq,
        this.depth,
        this.ts,
        this.deleted,
        this.metadata});

  PersonalPlanCollection.fromJson(Map<String, dynamic> json) {
    pplanid = json['pplanid'];
    providerid = json['providerid'];
    title = json['title'];
    description = json['description'];
    uid = json['uid'];
    startdate = json['startdate'];
    packageduration = json['packageduration'];
    seq = json['seq'];
    depth = json['depth'];
    ts = json['ts'];
    deleted = json['deleted'];
    metadata = json['metadata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pplanid'] = this.pplanid;
    data['providerid'] = this.providerid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['uid'] = this.uid;
    data['startdate'] = this.startdate;
    data['packageduration'] = this.packageduration;
    data['seq'] = this.seq;
    data['depth'] = this.depth;
    data['ts'] = this.ts;
    data['deleted'] = this.deleted;
    data['metadata'] = this.metadata;
    return data;
  }
}

class Forms {
  int formid;
  int providerid;
  String title;
  String description;
  int aid;
  int forprovider;
  int seq;
  int depth;
  String metadata;
  String ts;
  int deleted;
  int fieldcount;
  int points;

  Forms(
      {this.formid,
        this.providerid,
        this.title,
        this.description,
        this.aid,
        this.forprovider,
        this.seq,
        this.depth,
        this.metadata,
        this.ts,
        this.deleted,
        this.fieldcount,
        this.points});

  Forms.fromJson(Map<String, dynamic> json) {
    formid = json['formid'];
    providerid = json['providerid'];
    title = json['title'];
    description = json['description'];
    aid = json['aid'];
    forprovider = json['forprovider'];
    seq = json['seq'];
    depth = json['depth'];
    metadata = json['metadata'];
    ts = json['ts'];
    deleted = json['deleted'];
    fieldcount = json['fieldcount'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formid'] = this.formid;
    data['providerid'] = this.providerid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['aid'] = this.aid;
    data['forprovider'] = this.forprovider;
    data['seq'] = this.seq;
    data['depth'] = this.depth;
    data['metadata'] = this.metadata;
    data['ts'] = this.ts;
    data['deleted'] = this.deleted;
    data['fieldcount'] = this.fieldcount;
    data['points'] = this.points;
    return data;
  }
}