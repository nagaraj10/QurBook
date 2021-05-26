import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';

class EventTimeTile extends StatefulWidget {
  const EventTimeTile({
    @required this.title,
    @required this.onTimeSelected,
    this.selectedTime,
  });

  final String title;
  final Function onTimeSelected;
  final TimeOfDay selectedTime;

  @override
  _EventTimeTileState createState() => _EventTimeTileState();
}

class _EventTimeTileState extends State<EventTimeTile> {
  TimeOfDay timeSelected;
  DayPeriod selectedTimePeriod = DayPeriod.am;

  getTimeAsString(TimeOfDay timeOfDay) {
    selectedTimePeriod = timeOfDay.period;
    int hour = timeOfDay?.hourOfPeriod;
    if (timeOfDay?.hour == 12) {
      hour = 12;
    }
    return '${hour > 9 ? '' : '0'}${hour}:${timeOfDay.minute > 9 ? '' : '0'}${timeOfDay.minute}';
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
                getIcon(widget.title),
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
                      });
                      widget.onTimeSelected(
                        timeSelected,
                        widget.title,
                      );
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getTimeAsString(timeSelected),
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

  IconData getIcon(String title) {
    IconData icon = Icons.event;
    if (title.toLowerCase().contains('wakeup')) {
      icon = Icons.king_bed_rounded;
    } else if (title.toLowerCase().contains('breakfast')) {
      icon = Icons.fastfood_rounded;
    } else if (title.toLowerCase().contains('lunch')) {
      icon = Icons.fastfood_outlined;
    } else if (title.toLowerCase().contains('tea')) {
      icon = Icons.emoji_food_beverage;
    } else if (title.toLowerCase().contains('dinner')) {
      icon = Icons.food_bank;
    } else if (title.toLowerCase().contains('sleep')) {
      icon = Icons.bedtime_rounded;
    }
    return icon;
  }
}

// EventTimeTile(
// title: 'Wake up time',
// icon: Icons.king_bed_rounded,
// onTimeSelected: (timeSelected) {
// print(timeSelected);
// },
// ),
// EventTimeTile(
// title: 'Breakfast',
// icon: Icons.fastfood_rounded,
// onTimeSelected: (timeSelected) {
// print(timeSelected);
// },
// ),
// EventTimeTile(
// title: 'Break',
// icon: Icons.free_breakfast,
// onTimeSelected: (timeSelected) {
// print(timeSelected);
// },
// ),
// EventTimeTile(
// title: 'Lunch time',
// icon: Icons.fastfood_outlined,
// selectedTime: TimeOfDay(hour: 0, minute: 10),
// onTimeSelected: (timeSelected) {
// print(timeSelected);
// },
// ),
// EventTimeTile(
// title: 'Tea',
// icon: Icons.emoji_food_beverage,
// onTimeSelected: (timeSelected) {
// print(timeSelected);
// },
// ),
// EventTimeTile(
// title: 'Dinner',
// icon: Icons.food_bank,
// onTimeSelected: (timeSelected) {
// print(timeSelected);
// },
// ),
// EventTimeTile(
// title: 'Sleep time',
// icon: Icons.bedtime_rounded,
// onTimeSelected: (timeSelected) {
// print(timeSelected);
// },
// ),
