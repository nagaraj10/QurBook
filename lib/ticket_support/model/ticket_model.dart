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
    this.updated,
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
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    notes: List<dynamic>.from(json["notes"].map((x) => x)),
    attachments: List<dynamic>.from(json["attachments"].map((x) => x)),
    history: List<History>.from(json["history"].map((x) => History.fromJson(x))),
    uid: json["uid"],
    v: json["__v"],
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
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
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    "notes": List<dynamic>.from(notes.map((x) => x)),
    "attachments": List<dynamic>.from(attachments.map((x) => x)),
    "history": List<dynamic>.from(history.map((x) => x.toJson())),
    "uid": uid,
    "__v": v,
    "updated": updated == null ? null : updated.toIso8601String(),
  };
}

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
  Owner owner;
  DateTime date;
  String comment;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    deleted: json["deleted"],
    id: json["_id"],
    owner: Owner.fromJson(json["owner"]),
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

class Owner {
  Owner({
    this.id,
    this.username,
    this.fullname,
    this.email,
    this.role,
    this.title,
    this.deleted,
    this.userRefId,
  });

  String id;
  String username;
  String fullname;
  String email;
  Role role;
  TitleEnum title;
  bool deleted;
  String userRefId;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["_id"],
    username: json["username"],
    fullname: json["fullname"],
    email: json["email"],
    role: Role.fromJson(json["role"]),
    title: titleEnumValues.map[json["title"]],
    deleted: json["deleted"] == null ? null : json["deleted"],
    userRefId: json["userRefId"] == null ? null : json["userRefId"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "fullname": fullname,
    "email": email,
    "role": role.toJson(),
    "title": titleEnumValues.reverse[title],
    "deleted": deleted == null ? null : deleted,
    "userRefId": userRefId == null ? null : userRefId,
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

  RoleId id;
  RoleName name;
  RoleDescription description;
  Normalized normalized;
  bool isAdmin;
  bool isAgent;
  RoleId roleId;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: roleIdValues.map[json["_id"]],
    name: roleNameValues.map[json["name"]],
    description: roleDescriptionValues.map[json["description"]],
    normalized: normalizedValues.map[json["normalized"]],
    isAdmin: json["isAdmin"],
    isAgent: json["isAgent"],
    roleId: roleIdValues.map[json["id"]],
  );

  Map<String, dynamic> toJson() => {
    "_id": roleIdValues.reverse[id],
    "name": roleNameValues.reverse[name],
    "description": roleDescriptionValues.reverse[description],
    "normalized": normalizedValues.reverse[normalized],
    "isAdmin": isAdmin,
    "isAgent": isAgent,
    "id": roleIdValues.reverse[roleId],
  };
}

enum RoleDescription { DEFAULT_ROLE_FOR_USERS, DEFAULT_ROLE_FOR_ADMINS }

final roleDescriptionValues = EnumValues({
  "Default role for admins": RoleDescription.DEFAULT_ROLE_FOR_ADMINS,
  "Default role for users": RoleDescription.DEFAULT_ROLE_FOR_USERS
});

enum RoleId { THE_614_B24_CFB058_EF23_AAB79636, THE_614_B24_CFB058_EF23_AAB79634 }

final roleIdValues = EnumValues({
  "614b24cfb058ef23aab79634": RoleId.THE_614_B24_CFB058_EF23_AAB79634,
  "614b24cfb058ef23aab79636": RoleId.THE_614_B24_CFB058_EF23_AAB79636
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
  GroupId id;
  TitleEnum name;
  int v;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    members: List<Owner>.from(json["members"].map((x) => Owner.fromJson(x))),
    sendMailTo: List<dynamic>.from(json["sendMailTo"].map((x) => x)),
    public: json["public"],
    id: groupIdValues.map[json["_id"]],
    name: titleEnumValues.map[json["name"]],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "members": List<dynamic>.from(members.map((x) => x.toJson())),
    "sendMailTo": List<dynamic>.from(sendMailTo.map((x) => x)),
    "public": public,
    "_id": groupIdValues.reverse[id],
    "name": titleEnumValues.reverse[name],
    "__v": v,
  };
}

enum GroupId { THE_614_C0_F0509_BDC9338_E1919_A8 }

final groupIdValues = EnumValues({
  "614c0f0509bdc9338e1919a8": GroupId.THE_614_C0_F0509_BDC9338_E1919_A8
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
  Action action;
  HistoryDescription description;
  Owner owner;
  DateTime date;

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["_id"],
    action: actionValues.map[json["action"]],
    description: historyDescriptionValues.map[json["description"]],
    owner: Owner.fromJson(json["owner"]),
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "action": actionValues.reverse[action],
    "description": historyDescriptionValues.reverse[description],
    "owner": owner.toJson(),
    "date": date.toIso8601String(),
  };
}

enum Action { TICKET_CREATED, TICKET_COMMENT_ADDED }

final actionValues = EnumValues({
  "ticket:comment:added": Action.TICKET_COMMENT_ADDED,
  "ticket:created": Action.TICKET_CREATED
});

enum HistoryDescription { TICKET_WAS_CREATED, COMMENT_WAS_ADDED }

final historyDescriptionValues = EnumValues({
  "Comment was added": HistoryDescription.COMMENT_WAS_ADDED,
  "Ticket was created.": HistoryDescription.TICKET_WAS_CREATED
});

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
  HtmlColor htmlColor;
  PriorityId id;
  PriorityName name;
  int migrationNum;
  bool priorityDefault;
  int v;
  DurationFormatted durationFormatted;
  PriorityId priorityId;

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
    overdueIn: json["overdueIn"],
    htmlColor: htmlColorValues.map[json["htmlColor"]],
    id: priorityIdValues.map[json["_id"]],
    name: priorityNameValues.map[json["name"]],
    migrationNum: json["migrationNum"],
    priorityDefault: json["default"],
    v: json["__v"],
    durationFormatted: durationFormattedValues.map[json["durationFormatted"]],
    priorityId: priorityIdValues.map[json["id"]],
  );

  Map<String, dynamic> toJson() => {
    "overdueIn": overdueIn,
    "htmlColor": htmlColorValues.reverse[htmlColor],
    "_id": priorityIdValues.reverse[id],
    "name": priorityNameValues.reverse[name],
    "migrationNum": migrationNum,
    "default": priorityDefault,
    "__v": v,
    "durationFormatted": durationFormattedValues.reverse[durationFormatted],
    "id": priorityIdValues.reverse[priorityId],
  };
}

enum DurationFormatted { THE_2_DAYS }

final durationFormattedValues = EnumValues({
  "2 days": DurationFormatted.THE_2_DAYS
});

enum HtmlColor { THE_29_B955, THE_8_E24_AA, E65100 }

final htmlColorValues = EnumValues({
  "#e65100": HtmlColor.E65100,
  "#29b955": HtmlColor.THE_29_B955,
  "#8e24aa": HtmlColor.THE_8_E24_AA
});

enum PriorityId { THE_614_B24_D5_BA1_B2631_FE21_DBE6, THE_614_B24_D5_BA1_B2631_FE21_DBE7, THE_614_B24_D5_BA1_B2631_FE21_DBE8 }

final priorityIdValues = EnumValues({
  "614b24d5ba1b2631fe21dbe6": PriorityId.THE_614_B24_D5_BA1_B2631_FE21_DBE6,
  "614b24d5ba1b2631fe21dbe7": PriorityId.THE_614_B24_D5_BA1_B2631_FE21_DBE7,
  "614b24d5ba1b2631fe21dbe8": PriorityId.THE_614_B24_D5_BA1_B2631_FE21_DBE8
});

enum PriorityName { NORMAL, URGENT, CRITICAL }

final priorityNameValues = EnumValues({
  "Critical": PriorityName.CRITICAL,
  "Normal": PriorityName.NORMAL,
  "Urgent": PriorityName.URGENT
});

class Type {
  Type({
    this.priorities,
    this.id,
    this.name,
    this.v,
  });

  List<Priority> priorities;
  TypeId id;
  TypeName name;
  int v;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    priorities: List<Priority>.from(json["priorities"].map((x) => Priority.fromJson(x))),
    id: typeIdValues.map[json["_id"]],
    name: typeNameValues.map[json["name"]],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "priorities": List<dynamic>.from(priorities.map((x) => x.toJson())),
    "_id": typeIdValues.reverse[id],
    "name": typeNameValues.reverse[name],
    "__v": v,
  };
}

enum TypeId { THE_614_B24_CFB058_EF23_AAB79632, THE_614_B24_CFB058_EF23_AAB79633 }

final typeIdValues = EnumValues({
  "614b24cfb058ef23aab79632": TypeId.THE_614_B24_CFB058_EF23_AAB79632,
  "614b24cfb058ef23aab79633": TypeId.THE_614_B24_CFB058_EF23_AAB79633
});

enum TypeName { ISSUE, TASK }

final typeNameValues = EnumValues({
  "Issue": TypeName.ISSUE,
  "Task": TypeName.TASK
});

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
