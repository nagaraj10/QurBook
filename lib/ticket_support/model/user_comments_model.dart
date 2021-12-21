// To parse this JSON data, do
//
//     final userCommentsModel = userCommentsModelFromJson(jsonString);

import 'dart:convert';

UserCommentsModel userCommentsModelFromJson(String str) => UserCommentsModel.fromJson(json.decode(str));

String userCommentsModelToJson(UserCommentsModel data) => json.encode(data.toJson());

class UserCommentsModel {
  UserCommentsModel({
    this.isSuccess,
    this.result,
  });

  bool isSuccess;
  Result result;

  factory UserCommentsModel.fromJson(Map<String, dynamic> json) => UserCommentsModel(
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
    this.error,
    this.ticket,
  });

  bool success;
  dynamic error;
  Ticket ticket;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    success: json["success"],
    error: json["error"],
    ticket: Ticket.fromJson(json["ticket"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
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
    this.assignee,
    this.group,
    this.issue,
    this.owner,
    this.subject,
    this.type,
    this.priority,
    this.date,
    this.comments,
    this.notes,
    this.attachments,
    this.history,
    this.uid,
    this.v,
    this.updated,
  });

  bool deleted;
  int status;
  List<dynamic> tags;
  List<Assignee> subscribers;
  String id;
  Assignee assignee;
  Group group;
  String issue;
  Assignee owner;
  String subject;
  Type type;
  Priority priority;
  DateTime date;
  List<Comment> comments;
  List<dynamic> notes;
  List<dynamic> attachments;
  List<History> history;
  int uid;
  int v;
  DateTime updated;

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    deleted: json["deleted"],
    status: json["status"],
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
    subscribers: List<Assignee>.from(json["subscribers"].map((x) => Assignee.fromJson(x))),
    id: json["_id"],
    assignee: Assignee.fromJson(json["assignee"]),
    group: Group.fromJson(json["group"]),
    issue: json["issue"],
    owner: Assignee.fromJson(json["owner"]),
    subject: json["subject"],
    type: Type.fromJson(json["type"]),
    priority: Priority.fromJson(json["priority"]),
    date: DateTime.parse(json["date"]),
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    notes: List<dynamic>.from(json["notes"].map((x) => x)),
    attachments: List<dynamic>.from(json["attachments"].map((x) => x)),
    history: List<History>.from(json["history"].map((x) => History.fromJson(x))),
    uid: json["uid"],
    v: json["__v"],
    updated: DateTime.parse(json["updated"]),
  );

  Map<String, dynamic> toJson() => {
    "deleted": deleted,
    "status": status,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "subscribers": List<dynamic>.from(subscribers.map((x) => x.toJson())),
    "_id": id,
    "assignee": assignee.toJson(),
    "group": group.toJson(),
    "issue": issue,
    "owner": owner.toJson(),
    "subject": subject,
    "type": type.toJson(),
    "priority": priority.toJson(),
    "date": date.toIso8601String(),
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    "notes": List<dynamic>.from(notes.map((x) => x)),
    "attachments": List<dynamic>.from(attachments.map((x) => x)),
    "history": List<dynamic>.from(history.map((x) => x.toJson())),
    "uid": uid,
    "__v": v,
    "updated": updated.toIso8601String(),
  };
}

class Assignee {
  Assignee({
    this.id,
    this.username,
    this.email,
    this.fullname,
    this.title,
    this.role,
    this.deleted,
  });

  String id;
  String username;
  String email;
  String fullname;
  Title title;
  Role role;
  bool deleted;

  factory Assignee.fromJson(Map<String, dynamic> json) => Assignee(
    id: json["_id"],
    username: json["username"],
    email: json["email"],
    fullname: json["fullname"],
    title: titleValues.map[json["title"]],
    role: Role.fromJson(json["role"]),
    deleted: json["deleted"] == null ? null : json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "email": email,
    "fullname": fullname,
    "title": titleValues.reverse[title],
    "role": role.toJson(),
    "deleted": deleted == null ? null : deleted,
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
  Name name;
  Description description;
  Normalized normalized;
  bool isAdmin;
  bool isAgent;
  Id roleId;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: idValues.map[json["_id"]],
    name: nameValues.map[json["name"]],
    description: descriptionValues.map[json["description"]],
    normalized: normalizedValues.map[json["normalized"]],
    isAdmin: json["isAdmin"],
    isAgent: json["isAgent"],
    roleId: idValues.map[json["id"]],
  );

  Map<String, dynamic> toJson() => {
    "_id": idValues.reverse[id],
    "name": nameValues.reverse[name],
    "description": descriptionValues.reverse[description],
    "normalized": normalizedValues.reverse[normalized],
    "isAdmin": isAdmin,
    "isAgent": isAgent,
    "id": idValues.reverse[roleId],
  };
}

enum Description { DEFAULT_ROLE_FOR_AGENTS, DEFAULT_ROLE_FOR_USERS, DEFAULT_ROLE_FOR_ADMINS }

final descriptionValues = EnumValues({
  "Default role for admins": Description.DEFAULT_ROLE_FOR_ADMINS,
  "Default role for agents": Description.DEFAULT_ROLE_FOR_AGENTS,
  "Default role for users": Description.DEFAULT_ROLE_FOR_USERS
});

enum Id { THE_614_B24_CFB058_EF23_AAB79635, THE_614_B24_CFB058_EF23_AAB79636, THE_614_B24_CFB058_EF23_AAB79634 }

final idValues = EnumValues({
  "614b24cfb058ef23aab79634": Id.THE_614_B24_CFB058_EF23_AAB79634,
  "614b24cfb058ef23aab79635": Id.THE_614_B24_CFB058_EF23_AAB79635,
  "614b24cfb058ef23aab79636": Id.THE_614_B24_CFB058_EF23_AAB79636
});

enum Name { SUPPORT, USER, ADMIN }

final nameValues = EnumValues({
  "Admin": Name.ADMIN,
  "Support": Name.SUPPORT,
  "User": Name.USER
});

enum Normalized { SUPPORT, USER, ADMIN }

final normalizedValues = EnumValues({
  "admin": Normalized.ADMIN,
  "support": Normalized.SUPPORT,
  "user": Normalized.USER
});

enum Title { CARE_GIVER, PATIENT, ADMINISTRATOR }

final titleValues = EnumValues({
  "Administrator": Title.ADMINISTRATOR,
  "CareGiver": Title.CARE_GIVER,
  "Patient": Title.PATIENT
});

class Comment {
  Comment({
    this.deleted,
    this.id,
    this.owner,
    this.date,
    this.comment,
  });

  bool deleted;
  String id;
  Assignee owner;
  DateTime date;
  String comment;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    deleted: json["deleted"],
    id: json["_id"],
    owner: Assignee.fromJson(json["owner"]),
    date: DateTime.parse(json["date"]),
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "deleted": deleted,
    "_id": id,
    "owner": owner.toJson(),
    "date": date.toIso8601String(),
    "comment": comment,
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

  List<Assignee> members;
  List<dynamic> sendMailTo;
  bool public;
  String id;
  String name;
  int v;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    members: List<Assignee>.from(json["members"].map((x) => Assignee.fromJson(x))),
    sendMailTo: List<dynamic>.from(json["sendMailTo"].map((x) => x)),
    public: json["public"],
    id: json["_id"],
    name: json["name"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "members": List<dynamic>.from(members.map((x) => x.toJson())),
    "sendMailTo": List<dynamic>.from(sendMailTo.map((x) => x)),
    "public": public,
    "_id": id,
    "name": name,
    "__v": v,
  };
}

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
  Assignee owner;
  DateTime date;

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["_id"],
    action: json["action"],
    description: json["description"],
    owner: Assignee.fromJson(json["owner"]),
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
