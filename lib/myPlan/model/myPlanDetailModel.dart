class MyPlanDetailModel {
  bool isSuccess;
  List<MyPlanDetailResult> result;

  MyPlanDetailModel({this.isSuccess,this.result});

  MyPlanDetailModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<MyPlanDetailResult>();
      json['result'].forEach((v) {
        result.add(new MyPlanDetailResult.fromJson(v));
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

class MyPlanDetailResult {
  String planid;
  String packageid;
  String packagetitle;
  String tplanid;
  String startdate;
  String planstemplateTitle;
  String planstemplateDescription;
  String specid;
  String specialityTitle;
  String plancatid;
  String plancategoriesTitle;
  String deptid;
  String departmentsTitle;
  String cid;
  String conditionsTitle;
  String sid;
  String stepsTitle;
  String plansDuration;
  String teidUser;
  String teid;
  String title;
  String description;
  String duration;
  String aid;
  String pformid;
  String pformdata;
  String uformid;
  String doserepeat;
  String mealtype;
  String befafttime;
  String daystart;
  String dayrepeat;
  String weekrepeat;
  String remindin;
  String remindinType;
  String evDuration;
  String providerid;
  String providername;
  String titletext;
  String repeattext;

  MyPlanDetailResult(
      {this.planid,
        this.packageid,
        this.packagetitle,
        this.tplanid,
        this.startdate,
        this.planstemplateTitle,
        this.planstemplateDescription,
        this.specid,
        this.specialityTitle,
        this.plancatid,
        this.plancategoriesTitle,
        this.deptid,
        this.departmentsTitle,
        this.cid,
        this.conditionsTitle,
        this.sid,
        this.stepsTitle,
        this.plansDuration,
        this.teidUser,
        this.teid,
        this.title,
        this.description,
        this.duration,
        this.aid,
        this.pformid,
        this.pformdata,
        this.uformid,
        this.doserepeat,
        this.mealtype,
        this.befafttime,
        this.daystart,
        this.dayrepeat,
        this.weekrepeat,
        this.remindin,
        this.remindinType,
        this.evDuration,
        this.providerid,
        this.providername,
        this.titletext,
        this.repeattext});

  MyPlanDetailResult.fromJson(Map<String, dynamic> json) {
    planid = json['planid'];
    packageid = json['packageid'];
    packagetitle = json['packagetitle'];
    tplanid = json['tplanid'];
    startdate = json['startdate'];
    planstemplateTitle = json['planstemplate_title'];
    planstemplateDescription = json['planstemplate_description'];
    specid = json['specid'];
    specialityTitle = json['speciality_title'];
    plancatid = json['plancatid'];
    plancategoriesTitle = json['plancategories_title'];
    deptid = json['deptid'];
    departmentsTitle = json['departments_title'];
    cid = json['cid'];
    conditionsTitle = json['conditions_title'];
    sid = json['sid'];
    stepsTitle = json['steps_title'];
    plansDuration = json['plans_duration'];
    teidUser = json['teid_user'];
    teid = json['teid'];
    title = json['title'];
    description = json['description'];
    duration = json['duration'];
    aid = json['aid'];
    pformid = json['pformid'];
    pformdata = json['pformdata'];
    uformid = json['uformid'];
    doserepeat = json['doserepeat'];
    mealtype = json['mealtype'];
    befafttime = json['befafttime'];
    daystart = json['daystart'];
    dayrepeat = json['dayrepeat'];
    weekrepeat = json['weekrepeat'];
    remindin = json['remindin'];
    remindinType = json['remindin_type'];
    evDuration = json['ev_duration'];
    providerid = json['providerid'];
    providername = json['providername'];
    titletext = json['titletext'];
    repeattext = json['repeattext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planid'] = this.planid;
    data['packageid'] = this.packageid;
    data['packagetitle'] = this.packagetitle;
    data['tplanid'] = this.tplanid;
    data['startdate'] = this.startdate;
    data['planstemplate_title'] = this.planstemplateTitle;
    data['planstemplate_description'] = this.planstemplateDescription;
    data['specid'] = this.specid;
    data['speciality_title'] = this.specialityTitle;
    data['plancatid'] = this.plancatid;
    data['plancategories_title'] = this.plancategoriesTitle;
    data['deptid'] = this.deptid;
    data['departments_title'] = this.departmentsTitle;
    data['cid'] = this.cid;
    data['conditions_title'] = this.conditionsTitle;
    data['sid'] = this.sid;
    data['steps_title'] = this.stepsTitle;
    data['plans_duration'] = this.plansDuration;
    data['teid_user'] = this.teidUser;
    data['teid'] = this.teid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['aid'] = this.aid;
    data['pformid'] = this.pformid;
    data['pformdata'] = this.pformdata;
    data['uformid'] = this.uformid;
    data['doserepeat'] = this.doserepeat;
    data['mealtype'] = this.mealtype;
    data['befafttime'] = this.befafttime;
    data['daystart'] = this.daystart;
    data['dayrepeat'] = this.dayrepeat;
    data['weekrepeat'] = this.weekrepeat;
    data['remindin'] = this.remindin;
    data['remindin_type'] = this.remindinType;
    data['ev_duration'] = this.evDuration;
    data['providerid'] = this.providerid;
    data['providername'] = this.providername;
    data['titletext'] = this.titletext;
    data['repeattext'] = this.repeattext;
    return data;
  }
}