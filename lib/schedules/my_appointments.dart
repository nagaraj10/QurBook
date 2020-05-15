import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/src/model/AppointmentModel.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:random_color/random_color.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class MyAppointment extends StatefulWidget {
  static _MyAppointmentState of(BuildContext context) =>
      context.findAncestorStateOfType<State<MyAppointment>>();

  @override
  State<StatefulWidget> createState() => new _MyAppointmentState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class _MyAppointmentState extends State<MyAppointment> {
  SharedPreferences prefs;
  RandomColor _randomColor = RandomColor();

  dynamic detailsList =
      new List(); // our default setting is to login, and we should switch to creating an account when the user chooses to
  dynamic reverseDetailsList =
      new List(); // our default setting is to login, and we should switch to creating an account when the user chooses to

  _MyAppointmentState() {
    //_emailFilter.addListener(_emailListen);
    //_passwordFilter.addListener(_passwordListen);
  }

  void refresh() {
    setState(() {});
  }

  /*  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      //email = emailFilter.text;
    }
  } */

  /*  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      // password = passwordFilter.text;
    }
  } */

  // Swap in between our two forms, registering and logging in
  /* void _formChange(InitialPageModel model, BuildContext context) async {
    //Navigator.pushNamed(context, Router.registration);
  } */

  @override
  Widget build(BuildContext context) {
    /* return BaseView<InitialPageModel>(
      builder: (baseContext, model, child) { */
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
            //onGenerateRoute: Router.createRoute,
            home: new Scaffold(
              //appBar: _buildBar(context),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  PageNavigator.goTo(context, '/add_appointments');
                },
                child: Icon(Icons.add),
                backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
              ),
              body: detailsList.length > 0
                  ? new ListView.builder(
                      itemCount: detailsList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        AppointmentModel model = reverseDetailsList[index];
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
                                      16, // has the effect of softening the shadow
                                  spreadRadius:
                                      0.0, // has the effect of extending the shadow
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      Color(fhbColors.bgColorContainer),
                                  //_randomColor.randomColor(),
//                                  Color(new CommonUtil().getMyPrimaryColor()),

                                  child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          /*Padding(
                                        padding: EdgeInsets.zero,
                                        child: Text(
                                          */ /*new FHBUtils().convertMonthFromString(
                                              reverseDetailsList[index]['date']),*/ /*
                                          model.appDate
                                          ,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.zero,
                                        child: Text(
                                          */ /*new FHBUtils().convertDateFromString(
                                              reverseDetailsList[index]['date'])*/ /*
                                          model.appDate,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      )*/
                                          Padding(
                                            padding: EdgeInsets.all(2),
                                            child: Text(
                                              model.dName[0].toUpperCase(),
                                              style: TextStyle(
                                                color: Color(CommonUtil()
                                                    .getMyPrimaryColor()),
                                                fontSize: 24.0,
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
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
                                              color: Colors.black)),
                                      SizedBox(height: 5),
                                      Text(
                                        'Dr. ' +
                                            toBeginningOfSentenceCase(
                                                model.dName),
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        toBeginningOfSentenceCase(
                                            model.appDate +
                                                ',' +
                                                model.appTime),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[400]),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 1,
                                          height: 30,
                                          color: Color(CommonUtil()
                                              .getMyGredientColor()),
                                        ),
                                        SizedBox(width: 10),
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
                        /*  return Card(
                      child: ListTile(
                        leading: Icon(Icons.ac_unit),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(child: Text('Name of Hospital:')),
                                Expanded(
                                    child: Text('' +
                                        reverseDetailsList[index]['nameHos'])),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(child: Text("Docxtor's Name:")),
                                Expanded(
                                    child: Text('' +
                                        reverseDetailsList[index]['nameDoc'])),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(child: Text('Date:')),
                                Expanded(
                                    child: Text('' +
                                        reverseDetailsList[index]['date'])),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(child: Text('Reason:')),
                                Expanded(
                                    child: Text('' +
                                        reverseDetailsList[index]['reason'])),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ); */
                      })
                  : Container(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Text(
                            Constants.NO_DATA_SCHEDULES,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      color: Color(fhbColors.bgColorContainer),
                    ),
            ),
          );
        }
      },
      future: getProjectDetails(),
    );
    /*    },
    ); */
  }

  /*  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Demo App Page"),
      centerTitle: true,
    );
  } */

  /*  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(labelText: 'Employee Id'),
            ),
          ),
        ],
      ),
    );
  }
 */

  getProjectDetails() async {
    /*prefs = await SharedPreferences.getInstance();

    String getData = await prefs.get('key');
    if (getData == null) {
      detailsList = new List();
    } else {
      detailsList = json.decode(getData);

      reverseDetailsList = detailsList.reversed.toList();
    }*/

    detailsList = await FHBUtils().getAllAppointments();
    reverseDetailsList = detailsList.reversed.toList();
    //print(reverseDetailsList.toString());
    return detailsList;
  }
}
