import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../src/model/AppointmentModel.dart';
import '../src/utils/FHBUtils.dart';
import '../src/utils/PageNavigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors/fhb_colors.dart' as fhbColors;
import 'package:intl/intl.dart';
import '../common/CommonUtil.dart';
import 'package:random_color/random_color.dart';
import '../constants/fhb_constants.dart' as Constants;
import '../constants/variable_constant.dart' as variable;
import '../constants/router_variable.dart' as router;
import '../src/utils/screenutils/size_extensions.dart';

class MyAppointment extends StatefulWidget {
  static _MyAppointmentState of(BuildContext context) =>
      context.findAncestorStateOfType<State<MyAppointment>>();

  @override
  State<StatefulWidget> createState() => _MyAppointmentState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class _MyAppointmentState extends State<MyAppointment> {
  SharedPreferences prefs;
  final RandomColor _randomColor = RandomColor();

  dynamic detailsList =
      List(); // our default setting is to login, and we should switch to creating an account when the user chooses to
  dynamic reverseDetailsList =
      []; // our default setting is to login, and we should switch to creating an account when the user chooses to

  _MyAppointmentState();

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
              child: Text(variable.strLoadWait),
            )),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  PageNavigator.goTo(context, router.rt_AddAppointments);
                },
                backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
                child: Icon(Icons.add),
              ),
              body: detailsList.length > 0
                  ? ListView.builder(
                      itemCount: detailsList.length,
                      itemBuilder: (ctxt, index) {
                        final AppointmentModel model = reverseDetailsList[index];
                        return Container(
                            padding: EdgeInsets.all(10),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(fhbColors.cardShadowColor),
                                  blurRadius:
                                      16, // has the effect of extending the shadow
                                )
                              ],
                            ),
                            child: Row(
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
                                          Padding(
                                            padding: EdgeInsets.all(2),
                                            child: Text(
                                              model.dName[0].toUpperCase(),
                                              style: TextStyle(
                                                color: Color(CommonUtil()
                                                    .getMyPrimaryColor()),
                                                fontSize: 24.0.sp,
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0.w,
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          toBeginningOfSentenceCase(
                                              model.hName),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontSize: 16.0.sp,
                                          )),
                                      SizedBox(height: 5.0.h),
                                      Text(
                                        variable.strDr +
                                            toBeginningOfSentenceCase(
                                                model.dName),
                                        style: TextStyle(
                                            fontSize: 15.0.sp,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 5.0.h),
                                      Text(
                                        toBeginningOfSentenceCase(
                                            model.appDate +
                                                ',' +
                                                model.appTime),
                                        style: TextStyle(
                                            fontSize: 14.0.sp,
                                            color: Colors.grey[400]),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 1.0.w,
                                          height: 30.0.h,
                                          color: Color(CommonUtil()
                                              .getMyGredientColor()),
                                        ),
                                        SizedBox(width: 10.0.w),
                                        InkWell(
                                          onTap: () {
                                            FHBUtils()
                                                .deleteAppointment(model.id);
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            ));
                      })
                  : Container(
                      color: Color(fhbColors.bgColorContainer),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Text(
                            Constants.NO_DATA_SCHEDULES,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: variable.font_poppins,
                              fontSize: 16.0.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          );
        }
      },
      future: getProjectDetails(),
    );
  }

  getProjectDetails() async {
    detailsList = await FHBUtils().getAllAppointments();
    reverseDetailsList = detailsList.reversed.toList();
    return detailsList;
  }
}
