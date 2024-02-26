
import 'plan_auto_renewal_settings.dart';

class BookedByProviderAdditionalInfo {
  int? vitalSync;
  int? alertTrigger;
  List<dynamic>? moduleAccess;
  int? activityThreshold;
  String? patientOnboardingStatus;
  PlanAutoRenewalSettings? planAutoRenewalSettings;
  bool? providerAllowedVoiceCloningModule;
  bool? superAdminAllowedVoiceCloningModule;

  BookedByProviderAdditionalInfo({
    this.vitalSync,
    this.alertTrigger,
    this.moduleAccess,
    this.activityThreshold,
    this.patientOnboardingStatus,
    this.planAutoRenewalSettings,
    this.providerAllowedVoiceCloningModule,
    this.superAdminAllowedVoiceCloningModule,
  });

  factory BookedByProviderAdditionalInfo.fromJson(Map<String, dynamic> json) =>
      BookedByProviderAdditionalInfo(
        vitalSync: json['vitalSync'],
        alertTrigger: json['alert_trigger'],
        moduleAccess: json['module-access'] == null
            ? []
            : List<dynamic>.from(json['module-access']!.map((x) => x)),
        activityThreshold: json['activity_threshold'],
        patientOnboardingStatus: json['patientOnboardingStatus']!,
        planAutoRenewalSettings: json['planAutoRenewalSettings'] == null
            ? null
            : PlanAutoRenewalSettings.fromJson(json['planAutoRenewalSettings']),
        providerAllowedVoiceCloningModule:
            json['providerAllowedVoiceCloningModule'],
        superAdminAllowedVoiceCloningModule:
            json['superAdminAllowedVoiceCloningModule'],
      );

  Map<String, dynamic> toJson() => {
        'vitalSync': vitalSync,
        'alert_trigger': alertTrigger,
        'module-access': moduleAccess == null
            ? []
            : List<dynamic>.from(moduleAccess!.map((x) => x)),
        'activity_threshold': activityThreshold,
        'patientOnboardingStatus': patientOnboardingStatus,
        'planAutoRenewalSettings': planAutoRenewalSettings?.toJson(),
        'providerAllowedVoiceCloningModule': providerAllowedVoiceCloningModule,
        'superAdminAllowedVoiceCloningModule':
            superAdminAllowedVoiceCloningModule,
      };
}