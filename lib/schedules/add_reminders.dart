import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/src/model/ReminderModel.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;

class AddReminder extends StatefulWidget {
  final ReminderModel model;

  AddReminder({this.model});

  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  bool isUpdate = false;
  List<bool> isSelected = [false, false, false];

  static DateTime selectedDate;
  static TimeOfDay selectedTime;
  String id = '';
  String myCurrentDate = '';
  String myCurrentTime = '';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    if (widget.model != null) {
      isUpdate = true;
      tileContoller.text = widget.model.title;
      notesController.text = widget.model.notes;
      var timeArray = widget.model.time.split(':');
      selectedDate = DateTime.parse(widget.model.date);
      selectedTime = TimeOfDay(
          hour: int.parse(timeArray[0]),
          minute: int.parse(timeArray[1].substring(0, 2)));
      int intervalIndex =
          variable.selectedInterval.indexOf(widget.model.interval);
      isSelected[intervalIndex] = true;
    } else {
      isUpdate = false;
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
    }
  }

  TextEditingController tileContoller = TextEditingController();
  TextEditingController notesController = TextEditingController();
  bool _isTitleEmpty = false;
  bool _isNoteEmpty = false;
  bool _isTimeAfter = true;

  int intervalIndex = 0;

  SharedPreferences prefs;
  dynamic detailsList =
      new List(); // our default setting is to login, and we should switch to creating an account when the user chooses to
  dynamic reverseDetailsList = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        title: isUpdate
            ? Text(variable.strUpdateRemainder)
            : Text(variable.strAddRemainder),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: tileContoller,
                          decoration: InputDecoration(
                              labelText: variable.strTitle,
                              errorText: _isTitleEmpty
                                  ? variable.strTitleEmpty
                                  : null),
                        ),
                        TextFormField(
                          controller: notesController,
                          decoration: InputDecoration(
                              labelText: variable.strNote,
                              errorText:
                                  _isNoteEmpty ? variable.strNoteEmpty : null),
                        ),
                        Padding(
                          child: Text(
                            variable.strRemindMe,
                            textAlign: TextAlign.start,
                          ),
                          padding: EdgeInsets.only(top: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            OutlineButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(FHBUtils().getFormattedDateOnly(
                                      selectedDate.toString())),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                            OutlineButton(
                              onPressed: () {
                                _selectTime(context);
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(
                                      FHBUtils().formatTimeOfDay(selectedTime)),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.alarm,
                                    size: 18,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Opacity(
                              opacity: _isTimeAfter ? 0.0 : 1.0,
                              child: Text(
                                Constants.WrongTime,
                                style: TextStyle(
                                    color: Colors.red[500], fontSize: 14.0),
                              ),
                            )),
                        Text(variable.strRepeatedInterval),
                        SizedBox(height: 10),
                        Center(
                          child: ToggleButtons(
                            borderColor: Colors.black,
                            fillColor:
                                Color(new CommonUtil().getMyPrimaryColor()),
                            borderWidth: 1,
                            selectedBorderColor: Colors.black,
                            selectedColor: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minWidth: 100, maxHeight: 40),
                                child: Text(
                                  variable.strDaily,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minWidth: 100, maxHeight: 40),
                                child: Text(
                                  variable.strWeekly,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minWidth: 100, maxHeight: 40),
                                child: Text(
                                  variable.strMonthly,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                                intervalIndex = index;
                              });
                            },
                            isSelected: isSelected,
                          ),
                        ),
                      ]),
                ),
              ),
              RaisedGradientButton(
                gradient: LinearGradient(colors: [
                  Color(new CommonUtil().getMyPrimaryColor()),
                  Color(new CommonUtil().getMyGredientColor()),
                ]),
                width: 200,
                child: Text(
                  isUpdate ? variable.strUpate : variable.strSave,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setReminder();
                },
              )
            ]),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2100));

    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });

    if (FHBUtils().checkdate(selectedDate)) {
      setState(() {
        _isTimeAfter = true;
      });
    } else {
      if (FHBUtils().checkTime(selectedTime)) {
        setState(() {
          _isTimeAfter = true;
        });
      } else {
        setState(() {
          _isTimeAfter = false;
        });
      }
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
      });

    if (!FHBUtils().checkdate(selectedDate)) {
      if (FHBUtils().checkTime(selectedTime)) {
        setState(() {
          _isTimeAfter = true;
        });
      } else {
        setState(() {
          _isTimeAfter = false;
        });
      }
    }
  }

  void setReminder() async {
    if (tileContoller.text.isEmpty || notesController.text.isEmpty) {
      setState(() {
        tileContoller.text.isEmpty
            ? _isTitleEmpty = true
            : _isNoteEmpty = false;
        notesController.text.isEmpty
            ? _isNoteEmpty = true
            : _isNoteEmpty = false;
      });
    } else if (!_isTimeAfter) {
      //do nothing
    } else {
      ReminderModel model = new ReminderModel(
          title: tileContoller.text,
          notes: notesController.text,
          interval: variable.selectedInterval[intervalIndex],
          date: selectedDate.toString(),
          time: FHBUtils().formatTimeOfDay(selectedTime),
          id: isUpdate ? id = widget.model.id : DateTime.now().toString());

      if (isUpdate) {
        await FHBUtils().update(variable.strremainder, model).then((res) {
          Navigator.of(context).pop();
        });
      } else {
        await FHBUtils().create(model, variable.strremainder).then((res) {
          Navigator.of(context).pop();
        });
      }
      _triggerNotification(model);
    }
  }

  void _triggerNotification(ReminderModel model) async {
    var androidPlatformChannelSpecifies = new AndroidNotificationDetails(
        variable.strAppPackage,
        variable.strAPP_NAME,
        variable.strHealthRecordChannel,
        importance: Importance.max,
        priority: Priority.high);
    var iosPlatformChannelSpecifies = new IOSNotificationDetails();
    var platformChannelSpecifies = new NotificationDetails();
    var timeArray = model.time.split(':');
    var hour = int.parse(timeArray[0]);
    var mintues = int.parse(timeArray[1].substring(0, 2));
    var isAMPM = timeArray[1].substring(3);
    var dayFormat =
        DateFormat(variable.strFormatEE).format(DateTime.parse(model.date));
    var weekDays = {
      variable.strSunday: 0,
      variable.strMonday: 1,
      variable.strTuesday: 2,
      variable.strWednesday: 3,
      variable.strThursday: 4,
      variable.strFriday: 5,
      variable.strSaturday: 6,
    };

    var myCurrentDay = weekDays['$dayFormat'];

    if (isAMPM == variable.strPM) {
      hour = hour + 12;
      hour = hour > 23 ? 0 : hour;
    }
    switch (model.interval) {
      case variable.strDay:
        {
          var time = Time(hour, mintues, 0);
          await flutterLocalNotificationsPlugin.showDailyAtTime(
              1, model.title, model.notes, time, platformChannelSpecifies);
        }

        break;
      case variable.strWeek:
        {
          var time = Time(hour, mintues, 0);
          await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
              2,
              model.title,
              model.notes,
              Day.values[myCurrentDay],
              time,
              platformChannelSpecifies);
        }
        break;
      case variable.strMonth:
        {
          var time = DateTime.parse(widget.model.date);
          await flutterLocalNotificationsPlugin.schedule(
              3, model.title, model.notes, time, platformChannelSpecifies);
        }
        break;
      default:
        {}
        break;
    }
  }
}
