// To parse this JSON data, do
//
//     final createTicketModel = createTicketModelFromJson(jsonString);

import 'dart:convert';

CreateTicketModel createTicketModelFromJson(String str) => CreateTicketModel.fromJson(json.decode(str));

String createTicketModelToJson(CreateTicketModel data) => json.encode(data.toJson());

class CreateTicketModel {
  CreateTicketModel({
    this.isSuccess,
    this.result,
  });

  bool isSuccess;
  Result result;

  factory CreateTicketModel.fromJson(Map<String, dynamic> json) => CreateTicketModel(
    isSuccess: json["isSuccess"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "result": result.toJson(),
  };
}

class Result {
  Result({
    this.success,
    this.ticket,
  });

  bool success;
  Ticket ticket;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    success: json["success"],
    ticket: Ticket.fromJson(json["ticket"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "ticket": ticket.toJson(),
  };
}

class Ticket {
  Ticket({
    this.deleted,
    this.status,
    this.tags,
    this.subscribers,
    this.id,
    this.subject,
    this.issue,
    this.type,
    this.preferredDate,
    this.group,
    this.owner,
    this.date,
    this.comments,
    this.notes,
    this.attachments,
    this.history,
    this.uid,
    this.v,
  });

  bool deleted;
  int status;
  List<dynamic> tags;
  List<String> subscribers;
  String id;
  String subject;
  String issue;
  String type;
  DateTime preferredDate;
  Group group;
  Owner owner;
  DateTime date;
  List<dynamic> comments;
  List<dynamic> notes;
  List<dynamic> attachments;
  List<History> history;
  int uid;
  int v;

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    deleted: json["deleted"],
    status: json["status"],
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
    subscribers: List<String>.from(json["subscribers"].map((x) => x)),
    id: json["_id"],
    subject: json["subject"],
    issue: json["issue"],
    type: json["type"],
    preferredDate: DateTime.parse(json["preferredDate"]),
    group: Group.fromJson(json["group"]),
    owner: Owner.fromJson(json["owner"]),
    date: DateTime.parse(json["date"]),
    comments: List<dynamic>.from(json["comments"].map((x) => x)),
    notes: List<dynamic>.from(json["notes"].map((x) => x)),
    attachments: List<dynamic>.from(json["attachments"].map((x) => x)),
    history: List<History>.from(json["history"].map((x) => History.fromJson(x))),
    uid: json["uid"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "deleted": deleted,
    "status": status,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "subscribers": List<dynamic>.from(subscribers.map((x) => x)),
    "_id": id,
    "subject": subject,
    "issue": issue,
    "type": type,
    "preferredDate": preferredDate.toIso8601String(),
    "group": group.toJson(),
    "owner": owner.toJson(),
    "date": date.toIso8601String(),
    "comments": List<dynamic>.from(comments.map((x) => x)),
    "notes": List<dynamic>.from(notes.map((x) => x)),
    "attachments": List<dynamic>.from(attachments.map((x) => x)),
    "history": List<dynamic>.from(history.map((x) => x.toJson())),
    "uid": uid,
    "__v": v,
  };
}

class Group {
  Group({
    this.members,
    this.sendMailTo,
    this.public,
    this.id,
    this.name,
    this.v,
  });

  List<Member> members;
  List<dynamic> sendMailTo;
  bool public;
  String id;
  TitleEnum name;
  int v;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    members: List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
    sendMailTo: List<dynamic>.from(json["sendMailTo"].map((x) => x)),
    public: json["public"],
    id: json["_id"],
    name: titleEnumValues.map[json["name"]],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "members": List<dynamic>.from(members.map((x) => x.toJson())),
    "sendMailTo": List<dynamic>.from(sendMailTo.map((x) => x)),
    "public": public,
    "_id": id,
    "name": titleEnumValues.reverse[name],
    "__v": v,
  };
}

class Member {
  Member({
    this.deleted,
    this.id,
    this.username,
    this.fullname,
    this.email,
    this.role,
    this.title,
  });

  bool deleted;
  String id;
  String username;
  String fullname;
  String email;
  Role role;
  TitleEnum title;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    deleted: json["deleted"],
    id: json["_id"],
    username: json["username"],
    fullname: json["fullname"],
    email: json["email"],
    role: Role.fromJson(json["role"]),
    title: titleEnumValues.map[json["title"]],
  );

  Map<String, dynamic> toJson() => {
    "deleted": deleted,
    "_id": id,
    "username": username,
    "fullname": fullname,
    "email": email,
    "role": role.toJson(),
    "title": titleEnumValues.reverse[title],
  };
}

class Role {
  Role({
    this.id,
    this.name,
    this.description,
    this.normalized,
    this.isAdmin,
    this.isAgent,
    this.roleId,
  });

  Id id;
  RoleName name;
  Description description;
  Normalized normalized;
  bool isAdmin;
  bool isAgent;
  Id roleId;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: idValues.map[json["_id"]],
    name: roleNameValues.map[json["name"]],
    description: descriptionValues.map[json["description"]],
    normalized: normalizedValues.map[json["normalized"]],
    isAdmin: json["isAdmin"],
    isAgent: json["isAgent"],
    roleId: idValues.map[json["id"]],
  );

  Map<String, dynamic> toJson() => {
    "_id": idValues.reverse[id],
    "name": roleNameValues.reverse[name],
    "description": descriptionValues.reverse[description],
    "normalized": normalizedValues.reverse[normalized],
    "isAdmin": isAdmin,
    "isAgent": isAgent,
    "id": idValues.reverse[roleId],
  };
}

enum Description { DEFAULT_ROLE_FOR_USERS }

final descriptionValues = EnumValues({
  "Default role for users": Description.DEFAULT_ROLE_FOR_USERS
});

enum Id { THE_614_B24_CFB058_EF23_AAB79636 }

final idValues = EnumValues({
  "614b24cfb058ef23aab79636": Id.THE_614_B24_CFB058_EF23_AAB79636
});

enum RoleName { USER }

final roleNameValues = EnumValues({
  "User": RoleName.USER
});

enum Normalized { USER }

final normalizedValues = EnumValues({
  "user": Normalized.USER
});

enum TitleEnum { PATIENT }

final titleEnumValues = EnumValues({
  "Patient": TitleEnum.PATIENT
});

class History {
  History({
    this.id,
    this.action,
    this.description,
    this.owner,
    this.date,
  });

  String id;
  String action;
  String description;
  String owner;
  DateTime date;

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["_id"],
    action: json["action"],
    description: json["description"],
    owner: json["owner"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "action": action,
    "description": description,
    "owner": owner,
    "date": date.toIso8601String(),
  };
}

class Owner {
  Owner({
    this.preferences,
    this.hasL2Auth,
    this.deleted,
    this.id,
    this.username,
    this.fullname,
    this.email,
    this.role,
    this.title,
    this.v,
  });

  Preferences preferences;
  bool hasL2Auth;
  bool deleted;
  String id;
  String username;
  String fullname;
  String email;
  Role role;
  TitleEnum title;
  int v;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    preferences: Preferences.fromJson(json["preferences"]),
    hasL2Auth: json["hasL2Auth"],
    deleted: json["deleted"],
    id: json["_id"],
    username: json["username"],
    fullname: json["fullname"],
    email: json["email"],
    role: Role.fromJson(json["role"]),
    title: titleEnumValues.map[json["title"]],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "preferences": preferences.toJson(),
    "hasL2Auth": hasL2Auth,
    "deleted": deleted,
    "_id": id,
    "username": username,
    "fullname": fullname,
    "email": email,
    "role": role.toJson(),
    "title": titleEnumValues.reverse[title],
    "__v": v,
  };
}

class Preferences {
  Preferences({
    this.tourCompleted,
    this.autoRefreshTicketGrid,
    this.openChatWindows,
  });

  bool tourCompleted;
  bool autoRefreshTicketGrid;
  List<dynamic> openChatWindows;

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
    tourCompleted: json["tourCompleted"],
    autoRefreshTicketGrid: json["autoRefreshTicketGrid"],
    openChatWindows: List<dynamic>.from(json["openChatWindows"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "tourCompleted": tourCompleted,
    "autoRefreshTicketGrid": autoRefreshTicketGrid,
    "openChatWindows": List<dynamic>.from(openChatWindows.map((x) => x)),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
