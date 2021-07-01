class LoginDetails {
  Result result;

  LoginDetails({this.result});

  LoginDetails.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (result != null) {
      data['result'] = result.toJson();
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
    final data = <String, dynamic>{};
    data['id'] = id;
    data['lastLoggedIn'] = lastLoggedIn;
    data['status'] = status;
    data['verificationCode'] = verificationCode;
    data['codeExpirationDatetime'] = codeExpirationDatetime;
    data['isLocked'] = isLocked;
    data['failedVerificationCount'] = failedVerificationCount;
    data['accountLockedDatetime'] = accountLockedDatetime;
    data['resetPasswordExpiryDatetime'] = resetPasswordExpiryDatetime;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    data['passwordChangedOn'] = passwordChangedOn;
    data['firstLoggedIn'] = firstLoggedIn;
    return data;
  }
}
