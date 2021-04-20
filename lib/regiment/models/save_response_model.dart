class SaveResponseModel {
  SaveResponseModel({
    this.isSuccess,
    this.result,
  });

  final bool isSuccess;
  final SaveResultModel result;

  factory SaveResponseModel.fromJson(Map<String, dynamic> json) =>
      SaveResponseModel(
        isSuccess: json['isSuccess'],
        result: SaveResultModel.fromJson(json['result']),
      );

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'result': result.toJson(),
      };
}

class SaveResultModel {
  SaveResultModel({
    this.eventrow,
    this.result,
    this.missing,
    this.saved,
  });

  final dynamic eventrow;
  final dynamic result;
  final dynamic missing;
  final bool saved;

  factory SaveResultModel.fromJson(Map<String, dynamic> json) =>
      SaveResultModel(
        eventrow: json['eventrow'],
        result: json['result'],
        missing: json['missing'],
        saved: json['saved'],
      );

  Map<String, dynamic> toJson() => {
        'eventrow': eventrow,
        'result': result,
        'missing': missing,
        'saved': saved,
      };
}
