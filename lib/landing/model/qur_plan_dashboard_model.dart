class QurPlanDashboardModel {
  QurPlanDashboardModel({
    this.isSuccess,
    this.dashboardData,
  });

  final bool isSuccess;
  final DashboardModel dashboardData;

  factory QurPlanDashboardModel.fromJson(Map<String, dynamic> json) =>
      QurPlanDashboardModel(
        isSuccess: json['isSuccess'],
        dashboardData: DashboardModel.fromJson(json['result'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'result': dashboardData.toJson(),
      };
}

class DashboardModel {
  DashboardModel({
    this.activePlans,
    this.regimenDue,
    this.vitalsDetails,
    this.symptomsCheckIn,
    this.familyMember,
    this.providers,
    this.helperVideos,
  });

  final ActivePlans activePlans;
  final RegimenDue regimenDue;
  final dynamic vitalsDetails;
  final SymptomsCheckIn symptomsCheckIn;
  final FamilyMember familyMember;
  final Providers providers;
  final List<HelperVideo> helperVideos;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        activePlans: ActivePlans.fromJson(json['activePlans'] ?? {}),
        regimenDue: RegimenDue.fromJson(json['regimenDue'] ?? {}),
        vitalsDetails: json['vitalsDetails'],
        symptomsCheckIn:
            SymptomsCheckIn.fromJson(json['symptomsCheckIn'] ?? {}),
        familyMember: FamilyMember.fromJson(json['familyMember'] ?? {}),
        providers: Providers.fromJson(json['providers'] ?? {}),
        helperVideos: json['helperVideos'] != null
            ? List<HelperVideo>.from(
                json['helperVideos']?.map((x) => HelperVideo.fromJson(x ?? {})))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'activePlans': activePlans.toJson(),
        'regimenDue': regimenDue.toJson(),
        'vitalsDetails': vitalsDetails,
        'symptomsCheckIn': symptomsCheckIn.toJson(),
        'familyMember': familyMember.toJson(),
        'providers': providers.toJson(),
        'helperVideos': List<dynamic>.from(helperVideos.map((x) => x.toJson())),
      };
}

class ActivePlans {
  ActivePlans({
    this.activePlanCount,
  });

  final int activePlanCount;

  factory ActivePlans.fromJson(Map<String, dynamic> json) => ActivePlans(
        activePlanCount: json['activePlanCount'],
      );

  Map<String, dynamic> toJson() => {
        'activePlanCount': activePlanCount,
      };
}

class FamilyMember {
  FamilyMember({
    this.noOfFamilyMembers,
  });

  final int noOfFamilyMembers;

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        noOfFamilyMembers: json['noOfFamilyMembers'],
      );

  Map<String, dynamic> toJson() => {
        'noOfFamilyMembers': noOfFamilyMembers,
      };
}

class HelperVideo {
  HelperVideo({
    this.title,
    this.thumbnail,
    this.url,
  });

  final String title;
  final String thumbnail;
  final String url;

  factory HelperVideo.fromJson(Map<String, dynamic> json) => HelperVideo(
        title: json['title'],
        thumbnail: json['thumbnail'],
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'thumbnail': thumbnail,
        'url': url,
      };
}

class Providers {
  Providers({
    this.doctor,
    this.hospital,
    this.lab,
  });

  final int doctor;
  final int hospital;
  final int lab;

  factory Providers.fromJson(Map<String, dynamic> json) => Providers(
        doctor: json['doctor'],
        hospital: json['hospital'],
        lab: json['lab'],
      );

  Map<String, dynamic> toJson() => {
        'doctor': doctor,
        'hospital': hospital,
        'lab': lab,
      };
}

class RegimenDue {
  RegimenDue({
    this.activeDues,
    this.lastEnteredDateTime,
  });

  final int activeDues;
  final DateTime lastEnteredDateTime;

  factory RegimenDue.fromJson(Map<String, dynamic> json) => RegimenDue(
        activeDues: json['activeDues'],
        lastEnteredDateTime:
            DateTime.tryParse(json['lastEnteredDateTime'] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'activeDues': activeDues,
        'lastEnteredDateTime': lastEnteredDateTime.toIso8601String(),
      };
}

class SymptomsCheckIn {
  SymptomsCheckIn({
    this.eid,
    this.title,
    this.aid,
    this.activityname,
    this.estart,
    this.eend,
  });

  final int eid;
  final String title;
  final int aid;
  final String activityname;
  final DateTime estart;
  final DateTime eend;

  factory SymptomsCheckIn.fromJson(Map<String, dynamic> json) =>
      SymptomsCheckIn(
        eid: json['eid'],
        title: json['title'],
        aid: json['aid'],
        activityname: json['activityname'],
        estart: DateTime.tryParse(json['estart'] ?? ''),
        eend: DateTime.tryParse(json['eend'] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'eid': eid,
        'title': title,
        'aid': aid,
        'activityname': activityname,
        'estart': estart.toIso8601String(),
        'eend': eend.toIso8601String(),
      };
}
