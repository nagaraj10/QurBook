import 'Members.dart';
import 'SendMailTo.dart';
import 'attachments.dart';
import 'comments.dart';
import 'notes.dart';
import 'AdditionalInfo.dart';

class TicketsListResponse {
  bool success;
  List<Tickets> tickets;
  int count;
  int totalCount;
  int page;
  int prevPage;
  int nextPage;

  TicketsListResponse(
      {this.success,
      this.tickets,
      this.count,
      this.totalCount,
      this.page,
      this.prevPage,
      this.nextPage});

  TicketsListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['tickets'] != null) {
      tickets = new List<Tickets>();
      json['tickets'].forEach((v) {
        tickets.add(new Tickets.fromJson(v));
      });
    }
    count = json['count'];
    totalCount = json['totalCount'];
    page = json['page'];
    prevPage = json['prevPage'];
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.tickets != null) {
      data['tickets'] = this.tickets.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['totalCount'] = this.totalCount;
    data['page'] = this.page;
    data['prevPage'] = this.prevPage;
    data['nextPage'] = this.nextPage;
    return data;
  }
}

class Tickets {
  bool deleted;
  int status;
  List<Tags> tags;
  List<Subscribers> subscribers;
  String sId;
  Subscribers owner;
  String subject;
  Group group;
  Type type;
  Priority priority;
  String issue;
  Subscribers assignee;
  String date;
  String preferredDate;
  List<Comments> comments;
  List<Notes> notes;
  List<Attachments> attachments;
  AdditionalInfo additionalInfo;

  List<History> history;
  int uid;
  int iV;

  Tickets(
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
      this.iV,
      this.additionalInfo});

  Tickets.fromJson(Map<String, dynamic> json) {
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
        ? new Priority.fromJson(json['priority'])
        : null;
    issue = json['issue'];
    assignee = json['assignee'] != null
        ? new Subscribers.fromJson(json['assignee'])
        : null;
    date = json['date'];
    preferredDate = json['preferredDate'];
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    if (json['notes'] != null) {
      notes = new List<Notes>();
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

    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;

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
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
    }
    data['uid'] = this.uid;
    data['__v'] = this.iV;
    return data;
  }
}

class Tags {
  String id;

  Tags({this.id});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class Subscribers {
  String sId;
  String username;
  String fullname;
  String email;
  Role role;
  String title;

  Subscribers(
      {this.sId,
      this.username,
      this.fullname,
      this.email,
      this.role,
      this.title});

  Subscribers.fromJson(Map<String, dynamic> json) {
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

class Role {
  String sId;
  String name;
  String description;
  String normalized;
  bool isAdmin;
  bool isAgent;

  Role(
      {this.sId,
      this.name,
      this.description,
      this.normalized,
      this.isAdmin,
      this.isAgent});

  Role.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    normalized = json['normalized'];
    isAdmin = json['isAdmin'];
    isAgent = json['isAgent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['normalized'] = this.normalized;
    data['isAdmin'] = this.isAdmin;
    data['isAgent'] = this.isAgent;
    return data;
  }
}

class Group {
  List<Members> members;
  List<String> sendMailTo;
  bool public;
  String sId;
  String name;

  Group({this.members, this.sendMailTo, this.public, this.sId, this.name});

  Group.fromJson(Map<String, dynamic> json) {
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
    sendMailTo = json['sendMailTo'].cast<String>();
    public = json['public'];
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    if (this.sendMailTo != null) {
      data['sendMailTo'] = this.sendMailTo;
    }
    data['public'] = this.public;
    data['_id'] = this.sId;
    data['name'] = this.name;
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
  String durationFormatted;

  Priorities(
      {this.overdueIn,
      this.htmlColor,
      this.sId,
      this.name,
      this.migrationNum,
      this.defaultBool,
      this.durationFormatted});

  Priorities.fromJson(Map<String, dynamic> json) {
    overdueIn = json['overdueIn'];
    htmlColor = json['htmlColor'];
    sId = json['_id'];
    name = json['name'];
    migrationNum = json['migrationNum'];
    defaultBool = json['defaultBool'];
    durationFormatted = json['durationFormatted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['overdueIn'] = this.overdueIn;
    data['htmlColor'] = this.htmlColor;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['migrationNum'] = this.migrationNum;
    data['defaultBool'] = this.defaultBool;
    data['durationFormatted'] = this.durationFormatted;
    return data;
  }
}

class Priority {
  int overdueIn;
  String htmlColor;
  String sId;
  String name;
  int migrationNum;
  bool defaultBool;
  int iV;
  String durationFormatted;

  Priority(
      {this.overdueIn,
      this.htmlColor,
      this.sId,
      this.name,
      this.migrationNum,
      this.defaultBool,
      this.iV,
      this.durationFormatted});

  Priority.fromJson(Map<String, dynamic> json) {
    overdueIn = json['overdueIn'];
    htmlColor = json['htmlColor'];
    sId = json['_id'];
    name = json['name'];
    migrationNum = json['migrationNum'];
    defaultBool = json['defaultBool'];
    iV = json['__v'];
    durationFormatted = json['durationFormatted'];
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
