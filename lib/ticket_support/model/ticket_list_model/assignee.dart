import 'role.dart';

class Assignee {
  Assignee({
    String id,
    String username,
    String fullname,
    String email,
    Role role,
    String title,
  }) {
    _id = id;
    _username = username;
    _fullname = fullname;
    _email = email;
    _role = role;
    _title = title;
  }

  Assignee.fromJson(dynamic json) {
    _id = json['_id'];
    _username = json['username'];
    _fullname = json['fullname'];
    _email = json['email'];
    _role = json['role'] != null ? Role.fromJson(json['role']) : null;
    _title = json['title'];
  }
  String _id;
  String _username;
  String _fullname;
  String _email;
  Role _role;
  String _title;

  String get id => _id;
  String get username => _username;
  String get fullname => _fullname;
  String get email => _email;
  Role get role => _role;
  String get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['username'] = _username;
    map['fullname'] = _fullname;
    map['email'] = _email;
    if (_role != null) {
      map['role'] = _role.toJson();
    }
    map['title'] = _title;
    return map;
  }
}
