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

class AddReminder extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final ReminderModel model;

  AddReminder({this.model});

  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  bool isUpdate = false;
  List<bool> isSelected = [false, false, false];
  /*DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();*/
  static DateTime selectedDate;
  static TimeOfDay selectedTime;
  String id = '';
  String myCurrentDate = '';
  String myCurrentTime = '';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
//  NotificationAppLaunchDetails notificationAppLaunchDetails;
  @override
  void initState() {
    //init();

    if (widget.model != null) {
      isUpdate = true;
      tileContoller.text = widget.model.title;
      notesController.text = widget.model.notes;
      var timeArray = widget.model.time.split(':');
      selectedDate = DateTime.parse(widget.model.date);
      selectedTime = TimeOfDay(
          hour: int.parse(timeArray[0]),
          minute: int.parse(timeArray[1].substring(0, 2)));
      int intervalIndex = selectedInterval.indexOf(widget.model.interval);
      isSelected[intervalIndex] = true;
      /* print(
          '==============is selected array on update mode${isSelected.toString()}======================'); */
    } else {
      isUpdate = false;
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
    }
  }

  /*init() async{
    notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    var nsSettingsForAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var nsSettingsForIOS = new IOSInitializationSettings();
    var initializationSettingsForBothPlatoform = new InitializationSettings(nsSettingsForAndroid, nsSettingsForIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettingsForBothPlatoform,onSelectNotification: notificationAction);
  }*/

  TextEditingController tileContoller = TextEditingController();
  TextEditingController notesController = TextEditingController();
  List<String> selectedInterval = ['Day', 'Week', 'Month'];
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
        title: isUpdate ? Text('Update Reminder') : Text('Add Reminder'),
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
                              labelText: 'Title',
                              errorText: _isTitleEmpty
                                  ? 'Title can\'t be Empty'
                                  : null),
                        ),
                        TextFormField(
                          controller: notesController,
                          decoration: InputDecoration(
                              labelText: 'Notes',
                              errorText: _isNoteEmpty
                                  ? 'Notes can\'t be Empty'
                                  : null),
                        ),
                        Padding(
                          child: Text(
                            'Remind me',
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
                                  Text(
                                      /*isUpdate?FHBUtils().getFormattedDateOnly(widget.model.date):*/
                                      FHBUtils().getFormattedDateOnly(
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
                                //setState(() {});
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(/*isUpdate?widget.model.time:*/
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
                                'wrong time picked',
                                style: TextStyle(
                                    color: Colors.red[500], fontSize: 14.0),
                              ),
                            )),
                        Text('Repeated interval'),
                        SizedBox(height: 10),
                        Center(
                          child: ToggleButtons(
                            borderColor: Colors.black,
                            //TODO chnage theme
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
                                //padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Daily',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minWidth: 100, maxHeight: 40),
                                //padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Weekly',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minWidth: 100, maxHeight: 40),
                                //padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Monthly',
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

                        /*  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            OutlineButton(
                                onPressed: () {}, child: Text('Daily')),
                            OutlineButton(
                                onPressed: () {}, child: Text('Weekly')),
                            OutlineButton(
                                onPressed: () {}, child: Text('Monthly'))
                          ],
                        ) */
                      ]),
                ),
              ),
              RaisedGradientButton(
                gradient: LinearGradient(colors: [
                  //TODO chnage theme
                  Color(new CommonUtil().getMyPrimaryColor()),
                  Color(new CommonUtil().getMyGredientColor()),
                ]),
                width: 200,
                child: Text(
                  isUpdate ? 'Update' : 'Save',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setReminder();
                  //Navigator.of(context).pop();
                },
              )
              //RaisedButton(child: Text('Save'), onPressed: () {})
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
      //print('280------$_isTimeAfter');
      setState(() {
        _isTimeAfter = true;
      });
      //print('284------$_isTimeAfter');
    } else {
      if (FHBUtils().checkTime(selectedTime)) {
        setState(() {
          _isTimeAfter = true;
        });
        //print('288------$_isTimeAfter');
        //_isTimeAfter=true;
      } else {
        setState(() {
          _isTimeAfter = false;
        });
        //print('292------$_isTimeAfter');
        //_isTimeAfter=false;
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

    //print('291------$_isTimeAfter');
    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
      });

    //todo check date and time

    if (!FHBUtils().checkdate(selectedDate)) {
      if (FHBUtils().checkTime(selectedTime)) {
        setState(() {
          _isTimeAfter = true;
        });
        //print('299------$_isTimeAfter');
        //_isTimeAfter=true;
      } else {
        setState(() {
          _isTimeAfter = false;
        });
        //print('303------$_isTimeAfter');
        //_isTimeAfter=false;
      }
    }
  }

  void setReminder() async {
    //prefs = await SharedPreferences.getInstance();
    //TODO logic to check text field is empty or not
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
          interval: selectedInterval[intervalIndex],
          date: selectedDate.toString(),
          time: FHBUtils().formatTimeOfDay(selectedTime),
          id: isUpdate ? id = widget.model.id : DateTime.now().toString());

      if (isUpdate) {
        await FHBUtils().update('reminders', model).then((res) {
          Navigator.of(context).pop();
        });
      } else {
        await FHBUtils().create(model, 'reminders').then((res) {
          Navigator.of(context).pop();
          //MyReminders.of(context).refresh();
        });
      }
      _triggerNotification(model);
    }
  }

  void _triggerNotification(ReminderModel model) async {
    var androidPlatformChannelSpecifies = new AndroidNotificationDetails(
        'com.globalmantrainnovations.myfhb', 'MYFHB', 'Health Record channel',
        importance: Importance.Max, priority: Priority.High);
    var iosPlatformChannelSpecifies = new IOSNotificationDetails();
    var platformChannelSpecifies = new NotificationDetails(
        androidPlatformChannelSpecifies, iosPlatformChannelSpecifies);
    //await flutterLocalNotificationsPlugin.show(0, 'TEST', 'Hi floks this sample notification', platformChannelSpecifies,payload: 'Hello mohan!! How are you?');
    var timeArray = model.time.split(':');
    var hour = int.parse(timeArray[0]);
    var mintues = int.parse(timeArray[1].substring(0, 2));
    var isAMPM = timeArray[1].substring(3);
    var dayFormat = DateFormat('EEEE').format(DateTime.parse(model.date));
    var weekDays = {
      'Sunday': 0,
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
    };

    var myCurrentDay = weekDays['$dayFormat'];

    if (isAMPM == 'PM') {
      hour = hour + 12;
      hour = hour > 23 ? 0 : hour;
    }
    switch (model.interval) {
      case 'Day':
        {
          //var time = Time(hour, mintues, 0);
          var time = Time(hour, mintues, 0);
          await flutterLocalNotificationsPlugin.showDailyAtTime(
              1, model.title, model.notes, time, platformChannelSpecifies);
        }

        break;
      case 'Week':
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
      case 'Month':
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

    //await flutterLocalNotificationsPlugin.
//    await flutterLocalNotificationsPlugin.show(0, 'TEST', 'Hi floks this sample notification', platformChannelSpecifies,payload: 'Hello mohan!! How are you?');
  }

  /*getRemindersList() async {
    prefs = await SharedPreferences.getInstance();

    String getData = await prefs.get('reminders');
    if (getData == null) {
      detailsList = new List();
    } else {
      detailsList = json.decode(getData);

      reverseDetailsList = detailsList.reversed.toList();
    }

    return detailsList;
  }*/
}
