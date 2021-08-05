class ReferAFriendRequest {
  List<Contacts> contacts;
  String source;

  ReferAFriendRequest({this.contacts, this.source});

  ReferAFriendRequest.fromJson(Map<String, dynamic> json) {
    if (json['contacts'] != null) {
      contacts = List<Contacts>();
      json['contacts'].forEach((v) {
        contacts.add(Contacts.fromJson(v));
      });
    }
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (contacts != null) {
      data['contacts'] = contacts.map((v) => v.toJson()).toList();
    }
    data['source'] = source;
    return data;
  }
}

class Contacts {
  String phoneNumber;
  String name;

  Contacts({this.phoneNumber, this.name});

  Contacts.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    return data;
  }
}
