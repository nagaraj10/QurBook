class ProfileResponseModel {
  ProfileResponseModel({
    this.isSuccess,
    this.result,
  });

  final bool isSuccess;
  final ProfileResultModel result;

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      ProfileResponseModel(
        isSuccess: json["isSuccess"],
        result: ProfileResultModel.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "result": result.toJson(),
      };
}

class ProfileResultModel {
  ProfileResultModel({
    this.uid,
    this.phoneNumber,
    this.email,
    this.givenName,
    this.nick,
    this.ulinkid,
    this.familyName,
    this.profileData,
    this.metadata,
  });

  final String uid;
  final String phoneNumber;
  final String email;
  final String givenName;
  final String nick;
  final String ulinkid;
  final String familyName;
  final ProfileDataModel profileData;
  final dynamic metadata;

  factory ProfileResultModel.fromJson(Map<String, dynamic> json) =>
      ProfileResultModel(
        uid: json["uid"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        givenName: json["given_name"],
        nick: json["nick"],
        ulinkid: json["ulinkid"],
        familyName: json["family_name"],
        profileData: ProfileDataModel.fromJson(json["profile"]),
        metadata: json["metadata"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "phone_number": phoneNumber,
        "email": email,
        "given_name": givenName,
        "nick": nick,
        "ulinkid": ulinkid,
        "family_name": familyName,
        "profile": profileData.toJson(),
        "metadata": metadata,
      };
}

class ProfileDataModel {
  ProfileDataModel({
    this.age,
    this.height,
    this.language,
    this.wakeup,
    this.breakfast,
    this.lunch,
    this.tea,
    this.dinner,
    this.sleep,
  });

  final String age;
  final String height;
  final String language;
  final String wakeup;
  final String breakfast;
  final String lunch;
  final String tea;
  final String dinner;
  final String sleep;

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) =>
      ProfileDataModel(
        age: json["Age"],
        height: json["Height"],
        language: json["Language"],
        wakeup: json["Wakeup"],
        breakfast: json["Breakfast"],
        lunch: json["Lunch"],
        tea: json["Tea"],
        dinner: json["Dinner"],
        sleep: json["Sleep"],
      );

  Map<String, dynamic> toJson() => {
        "Wakeup": wakeup,
        "Breakfast": breakfast,
        "Lunch": lunch,
        "Tea": tea,
        "Dinner": dinner,
        "Sleep": sleep,
      };
}
