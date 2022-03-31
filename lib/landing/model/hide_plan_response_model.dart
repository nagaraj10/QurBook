class HidePlanResponseModel {
  HidePlanResponseModel({
      bool isSuccess,
      Result result,}){
    _isSuccess = isSuccess;
    _result = result;
}

  HidePlanResponseModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    _result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
  bool _isSuccess;
  Result _result;

  bool get isSuccess => _isSuccess;
  Result get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = _isSuccess;
    if (_result != null) {
      map['result'] = _result?.toJson();
    }
    return map;
  }

}

class Result {
  Result({
      QurBook qurBook,}){
    _qurBook = qurBook;
}

  Result.fromJson(dynamic json) {
    _qurBook = json['qurBook'] != null ? QurBook.fromJson(json['qurBook']) : null;
  }
  QurBook _qurBook;

  QurBook get qurBook => _qurBook;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_qurBook != null) {
      map['qurBook'] = _qurBook?.toJson();
    }
    return map;
  }

}

class QurBook {
  QurBook({
      bool addPlanBtn,
      bool cart,
      bool unSubscribeBtn,}){
    _addPlanBtn = addPlanBtn;
    _cart = cart;
    _unSubscribeBtn = unSubscribeBtn;
}

  QurBook.fromJson(dynamic json) {
    _addPlanBtn = json['addPlanBtn'];
    _cart = json['cart'];
    _unSubscribeBtn = json['unSubscribeBtn'];
  }
  bool _addPlanBtn;
  bool _cart;
  bool _unSubscribeBtn;

  bool get addPlanBtn => _addPlanBtn;
  bool get cart => _cart;
  bool get unSubscribeBtn => _unSubscribeBtn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addPlanBtn'] = _addPlanBtn;
    map['cart'] = _cart;
    map['unSubscribeBtn'] = _unSubscribeBtn;
    return map;
  }

}