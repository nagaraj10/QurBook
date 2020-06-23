import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
            Padding(
              padding: EdgeInsets.only(top: 30, right: 10),
              child: OutlineButton(
                  child: Text('Close'),
                  textColor: Colors.white70,
                  borderSide: BorderSide(color: Colors.white70),
                  onPressed: Navigator.of(context).pop),
            ),

            Expanded(flex: 7, child: showPhotoView(widget.imageList)
                //_loadImage(widget.imageList),
                ),
            //Expanded(flex: 1,child: SizedBox(height: 5,)),
          ],
        ),
      ),
    );
  }

  /*  Widget _loadImage(List<dynamic> imagesPath) {
    index = _current + 1;
    _current = 0;
    length = imagesPath.length;
    if (imagesPath.length > 0) {
      return Row(
        children: <Widget>[
          /* Expanded(
                        flex: 0,
                        child: IconButton(icon: Icon(Icons.chevron_left),onPressed: (){goToPrevious();},color: Colors.white,iconSize: 30.0,),
                      ),*/
          Expanded(
            flex: 1,
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
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: PhotoView(
                            minScale: 0.6,
                            imageProvider:
                                MemoryImage(Uint8List.fromList(imgUrl))));
                  },
                );
              }).toList(),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  */

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  showPhotoView(List imageList) {
    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
            imageProvider: MemoryImage(imageList[index]),
            initialScale: PhotoViewComputedScale.contained * 1.0,
            minScale: PhotoViewComputedScale.contained * 1.0,
            maxScale: PhotoViewComputedScale.contained * 2.0
            //heroAttributes: HeroAttributes(tag: galleryItems[index].id),
            );
      },
      itemCount: imageList.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
      ),
      /*  backgroundDecoration: widget.backgroundDecoration,
      pageController: widget.pageController,
      onPageChanged: onPageChanged, */
    ));
  }
}
