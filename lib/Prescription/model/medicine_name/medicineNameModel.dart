import 'package:myfhb/Prescription/model/medicine_name/medicineNameResult.dart';

class MedicineNameModel {
  MedicineNameModel({
    this.isSuccess,
    this.result,
  });

  bool isSuccess;
  List<MedicineNameResult> result;

  factory MedicineNameModel.fromJson(Map<String, dynamic> json) =>
      MedicineNameModel(
        isSuccess: json["isSuccess"],
        result: List<MedicineNameResult>.from(
            json["result"].map((x) => MedicineNameResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}
