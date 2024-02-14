/// A class representing the additional information related to a membership benefit type.
class MemberShipAdditionalInfoBenefitType {
  String? id;
  String? code;
  String? name;
  String? fieldName;
  int? transactionLimit;

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
        /// now transactionLimit can handle int and string both
        transactionLimit: int.tryParse(json['transactionLimit'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'fieldName': fieldName,
      };
}
