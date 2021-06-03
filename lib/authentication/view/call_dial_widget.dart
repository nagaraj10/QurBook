import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class CallDialWidget extends StatelessWidget {
  const CallDialWidget({
    @required this.canDialDirectly,
    @required this.phoneNumber,
  });

  final bool canDialDirectly;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: canDialDirectly
          ? () async {
              if (await canLaunch('tel:$phoneNumber')) {
                await launch('tel:$phoneNumber');
              }
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.0.h,
        ),
        width: 160.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.phone,
              size: 24.0.sp,
              color: Colors.blueAccent,
            ),
            SizedBox(
              width: 10.0.w,
            ),
            Text(
              phoneNumber,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
