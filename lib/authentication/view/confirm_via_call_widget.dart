import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';

class ConfirmViaCallWidget extends StatelessWidget {
  ConfirmViaCallWidget({
    @required this.ivrNumbersList,
  });

  List<dynamic> ivrNumbersList;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.sp),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0.sp,
            horizontal: 20.0.sp,
          ),
          child: Text(
            strCallFromNumber,
            style: TextStyle(
              fontSize: 15.0.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: 0.5.sw,
          alignment: Alignment.center,
          padding: EdgeInsets.all(20.0.sp),
          child: Center(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: ivrNumbersList?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    if (await canLaunch('tel:${ivrNumbersList[index] ?? ''}')) {
                      Get.back();
                      await launch('tel:${ivrNumbersList[index] ?? ''}');
                    }
                  },
                  title: Text(
                    ivrNumbersList[index] ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.phone,
                    size: 24.0.sp,
                    color: Colors.blueAccent,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
