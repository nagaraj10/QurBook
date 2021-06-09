import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/view_model/otp_view_model.dart';
import 'package:myfhb/authentication/view/call_dial_widget.dart';
import 'package:provider/provider.dart';
import 'or_divider.dart';

class ConfirmViaCallWidget extends StatelessWidget {
  ConfirmViaCallWidget({
    @required this.ivrNumbersList,
  });

  List<String> ivrNumbersList;

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
              strCallDirect,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: getPhoneWidgets(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getPhoneWidgets() {
    final phoneWidgets = <Widget>[];
    primaryNumber;
    int index = 0;
    for (var ivrNumber in ivrNumbersList) {
      phoneWidgets.add(('${ivrNumber ?? ''}').isNotEmpty
          ? Column(
              children: [
                if (index != 0) OrDivider(),
                CallDialWidget(
                  phoneNumber: ivrNumber ?? '',
                  phoneNumberName:
                      index == 0 ? primaryNumber : '${alternateNumber} $index',
                ),
              ],
            )
          : const SizedBox.shrink());
      index++;
    }
    return phoneWidgets;
  }
}
