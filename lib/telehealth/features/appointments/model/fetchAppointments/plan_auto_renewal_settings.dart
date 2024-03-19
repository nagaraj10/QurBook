
class PlanAutoRenewalSettings {
    bool? isEnabled;
    int? renewalDaysBeforeExpiry;

    PlanAutoRenewalSettings({
        this.isEnabled,
        this.renewalDaysBeforeExpiry,
    });

    factory PlanAutoRenewalSettings.fromJson(Map<String, dynamic> json) => PlanAutoRenewalSettings(
        isEnabled: json["isEnabled"],
        renewalDaysBeforeExpiry: json["renewalDaysBeforeExpiry"],
    );

    Map<String, dynamic> toJson() => {
        "isEnabled": isEnabled,
        "renewalDaysBeforeExpiry": renewalDaysBeforeExpiry,
    };
}