class Secret {
  final Map myScerets;

  Secret({this.myScerets});

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return Secret(myScerets: jsonMap);
  }

}
