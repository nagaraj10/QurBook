import 'package:flutter/material.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class ImageViewer extends StatelessWidget {
  String imageURL;
  ImageViewer(
    this.imageURL,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: RichText(
          text: TextSpan(
            text: 'Image',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.0.sp,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () => onBackPressed(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // add custom icons also
            size: 24.0.sp,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 300.0.h,
          height: 300.0.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              30.0.sp,
            ),
          ),
          child: Image(
            image: NetworkImage(
              imageURL,
            ),
            errorBuilder: (context, exception, stackTrack) => Column(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                Text(
                  "Failed to get the image",
                )
              ],
            ),
            loadingBuilder: (context, exception, stackTrack) =>
                CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
