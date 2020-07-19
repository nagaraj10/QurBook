import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/GridViewNew.dart';

class SessionList extends StatefulWidget {

  final List<SessionsTime> sessionData;

  SessionList({this.sessionData});

  @override
  State<StatefulWidget> createState() {

    return SessionListState();
  }

}

class SessionListState extends State<SessionList>{

  String sessionTimings='';
  int selectedRow = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
          itemCount: widget.sessionData.length,
          itemBuilder: (BuildContext context, int index) {
            sessionTimings = removeLastThreeDigits(widget.sessionData[index].sessionStartTime)+" - "
                +removeLastThreeDigits(widget.sessionData[index].sessionEndTime);
            return Container(
              alignment: Alignment.center,
              height: 40.0,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBoxWidget(width: 15,),
                  Expanded(
                      flex: 1,
                      child: sessionTimings == ''
                          ? SizedBoxWidget(width: 132,)
                          : TextWidget(text: sessionTimings,)),
                  Expanded(
                      flex: 2,
                      child: GridViewNew(widget.sessionData[index].slots,index,(position){
                        selectedRow = position;
                        print(selectedRow);
                        setState(() {});
                      },selectedRow)),
                ],
              ),
            );
          }
      ),
    );
  }

  removeLastThreeDigits(String string){

    String removedString='';
    removedString = string.substring(0, string.length - 3);

    return removedString;
  }


}