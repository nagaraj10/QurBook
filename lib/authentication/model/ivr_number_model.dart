class IvrNumberModel {
  IvrNumberModel({
    this.isSuccess,
    this.result,
  });

  final bool isSuccess;
  final List<String> result;

  factory IvrNumberModel.fromJson(Map<String, dynamic> json) => IvrNumberModel(
        isSuccess: json['isSuccess'],
        result: json['result'] != null
            ? List<String>.from(json['result']?.map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'result': List<dynamic>.from(result.map((x) => x)),
      };
}
