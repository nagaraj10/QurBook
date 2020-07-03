class Secret {
  final dynamic apiKey;
  Secret({this.apiKey = ""});
  factory Secret.fromJson(Map<String, dynamic> jsonMap, String key) {
    return new Secret(apiKey: jsonMap[key]);
  }
}
