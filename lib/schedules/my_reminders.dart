import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';

class MyReminders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MyRemindersState();
}

class _MyRemindersState extends State<MyReminders> {
  SharedPreferences prefs;

  dynamic detailsList =
      new List(); // our default setting is to login, and we should switch to creating an account when the user chooses to
  dynamic reverseDetailsList =
      new List(); // our default setting is to login, and we should switch to creating an account when the user chooses to

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (detailsList == null) {
          return MaterialApp(
            home: Scaffold(
                body: Center(
              child: Text('Loading...'),
            )),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: new Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  PageNavigator.goTo(context, '/add_reminders');
                },
                label: Text('Add'),
                icon: Icon(Icons.add),
                //TODO chnage theme
                backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
              ),
              body: new ListView.builder(
                  itemCount: detailsList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(fhbColors.cardShadowColor),
                              blurRadius:
                                  16, // has the effect of softening the shadow
                              spreadRadius:
                                  0.0, // has the effect of extending the shadow
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      toBeginningOfSentenceCase(
                                          reverseDetailsList[index]['title']),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                  SizedBox(height: 5),
                                  Text(
                                    toBeginningOfSentenceCase(
                                        reverseDetailsList[index]['notes']),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    toBeginningOfSentenceCase(
                                        reverseDetailsList[index]['date']),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[400]),
                                  ),
                                  Text(
                                    toBeginningOfSentenceCase(
                                        reverseDetailsList[index]['time']),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[400]),
                                  ),
                                  Text(
                                    toBeginningOfSentenceCase(
                                        reverseDetailsList[index]['interval']),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[400]),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ));
                  }),
            ),
          );
        }
      },
      future: getRemindersList(),
    );
  }

  getRemindersList() async {
    prefs = await SharedPreferences.getInstance();

    String getData = await prefs.get('reminders');
    if (getData == null) {
      detailsList = new List();
    } else {
      detailsList = json.decode(getData);

      reverseDetailsList = detailsList.reversed.toList();
    }

    return detailsList;
  }
}
