import 'owner.dart';

class History {
  History({
    String id,
    String action,
    String description,
    Owner owner,
    String date,
  }) {
    _id = id;
    _action = action;
    _description = description;
    _owner = owner;
    _date = date;
  }

  History.fromJson(dynamic json) {
    _id = json['_id'];
    _action = json['action'];
    _description = json['description'];
    _owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    _date = json['date'];
  }
  String _id;
  String _action;
  String _description;
  Owner _owner;
  String _date;

  String get id => _id;
  String get action => _action;
  String get description => _description;
  Owner get owner => _owner;
  String get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['action'] = _action;
    map['description'] = _description;
    if (_owner != null) {
      map['owner'] = _owner.toJson();
    }
    map['date'] = _date;
    return map;
  }
}
