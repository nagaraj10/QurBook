class VoiceCloneRequest {
  List<VoiceCloneUserRequest>? user;
  VoiceCloneBaseRequest? voiceClone;

  VoiceCloneRequest({
    this.user,
    this.voiceClone,
  });

  factory VoiceCloneRequest.fromJson(Map<String, dynamic> json) =>
      VoiceCloneRequest(
        user: json['user'] == null
            ? []
            : List<VoiceCloneUserRequest>.from(
                json['user']!.map(
                  (x) => VoiceCloneUserRequest.fromJson(x),
                ),
              ),
        voiceClone: json['voiceClone'] == null
            ? null
            : VoiceCloneBaseRequest.fromJson(
                json['voiceClone'],
              ),
      );

  Map<String, dynamic> toJson() => {
        'user': user == null
            ? []
            : List<dynamic>.from(
                user!.map(
                  (x) => x.toJson(),
                ),
              ),
        'voiceClone': voiceClone?.toJson(),
      };
}

class VoiceCloneUserRequest {
  String? id;
  bool? isActive;

  VoiceCloneUserRequest({
    this.id,
    this.isActive,
  });

  factory VoiceCloneUserRequest.fromJson(Map<String, dynamic> json) =>
      VoiceCloneUserRequest(
        id: json['id'],
        isActive: json['isActive'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'isActive': isActive,
      };
}

class VoiceCloneBaseRequest {
  String? id;

  VoiceCloneBaseRequest({
    this.id,
  });

  factory VoiceCloneBaseRequest.fromJson(Map<String, dynamic> json) =>
      VoiceCloneBaseRequest(
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
