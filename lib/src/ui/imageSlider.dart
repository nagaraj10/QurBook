import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/record_detail/model/ImageDocumentResponse.dart';


class ImageSlider extends StatefulWidget {
  final List<ImageDocumentResponse> imageList;

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
                  child: Text(variable.strClose),
                  textColor: Colors.white70,
                  borderSide: BorderSide(color: Colors.white70),
                  onPressed: Navigator.of(context).pop),
            ),

            Expanded(flex: 7, child: showPhotoView(widget.imageList)
                ),
          ],
        ),
      ),
    );
  }
  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  showPhotoView(List<ImageDocumentResponse> imageList) {
    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
                imageList[index].response.data.fileContent),
            initialScale: PhotoViewComputedScale.contained * 1.0,
            minScale: PhotoViewComputedScale.contained * 1.0,
            maxScale: PhotoViewComputedScale.contained * 2.0
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
    ));
  }
}
