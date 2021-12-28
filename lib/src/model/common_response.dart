class CommonResponse {
  bool isSuccess;
  String message;
  String result;

  CommonResponse({this.isSuccess, this.message, this.result});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    try{
      message = json['message'];
      result = json['result'];
    }catch(e){

    }

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['result'] = result;
    return data;
  }
}
