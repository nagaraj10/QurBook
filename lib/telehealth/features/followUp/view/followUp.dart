import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/telehealth/features/followUp/model/radioListModel.dart';

class FollowUp extends StatefulWidget {
  @override
  _FollowUpState createState() => _FollowUpState();
}

class _FollowUpState extends State<FollowUp> {
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
      RadioList(index: 2, widget: Text('hhh')),
    ];
    Widget radioItem = dropDown();
    // Group Value for Radio Button.
    int id = 1;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 220,
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
                                  });
                                },
                              ))
                          .toList(),
                    );
                  },
                ),
              )
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

  Widget dropDown() {
    String _selectedId = 'after 1 days';
    int dateCount = 0;
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
                });
              },
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
}
