import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChooseDateSlot extends StatefulWidget {
  ChooseDateSlot({Key key}) : super(key: key);

  @override
  _ChooseDateSlotState createState() => _ChooseDateSlotState();
}

class _ChooseDateSlotState extends State<ChooseDateSlot> {
  var dateList = [];
  var timeList = [];
  List<Map<String, dynamic>> finalList = [];
  TimeOfDay selectedTime = TimeOfDay.now();
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  // Map<String, String> selectedDate = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Schedule'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                child: SfDateRangePicker(
              controller: dateRangePickerController,
              selectionColor: Color(CommonUtil().getMyPrimaryColor()),
              todayHighlightColor: Color(CommonUtil().getMyPrimaryColor()),
              onSelectionChanged: _onSelectionChanged,
              enablePastDates: false,
              selectionMode: DateRangePickerSelectionMode.multiple,
              monthCellStyle: DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(color: Colors.black)),
            )),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Selected Dates',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: finalList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              removeDate(index);
                            },
                            child: Card(
                              color: Color(CommonUtil().getMyPrimaryColor()),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      changeDateFormat(
                                          finalList[index]['date'].toString()),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              // decoration: BoxDecoration(
                              //     border: Border.all(
                              //       color: Colors.grey[500],
                              //     ),
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(10))),
                              child: DropdownButton<String>(
                                items: <String>[
                                  'Any Time',
                                  'Morning',
                                  'Evening'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                isExpanded: true,
                                value: finalList[index]['selectedSession'],
                                onChanged: (value) {
                                  setState(() {
                                    finalList[index]['selectedSession'] = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 120, vertical: 5),
                width: double.infinity,
                child: FlatButton(
                  child: Text('Ok', style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    try {
                      if (finalList?.length > 0) {
                        List<String> appendedList = [];

                        for (var array in finalList) {
                          appendedList.add(getFormattedDateTimeChoose(
                                  array['date'].toString()) +
                              ' - ' +
                              array['selectedSession'].toString());
                        }

                        Navigator.pop(context, appendedList.toString());
                      } else {
                        Navigator.pop(context);
                      }
                    } catch (e) {}
                  },
                  color: Color(CommonUtil().getMyPrimaryColor()),
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getFormattedDateTimeChoose(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate = DateFormat('MMMdd').format(dateTimeStamp);
    return formattedDate;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print(args.value);
    if (args.value.length > finalList.length) {
      Map<String, dynamic> temp = {};
      temp['date'] = args.value[args.value.length - 1];
      temp['selectedSession'] = 'Any Time';
      finalList.add(temp);
      dateList.add(args.value[args.value.length - 1]);
      setState(() {});
    } else {
      List<int> notInList = [];
      for (int i = 0; i < finalList.length; i++) {
        bool found = false;
        for (int j = 0; j < args.value.length; j++) {
          print(finalList[i]['date'].toString() +
              ' second ' +
              args.value[j].toString());
          print(finalList[i]['date'].toString() == args.value[j].toString());
          if (finalList[i]['date'].toString() == args.value[j].toString()) {
            found = true;
          }
        }
        if (!found) {
          notInList.add(i);
        }
        found = false;
      }
      notInList.forEach((element) {
        finalList.removeAt(element);
      });
      setState(() {});
    }
  }

  void dialogNew() {
    final startTime = TimeOfDay(hour: 9, minute: 0);
    final endTime = TimeOfDay(hour: 22, minute: 0);
    final step = Duration(minutes: 30);
    var selectedTime = [];
    final times = getTimes(startTime, endTime, step)
        .map((tod) => tod.format(context))
        .toList();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemCount: times.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    selectedTime.add(times[index]);
                                  },
                                  child: Text(times[index].toString()),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                  FlatButton(
                    child: Text("Select"),
                    onPressed: () {
                      dateList[0]["selectedTime"] = selectedTime;
                      print(dateList);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime) {
      print('kupz');
      List list = finalList[index]['selectedTime'];
      list.add(picked_s.hour.toString() + ':' + picked_s.minute.toString());
      print(list);
      setState(() {
        finalList[index]['selectedTime'] = list;
        selectedTime = picked_s;
      });
      print(finalList);
    }
  }

  String changeDateFormat(String date) {
    String dateFormate = DateFormat("dd-MMM-yyyy").format(DateTime.parse(date));
    return dateFormate;
  }

  void removeDate(int index) {
    List<DateTime> dates = [];
    finalList.removeAt(index);
    for (int i = 0; i < finalList.length; i++) {
      print('anbu ' + finalList[i]['date'].toString());
      var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
      var date1 = inputFormat.parse(finalList[i]['date'].toString());
      dates.add(date1);
    }
    print(dates);
    setState(() {
      dateRangePickerController.selectedDates = dates;
    });
  }
}
