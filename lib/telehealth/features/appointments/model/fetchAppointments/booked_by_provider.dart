import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:myfhb/common/CommonUtil.dart';
import 'appointment_user_address_collection.dart';
import 'booked_by_provider_additional_info.dart';
import 'booked_by_provider_business_detail.dart';

class BookedByProvider {
  String? id;
  String? name;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  BookedByProviderBusinessDetail? businessDetail;
  String? domainUrl;
  bool? isDisabled;
  dynamic communicationEmails;
  dynamic emailDomain;
  dynamic specialty;
  bool? isHealthPlansActivated;
  bool? isOptCaregiveService;
  bool? isPrivate;
  dynamic revenuePercentage;
  dynamic telehealthRevenue;
  BookedByProviderAdditionalInfo? additionalInfo;
  List<AppointmentUserAddressCollection3>? healthOrganizationAddressCollection;

  BookedByProvider({
    this.id,
    this.name,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.businessDetail,
    this.domainUrl,
    this.isDisabled,
    this.communicationEmails,
    this.emailDomain,
    this.specialty,
    this.isHealthPlansActivated,
    this.isOptCaregiveService,
    this.isPrivate,
    this.revenuePercentage,
    this.telehealthRevenue,
    this.additionalInfo,
    this.healthOrganizationAddressCollection,
  });

  BookedByProvider.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      businessDetail = json['businessDetail'] == null
          ? null
          : BookedByProviderBusinessDetail.fromJson(json['businessDetail']);
      domainUrl = json['domainUrl'];
      isDisabled = json['isDisabled'];
      communicationEmails = json['communicationEmails'];
      emailDomain = json['emailDomain'];
      specialty = json['specialty'];
      isHealthPlansActivated = json['isHealthPlansActivated'];
      isOptCaregiveService = json['isOptCaregiveService'];
      isPrivate = json['isPrivate'];
      revenuePercentage = json['revenuePercentage'];
      telehealthRevenue = json['telehealthRevenue'];
      additionalInfo = json['additionalInfo'] == null
          ? null
          : BookedByProviderAdditionalInfo.fromJson(json['additionalInfo']);
      healthOrganizationAddressCollection =
          json['healthOrganizationAddressCollection'] == null
              ? []
              : List<AppointmentUserAddressCollection3>.from(
                  json['healthOrganizationAddressCollection'].map(
                    (x) => AppointmentUserAddressCollection3.fromJson(x),
                  ),
                );
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isActive': isActive,
        'createdOn': createdOn,
        'lastModifiedOn': lastModifiedOn,
        'businessDetail': businessDetail?.toJson(),
        'domainUrl': domainUrl,
        'isDisabled': isDisabled,
        'communicationEmails': communicationEmails,
        'emailDomain': emailDomain,
        'specialty': specialty,
        'isHealthPlansActivated': isHealthPlansActivated,
        'isOptCaregiveService': isOptCaregiveService,
        'isPrivate': isPrivate,
        'revenuePercentage': revenuePercentage,
        'telehealthRevenue': telehealthRevenue,
        'additionalInfo': additionalInfo?.toJson(),
        'healthOrganizationAddressCollection':
            healthOrganizationAddressCollection == null
                ? []
                : List<AppointmentUserAddressCollection3>.from(
                    healthOrganizationAddressCollection!.map(
                      (x) => x?.toJson(),
                    ),
                  ),
      };
}
