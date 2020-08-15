import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/BookingConfirmation.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/SessionList.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class GetTimeSlots extends StatelessWidget {
  SessionData dateSlotTimingsObj;
  final List<DoctorIds> docs;
  final int j;
  final DateTime selectedDate;
  FlutterToast toast = new FlutterToast();

  GetTimeSlots({this.dateSlotTimingsObj,this.docs,this.j,this.selectedDate});

  @override
  Widget build(BuildContext context) {
    int rowPosition=-1;
    int itemPosition=-1;
    return Column(
      children: <Widget>[
        SessionList(
          sessionData: dateSlotTimingsObj.sessions,
          selectedPosition: (rowPos, itemPos) {
            rowPosition = rowPos;
            itemPosition = itemPos;
          },
        ),
        SizedBoxWidget(height: 10,),
        Align(
          alignment: Alignment.center,
          child: SizedBoxWithChild(
            width: 85,
            height: 35,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side:
                  BorderSide(color: Color(new CommonUtil().getMyPrimaryColor()))),
              color: Colors.transparent,
              textColor: Color(new CommonUtil().getMyPrimaryColor()),
              padding: EdgeInsets.all(8.0),
              onPressed: () {

              },
              child: TextWidget(text: bookNow, fontsize: 12),
            ),
          ),
        ),
        SizedBoxWidget(
          height: 10,
        ),
      ],
    );
  }
}
