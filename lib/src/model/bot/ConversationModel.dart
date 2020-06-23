import 'package:flutter/foundation.dart';

class Conversation{
    bool isMayaSaid;
    String text;
    String imageUrl;
    String name;
    String timeStamp;
    Conversation({@required this.isMayaSaid,@required this.text,this.imageUrl,@required this.name,this.timeStamp});

    Conversation.fromJson(Map<String,dynamic> json){
        isMayaSaid = json['isMayaSaid'];
        text = json['text'];
        imageUrl = json['imageUrl'];
        name = json['name'];
        timeStamp = json['timeStamp'];
    }


    Map<String,dynamic> toJson(){
      final Map<String,dynamic> data = new Map<String,dynamic>();
      data['isMayaSaid'] = this.isMayaSaid;
      data['text']=this.text;
      data['imageUrl']=this.imageUrl;
      data['name']=this.name;
      data['timeStamp']=this.timeStamp;
      return data;
    }

}