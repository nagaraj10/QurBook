class MedicineNameResult {
  MedicineNameResult({
    this.id,
    this.name,
    this.description,
    this.isGeneric,
    this.isDoctorCreated,
    this.strength,
    this.category,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
  });

  String id;
  String name;
  String description;
  bool isGeneric;
  bool isDoctorCreated;
  dynamic strength;
  String category;
  bool isActive;
  DateTime createdOn;
  dynamic lastModifiedOn;

  factory MedicineNameResult.fromJson(Map<String, dynamic> json) =>
      MedicineNameResult(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isGeneric: json["isGeneric"],
        isDoctorCreated: json["isDoctorCreated"],
        strength: json["strength"],
        category: json["category"],
        isActive: json["isActive"],
        createdOn: DateTime.parse(json["createdOn"]),
        lastModifiedOn: json["lastModifiedOn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "isGeneric": isGeneric,
        "isDoctorCreated": isDoctorCreated,
        "strength": strength,
        "category": category,
        "isActive": isActive,
        "createdOn": createdOn.toIso8601String(),
        "lastModifiedOn": lastModifiedOn,
      };
}
