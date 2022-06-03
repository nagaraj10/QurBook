import 'dart:convert';

class UserContactCollection {
  String id;
  String phonenumber;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String email;
  UserContactCollection({
    this.id,
    this.phonenumber,
    this.isPrimary,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.email,
  });

  UserContactCollection.fromMap(Map<String, dynamic> map) {
    id = map['id'] != null ? map['id'] : null;
    phonenumber = map['phoneNumber'] != null ? map['phoneNumber'] : null;
    isPrimary = map['isPrimary'] != null ? map['isPrimary'] : null;
    isActive = map['isActive'] != null ? map['isActive'] : null;
    createdOn = map['createdOn'] != null ? map['createdOn'] : null;
    lastModifiedOn =
        map['lastModifiedOn'] != null ? map['lastModifiedOn'] : null;
    email = map['email'] != null ? map['email'] : null;
  }
}
