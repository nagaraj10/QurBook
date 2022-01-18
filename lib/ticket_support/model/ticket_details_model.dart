class TicketDetailResponseModel {
  bool isSuccess;
  String message;
  Result result;

  TicketDetailResponseModel({this.isSuccess, this.message, this.result});

  TicketDetailResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  bool success;
  Ticket ticket;

  Result({this.success, this.ticket});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    ticket =
        json['ticket'] != null ? new Ticket.fromJson(json['ticket']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.ticket != null) {
      data['ticket'] = this.ticket.toJson();
    }
    return data;
  }
}

class Ticket {
  bool deleted;
  int status;
  List<Tags> tags;
  List<Subscribers> subscribers;
  String sId;
  Subscribers owner;
  String subject;
  Group group;
  Type type;
  Priorities priority;
  String issue;
  Subscribers assignee;
  String date;
  String preferredDate;
  List<Comments> comments;
  List<Notes> notes;
  List<Attachments> attachments;
  List<History> history;
  int uid;
  int iV;

  Ticket(
      {this.deleted,
      this.status,
      this.tags,
      this.subscribers,
      this.sId,
      this.owner,
      this.subject,
      this.group,
      this.type,
      this.priority,
      this.issue,
      this.assignee,
      this.date,
      this.preferredDate,
      this.comments,
      this.notes,
      this.attachments,
      this.history,
      this.uid,
      this.iV});

  Ticket.fromJson(Map<String, dynamic> json) {
    deleted = json['deleted'];
    status = json['status'];
    if (json['tags'] != null) {
      tags = new List<Tags>();
      json['tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
    if (json['subscribers'] != null) {
      subscribers = new List<Subscribers>();
      json['subscribers'].forEach((v) {
        subscribers.add(new Subscribers.fromJson(v));
      });
    }
    sId = json['_id'];
    owner =
        json['owner'] != null ? new Subscribers.fromJson(json['owner']) : null;
    subject = json['subject'];
    group = json['group'] != null ? new Group.fromJson(json['group']) : null;
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
    priority = json['priority'] != null
        ? new Priorities.fromJson(json['priority'])
        : null;
    issue = json['issue'];
    assignee = json['assignee'] != null
        ? new Subscribers.fromJson(json['assignee'])
        : null;
    date = json['date'];
    preferredDate = json['preferredDate'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    if (json['notes'] != null) {
      notes = new List<Null>();
      json['notes'].forEach((v) {
        notes.add(new Notes.fromJson(v));
      });
    }
    if (json['attachments'] != null) {
      attachments = new List<Attachments>();
      json['attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
      });
    }
    if (json['history'] != null) {
      history = new List<History>();
      json['history'].forEach((v) {
        history.add(new History.fromJson(v));
      });
    }
    uid = json['uid'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deleted'] = this.deleted;
    data['status'] = this.status;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    if (this.subscribers != null) {
      data['subscribers'] = this.subscribers.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['subject'] = this.subject;
    if (this.group != null) {
      data['group'] = this.group.toJson();
    }
    if (this.type != null) {
      data['type'] = this.type.toJson();
    }
    if (this.priority != null) {
      data['priority'] = this.priority.toJson();
    }
    data['issue'] = this.issue;
    if (this.assignee != null) {
      data['assignee'] = this.assignee.toJson();
    }
    data['date'] = this.date;
    data['preferredDate'] = this.preferredDate;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.notes != null) {
      data['notes'] = this.notes.map((v) => v.toJson()).toList();
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    if (this.history != null) {
      data['history'] = this.history.map((v) => v.toJson()).toList();
    }
    data['uid'] = this.uid;
    data['__v'] = this.iV;
    return data;
  }
}

class Attachments {
  String sId;
  String owner;
  String name;
  String path;
  String type;
  String date;

  Attachments(
      {this.sId, this.owner, this.name, this.path, this.type, this.date});

  Attachments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    owner = json['owner'];
    name = json['name'];
    path = json['path'];
    type = json['type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['owner'] = this.owner;
    data['name'] = this.name;
    data['path'] = this.path;
    data['type'] = this.type;
    data['date'] = this.date;
    return data;
  }
}

class Tags {
  Tags({
    String id,
  }) {
    _id = id;
  }

  Tags.fromJson(dynamic json) {
    _id = json['id'];
  }
  String _id;

  String get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }
}

class Notes {
  Notes({
    String id,
  }) {
    _id = id;
  }

  Notes.fromJson(dynamic json) {
    _id = json['id'];
  }
  String _id;

  String get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }
}

class Comments {
  bool deleted;
  String sId;
  Owner owner;
  String date;
  String comment;

  Comments({this.deleted, this.sId, this.owner, this.date, this.comment});

  Comments.fromJson(Map<String, dynamic> json) {
    deleted = json['deleted'];
    sId = json['_id'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    date = json['date'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deleted'] = this.deleted;
    data['_id'] = this.sId;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['date'] = this.date;
    data['comment'] = this.comment;
    return data;
  }
}

class Owner {
  String sId;
  String username;
  String fullname;
  String email;
  Role role;
  String title;

  Owner(
      {this.sId,
      this.username,
      this.fullname,
      this.email,
      this.role,
      this.title});

  Owner.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    fullname = json['fullname'];
    email = json['email'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    data['title'] = this.title;
    return data;
  }
}

class Subscribers {
  String sId;
  String username;
  String email;
  String fullname;
  String title;
  Role role;

  Subscribers(
      {this.sId,
      this.username,
      this.email,
      this.fullname,
      this.title,
      this.role});

  Subscribers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    fullname = json['fullname'];
    title = json['title'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['fullname'] = this.fullname;
    data['title'] = this.title;
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    return data;
  }
}

class Role {
  String sId;
  String name;
  String description;
  String normalized;
  bool isAdmin;
  bool isAgent;
  String id;

  Role(
      {this.sId,
      this.name,
      this.description,
      this.normalized,
      this.isAdmin,
      this.isAgent,
      this.id});

  Role.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    normalized = json['normalized'];
    isAdmin = json['isAdmin'];
    isAgent = json['isAgent'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['normalized'] = this.normalized;
    data['isAdmin'] = this.isAdmin;
    data['isAgent'] = this.isAgent;
    data['id'] = this.id;
    return data;
  }
}

class Group {
  List<Members> members;
  List<SendMailTo> sendMailTo;
  bool public;
  String sId;
  String name;
  int iV;

  Group(
      {this.members,
      this.sendMailTo,
      this.public,
      this.sId,
      this.name,
      this.iV});

  Group.fromJson(Map<String, dynamic> json) {
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
    if (json['sendMailTo'] != null) {
      sendMailTo = new List<Null>();
      json['sendMailTo'].forEach((v) {
        sendMailTo.add(new SendMailTo.fromJson(v));
      });
    }
    public = json['public'];
    sId = json['_id'];
    name = json['name'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    if (this.sendMailTo != null) {
      data['sendMailTo'] = this.sendMailTo.map((v) => v.toJson()).toList();
    }
    data['public'] = this.public;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['__v'] = this.iV;
    return data;
  }
}

class SendMailTo {
  SendMailTo({
    String id,
  }) {
    _id = id;
  }

  SendMailTo.fromJson(dynamic json) {
    _id = json['id'];
  }
  String _id;

  String get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }
}

class Members {
  bool deleted;
  String sId;
  String username;
  String fullname;
  String email;
  Role role;
  String title;

  Members(
      {this.deleted,
      this.sId,
      this.username,
      this.fullname,
      this.email,
      this.role,
      this.title});

  Members.fromJson(Map<String, dynamic> json) {
    deleted = json['deleted'];
    sId = json['_id'];
    username = json['username'];
    fullname = json['fullname'];
    email = json['email'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deleted'] = this.deleted;
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    data['title'] = this.title;
    return data;
  }
}

class Type {
  List<Priorities> priorities;
  String sId;
  String name;
  int iV;

  Type({this.priorities, this.sId, this.name, this.iV});

  Type.fromJson(Map<String, dynamic> json) {
    if (json['priorities'] != null) {
      priorities = new List<Priorities>();
      json['priorities'].forEach((v) {
        priorities.add(new Priorities.fromJson(v));
      });
    }
    sId = json['_id'];
    name = json['name'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priorities != null) {
      data['priorities'] = this.priorities.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['__v'] = this.iV;
    return data;
  }
}

class Priorities {
  int overdueIn;
  String htmlColor;
  String sId;
  String name;
  int migrationNum;
  bool defaultBool;
  int iV;
  String durationFormatted;
  String id;

  Priorities(
      {this.overdueIn,
      this.htmlColor,
      this.sId,
      this.name,
      this.migrationNum,
      this.defaultBool,
      this.iV,
      this.durationFormatted,
      this.id});

  Priorities.fromJson(Map<String, dynamic> json) {
    overdueIn = json['overdueIn'];
    htmlColor = json['htmlColor'];
    sId = json['_id'];
    name = json['name'];
    migrationNum = json['migrationNum'];
    defaultBool = json['defaultBool'];
    iV = json['__v'];
    durationFormatted = json['durationFormatted'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['overdueIn'] = this.overdueIn;
    data['htmlColor'] = this.htmlColor;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['migrationNum'] = this.migrationNum;
    data['defaultBool'] = this.defaultBool;
    data['__v'] = this.iV;
    data['durationFormatted'] = this.durationFormatted;
    data['id'] = this.id;
    return data;
  }
}

class History {
  String sId;
  String action;
  String description;
  Subscribers owner;
  String date;

  History({this.sId, this.action, this.description, this.owner, this.date});

  History.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    action = json['action'];
    description = json['description'];
    owner =
        json['owner'] != null ? new Subscribers.fromJson(json['owner']) : null;
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['action'] = this.action;
    data['description'] = this.description;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['date'] = this.date;
    return data;
  }
}
