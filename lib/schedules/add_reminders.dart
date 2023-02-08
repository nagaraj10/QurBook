
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import '../src/model/ReminderModel.dart';
import '../src/utils/FHBUtils.dart';
import '../widgets/GradientAppBar.dart';
import '../widgets/RaisedGradientButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/CommonUtil.dart';
import '../constants/fhb_constants.dart' as Constants;
import '../constants/variable_constant.dart' as variable;
import '../src/utils/screenutils/size_extensions.dart';

class AddReminder extends StatefulWidget {
  final ReminderModel? model;

  const AddReminder({this.model});

  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  bool isUpdate = false;
  List<bool> isSelected = [false, false, false];

  static DateTime? selectedDate;
  static TimeOfDay? selectedTime;
  String? id = '';
  String myCurrentDate = '';
  String myCurrentTime = '';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    if (widget.model != null) {
      isUpdate = true;
      tileContoller.text = widget.model!.title!;
      notesController.text = widget.model!.notes!;
      final timeArray = widget.model!.time!.split(':');
      selectedDate = DateTime.parse(widget.model!.date!);
      selectedTime = TimeOfDay(
          hour: int.parse(timeArray[0]),
          minute: int.parse(timeArray[1].substring(0, 2)));
      var intervalIndex =
          variable.selectedInterval.indexOf(widget.model!.interval);
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

  SharedPreferences? prefs;
  dynamic detailsList =
      []; // our default setting is to login, and we should switch to creating an account when the user chooses to
  dynamic reverseDetailsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        title: isUpdate
            ? Text(variable.strUpdateRemainder)
            : Text(variable.strAddRemainder),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
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
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            fontSize: 16.0.sp,
                          ),
                          controller: tileContoller,
                          decoration: InputDecoration(
                              labelText: variable.strTitle,
                              errorText: _isTitleEmpty
                                  ? variable.strTitleEmpty
                                  : null),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            fontSize: 16.0.sp,
                          ),
                          controller: notesController,
                          decoration: InputDecoration(
                              labelText: variable.strNote,
                              errorText:
                                  _isNoteEmpty ? variable.strNoteEmpty : null),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            variable.strRemindMe,
                            textAlign: TextAlign.start,
                          ),
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
                                  SizedBox(width: 10.0.w),
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18.0.sp,
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
                                      FHBUtils().formatTimeOfDay(selectedTime!)),
                                  SizedBox(width: 10.0.w),
                                  Icon(
                                    Icons.alarm,
                                    size: 18.0.sp,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Opacity(
                              opacity: _isTimeAfter ? 0.0 : 1.0,
                              child: Text(
                                Constants.WrongTime,
                                style: TextStyle(
                                  color: Colors.red[500],
                                  fontSize: 16.0.sp,
                                ),
                              ),
                            )),
                        Text(variable.strRepeatedInterval),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Center(
                          child: ToggleButtons(
                            borderColor: Colors.black,
                            fillColor: Color(CommonUtil().getMyPrimaryColor()),
                            borderWidth: 1,
                            selectedBorderColor: Colors.black,
                            selectedColor: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            onPressed: (index) {
                              setState(() {
                                for (var i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                                intervalIndex = index;
                              });
                            },
                            isSelected: isSelected,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                  minWidth: 100.0.w,
                                  maxHeight: 40.0.h,
                                ),
                                child: Text(
                                  variable.strDaily,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                  minWidth: 100.0.w,
                                  maxHeight: 40.0.h,
                                ),
                                child: Text(
                                  variable.strWeekly,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                  minWidth: 100.0.w,
                                  maxHeight: 40.0.h,
                                ),
                                child: Text(
                                  variable.strMonthly,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              RaisedGradientButton(
                gradient: LinearGradient(colors: [
                  Color(CommonUtil().getMyPrimaryColor()),
                  Color(CommonUtil().getMyGredientColor()),
                ]),
                width: 200.0.w,
                onPressed: () {
                  setReminder();
                },
                child: Text(
                  isUpdate ? variable.strUpate : variable.strSave,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0.sp,
                  ),
                ),
              )
            ]),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2100));

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }

    if (FHBUtils().checkdate(selectedDate!)) {
      setState(() {
        _isTimeAfter = true;
      });
    } else {
      if (FHBUtils().checkTime(selectedTime!)) {
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
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }

    if (!FHBUtils().checkdate(selectedDate!)) {
      if (FHBUtils().checkTime(selectedTime!)) {
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
      final model = ReminderModel(
          title: tileContoller.text,
          notes: notesController.text,
          interval: variable.selectedInterval[intervalIndex],
          date: selectedDate.toString(),
          time: FHBUtils().formatTimeOfDay(selectedTime!),
          id: isUpdate ? id = widget.model!.id : DateTime.now().toString());

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
    final androidPlatformChannelSpecifies = AndroidNotificationDetails(
        variable.strAppPackage,
        variable.strAPP_NAME,
        variable.strHealthRecordChannel,
        importance: Importance.max,
        priority: Priority.high);
    final iosPlatformChannelSpecifies = IOSNotificationDetails();
    final platformChannelSpecifies = NotificationDetails();
    final timeArray = model.time!.split(':');
    var hour = int.parse(timeArray[0]);
    final mintues = int.parse(timeArray[1].substring(0, 2));
    final isAMPM = timeArray[1].substring(3);
    final dayFormat =
        DateFormat(variable.strFormatEE).format(DateTime.parse(model.date!));
    final weekDays = {
      variable.strSunday: 0,
      variable.strMonday: 1,
      variable.strTuesday: 2,
      variable.strWednesday: 3,
      variable.strThursday: 4,
      variable.strFriday: 5,
      variable.strSaturday: 6,
    };

    final myCurrentDay = weekDays[dayFormat];

    if (isAMPM == variable.strPM) {
      hour = hour + 12;
      hour = hour > 23 ? 0 : hour;
    }
    switch (model.interval) {
      case variable.strDay:
        {
          final time = Time(hour, mintues);
          await flutterLocalNotificationsPlugin.showDailyAtTime(
              1, model.title, model.notes, time, platformChannelSpecifies);
        }

        break;
      case variable.strWeek:
        {
          final time = Time(hour, mintues);
          await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
              2,
              model.title,
              model.notes,
              Day.values[myCurrentDay!],
              time,
              platformChannelSpecifies);
        }
        break;
      case variable.strMonth:
        {
          final time = DateTime.parse(widget.model!.date!);
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
