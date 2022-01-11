import 'dart:convert';

FeedbackTypeModel feedbackTypeModelFromJson(String str) =>
    FeedbackTypeModel.fromJson(json.decode(str));

String feedbackTypeModelToJson(FeedbackTypeModel data) =>
    json.encode(data.toJson());

class FeedbackTypeModel {
  FeedbackTypeModel({
    this.isSuccess,
    this.result,
  });

  bool isSuccess;
  List<FeedbackCategroy> result;

  factory FeedbackTypeModel.fromJson(Map<String, dynamic> json) =>
      FeedbackTypeModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        result: json["result"] == null
            ? null
            : List<FeedbackCategroy>.from(
                json["result"].map((x) => FeedbackCategroy.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess == null ? null : isSuccess,
        "result": result == null
            ? null
            : List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class FeedbackCategroy {
  FeedbackCategroy({
    this.id,
    this.categoryName,
    this.categoryDescription,
    this.logo,
    this.isDisplay,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.createdBy,
    this.healthRecordShareDetailCollection,
    this.healthRecordTypeCollection,
  });

  String id;
  String categoryName;
  String categoryDescription;
  String logo;
  bool isDisplay;
  bool isActive;
  DateTime createdOn;
  dynamic lastModifiedOn;
  CreatedBy createdBy;
  List<dynamic> healthRecordShareDetailCollection;
  List<HealthRecordTypeCollection> healthRecordTypeCollection;

  factory FeedbackCategroy.fromJson(Map<String, dynamic> json) =>
      FeedbackCategroy(
        id: json["id"] == null ? null : json["id"],
        categoryName:
            json["categoryName"] == null ? null : json["categoryName"],
        categoryDescription: json["categoryDescription"] == null
            ? null
            : json["categoryDescription"],
        logo: json["logo"] == null ? null : json["logo"],
        isDisplay: json["isDisplay"] == null ? null : json["isDisplay"],
        isActive: json["isActive"] == null ? null : json["isActive"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        lastModifiedOn: json["lastModifiedOn"],
        createdBy: json["createdBy"] == null
            ? null
            : CreatedBy.fromJson(json["createdBy"]),
        healthRecordShareDetailCollection:
            json["healthRecordShareDetailCollection"] == null
                ? null
                : List<dynamic>.from(
                    json["healthRecordShareDetailCollection"].map((x) => x)),
        healthRecordTypeCollection: json["healthRecordTypeCollection"] == null
            ? null
            : List<HealthRecordTypeCollection>.from(
                json["healthRecordTypeCollection"]
                    .map((x) => HealthRecordTypeCollection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "categoryName": categoryName == null ? null : categoryName,
        "categoryDescription":
            categoryDescription == null ? null : categoryDescription,
        "logo": logo == null ? null : logo,
        "isDisplay": isDisplay == null ? null : isDisplay,
        "isActive": isActive == null ? null : isActive,
        "createdOn": createdOn == null ? null : createdOn.toIso8601String(),
        "lastModifiedOn": lastModifiedOn,
        // "createdBy": createdBy == null ? null : createdBy.toJson(),
        // "healthRecordShareDetailCollection":
        //     healthRecordShareDetailCollection == null
        //         ? null
        //         : List<dynamic>.from(
        //             healthRecordShareDetailCollection.map((x) => x)),
        // "healthRecordTypeCollection": healthRecordTypeCollection == null
        //     ? null
        //     : List<dynamic>.from(
        //         healthRecordTypeCollection.map((x) => x.toJson())),
      };
}

class CreatedBy {
  CreatedBy({
    this.id,
    this.name,
    this.userName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.bloodGroup,
    this.countryCode,
    this.profilePicUrl,
    this.profilePicThumbnailUrl,
    this.isTempUser,
    this.isVirtualUser,
    this.isMigrated,
    this.isClaimed,
    this.isIeUser,
    this.isEmailVerified,
    this.isCpUser,
    this.communicationPreferences,
    this.medicalPreferences,
    this.isSignedIn,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.lastModifiedBy,
    this.lastModifiedOn,
    this.providerId,
    this.additionalInfo,
  });

  String id;
  String name;
  String userName;
  String firstName;
  dynamic middleName;
  String lastName;
  dynamic gender;
  dynamic dateOfBirth;
  dynamic bloodGroup;
  dynamic countryCode;
  dynamic profilePicUrl;
  dynamic profilePicThumbnailUrl;
  dynamic isTempUser;
  dynamic isVirtualUser;
  dynamic isMigrated;
  dynamic isClaimed;
  bool isIeUser;
  dynamic isEmailVerified;
  bool isCpUser;
  dynamic communicationPreferences;
  dynamic medicalPreferences;
  bool isSignedIn;
  bool isActive;
  dynamic createdBy;
  DateTime createdOn;
  dynamic lastModifiedBy;
  dynamic lastModifiedOn;
  String providerId;
  dynamic additionalInfo;

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        userName: json["userName"] == null ? null : json["userName"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"],
        bloodGroup: json["bloodGroup"],
        countryCode: json["countryCode"],
        profilePicUrl: json["profilePicUrl"],
        profilePicThumbnailUrl: json["profilePicThumbnailUrl"],
        isTempUser: json["isTempUser"],
        isVirtualUser: json["isVirtualUser"],
        isMigrated: json["isMigrated"],
        isClaimed: json["isClaimed"],
        isIeUser: json["isIeUser"] == null ? null : json["isIeUser"],
        isEmailVerified: json["isEmailVerified"],
        isCpUser: json["isCpUser"] == null ? null : json["isCpUser"],
        communicationPreferences: json["communicationPreferences"],
        medicalPreferences: json["medicalPreferences"],
        isSignedIn: json["isSignedIn"] == null ? null : json["isSignedIn"],
        isActive: json["isActive"] == null ? null : json["isActive"],
        createdBy: json["createdBy"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        lastModifiedBy: json["lastModifiedBy"],
        lastModifiedOn: json["lastModifiedOn"],
        providerId: json["providerId"] == null ? null : json["providerId"],
        additionalInfo: json["additionalInfo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "userName": userName == null ? null : userName,
        "firstName": firstName == null ? null : firstName,
        "middleName": middleName,
        "lastName": lastName == null ? null : lastName,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "bloodGroup": bloodGroup,
        "countryCode": countryCode,
        "profilePicUrl": profilePicUrl,
        "profilePicThumbnailUrl": profilePicThumbnailUrl,
        "isTempUser": isTempUser,
        "isVirtualUser": isVirtualUser,
        "isMigrated": isMigrated,
        "isClaimed": isClaimed,
        "isIeUser": isIeUser == null ? null : isIeUser,
        "isEmailVerified": isEmailVerified,
        "isCpUser": isCpUser == null ? null : isCpUser,
        "communicationPreferences": communicationPreferences,
        "medicalPreferences": medicalPreferences,
        "isSignedIn": isSignedIn == null ? null : isSignedIn,
        "isActive": isActive == null ? null : isActive,
        "createdBy": createdBy,
        "createdOn": createdOn == null ? null : createdOn.toIso8601String(),
        "lastModifiedBy": lastModifiedBy,
        "lastModifiedOn": lastModifiedOn,
        "providerId": providerId == null ? null : providerId,
        "additionalInfo": additionalInfo,
      };
}

class HealthRecordTypeCollection {
  HealthRecordTypeCollection({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.isDisplay,
    this.isAiTranscription,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
  });

  String id;
  String name;
  String description;
  String logo;
  bool isDisplay;
  bool isAiTranscription;
  bool isActive;
  DateTime createdOn;
  DateTime lastModifiedOn;

  factory HealthRecordTypeCollection.fromJson(Map<String, dynamic> json) =>
      HealthRecordTypeCollection(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        logo: json["logo"] == null ? null : json["logo"],
        isDisplay: json["isDisplay"] == null ? null : json["isDisplay"],
        isAiTranscription: json["isAiTranscription"] == null
            ? null
            : json["isAiTranscription"],
        isActive: json["isActive"] == null ? null : json["isActive"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        lastModifiedOn: json["lastModifiedOn"] == null
            ? null
            : DateTime.parse(json["lastModifiedOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "logo": logo == null ? null : logo,
        "isDisplay": isDisplay == null ? null : isDisplay,
        "isAiTranscription":
            isAiTranscription == null ? null : isAiTranscription,
        "isActive": isActive == null ? null : isActive,
        "createdOn": createdOn == null ? null : createdOn.toIso8601String(),
        "lastModifiedOn":
            lastModifiedOn == null ? null : lastModifiedOn.toIso8601String(),
      };
}
