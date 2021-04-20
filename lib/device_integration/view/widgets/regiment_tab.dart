import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'regiment_data_card.dart';
import 'event_time_tile.dart';

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                  Padding(
                    padding: EdgeInsets.only(
                      right: 5.0.w,
                    ),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return SimpleDialog(
                                children: [
                                  EventTimeTile(
                                    title: 'Wake up time',
                                    icon: Icons.king_bed_rounded,
                                    onTimeSelected: (timeSelected) {
                                      print(timeSelected);
                                    },
                                  ),
                                  EventTimeTile(
                                    title: 'Breakfast',
                                    icon: Icons.fastfood_rounded,
                                    onTimeSelected: (timeSelected) {
                                      print(timeSelected);
                                    },
                                  ),
                                  EventTimeTile(
                                    title: 'Break',
                                    icon: Icons.free_breakfast,
                                    onTimeSelected: (timeSelected) {
                                      print(timeSelected);
                                    },
                                  ),
                                  EventTimeTile(
                                    title: 'Lunch time',
                                    icon: Icons.fastfood_outlined,
                                    onTimeSelected: (timeSelected) {
                                      print(timeSelected);
                                    },
                                  ),
                                  EventTimeTile(
                                    title: 'Tea',
                                    icon: Icons.emoji_food_beverage,
                                    onTimeSelected: (timeSelected) {
                                      print(timeSelected);
                                    },
                                  ),
                                  EventTimeTile(
                                    title: 'Dinner',
                                    icon: Icons.food_bank,
                                    onTimeSelected: (timeSelected) {
                                      print(timeSelected);
                                    },
                                  ),
                                  EventTimeTile(
                                    title: 'Sleep time',
                                    icon: Icons.bedtime_sharp,
                                    onTimeSelected: (timeSelected) {
                                      print(timeSelected);
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 150.0.w,
                                        child: RaisedButton(
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                              fontSize: 16.0.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          color: Color(
                                              CommonUtil().getMyPrimaryColor()),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                              5.0.sp,
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                contentPadding: EdgeInsets.all(10.0.sp),
                              );
                            });
                          },
                        );
                      },
                      child: Icon(
                        Icons.access_time,
                        size: 24.0.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RegimentDataCard(
              //TODO: Replace with actual data
              title: 'Blood Pressure',
              time: '06:00 AM',
              color: Colors.teal,
              icon: Icons.meeting_room_outlined,
            ),
            RegimentDataCard(
              //TODO: Replace with actual data
              title: 'Glucose (Fasting)',
              time: '06:15 AM',
              color: Colors.green,
              icon: Icons.no_food_outlined,
            ),
            RegimentDataCard(
              //TODO: Replace with actual data
              title: 'Medicine (Before Food)',
              time: '06:45 AM',
              color: Colors.lightBlueAccent,
              icon: Icons.medical_services_outlined,
              needCheckbox: true,
            ),
            RegimentDataCard(
              //TODO: Replace with actual data
              title: 'Walking',
              time: '07:00 AM',
              color: Colors.blue,
              icon: Icons.directions_walk_rounded,
            ),
            RegimentDataCard(
              //TODO: Replace with actual data
              title: 'Food',
              time: '08:00 AM',
              color: Color(CommonUtil().getMyPrimaryColor()),
              icon: Icons.fastfood_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
