import 'dart:core';
import 'package:flutter/material.dart';
import '../src/model/AppointmentModel.dart';
import '../src/model/ReminderModel.dart';
import '../src/utils/FHBUtils.dart';
import '../widgets/GradientAppBar.dart';
import '../widgets/RaisedGradientButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/CommonUtil.dart';
import '../constants/fhb_constants.dart' as Constants;
import '../src/utils/screenutils/size_extensions.dart';

class AddAppointments extends StatefulWidget {
  final ReminderModel model;

  const AddAppointments({this.model});

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointments> {
  List<bool> isSelected = [false, false, false];
  static DateTime selectedDate;
  static TimeOfDay selectedTime;
  String id = '';
  String myCurrentDate = '';
  String myCurrentTime = '';
  @override
  void initState() {
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  TextEditingController hosContoller = TextEditingController();
  TextEditingController docNameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  bool _isTitleEmpty = false;
  bool _isNoteEmpty = false;
  bool _isTimeAfter = true;

  int intervalIndex = 0;

  SharedPreferences prefs;
  dynamic detailsList =
      List(); // our default setting is to login, and we should switch to creating an account when the user chooses to
  dynamic reverseDetailsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        title: Text(Constants.AddAppointment),
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
                          style: TextStyle(
                            fontSize: 16.0.sp,
                          ),
                          controller: hosContoller,
                          decoration: InputDecoration(
                              labelText: Constants.HospitalName,
                              errorText: _isTitleEmpty
                                  ? Constants.hopspitalEmpty
                                  : null),
                        ),
                        TextFormField(
                          style: TextStyle(
                            fontSize: 16.0.sp,
                          ),
                          controller: docNameController,
                          decoration: InputDecoration(
                              labelText: Constants.DoctorName,
                              errorText: _isNoteEmpty
                                  ? Constants.DoctorNameEmpty
                                  : null),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            Constants.AppointmentDateTime,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.0.sp,
                            ),
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
                                      FHBUtils().formatTimeOfDay(selectedTime)),
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
                        SizedBox(height: 10.0.h),
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
                        TextFormField(
                          style: TextStyle(
                            fontSize: 16.0.sp,
                          ),
                          controller: reasonController,
                          decoration: InputDecoration(
                            labelText: Constants.Reason,
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
                  NewAppointment();
                },
                child: Text(
                  Constants.Save,
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
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2100));

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }

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
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }

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

  void NewAppointment() async {
    if (hosContoller.text.isEmpty || docNameController.text.isEmpty) {
      setState(() {
        hosContoller.text.isEmpty ? _isTitleEmpty = true : _isNoteEmpty = false;
        docNameController.text.isEmpty
            ? _isNoteEmpty = true
            : _isNoteEmpty = false;
      });
    } else if (!_isTimeAfter) {
      //do nothing
    } else {
      final model = AppointmentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          hName: hosContoller.text,
          dName: docNameController.text,
          appDate: FHBUtils().getFormattedDateOnly(selectedDate.toString()),
          appTime: FHBUtils().formatTimeOfDay(selectedTime),
          reason: reasonController.text);

      await FHBUtils().createNewAppointment(model).then((_) {
        Navigator.of(context).pop();
      });
    }
  }
}
