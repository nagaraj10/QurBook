import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;


class ShowImage extends StatefulWidget {
  final List<String> filePathList;
  final String filePath;

  ShowImage({this.filePath,this.filePathList});

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  int _current = 0;
  int index = 0;
  int length = 0;
  CarouselController carouselSlider;

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
                  onPressed: Navigator
                      .of(context)
                      .pop),
            ),
            Expanded(flex: 7, child: widget.filePathList.length>0?getCarousalImage(widget.filePathList):showImage(widget.filePath)),
          ],
        ),
      ),
    );
  }


  showImage(String filePath) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: Image.file(
        File(filePath),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 200,
        alignment: Alignment.topCenter,
      ),);
  }

  Widget getCarousalImage(List<String> imagesPath) {
    if (imagesPath != null && imagesPath.isNotEmpty) {
      index = _current + 1;
      _current = 0;
      length = imagesPath.length;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          (imagesPath != null && imagesPath.isNotEmpty)
              ? Expanded(
            child: CarouselSlider(
              carouselController: carouselSlider,
              items: imagesPath.map((imgUrl) {
                return Builder(
                  builder: (context) {
                    return showImage(imgUrl);
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 400.0.h,
                //width: 1.sw,
                initialPage: 0,
                enlargeCenterPage: true,
                reverse: false,
                enableInfiniteScroll: false,
                // pauseAutoPlayOnTouch: Duration(seconds: 10),
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, carouselPageChangedReason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ):Container()

        ],
      ),
    );
  }

}
