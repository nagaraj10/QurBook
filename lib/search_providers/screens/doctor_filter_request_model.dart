import 'dart:convert';

DoctorFilterRequestModel doctorFilterRequestModelFromJson(String str) => DoctorFilterRequestModel.fromJson(json.decode(str));

String doctorFilterRequestModelToJson(DoctorFilterRequestModel data) => json.encode(data.toJson());

class DoctorFilterRequestModel {
  int? page;
  int? size;
  String? searchText;
  List<Filter>? filters;
  String? healthOrganizationType;

  DoctorFilterRequestModel({
    this.page,
    this.size,
    this.searchText,
    this.filters,
    this.healthOrganizationType,
  });

  factory DoctorFilterRequestModel.fromJson(Map<String, dynamic> json) => DoctorFilterRequestModel(
        page: json["page"],
        size: json["size"],
        searchText: json["searchText"],
        filters: json["filters"] == null ? [] : List<Filter>.from(json["filters"]!.map((x) => Filter.fromJson(x))),
        healthOrganizationType: json["healthOrganizationType"],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "page": page,
      "size": size,
      "searchText": searchText,
      "filters": filters == null ? [] : List<dynamic>.from(filters!.map((x) => x.toJson())),
    };
    // Only include healthOrganizationType if it's not null
    if (healthOrganizationType != null) {
      json["healthOrganizationType"] = healthOrganizationType;
    }

    return json;
  }
}

class Filter {
  String? field;
  dynamic value;
  String? type;

  Filter({
    this.field,
    this.value,
    this.type,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        field: json["field"],
        value: json["value"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "field": field,
        "value": value,
        "type": type,
      };
}

class ValueClass {
  int? min;
  int? max;

  ValueClass({
    this.min,
    this.max,
  });

  factory ValueClass.fromJson(Map<String, dynamic> json) => ValueClass(
        min: json["min"],
        max: json["max"],
      );

  Map<String, dynamic> toJson() => {
        "min": min,
        "max": max,
      };
}
