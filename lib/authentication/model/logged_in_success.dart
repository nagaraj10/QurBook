class LoginDetails {
  Result result;

  LoginDetails({this.result});

  LoginDetails.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String id;
  String lastLoggedIn;
  String status;
  Null verificationCode;
  Null codeExpirationDatetime;
  bool isLocked;
  int failedVerificationCount;
  Null accountLockedDatetime;
  Null resetPasswordExpiryDatetime;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  Null passwordChangedOn;
  String firstLoggedIn;

  Result(
      {this.id,
      this.lastLoggedIn,
      this.status,
      this.verificationCode,
      this.codeExpirationDatetime,
      this.isLocked,
      this.failedVerificationCount,
      this.accountLockedDatetime,
      this.resetPasswordExpiryDatetime,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.passwordChangedOn,
      this.firstLoggedIn});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastLoggedIn = json['lastLoggedIn'];
    status = json['status'];
    verificationCode = json['verificationCode'];
    codeExpirationDatetime = json['codeExpirationDatetime'];
    isLocked = json['isLocked'];
    failedVerificationCount = json['failedVerificationCount'];
    accountLockedDatetime = json['accountLockedDatetime'];
    resetPasswordExpiryDatetime = json['resetPasswordExpiryDatetime'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    passwordChangedOn = json['passwordChangedOn'];
    firstLoggedIn = json['firstLoggedIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lastLoggedIn'] = this.lastLoggedIn;
    data['status'] = this.status;
    data['verificationCode'] = this.verificationCode;
    data['codeExpirationDatetime'] = this.codeExpirationDatetime;
    data['isLocked'] = this.isLocked;
    data['failedVerificationCount'] = this.failedVerificationCount;
    data['accountLockedDatetime'] = this.accountLockedDatetime;
    data['resetPasswordExpiryDatetime'] = this.resetPasswordExpiryDatetime;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['passwordChangedOn'] = this.passwordChangedOn;
    data['firstLoggedIn'] = this.firstLoggedIn;
    return data;
  }
}
