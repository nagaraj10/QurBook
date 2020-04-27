import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/src/model/AppointmentModel.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:random_color/random_color.dart';

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
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  // Add your onPressed code here!
                  //customDialog("New appointment", "Save", context, "Save");
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext contxt) {
                        return _MyCustomAlertDialog(
                            title: 'New appointment',
                            subtitle: 'Save',
                            context: context,
                            actionText: 'Save');
                      });
                },
                label: Text('Add'),
                icon: Icon(Icons.add),
                //TODO chnage theme
                backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
              ),
              body: new ListView.builder(
                  itemCount: detailsList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    AppointmentModel model = reverseDetailsList[index];
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
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  Color(fhbColors.bgColorContainer),
                              //_randomColor.randomColor(),
//                                  Color(new CommonUtil().getMyPrimaryColor()),

                              child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(toBeginningOfSentenceCase(model.hName),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                  SizedBox(height: 5),
                                  Text(
                                    'Dr. ' +
                                        toBeginningOfSentenceCase(model.dName),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    toBeginningOfSentenceCase(FHBUtils()
                                        .getFormattedDateString(model.appDate)),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[400]),
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
                                      color: Color(
                                          CommonUtil().getMyGredientColor()),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        FHBUtils().deleteAppointment(model.id);
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
                  }),
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
    print(reverseDetailsList.toString());
    return detailsList;
  }
}

class _MyCustomAlertDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final BuildContext context;
  final String actionText;
  _MyCustomAlertDialog({
    this.title,
    this.subtitle,
    this.context,
    this.actionText,
  });

  @override
  _MyCustomAlertDialogState createState() => _MyCustomAlertDialogState();
}

class _MyCustomAlertDialogState extends State<_MyCustomAlertDialog> {
  TextEditingController nameHos = new TextEditingController();
  TextEditingController nameDoc = new TextEditingController();
  TextEditingController reason = new TextEditingController();
  TextEditingController date = new TextEditingController();
  bool _isHosEmpty = false;
  bool _isDocEmpty = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: new DateTime(2100));

    //DateFormat('yyyy-MM-dd – kk:mm').format(now)
    //date.text = new DateFormat('dd MMM yyyy').format(picked).toString();
    date.text = new FHBUtils().getFormattedDateOnly(picked.toString());
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    date.text = date.text +
        " " +
        picked.hour.toString() +
        ":" +
        picked.minute.toString();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)
          // BorderRadius.all(Radius.circular(UIHelper.BorderRadiusSmall)),
          ),
      content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            constraints: BoxConstraints(minWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 7.0,
                ),
                new TextFormField(
                  controller: nameHos,
                  decoration: InputDecoration(
                    //icon: const Icon(Icons.person),
                    labelText: 'Hospital Name',
                    errorText:
                        _isHosEmpty ? 'Hospital name can\'t be empty' : null,
                  ),
                ),
                new TextFormField(
                  controller: nameDoc,
                  decoration: InputDecoration(
                    //icon: const Icon(Icons.person),
                    labelText: "Doctor's Name",

                    errorText:
                        _isDocEmpty ? 'Doctor name can\'t be empty' : null,
                  ),
                ),
                InkWell(
                  child: new TextFormField(
                    controller: date,
                    decoration: const InputDecoration(
                      suffixIcon:
                          Icon(Icons.calendar_today, color: Colors.black),
                      //icon: const Icon(Icons.calendar_today),
                      labelText: 'Appointment Date',
                    ),
                    enabled: false,
                    keyboardType: TextInputType.datetime,
                  ),
                  onTap: () async {
                    await _selectDate(context);
                    await _selectTime(context);
                  },
                ),
                new TextFormField(
                  controller: reason,
                  decoration: const InputDecoration(
                    //icon: const Icon(Icons.person),
                    labelText: 'Reason',
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: SizedBox(
                    height: 37,
                    width: 150,
                    child: RaisedGradientButton(
                      borderRadius: 30,
                      gradient: LinearGradient(
                        colors: <Color>[
                          //TODO chnage theme
                          Color(new CommonUtil().getMyPrimaryColor()),
                          Color(new CommonUtil().getMyGredientColor()),
                        ],
                      ),
                      //color: Colors.blue,
                      child: Text(
                        widget.actionText,
                        style: TextStyle(
                          //fontSize: UIHelper.FontRegular,
                          color: Colors.white,
                          //fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () async {
                        if (nameHos.text.isEmpty || nameDoc.text.isEmpty) {
                          setState(() {
                            nameHos.text.isEmpty
                                ? _isHosEmpty = true
                                : _isHosEmpty = false;
                            nameDoc.text.isEmpty
                                ? _isDocEmpty = true
                                : _isDocEmpty = false;
                          });

                          setState(() {});
                          return false;
                        } else {
                          /*Map<String, dynamic> items = {};
                      items['nameHos'] = nameHos.text;
                      items['nameDoc'] = nameDoc.text;
                      items['date'] = DateTime.now().toString();
                      items['reason'] = reason.text;*/
                          AppointmentModel model = new AppointmentModel(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              hName: nameHos.text,
                              dName: nameDoc.text,
                              appDate: DateTime.now().toString(),
                              reason: reason.text);

                          await FHBUtils()
                              .createNewAppointment(model)
                              .then((_) {
                            Navigator.of(context).pop();
                            MyAppointment.of(widget.context).refresh();
                          });
                          return true;
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20)
              ],
            ),
          )),
    );
  }
}
