import 'package:flutter/material.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:url_launcher/url_launcher.dart';

class CallDialWidget extends StatelessWidget {
  const CallDialWidget({
    @required this.phoneNumber,
    @required this.phoneNumberName,
  });

  final String phoneNumber;
  final String phoneNumberName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10.0.h,
        horizontal: 10.0.w,
      ),
      child: RaisedGradientButton(
        gradient: LinearGradient(colors: [
          Color(new CommonUtil().getMyPrimaryColor()),
          Color(new CommonUtil().getMyGredientColor()),
        ]),
        width: 220.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              phoneNumberName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0.sp,
              ),
            ),
            SizedBox(
              width: 10.0.w,
            ),
            Icon(
              Icons.phone,
              size: 24.0.sp,
              color: Colors.white,
            ),
          ],
        ),
        onPressed: () async {
          if (await canLaunch('tel:$phoneNumber')) {
            await launch('tel:$phoneNumber');
          }
        },
      ),
    );
  }
}
