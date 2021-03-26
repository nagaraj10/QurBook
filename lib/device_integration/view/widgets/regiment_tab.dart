import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'regiment_data_card.dart';

class RegimentTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 1.sw,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(10.0.sp),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    child: Icon(
                      Icons.chevron_left_rounded,
                      size: 24.0.sp,
                      color: Color(CommonUtil().getMyPrimaryColor()),
                    ),
                    onTap: () {
                      Provider.of<DevicesViewModel>(context, listen: false)
                          .getRegimentDate(isPrevious: true);
                    },
                  ),
                  SizedBox(
                    width: 5.0.w,
                  ),
                  Text(
                    '${Provider.of<DevicesViewModel>(context).regimentDate}',
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      color: Color(CommonUtil().getMyPrimaryColor()),
                    ),
                  ),
                  SizedBox(
                    width: 5.0.w,
                  ),
                  InkWell(
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 24.0.sp,
                      color: Color(CommonUtil().getMyPrimaryColor()),
                    ),
                    onTap: () {
                      Provider.of<DevicesViewModel>(context, listen: false)
                          .getRegimentDate(isNext: true);
                    },
                  ),
                ],
              ),
            ),
            RegimentDataCard(
              //TODO: Replace with actual data
              title: 'Blood Pressure',
            ),
          ],
        ),
      ),
    );
  }
}
