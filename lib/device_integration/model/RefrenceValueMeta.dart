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

    factory RefrenceValueMeta.fromJson(Map<String, dynamic> json) => RefrenceValueMeta(
        code: json['code'],
        name: json['name'],
        description: json['description'],
        /* id: json['id'],
        sortOrder: json['sortOrder'],
        isActive: json['isActive'],
        createdBy: json['createdBy'],
        createdOn: DateTime.parse(json['createdOn']),
        lastModifiedOn: json['lastModifiedOn'],*/
    );

    Map<String, dynamic> toJson() => {

        'code': code,
        'name': name,
        'description': description,

        /* 'id': id,
        'sortOrder': sortOrder,
        'isActive': isActive,
        'createdBy': createdBy,
        'createdOn': createdOn.toIso8601String(),
        'lastModifiedOn': lastModifiedOn,*/
    };
}
