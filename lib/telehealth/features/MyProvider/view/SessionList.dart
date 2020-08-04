import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/GridViewNew.dart';

class SessionList extends StatefulWidget {
  final List<SessionsTime> sessionData;
  Function(int, int) selectedPosition;

  SessionList({this.sessionData, this.selectedPosition});

  @override
  State<StatefulWidget> createState() {
    return SessionListState();
  }
}

class SessionListState extends State<SessionList> {
  CommonUtil commonUtil = new CommonUtil();
  String sessionTimings = '';
  int selectedRow = -1;
  int selectedItem = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.sessionData.length,
          itemBuilder: (BuildContext context, int index) {
            sessionTimings = commonUtil.removeLastThreeDigits(
                    widget.sessionData[index].sessionStartTime) +
                " - " +
                commonUtil.removeLastThreeDigits(
                    widget.sessionData[index].sessionEndTime);
            return Container(
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: widget.sessionData[index].slots.length > 0
                        ? true
                        : false,
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBoxWidget(width: 10),
                        Expanded(
                            flex: 1,
                            child: sessionTimings == ''
                                ? SizedBoxWidget(
                                    width: 132,
                                  )
                                : TextWidget(text: sessionTimings)),
                        Expanded(
                            flex: 2,
                            child: GridViewNew(
                                widget.sessionData[index].slots, index,
                                (rowPosition, itemPosition) {
                              selectedRow = rowPosition;
                              selectedItem = itemPosition;
                              widget.selectedPosition(
                                  rowPosition, itemPosition);
                              setState(() {});
                            }, selectedRow)),
                        SizedBoxWidget(width: 10),
                      ],
                    ),
                  ),
                  SizedBoxWidget(
                    height: 12.0,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
