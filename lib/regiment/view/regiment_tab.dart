import 'package:flutter/material.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:provider/provider.dart';
import 'widgets/regiment_data_card.dart';
import 'widgets/event_time_tile.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/constants/fhb_constants.dart';

class RegimentTab extends StatefulWidget {
  @override
  _RegimentTabState createState() => _RegimentTabState();
}

class _RegimentTabState extends State<RegimentTab> {
  RegimentViewModel _regimentViewModel;
  @override
  void initState() {
    super.initState();
    Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
      isInitial: true,
    );
  }

  Color getColor(Activityname activityname) {
    Color cardColor;
    switch (activityname) {
      case Activityname.DIET:
        cardColor = Colors.green;
        break;
      case Activityname.VITALS:
        cardColor = Colors.lightBlueAccent;
        break;
      case Activityname.MEDICATION:
        cardColor = Colors.blue;
        break;
      case Activityname.SCREENING:
        cardColor = Colors.teal;
        break;
      default:
        cardColor = Color(CommonUtil().getMyPrimaryColor());
    }
    return cardColor;
  }

  IconData getIcon(Activityname activityname) {
    IconData cardIcon;
    switch (activityname) {
      case Activityname.DIET:
        cardIcon = Icons.fastfood_rounded;
        break;
      case Activityname.VITALS:
        cardIcon = Icons.style;
        break;
      case Activityname.MEDICATION:
        cardIcon = Icons.medical_services;
        break;
      case Activityname.SCREENING:
        cardIcon = Icons.screen_search_desktop;
        break;
      default:
        cardIcon = Icons.lock_clock;
    }
    return cardIcon;
  }

  @override
  Widget build(BuildContext context) {
    _regimentViewModel = Provider.of<RegimentViewModel>(context);
    return Column(
      children: [
        Container(
          width: 1.sw,
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
                      _regimentViewModel.getRegimentDate(isPrevious: true);
                    },
                  ),
                  SizedBox(
                    width: 5.0.w,
                  ),
                  InkWell(
                    onTap: () async {
                      DateTime selectedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                        initialDate: _regimentViewModel.selectedDate,
                      );
                      if (selectedDate != null) {
                        _regimentViewModel.getRegimentDate(
                          dateTime: selectedDate,
                        );
                      }
                    },
                    child: Text(
                      '${_regimentViewModel.regimentDate}',
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        color: Color(CommonUtil().getMyPrimaryColor()),
                      ),
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
                      _regimentViewModel.getRegimentDate(isNext: true);
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
                        return StatefulBuilder(builder: (context, setState) {
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
                                selectedTime: TimeOfDay(hour: 0, minute: 10),
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
                                icon: Icons.bedtime_rounded,
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
                                        okButton,
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
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(
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
        Expanded(
          child: FutureBuilder<RegimentResponseModel>(
            future: _regimentViewModel.regimentsData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return ErrorsWidget();
                } else {
                  if (snapshot.hasData &&
                      (snapshot?.data?.regimentsList?.length ?? 0) > 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        bottom: 10.0.h,
                      ),
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.regimentsList.length,
                      itemBuilder: (context, index) {
                        var regimentData = snapshot.data.regimentsList[index];
                        return RegimentDataCard(
                          title: regimentData.title,
                          time: DateFormat('HH:mm\na')
                              .format(regimentData.estart),
                          color: getColor(regimentData.activityname),
                          icon: getIcon(regimentData.activityname),
                          vitalsData: regimentData.uformdata.vitalsData,
                          eid: regimentData.eid,
                        );
                        // RegimentDataCard(
                        // //TODO: Replace with actual data
                        // title: 'Glucose (Fasting)',
                        // time: '06:15 AM',
                        // color: Colors.green,
                        // icon: Icons.no_food_outlined,
                        // ),
                        // RegimentDataCard(
                        // //TODO: Replace with actual data
                        // title: 'Medicine (Before Food)',
                        // time: '06:45 AM',
                        // color: Colors.lightBlueAccent,
                        // icon: Icons.medical_services_outlined,
                        // needCheckbox: true,
                        // ),
                        // RegimentDataCard(
                        // //TODO: Replace with actual data
                        // title: 'Walking',
                        // time: '07:00 AM',
                        // color: Colors.blue,
                        // icon: Icons.directions_walk_rounded,
                        // ),
                        // RegimentDataCard(
                        // //TODO: Replace with actual data
                        // title: 'Food',
                        // time: '08:00 AM',
                        // color: Color(CommonUtil().getMyPrimaryColor()),
                        // icon: Icons.fastfood_rounded,
                        // ),
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                            10.0.sp,
                          ),
                          child: Text(
                            noRegimentData,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }
                }
              } else if (snapshot.hasError) {
                return ErrorsWidget();
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(CommonUtil().getMyPrimaryColor()),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
