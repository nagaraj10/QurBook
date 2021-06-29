class ReferAFriendRequest {
  List<Contacts> contacts;
  String source;

  ReferAFriendRequest({this.contacts, this.source});

  ReferAFriendRequest.fromJson(Map<String, dynamic> json) {
    if (json['contacts'] != null) {
      contacts = new List<Contacts>();
      json['contacts'].forEach((v) {
        contacts.add(new Contacts.fromJson(v));
      });
    }
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contacts != null) {
      data['contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }
    data['source'] = this.source;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['name'] = this.name;
    return data;
  }
}
