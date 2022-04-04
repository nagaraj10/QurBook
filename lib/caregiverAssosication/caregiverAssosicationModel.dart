class CaregiverAssosicationModel {
  CaregiverAssosicationModel({
    this.isSuccess,
    this.message,
  });

  bool isSuccess;
  String message;

  factory CaregiverAssosicationModel.fromMap(Map<String, dynamic> json) =>
      CaregiverAssosicationModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "isSuccess": isSuccess == null ? null : isSuccess,
        "message": message == null ? null : message,
      };
}
