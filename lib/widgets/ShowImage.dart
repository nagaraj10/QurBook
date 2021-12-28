import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;


class ShowImage extends StatefulWidget {
final String filePath;
ShowImage({this.filePath});

@override
_ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  int _current = 0;
  int index = 0;
  int length = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30, right: 10),
              child: OutlineButton(
                  child: Text(variable.strClose),
                  textColor: Colors.white70,
                  borderSide: BorderSide(color: Colors.white70),
                  onPressed: Navigator.of(context).pop),
            ),
            Expanded(flex: 7, child: showImage(widget.filePath)),
          ],
        ),
      ),
    );
  }


  showImage(String filePath){
    return Container(
      width: MediaQuery.of(context).size.width,
      height:MediaQuery.of(context).size.height,
      child: Image.file(
      File(filePath),
      width:MediaQuery.of(context).size.width,
      height: 200,
      alignment: Alignment.topCenter,
    ),);
  }
}
