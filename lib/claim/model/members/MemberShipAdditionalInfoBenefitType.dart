import '../../../src/utils/screenutils/size_extensions.dart';

/// A class representing the additional information related to a membership benefit type.
class MemberShipAdditionalInfoBenefitType {
  String? id;
  String? code;
  String? name;
  String? fieldName;
  num? transactionLimit;

  MemberShipAdditionalInfoBenefitType({
    this.id,
    this.code,
    this.name,
    this.fieldName,
    this.transactionLimit,
  });

  factory MemberShipAdditionalInfoBenefitType.fromJson(
          Map<String, dynamic> json) =>
      MemberShipAdditionalInfoBenefitType(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        fieldName: json['fieldName'],
        transactionLimit: json['transactionLimit'].toString().parseNum(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'fieldName': fieldName,
      };
}
