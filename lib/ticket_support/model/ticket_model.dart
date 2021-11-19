// To parse this JSON data, do
//
//     final userTicketModel = userTicketModelFromJson(jsonString);

import 'dart:convert';

UserTicketModel userTicketModelFromJson(String str) => UserTicketModel.fromJson(json.decode(str));

String userTicketModelToJson(UserTicketModel data) => json.encode(data.toJson());

class UserTicketModel {
  UserTicketModel({
    this.isSuccess,
    this.message,
    this.result,
  });

  bool isSuccess;
  String message;
  Result result;

  factory UserTicketModel.fromJson(Map<String, dynamic> json) => UserTicketModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "result": result.toJson(),
  };
}

class Result {
  Result({
    this.success,
    this.tickets,
    this.count,
    this.totalCount,
    this.page,
    this.prevPage,
    this.nextPage,
  });

  bool success;
  List<Ticket> tickets;
  int count;
  int totalCount;
  int page;
  int prevPage;
  int nextPage;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    success: json["success"],
    tickets: List<Ticket>.from(json["tickets"].map((x) => Ticket.fromJson(x))),
    count: json["count"],
    totalCount: json["totalCount"],
    page: json["page"],
    prevPage: json["prevPage"],
    nextPage: json["nextPage"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "tickets": List<dynamic>.from(tickets.map((x) => x.toJson())),
    "count": count,
    "totalCount": totalCount,
    "page": page,
    "prevPage": prevPage,
    "nextPage": nextPage,
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
    this.priority,
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
  List<Owner> subscribers;
  String id;
  String subject;
  String issue;
  Type type;
  Priority priority;
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
    subscribers: List<Owner>.from(json["subscribers"].map((x) => Owner.fromJson(x))),
    id: json["_id"],
    subject: json["subject"],
    issue: json["issue"],
    type: json["type"] == null ? null : Type.fromJson(json["type"]),
    priority: json["priority"] == null ? null : Priority.fromJson(json["priority"]),
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
    "subscribers": List<dynamic>.from(subscribers.map((x) => x.toJson())),
    "_id": id,
    "subject": subject,
    "issue": issue,
    "type": type == null ? null : type.toJson(),
    "priority": priority == null ? null : priority.toJson(),
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

  List<Owner> members;
  List<dynamic> sendMailTo;
  bool public;
  String id;
  TitleEnum name;
  int v;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    members: List<Owner>.from(json["members"].map((x) => Owner.fromJson(x))),
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

class Owner {
  Owner({
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

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    deleted: json["deleted"] == null ? null : json["deleted"],
    id: json["_id"],
    username: json["username"],
    fullname: json["fullname"],
    email: json["email"],
    role: Role.fromJson(json["role"]),
    title: titleEnumValues.map[json["title"]],
  );

  Map<String, dynamic> toJson() => {
    "deleted": deleted == null ? null : deleted,
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

enum Description { DEFAULT_ROLE_FOR_USERS, DEFAULT_ROLE_FOR_ADMINS }

final descriptionValues = EnumValues({
  "Default role for admins": Description.DEFAULT_ROLE_FOR_ADMINS,
  "Default role for users": Description.DEFAULT_ROLE_FOR_USERS
});

enum Id { THE_614_B24_CFB058_EF23_AAB79636, THE_614_B24_CFB058_EF23_AAB79634 }

final idValues = EnumValues({
  "614b24cfb058ef23aab79634": Id.THE_614_B24_CFB058_EF23_AAB79634,
  "614b24cfb058ef23aab79636": Id.THE_614_B24_CFB058_EF23_AAB79636
});

enum RoleName { USER, ADMIN }

final roleNameValues = EnumValues({
  "Admin": RoleName.ADMIN,
  "User": RoleName.USER
});

enum Normalized { USER, ADMIN }

final normalizedValues = EnumValues({
  "admin": Normalized.ADMIN,
  "user": Normalized.USER
});

enum TitleEnum { PATIENT, ADMINISTRATOR }

final titleEnumValues = EnumValues({
  "Administrator": TitleEnum.ADMINISTRATOR,
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
  Owner owner;
  DateTime date;

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["_id"],
    action: json["action"],
    description: json["description"],
    owner: Owner.fromJson(json["owner"]),
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "action": action,
    "description": description,
    "owner": owner.toJson(),
    "date": date.toIso8601String(),
  };
}

class Priority {
  Priority({
    this.overdueIn,
    this.htmlColor,
    this.id,
    this.name,
    this.migrationNum,
    this.priorityDefault,
    this.v,
    this.durationFormatted,
    this.priorityId,
  });

  int overdueIn;
  String htmlColor;
  String id;
  String name;
  int migrationNum;
  bool priorityDefault;
  int v;
  String durationFormatted;
  String priorityId;

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
    overdueIn: json["overdueIn"],
    htmlColor: json["htmlColor"],
    id: json["_id"],
    name: json["name"],
    migrationNum: json["migrationNum"],
    priorityDefault: json["default"],
    v: json["__v"],
    durationFormatted: json["durationFormatted"],
    priorityId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "overdueIn": overdueIn,
    "htmlColor": htmlColor,
    "_id": id,
    "name": name,
    "migrationNum": migrationNum,
    "default": priorityDefault,
    "__v": v,
    "durationFormatted": durationFormatted,
    "id": priorityId,
  };
}

class Type {
  Type({
    this.priorities,
    this.id,
    this.name,
    this.v,
  });

  List<Priority> priorities;
  String id;
  String name;
  int v;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    priorities: List<Priority>.from(json["priorities"].map((x) => Priority.fromJson(x))),
    id: json["_id"],
    name: json["name"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "priorities": List<dynamic>.from(priorities.map((x) => x.toJson())),
    "_id": id,
    "name": name,
    "__v": v,
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
