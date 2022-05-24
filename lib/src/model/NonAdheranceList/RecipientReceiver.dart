import 'AdditionalInfo.dart';

class RecipientReceiver {
  RecipientReceiver({
      String id, 
      dynamic name, 
      dynamic userName, 
      String firstName, 
      String middleName, 
      String lastName, 
      String gender, 
      String dateOfBirth, 
      String bloodGroup, 
      dynamic countryCode, 
      String profilePicUrl, 
      String profilePicThumbnailUrl, 
      dynamic isTempUser, 
      dynamic isVirtualUser, 
      dynamic isMigrated, 
      dynamic isClaimed, 
      bool isIeUser, 
      dynamic isEmailVerified, 
      bool isCpUser, 
      dynamic communicationPreferences, 
      dynamic medicalPreferences, 
      bool isSignedIn, 
      bool isActive, 
      String createdBy, 
      String createdOn, 
      String lastModifiedBy, 
      dynamic lastModifiedOn, 
      String providerId, 
      AdditionalInfo additionalInfo,}){
    _id = id;
    _name = name;
    _userName = userName;
    _firstName = firstName;
    _middleName = middleName;
    _lastName = lastName;
    _gender = gender;
    _dateOfBirth = dateOfBirth;
    _bloodGroup = bloodGroup;
    _countryCode = countryCode;
    _profilePicUrl = profilePicUrl;
    _profilePicThumbnailUrl = profilePicThumbnailUrl;
    _isTempUser = isTempUser;
    _isVirtualUser = isVirtualUser;
    _isMigrated = isMigrated;
    _isClaimed = isClaimed;
    _isIeUser = isIeUser;
    _isEmailVerified = isEmailVerified;
    _isCpUser = isCpUser;
    _communicationPreferences = communicationPreferences;
    _medicalPreferences = medicalPreferences;
    _isSignedIn = isSignedIn;
    _isActive = isActive;
    _createdBy = createdBy;
    _createdOn = createdOn;
    _lastModifiedBy = lastModifiedBy;
    _lastModifiedOn = lastModifiedOn;
    _providerId = providerId;
    _additionalInfo = additionalInfo;
}

  RecipientReceiver.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _userName = json['userName'];
    _firstName = json['firstName'];
    _middleName = json['middleName'];
    _lastName = json['lastName'];
    _gender = json['gender'];
    _dateOfBirth = json['dateOfBirth'];
    _bloodGroup = json['bloodGroup'];
    _countryCode = json['countryCode'];
    _profilePicUrl = json['profilePicUrl'];
    _profilePicThumbnailUrl = json['profilePicThumbnailUrl'];
    _isTempUser = json['isTempUser'];
    _isVirtualUser = json['isVirtualUser'];
    _isMigrated = json['isMigrated'];
    _isClaimed = json['isClaimed'];
    _isIeUser = json['isIeUser'];
    _isEmailVerified = json['isEmailVerified'];
    _isCpUser = json['isCpUser'];
    _communicationPreferences = json['communicationPreferences'];
    _medicalPreferences = json['medicalPreferences'];
    _isSignedIn = json['isSignedIn'];
    _isActive = json['isActive'];
    _createdBy = json['createdBy'];
    _createdOn = json['createdOn'];
    _lastModifiedBy = json['lastModifiedBy'];
    _lastModifiedOn = json['lastModifiedOn'];
    _providerId = json['providerId'];
    _additionalInfo = json['additionalInfo'] != null ? AdditionalInfo.fromJson(json['additionalInfo']) : null;
  }
  String _id;
  dynamic _name;
  dynamic _userName;
  String _firstName;
  String _middleName;
  String _lastName;
  String _gender;
  String _dateOfBirth;
  String _bloodGroup;
  dynamic _countryCode;
  String _profilePicUrl;
  String _profilePicThumbnailUrl;
  dynamic _isTempUser;
  dynamic _isVirtualUser;
  dynamic _isMigrated;
  dynamic _isClaimed;
  bool _isIeUser;
  dynamic _isEmailVerified;
  bool _isCpUser;
  dynamic _communicationPreferences;
  dynamic _medicalPreferences;
  bool _isSignedIn;
  bool _isActive;
  String _createdBy;
  String _createdOn;
  String _lastModifiedBy;
  dynamic _lastModifiedOn;
  String _providerId;
  AdditionalInfo _additionalInfo;

  String get id => _id;
  dynamic get name => _name;
  dynamic get userName => _userName;
  String get firstName => _firstName;
  String get middleName => _middleName;
  String get lastName => _lastName;
  String get gender => _gender;
  String get dateOfBirth => _dateOfBirth;
  String get bloodGroup => _bloodGroup;
  dynamic get countryCode => _countryCode;
  String get profilePicUrl => _profilePicUrl;
  String get profilePicThumbnailUrl => _profilePicThumbnailUrl;
  dynamic get isTempUser => _isTempUser;
  dynamic get isVirtualUser => _isVirtualUser;
  dynamic get isMigrated => _isMigrated;
  dynamic get isClaimed => _isClaimed;
  bool get isIeUser => _isIeUser;
  dynamic get isEmailVerified => _isEmailVerified;
  bool get isCpUser => _isCpUser;
  dynamic get communicationPreferences => _communicationPreferences;
  dynamic get medicalPreferences => _medicalPreferences;
  bool get isSignedIn => _isSignedIn;
  bool get isActive => _isActive;
  String get createdBy => _createdBy;
  String get createdOn => _createdOn;
  String get lastModifiedBy => _lastModifiedBy;
  dynamic get lastModifiedOn => _lastModifiedOn;
  String get providerId => _providerId;
  AdditionalInfo get additionalInfo => _additionalInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['userName'] = _userName;
    map['firstName'] = _firstName;
    map['middleName'] = _middleName;
    map['lastName'] = _lastName;
    map['gender'] = _gender;
    map['dateOfBirth'] = _dateOfBirth;
    map['bloodGroup'] = _bloodGroup;
    map['countryCode'] = _countryCode;
    map['profilePicUrl'] = _profilePicUrl;
    map['profilePicThumbnailUrl'] = _profilePicThumbnailUrl;
    map['isTempUser'] = _isTempUser;
    map['isVirtualUser'] = _isVirtualUser;
    map['isMigrated'] = _isMigrated;
    map['isClaimed'] = _isClaimed;
    map['isIeUser'] = _isIeUser;
    map['isEmailVerified'] = _isEmailVerified;
    map['isCpUser'] = _isCpUser;
    map['communicationPreferences'] = _communicationPreferences;
    map['medicalPreferences'] = _medicalPreferences;
    map['isSignedIn'] = _isSignedIn;
    map['isActive'] = _isActive;
    map['createdBy'] = _createdBy;
    map['createdOn'] = _createdOn;
    map['lastModifiedBy'] = _lastModifiedBy;
    map['lastModifiedOn'] = _lastModifiedOn;
    map['providerId'] = _providerId;
    if (_additionalInfo != null) {
      map['additionalInfo'] = _additionalInfo.toJson();
    }
    return map;
  }

}