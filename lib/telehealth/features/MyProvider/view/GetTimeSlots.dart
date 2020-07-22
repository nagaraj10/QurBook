import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/showAlertDialog.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';
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

  GetTimeSlots({this.dateSlotTimingsObj,this.docs,this.j,this.selectedDate});

  @override
  Widget build(BuildContext context) {
    int rowPosition;
    int itemPosition;
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
                if(rowPosition>-1&&itemPosition>-1){
                  navigateToConfirmBook(context,rowPosition,itemPosition);
                }else{
                  /*Fluttertoast.showToast(
                      msg: "Please select the time slot before you book",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue[800],
                      textColor: Colors.white,
                      fontSize: 14.0
                  );*/
                }
              },
              child: TextWidget(text: 'Book Now', fontsize: 12),
            ),
          ),
        ),
        SizedBoxWidget(
          height: 10,
        ),
      ],
    );
  }

  navigateToConfirmBook(BuildContext context,int rowPos,int itemPos){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmation(
              docs: docs,
              i: j,
              selectedDate: selectedDate,
              sessionData: dateSlotTimingsObj.sessions,
              rowPosition: rowPos,
              itemPosition: itemPos),
        ));
  }
}
