class RefrenceValueMeta {
  RefrenceValueMeta({
    this.id,
    this.code,
    this.name,
    this.description,
    this.sortOrder,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.lastModifiedOn,
  });

  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  DateTime createdOn;
  dynamic lastModifiedOn;

  factory RefrenceValueMeta.fromJson(Map<String, dynamic> json) =>
      RefrenceValueMeta(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        description: json['description'],
        sortOrder: json['sortOrder'],
        isActive: json['isActive'],
        createdBy: json['createdBy'],
        createdOn: json['createdOn'] != null
            ? DateTime.tryParse(json['createdOn'])
            : null,
        lastModifiedOn: json['lastModifiedOn'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'description': description,
        'sortOrder': sortOrder,
        'isActive': isActive,
        'createdBy': createdBy,
        'createdOn': createdOn.toIso8601String(),
        'lastModifiedOn': lastModifiedOn,
      };
}
