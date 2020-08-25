import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/ButtonWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/telehealth/features/followUp/model/followUpResponse.dart';
import 'package:myfhb/telehealth/features/followUp/model/radioListModel.dart';
import 'package:myfhb/telehealth/features/followUp/viewModel/followUpViewModel.dart';

class FollowUp extends StatefulWidget {
  @override
  _FollowUpState createState() => _FollowUpState();
}

class _FollowUpState extends State<FollowUp> {
  TextEditingController calenderController = TextEditingController();
  FocusNode calenderFocus = FocusNode();
  DateTime dateTime = DateTime.now();
  String calanderStr;
  int id = 1;
  String _selectedId = 'after 0 days';
  int dateCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    calenderController = TextEditingController(
        text: DateFormat('dd MMM , yyyy').format(dateTime).toString());
    super.initState();
  }

  FollowUpViewModel followUpViewModel = FollowUpViewModel();

  Future<FollowOnDate> followUpAppointment(String id, String date) async {
    FollowOnDate followUpAppointment =
        await followUpViewModel.followUpAppointment(id, date);

    return followUpAppointment;
  }

  FlutterToast toast = new FlutterToast();

  getFollowUpAppoitment(String id, String date) {
    followUpAppointment(id, date).then((value) {
      if (value == null) {
        toast.getToast(Constants.FOLLOW_UP_CANCEL, Colors.red);
      } else if (value.status == 200 && value.success == true) {
        toast.getToast(Constants.YOUR_FOLLOWUP_SUCCESS, Colors.green);
      } else {
        toast.getToast(Constants.FOLLOW_UP_CANCEL, Colors.red);
      }
    });
  }

  void dateOfBirthTapped() {
    _selectDate(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2022, 05));

    if (picked != null) {
      setState(() {
        dateTime = picked ?? dateTime;

        calanderStr =
            new FHBUtils().getFormattedDateForUser(dateTime.toString());
        calenderController.text =
            new DateFormat('dd MMM , yyyy').format(dateTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      alignment: FractionalOffset.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 100),
        child: IconButton(
            icon: Icon(Icons.access_alarm),
            onPressed: () {
              popUpDialog();
            }),
      ),
    ));
  }

  popUpDialog() {
    showGeneralDialog(
      barrierLabel: '',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return followUpWidget();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  Widget followUpWidget() {
    List<RadioList> fList = [
      RadioList(index: 1, widget: dropDown()),
      RadioList(index: 2, widget: showCalenderTextField()),
    ];
    Widget radioItem = dropDown();
    // Group Value for Radio Button.

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 200,
        width: 300,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  alignment: Alignment.topRight,
                  height: 20,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 15,
                      ))),
              Container(
                  padding: EdgeInsets.only(left: 15, right: 5),
                  child: TextWidget(
                    text: PATIENT_FOLLOW_UP,
                    colors: Colors.black38,
                    fontsize: 15,
                    //fhbStyles.fnt_doc_specialist,
                    softwrap: false,
                    overflow: TextOverflow.ellipsis,
                  )),
              Container(
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: fList
                          .map((data) => RadioListTile(
                                title: data.widget,
                                groupValue: id,
                                activeColor: Colors.blue,
                                value: data.index,
                                onChanged: (val) {
                                  setState(() {
                                    radioItem = data.widget;
                                    id = data.index;
                                    print(id);
                                  });
                                },
                              ))
                          .toList(),
                    );
                  },
                ),
              ),
              outlineButton('Send')
            ],
          ),
        ),
        margin: EdgeInsets.only(bottom: 90, left: 12, right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget showCalenderTextField() {
    return GestureDetector(
      onTap: dateOfBirthTapped,
      child: Container(
//        width: 0,
          padding: EdgeInsets.only(right: 80),
          child: TextField(
            cursorColor: Theme.of(context).primaryColor,
            controller: calenderController,
            maxLines: 1,
            autofocus: false,
            readOnly: true,
            keyboardType: TextInputType.text,
            //          focusNode: calenderFocus,
            textInputAction: TextInputAction.done,
            onSubmitted: (term) {
              calenderFocus.unfocus();
            },
            style: new TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
                color: Colors.black),
            decoration: InputDecoration(
                suffixIcon: new IconButton(
                  icon: new Icon(
                    Icons.calendar_today,
                  ),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                border: InputBorder.none),
          )),
    );
  }

  Widget dropDown() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
          child: Row(
        children: <Widget>[
          Container(
            width: 107,
            padding: const EdgeInsets.only(right: 13),
            child: DropdownButtonFormField<String>(
              style: TextStyle(
                color: Colors.black38,
                fontSize: 14,
              ),
              decoration: InputDecoration.collapsed(hintText: ''),
              value: _selectedId,
              icon: new Icon(Icons.keyboard_arrow_down),
              onChanged: (String value) {
                setState(() {
                  _selectedId = value;
                  dateCount = int.parse(value.substring(6, 8).trim());
                  print(dateCount);
                  print(_selectedId);
                });
              },
              isDense: true,
              items: List<String>.generate(31, (i) => 'after $i days')
                  .map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new TextWidget(
                    text: value,
                    colors: Colors.black38,
                    fontsize: 12,
                    //fhbStyles.fnt_doc_specialist,
                    softwrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
          TextWidget(
            text: DateFormat.yMMMEd()
                .format(DateTime.now().add(Duration(days: dateCount)))
                .toString(),
            colors: Colors.black38,
            fontsize: 12,
            //fhbStyles.fnt_doc_specialist,
            softwrap: false,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ));
    });
  }

  Widget outlineButton(String text) {
    return Container(
      alignment: Alignment.center,
      height: 25,
      child: ButtonWidget(
        colors: Color(0xff138fcf),
        fontsize: 8,
        fontWeight: FontWeight.w500,
        onClicked: () {
          if (id == 2) {
            print(DateFormat('yyy-MM-dd')
                .format(DateTime.parse(dateTime.toString()))
                .toString());
            String date = DateFormat('yyy-MM-dd')
                .format(DateTime.parse(dateTime.toString()))
                .toString();
            Navigator.pop(
                context,
                getFollowUpAppoitment(
                    "b8492d67-cb41-45cb-86e5-c53c2627511b", date));
          } else {
            String dat = DateFormat('yyy-MM-dd')
                .format(DateTime.now().add(Duration(days: dateCount)))
                .toString();
            print(DateFormat('yyy-MM-dd')
                .format(DateTime.now().add(Duration(days: dateCount)))
                .toString());
            Navigator.pop(
                context,
                getFollowUpAppoitment(
                    "b8492d67-cb41-45cb-86e5-c53c2627511b", dat));
          }
        },
        text: text,
      ),
    );
  }
}
