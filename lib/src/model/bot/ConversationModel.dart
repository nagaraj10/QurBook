import 'package:flutter/foundation.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Conversation{
    bool isMayaSaid;
    String text;
    String imageUrl;
    String name;
    String timeStamp;
    Conversation({@required this.isMayaSaid,@required this.text,this.imageUrl,@required this.name,this.timeStamp});

    Conversation.fromJson(Map<String,dynamic> json){
        isMayaSaid = json[parameters.strIsMayaSaid];
        text = json[parameters.strText];
        imageUrl = json[parameters.strImageUrl];
        name = json[parameters.strName];
        timeStamp = json[parameters.strTimeStamp];
    }


    Map<String,dynamic> toJson(){
      final Map<String,dynamic> data = new Map<String,dynamic>();
      data[parameters.strIsMayaSaid] = this.isMayaSaid;
      data[parameters.strText]=this.text;
      data[parameters.strImageUrl]=this.imageUrl;
      data[parameters.strName]=this.name;
      data[parameters.strTimeStamp]=this.timeStamp;
      return data;
    }

}