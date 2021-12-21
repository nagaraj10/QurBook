class Comments {
  Comments({
    String id,
  }) {
    _id = id;
  }

  Comments.fromJson(dynamic json) {
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
