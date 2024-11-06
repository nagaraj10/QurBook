import 'package:flutter/material.dart';
import 'package:myfhb/widgets/app_primary_button.dart';
import '../../src/ui/MyRecord.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class CallDialWidget extends StatelessWidget {
  const CallDialWidget({
    required this.phoneNumber,
    required this.phoneNumberName,
  });

  final String phoneNumber;
  final String phoneNumberName;

  @override
  Widget build(BuildContext context) {
   return AppPrimaryButton(onTap: ()async {
      try {
        if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
      }
      } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      print(e);
      }
    },
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
    );
  }
}
