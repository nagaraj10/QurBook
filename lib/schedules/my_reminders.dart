import 'package:flutter/material.dart';
import 'add_reminders.dart';
import '../src/model/ReminderModel.dart';
import '../src/utils/FHBUtils.dart';
import '../src/utils/PageNavigator.dart';
import 'package:random_color/random_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors/fhb_colors.dart' as fhbColors;
import 'package:intl/intl.dart';
import '../common/CommonUtil.dart';
import '../constants/fhb_constants.dart' as Constants;
import '../constants/variable_constant.dart' as variable;
import '../constants/router_variable.dart' as router;
import '../src/utils/screenutils/size_extensions.dart';

class MyReminders extends StatefulWidget {
  static _MyRemindersState of(BuildContext context) =>
      context.findAncestorStateOfType<State<MyReminders>>();

  @override
  State<StatefulWidget> createState() => _MyRemindersState();
}

class _MyRemindersState extends State<MyReminders> {
  final RandomColor _randomColor = RandomColor();
  SharedPreferences prefs;

  dynamic detailsList =
      []; // our default setting is to login, and we should switch to creating an account when the user chooses to
  dynamic reverseDetailsList =
      List(); // our default setting is to login, and we should switch to creating an account when the user chooses to

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (detailsList == null) {
          return MaterialApp(
            home: Scaffold(body: Center(child: Text(variable.strLoadWait))),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  PageNavigator.goTo(context, router.rt_AddRemainder);
                },
                backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              body: detailsList.length > 0
                  ? ListView.builder(
                      itemCount: detailsList.length,
                      itemBuilder: (ctxt, index) {
                        final ReminderModel model = reverseDetailsList[index];
                        final tempDate = DateFormat(variable.dateFormatMMY)
                            .format(DateTime.parse(model.date));
                        final dateArr = tempDate.split(' ');
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddReminder(
                                        model: model,
                                      ))),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(fhbColors.cardShadowColor),
                                    blurRadius:
                                        16, // has the effect of extending the shadow
                                  )
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor:
                                              Color(fhbColors.bgColorContainer),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 1.0.h,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(2),
                                                  child: Text(
                                                    dateArr[1],
                                                    style: TextStyle(
                                                      color: Color(CommonUtil()
                                                          .getMyPrimaryColor()),
                                                      fontSize: 20.0.sp,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(2),
                                                  child: Text(
                                                    dateArr[0],
                                                    style: TextStyle(
                                                        color: Color(CommonUtil()
                                                            .getMyGredientColor()),
                                                        fontSize: 14.0.sp,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5.0.h),
                                        Text(
                                          '${dateArr[2]} ${dateArr[3]}',
                                          style: TextStyle(
                                              fontSize: 14.0.sp,
                                              color: Colors.grey[400]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          toBeginningOfSentenceCase(
                                              model.title.toLowerCase()),
                                          style: TextStyle(
                                            fontSize: 18.0.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0.h,
                                        ),
                                        Text(
                                          toBeginningOfSentenceCase(
                                              model.notes.toLowerCase()),
                                          style: TextStyle(
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(
                                          Icons.notifications_none,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          model.interval,
                                          style: TextStyle(
                                              fontSize: 14.0.sp,
                                              color: Colors.grey[400]),
                                        ),
                                        SizedBox(
                                          height: 3.0.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            FHBUtils().delete(
                                                variable.strremainder,
                                                model.id);
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
                      })
                  : Container(
                      color: Color(fhbColors.bgColorContainer),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Text(
                            Constants.NO_DATA_SCHEDULES,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: variable.font_poppins),
                          ),
                        ),
                      ),
                    ),
            ),
          );
        }
      },
      future: getRemindersList(),
    );
  }

  getRemindersList() async {
    detailsList = await FHBUtils().getAll(variable.strremainder);
    reverseDetailsList = detailsList.reversed.toList();
    return detailsList;
  }
}
