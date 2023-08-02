
import 'package:myfhb/common/CommonUtil.dart';

class ReferAFriendRequest {
  List<Contacts>? contacts;
  String? source;

  ReferAFriendRequest({this.contacts, this.source});

  ReferAFriendRequest.fromJson(Map<String, dynamic> json) {
    try {
      if (json['contacts'] != null) {
            contacts = <Contacts>[];
            json['contacts'].forEach((v) {
              contacts!.add(Contacts.fromJson(v));
            });
          }
      source = json['source'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (contacts != null) {
      data['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    data['source'] = source;
    return data;
  }
}

class Contacts {
  String? phoneNumber;
  String? name;

  Contacts({this.phoneNumber, this.name});

  Contacts.fromJson(Map<String, dynamic> json) {
    try {
      phoneNumber = json['phoneNumber'];
      name = json['name'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    return data;
  }
}
