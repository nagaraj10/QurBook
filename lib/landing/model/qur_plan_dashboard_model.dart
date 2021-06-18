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
    this.careGiverInfo,
  });

  final ActivePlans activePlans;
  final RegimenDue regimenDue;
  final VitalsDetails vitalsDetails;
  final SymptomsCheckIn symptomsCheckIn;
  final FamilyMember familyMember;
  final Providers providers;
  final List<HelperVideo> helperVideos;
  final CareGiverInfo careGiverInfo;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        activePlans: ActivePlans.fromJson(json['activePlans'] ?? {}),
        regimenDue: RegimenDue.fromJson(json['regimenDue'] ?? {}),
        vitalsDetails: VitalsDetails.fromJson(json['vitalsDetails'] ?? {}),
        symptomsCheckIn:
            SymptomsCheckIn.fromJson(json['symptomsCheckIn'] ?? {}),
        familyMember: FamilyMember.fromJson(json['familyMember'] ?? {}),
        providers: Providers.fromJson(json['providers'] ?? {}),
        helperVideos: json['helperVideos'] != null
            ? List<HelperVideo>.from(
                json['helperVideos']?.map((x) => HelperVideo.fromJson(x ?? {})))
            : null,
        careGiverInfo: CareGiverInfo.fromJson(json['careGiverInfo'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'activePlans': activePlans.toJson(),
        'regimenDue': regimenDue.toJson(),
        'vitalsDetails': vitalsDetails.toJson(),
        'symptomsCheckIn': symptomsCheckIn.toJson(),
        'familyMember': familyMember.toJson(),
        'providers': providers.toJson(),
        'helperVideos': List<dynamic>.from(helperVideos.map((x) => x.toJson())),
        'careGiverInfo': careGiverInfo.toJson(),
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
    this.lastEventTitle,
    this.eid,
  });

  final int activeDues;
  final DateTime lastEnteredDateTime;
  final String lastEventTitle;
  final int eid;

  factory RegimenDue.fromJson(Map<String, dynamic> json) => RegimenDue(
        activeDues: json['activeDues'],
        lastEnteredDateTime: json['lastEnteredDateTime'] != null
            ? DateTime.tryParse(json['lastEnteredDateTime'] ?? '')?.toLocal()
            : null,
        lastEventTitle: json['lastEventTitle'],
        eid: json['eid'],
      );

  Map<String, dynamic> toJson() => {
        'activeDues': activeDues,
        'lastEnteredDateTime': lastEnteredDateTime.toIso8601String(),
        'lastEventTitle': lastEventTitle,
        'eid': eid,
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
    this.ack,
  });

  final int eid;
  final String title;
  final int aid;
  final String activityname;
  final DateTime estart;
  final DateTime eend;
  final DateTime ack;

  factory SymptomsCheckIn.fromJson(Map<String, dynamic> json) =>
      SymptomsCheckIn(
        eid: json['eid'],
        title: json['title'],
        aid: json['aid'],
        activityname: json['activityname'],
        estart: DateTime.tryParse(json['estart'] ?? ''),
        eend: DateTime.tryParse(json['eend'] ?? ''),
        ack: json['ack'] != null
            ? DateTime.tryParse(json['ack'] ?? '')?.toLocal()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'eid': eid,
        'title': title,
        'aid': aid,
        'activityname': activityname,
        'estart': estart.toIso8601String(),
        'eend': eend.toIso8601String(),
        'ack': ack.toIso8601String(),
      };
}

class CareGiverInfo {
  CareGiverInfo({
    this.doctorId,
    this.firstName,
    this.lastName,
    this.profilePic,
  });

  final String doctorId;
  final String firstName;
  final String lastName;
  final String profilePic;

  factory CareGiverInfo.fromJson(Map<String, dynamic> json) => CareGiverInfo(
        doctorId: json['doctorId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        profilePic: json['profilePic'],
      );

  Map<String, dynamic> toJson() => {
        'doctorId': doctorId,
        'firstName': firstName,
        'lastName': lastName,
        'profilePic': profilePic,
      };
}

class VitalsDetails {
  VitalsDetails({
    this.activeDevice,
    this.lastestDeviceInfo,
  });

  final int activeDevice;
  final LastestDeviceInfo lastestDeviceInfo;

  factory VitalsDetails.fromJson(Map<String, dynamic> json) => VitalsDetails(
        activeDevice: json['activeDevice'],
        lastestDeviceInfo:
            LastestDeviceInfo.fromJson(json['lastestDeviceInfo'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'activeDevice': activeDevice,
        'lastestDeviceInfo': lastestDeviceInfo.toJson(),
      };
}

class LastestDeviceInfo {
  LastestDeviceInfo({
    this.lastSyncDateTime,
    this.deviceName,
  });

  final DateTime lastSyncDateTime;
  final String deviceName;

  factory LastestDeviceInfo.fromJson(Map<String, dynamic> json) =>
      LastestDeviceInfo(
        lastSyncDateTime: DateTime.tryParse(json['lastSyncDateTime'] ?? ''),
        deviceName: json['deviceName'],
      );

  Map<String, dynamic> toJson() => {
        'lastSyncDateTime': lastSyncDateTime.toIso8601String(),
        'deviceName': deviceName,
      };
}
