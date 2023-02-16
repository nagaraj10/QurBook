
class UpdateSelfProfileModel {
  bool? isSuccess;
  String? message;
  String? result;

  UpdateSelfProfileModel({this.isSuccess, this.message, this.result});

  UpdateSelfProfileModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['result'] = result;
    return data;
  }
}

// class Result {
//   String id;

//   Result({this.id});

//   Result.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     return data;
//   }
// }
