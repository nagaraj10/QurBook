import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/view_model/otp_view_model.dart';
import 'package:provider/provider.dart';

class ConfirmViaCallWidget extends StatelessWidget {
  ConfirmViaCallWidget({
    @required this.ivrNumbersList,
    @required this.canDialDirectly,
  });

  List<dynamic> ivrNumbersList;
  final bool canDialDirectly;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<OtpViewModel>(context, listen: false)
            ?.updateDialogStatus(false);
        return Future.value(true);
      },
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0.sp),
        ),
        contentPadding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 20.0.h,
              right: 20.0.w,
              left: 20.0.w,
            ),
            child: Text(
              canDialDirectly ? strCallDirect : strCallFromNumber,
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
            padding: EdgeInsets.symmetric(
              horizontal: 20.0.w,
              vertical: 10.0.h,
            ),
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ivrNumbersList?.length ?? 0,
                itemBuilder: (context, index) {
                  return ('${ivrNumbersList[index] ?? ''}').isNotEmpty
                      ? InkWell(
                          onTap: canDialDirectly
                              ? () async {
                                  if (await canLaunch(
                                      'tel:${ivrNumbersList[index] ?? ''}')) {
                                    await launch(
                                        'tel:${ivrNumbersList[index] ?? ''}');
                                  }
                                }
                              : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0.h,
                            ),
                            constraints: BoxConstraints(minWidth: 0.5.sw),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
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
                                  ivrNumbersList[index] ?? '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
