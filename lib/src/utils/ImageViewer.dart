import 'package:flutter/material.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:provider/provider.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class ImageViewer extends StatelessWidget {
  String imageURL;
  String eid;

  ImageViewer(this.imageURL, this.eid);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
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
          actions: [
            IconButton(
              icon: Icon(
                Icons.delete,
                size: 24.0,
                color: Colors.red[600],
              ),
              padding: EdgeInsets.only(
                right: 2,
              ),
              onPressed: () async {
                final saveResponse =
                    await Provider.of<RegimentViewModel>(context, listen: false)
                        .deletMedia(eid: eid);
                onBackPressed(context);
              },
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              //height: 300.0.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  30.0.sp,
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    imageURL,
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onBackPressed(BuildContext context) {
    Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData();
    Navigator.pop(context);
  }
}
