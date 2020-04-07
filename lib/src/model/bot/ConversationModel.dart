import 'package:flutter/foundation.dart';

class Conversation{
    bool isMayaSaid;
    String text;
    String imageUrl;
    String name;

    Conversation({@required this.isMayaSaid,@required this.text,@required this.imageUrl,@required this.name});

    Conversation.fromJson(Map<String,dynamic> json){
        isMayaSaid = json['isMayaSaid'];
        text = json['text'];
        imageUrl = json['imageUrl'];
        name = json['name'];
    }


    Map<String,dynamic> toJson(){
      final Map<String,dynamic> data = new Map<String,dynamic>();
      data['isMayaSaid'] = this.isMayaSaid;
      data['text']=this.text;
      data['imageUrl']=this.imageUrl;
      data['name']=this.name;
      return data;
    }

}