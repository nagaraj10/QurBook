import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ImageSlider extends StatefulWidget {
  final List<dynamic> imageList;

  ImageSlider({this.imageList});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  CarouselSlider carouselSlider;
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
            Expanded(flex: 1,child: IconButton(icon: Icon(Icons.cancel), onPressed: ()=>Navigator.of(context).pop(),color: Colors.white,)),
            Expanded(
              flex: 7,
              child: _loadImage(widget.imageList),
            ),
            //Expanded(flex: 1,child: SizedBox(height: 5,)),
          ],
        ),
      ),
    );
  }


  Widget _loadImage(List<dynamic> imagesPath){
    index = _current + 1;
    _current = 0;
    length = imagesPath.length;
    if(imagesPath.length>0){
      return Row(
        children: <Widget>[
         /* Expanded(
            flex: 0,
            child: IconButton(icon: Icon(Icons.chevron_left),onPressed: (){goToPrevious();},color: Colors.white,iconSize: 30.0,),
          ),*/
          Expanded(flex: 1,
            child: CarouselSlider(
            height: 500,
            //width: MediaQuery.of(context).size.width,
            initialPage: 0,
            enlargeCenterPage: true,
            reverse: false,
            enableInfiniteScroll: false,
            pauseAutoPlayOnTouch: Duration(seconds: 10),
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: imagesPath.map((imgUrl) {
              print('--------------image url $imgUrl---------------');
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    height: double.infinity,
                    child: Image.memory(
                      Uint8List.fromList(imgUrl),
                      fit: BoxFit.fill,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          ),
         /* Expanded(
            flex: 0,
            child: IconButton(icon: Icon(Icons.chevron_right),onPressed: (){goToNext();},color: Colors.white,iconSize: 30.0,),
          ),*/
        ],
      );
    }else {
      return Container();
    }
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }
}
