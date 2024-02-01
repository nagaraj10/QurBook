import 'dart:convert';

// DoctorFilterResponseModel doctorFilterResponseModelFromJson(String str) => DoctorFilterResponseModel.fromJson(json.decode(str));
//
// String doctorFilterResponseModelToJson(DoctorFilterResponseModel data) => json.encode(data.toJson());
//
// class DoctorFilterResponseModel {
//   bool? isSuccess;
//   DoctorFilterResult? result;
//
//   DoctorFilterResponseModel({
//     this.isSuccess,
//     this.result,
//   });
//
//   factory DoctorFilterResponseModel.fromJson(Map<String, dynamic> json) => DoctorFilterResponseModel(
//         isSuccess: json["isSuccess"],
//         result: json["result"] == null ? null : DoctorFilterResult.fromJson(json["result"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "isSuccess": isSuccess,
//         "result": result?.toJson(),
//       };
// }

// class DoctorFilterResult {
//   String? totalRecord;
//   int? currentPage;
//   int? totalPage;
//   DoctorData? data;
//
//   DoctorFilterResult({
//     this.totalRecord,
//     this.currentPage,
//     this.totalPage,
//     this.data,
//   });
//
//   factory DoctorFilterResult.fromJson(Map<String, dynamic> json) => DoctorFilterResult(
//         totalRecord: json["totalRecord"],
//         currentPage: json["currentPage"],
//         totalPage: json["totalPage"],
//         data: json["data"] == null ? null : DoctorData.fromJson(json["data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "totalRecord": totalRecord,
//         "currentPage": currentPage,
//         "totalPage": totalPage,
//         "data": data?.toJson(),
//       };
// }
//
// class DoctorData {
//   bool? isSuccess;
//   List<Entity>? entities;
//   String? totalRecordCount;
//
//   DoctorData({
//     this.isSuccess,
//     this.entities,
//     this.totalRecordCount,
//   });
//
//   factory DoctorData.fromJson(Map<String, dynamic> json) => DoctorData(
//         isSuccess: json["isSuccess"],
//         entities: json["entities"] == null ? [] : List<Entity>.from(json["entities"]!.map((x) => Entity.fromJson(x))),
//         totalRecordCount: json["totalRecordCount"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "isSuccess": isSuccess,
//         "entities": entities == null ? [] : List<dynamic>.from(entities!.map((x) => x.toJson())),
//         "totalRecordCount": totalRecordCount,
//       };
// }
//
// class Entity {
//   String? doctorId;
//   String? userId;
//   String? name;
//   String? firstName;
//   String? lastName;
//   String? specialization;
//   String? city;
//   String? state;
//   dynamic doctorReferenceId;
//   String? addressLine1;
//   String? specialty;
//   String? addressLine2;
//   String? profilePicThumbnailUrl;
//   bool? isTelehealthEnabled;
//   bool? isMciVerified;
//   String? healthOrganizationName;
//   bool? patientAssociationRequest;
//   String? doctorLanguage;
//   String? gender;
//   dynamic experience;
//
//   Entity({
//     this.doctorId,
//     this.userId,
//     this.name,
//     this.firstName,
//     this.lastName,
//     this.specialization,
//     this.city,
//     this.state,
//     this.doctorReferenceId,
//     this.addressLine1,
//     this.specialty,
//     this.addressLine2,
//     this.profilePicThumbnailUrl,
//     this.isTelehealthEnabled,
//     this.isMciVerified,
//     this.healthOrganizationName,
//     this.patientAssociationRequest,
//     this.doctorLanguage,
//     this.gender,
//     this.experience,
//   });
//
//   factory Entity.fromJson(Map<String, dynamic> json) => Entity(
//         doctorId: json["doctorId"],
//         userId: json["userId"],
//         name: json["name"],
//         firstName: json["firstName"],
//         lastName: json["lastName"],
//         specialization: json["specialization"],
//         city: json["city"],
//         state: json["state"],
//         doctorReferenceId: json["doctorReferenceId"],
//         addressLine1: json["addressLine1"],
//         specialty: json["specialty"],
//         addressLine2: json["addressLine2"],
//         profilePicThumbnailUrl: json["profilePicThumbnailUrl"],
//         isTelehealthEnabled: json["isTelehealthEnabled"],
//         isMciVerified: json["isMciVerified"],
//         healthOrganizationName: json["healthOrganizationName"],
//         patientAssociationRequest: json["patientAssociationRequest"],
//         doctorLanguage: json["doctorLanguage"],
//         gender: json["gender"],
//         experience: json["experience"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "doctorId": doctorId,
//         "userId": userId,
//         "name": name,
//         "firstName": firstName,
//         "lastName": lastName,
//         "specialization": specialization,
//         "city": city,
//         "state": state,
//         "doctorReferenceId": doctorReferenceId,
//         "addressLine1": addressLine1,
//         "specialty": specialty,
//         "addressLine2": addressLine2,
//         "profilePicThumbnailUrl": profilePicThumbnailUrl,
//         "isTelehealthEnabled": isTelehealthEnabled,
//         "isMciVerified": isMciVerified,
//         "healthOrganizationName": healthOrganizationName,
//         "patientAssociationRequest": patientAssociationRequest,
//         "doctorLanguage": doctorLanguage,
//         "gender": gender,
//         "experience": experience,
//       };
// }
