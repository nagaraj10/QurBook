class MyPlanDetailModel {
  bool isSuccess;
  List<MyPlanDetailResult> result;

  MyPlanDetailModel({this.isSuccess,this.result});

  MyPlanDetailModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = List<MyPlanDetailResult>();
      json['result'].forEach((v) {
        result.add(MyPlanDetailResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.map((v) => v.toJson()).toList();
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
    final data = <String, dynamic>{};
    data['planid'] = planid;
    data['packageid'] = packageid;
    data['packagetitle'] = packagetitle;
    data['tplanid'] = tplanid;
    data['startdate'] = startdate;
    data['planstemplate_title'] = planstemplateTitle;
    data['planstemplate_description'] = planstemplateDescription;
    data['specid'] = specid;
    data['speciality_title'] = specialityTitle;
    data['plancatid'] = plancatid;
    data['plancategories_title'] = plancategoriesTitle;
    data['deptid'] = deptid;
    data['departments_title'] = departmentsTitle;
    data['cid'] = cid;
    data['conditions_title'] = conditionsTitle;
    data['sid'] = sid;
    data['steps_title'] = stepsTitle;
    data['plans_duration'] = plansDuration;
    data['teid_user'] = teidUser;
    data['teid'] = teid;
    data['title'] = title;
    data['description'] = description;
    data['duration'] = duration;
    data['aid'] = aid;
    data['pformid'] = pformid;
    data['pformdata'] = pformdata;
    data['uformid'] = uformid;
    data['doserepeat'] = doserepeat;
    data['mealtype'] = mealtype;
    data['befafttime'] = befafttime;
    data['daystart'] = daystart;
    data['dayrepeat'] = dayrepeat;
    data['weekrepeat'] = weekrepeat;
    data['remindin'] = remindin;
    data['remindin_type'] = remindinType;
    data['ev_duration'] = evDuration;
    data['providerid'] = providerid;
    data['providername'] = providername;
    data['titletext'] = titletext;
    data['repeattext'] = repeattext;
    return data;
  }
}