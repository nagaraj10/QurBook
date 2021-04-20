import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';

class EventTimeTile extends StatefulWidget {
  const EventTimeTile({
    @required this.icon,
    @required this.title,
    @required this.onTimeSelected,
    this.selectedTime,
  });

  final IconData icon;
  final String title;
  final Function onTimeSelected;
  final TimeOfDay selectedTime;

  @override
  _EventTimeTileState createState() => _EventTimeTileState();
}

class _EventTimeTileState extends State<EventTimeTile> {
  TimeOfDay timeSelected;
  String selectedTime = '07:00';
  DayPeriod selectedTimePeriod = DayPeriod.am;

  getTimeAsString(TimeOfDay timeOfDay) {
    return '${timeOfDay.hourOfPeriod > 9 ? '' : '0'}${timeOfDay.hourOfPeriod}:${timeOfDay.minute > 9 ? '' : '0'}${timeOfDay.minute}';
  }

  @override
  Widget build(BuildContext context) {
    if (timeSelected == null) {
      timeSelected = widget.selectedTime;
    }
    return Container(
      width: 0.75.sw,
      padding: EdgeInsets.symmetric(
        horizontal: 10.0.w,
        vertical: 5.0.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                widget.icon,
                color: Color(
                  CommonUtil().getMyPrimaryColor(),
                ),
              ),
              SizedBox(
                width: 10.0.w,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16.0.sp,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Container(
                width: 50.0.w,
                child: InkWell(
                  onTap: () async {
                    timeSelected = await showTimePicker(
                      context: context,
                      initialTime: timeSelected ?? TimeOfDay.now(),
                    );
                    if (timeSelected != null) {
                      setState(() {
                        selectedTimePeriod = timeSelected.period;
                        selectedTime = getTimeAsString(timeSelected);
                      });
                      widget.onTimeSelected(timeSelected);
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        selectedTime,
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                      ),
                      Divider(
                        height: 2.0.h,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 5.0.w,
              ),
              DropdownButton(
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0.sp,
                ),
                underline: SizedBox.shrink(),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 24.0.sp,
                ),
                value: selectedTimePeriod,
                onChanged: (value) {
                  setState(() {
                    selectedTimePeriod = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: DayPeriod.am,
                    child: Text('AM'),
                  ),
                  DropdownMenuItem(
                    value: DayPeriod.pm,
                    child: Text('PM'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
