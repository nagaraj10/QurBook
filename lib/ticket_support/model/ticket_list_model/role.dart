class Role {
  Role({
    String id,
    String name,
    String description,
    String normalized,
    bool isAdmin,
    bool isAgent,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _normalized = normalized;
    _isAdmin = isAdmin;
    _isAgent = isAgent;
  }

  Role.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _description = json['description'];
    _normalized = json['normalized'];
    _isAdmin = json['isAdmin'];
    _isAgent = json['isAgent'];
  }
  String _id;
  String _name;
  String _description;
  String _normalized;
  bool _isAdmin;
  bool _isAgent;

  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get normalized => _normalized;
  bool get isAdmin => _isAdmin;
  bool get isAgent => _isAgent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['normalized'] = _normalized;
    map['isAdmin'] = _isAdmin;
    map['isAgent'] = _isAgent;
    return map;
  }
}
