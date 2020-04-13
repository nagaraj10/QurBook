import 'package:flutter/material.dart';
import 'package:myfhb/schedules/add_reminders.dart';
import 'package:myfhb/src/model/ReminderModel.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:random_color/random_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';

class MyReminders extends StatefulWidget {
  static _MyRemindersState of(BuildContext context) =>
      context.findAncestorStateOfType<State<MyReminders>>();

  @override
  State<StatefulWidget> createState() => new _MyRemindersState();
}

class _MyRemindersState extends State<MyReminders> {
  RandomColor _randomColor = RandomColor();
  SharedPreferences prefs;

  dynamic detailsList =
      new List(); // our default setting is to login, and we should switch to creating an account when the user chooses to
  dynamic reverseDetailsList =
      new List(); // our default setting is to login, and we should switch to creating an account when the user chooses to

  void refresh() {
    setState(() {});
  }

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
                    ReminderModel model = reverseDetailsList[index];
                    var tempDate = DateFormat('E d MMM, yyyy')
                        .format(DateTime.parse(model.date));
                    var dateArr = tempDate.split(" ");
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddReminder(
                                    model: model,
                                  ))),
                      child: Container(
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
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor:
                                          _randomColor.randomColor(),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 1,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Text(
                                                dateArr[1],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Text(
                                                dateArr[0],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${dateArr[2]} ${dateArr[3]}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      model.title,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      model.notes,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(
                                      Icons.notifications_none,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      model.interval,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[400]),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        FHBUtils()
                                            .delete('reminders', model.id);
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    );
                  }),
            ),
          );
        }
      },
      future: getRemindersList(),
    );
  }

  getRemindersList() async {
    /*prefs = await SharedPreferences.getInstance();

    String getData = await prefs.get('reminders');
    if (getData == null) {
      detailsList = new List();
    } else {
      detailsList = json.decode(getData);

      reverseDetailsList = detailsList.reversed.toList();
    }*/

    detailsList = await FHBUtils().getAll('reminders');
    reverseDetailsList = detailsList.reversed.toList();
    print(reverseDetailsList.toString());
    return detailsList;
  }
}
