import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;
class BookedByProvider {
  String? id;
  String? name;
  bool? isActive;
  DateTime? createdOn;
  DateTime? lastModifiedOn;

  BookedByProvider({
     this.id,
     this.name,
     this.isActive,
     this.createdOn,
     this.lastModifiedOn,
  });

  factory BookedByProvider.fromJson(Map<String, dynamic> json) {
    return BookedByProvider(
      id: json[parameters.strId] ?? '',
      name: json[parameters.strName] ?? '',
      isActive: json[parameters.strIsActive] ?? false,
      createdOn: json[parameters.strCreatedOn] != null ? DateTime.parse(json['createdOn']) : null,
      lastModifiedOn: json[parameters.strLastModifiedOn] != null ? DateTime.parse(json['lastModifiedOn']) : null,
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[parameters.strId]=id;
    data[parameters.strName]= name;
    data[parameters.strIsActive]=isActive;
    data[parameters.strCreatedOn]= createdOn?.toIso8601String();
    data[parameters.strLastModifiedOn]= lastModifiedOn?.toIso8601String();
    return data;
  }
}