import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/record_detail/model/ImageDocumentResponse.dart';

class ImageSlider extends StatefulWidget {
  final List<HealthRecordCollection> imageList;
  final String imageURl;

  ImageSlider({this.imageList, this.imageURl});
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
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
            Expanded(
                flex: 7,
                child: widget.imageURl != null
                    ? ImageWidget(widget.imageURl)
                    : showPhotoView(widget.imageList)),
          ],
        ),
      ),
    );
  }

  showPhotoView(List<HealthRecordCollection> imageList) {
    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageList[index].healthRecordUrl),
            initialScale: PhotoViewComputedScale.contained * 1.0,
            minScale: PhotoViewComputedScale.contained * 1.0,
            maxScale: PhotoViewComputedScale.contained * 2.0);
      },
      itemCount: imageList.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0.h,
          height: 20.0.h,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
      ),
    ));
  }

  Widget ImageWidget(String imageURL) {
    return PhotoView(imageProvider: NetworkImage(imageURL));
  }
}
