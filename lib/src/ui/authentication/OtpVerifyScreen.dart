import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class OtpVerifyScreen extends StatefulWidget {
  final String enteredMobNumber;
  final String selectedCountryCode;

  const OtpVerifyScreen(
      {Key key,
      @required this.enteredMobNumber,
      @required this.selectedCountryCode})
      : super(key: key);

  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController currController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
  }

  @override
  void initState() {
    super.initState();
    currController = controller1;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 0.0, right: 2.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              //color: Color.fromRGBO(0, 0, 0, 0.1),
              border: new Border(
                  top: BorderSide.none,
                  left: BorderSide.none,
                  right: BorderSide.none,
                  bottom: BorderSide(color: Colors.deepPurple, width: 1.0)
                  //width: 1.0,
                  //color: Colors.deepPurple.withOpacity(0.5)
                  ),
              //borderRadius: new BorderRadius.circular(4.0)
            ),
            child: new TextField(
              //obscureText: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              enabled: false,
              controller: controller1,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            //color: Color.fromRGBO(0, 0, 0, 0.1),
            border: new Border(
                top: BorderSide.none,
                left: BorderSide.none,
                right: BorderSide.none,
                bottom: BorderSide(color: Colors.deepPurple, width: 1.0)
                //width: 1.0,
                //color: Colors.deepPurple.withOpacity(0.5)
                ),
            //borderRadius: new BorderRadius.circular(4.0)
          ),
          child: new TextField(
            //obscureText: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            controller: controller2,
            autofocus: false,
            enabled: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            //color: Color.fromRGBO(0, 0, 0, 0.1),
            border: new Border(
                top: BorderSide.none,
                left: BorderSide.none,
                right: BorderSide.none,
                bottom: BorderSide(color: Colors.deepPurple, width: 1.0)
                //width: 1.0,
                //color: Colors.deepPurple.withOpacity(0.5)
                ),
            //borderRadius: new BorderRadius.circular(4.0)
          ),
          child: new TextField(
            //obscureText: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            controller: controller3,
            textAlign: TextAlign.center,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 14.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            //color: Color.fromRGBO(0, 0, 0, 0.1),
            border: new Border(
                top: BorderSide.none,
                left: BorderSide.none,
                right: BorderSide.none,
                bottom: BorderSide(color: Colors.deepPurple, width: 1.0)
                //width: 1.0,
                //color: Colors.deepPurple.withOpacity(0.5)
                ),
            //borderRadius: new BorderRadius.circular(4.0)
          ),
          child: new TextField(
            //obscureText: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller4,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 14.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 2.0, right: 0.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(child: Image.asset('assets/bg/login-bg.png')),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          Constants.OtpScreenText,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                          '+${widget.selectedCountryCode} ${widget.enteredMobNumber}',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      Flexible(
                        child: Center(
                          child: Column(children: <Widget>[
                            GridView.count(
                                crossAxisCount: 6,
                                crossAxisSpacing: 20,
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                children: List<Container>.generate(
                                    6,
                                    (int index) => Container(
                                          child: widgetList[index],
                                        ))),
                          ]),
                        ),
                        flex: 20,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 8.0,
                                    right: 8.0,
                                    bottom: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    MaterialButton(
                                      onPressed: () {
                                        inputTextToField("1");
                                      },
                                      child: Text("1",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        inputTextToField("2");
                                      },
                                      child: Text("2",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        inputTextToField("3");
                                      },
                                      child: Text("3",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                          textAlign: TextAlign.center),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 4.0,
                                    right: 8.0,
                                    bottom: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    MaterialButton(
                                      onPressed: () {
                                        inputTextToField("4");
                                      },
                                      child: Text("4",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        inputTextToField("5");
                                      },
                                      child: Text("5",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        inputTextToField("6");
                                      },
                                      child: Text("6",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 4.0,
                                    right: 8.0,
                                    bottom: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    MaterialButton(
                                      onPressed: () {
                                        inputTextToField("7");
                                      },
                                      child: Text("7",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        inputTextToField("8");
                                      },
                                      child: Text("8",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        inputTextToField("9");
                                      },
                                      child: Text("9",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 4.0,
                                    right: 8.0,
                                    bottom: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    MaterialButton(
                                        onPressed: () {
                                          deleteText();
                                        },
                                        child: Icon(
                                          Icons.backspace,
                                          color: Colors.deepPurple,
                                        )),
                                    MaterialButton(
                                      onPressed: () {
                                        inputTextToField("0");
                                      },
                                      child: Text("0",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        PageNavigator.goToPermanent(
                                            context, '/dashboard_screen');
                                        //matchOtp();
                                      },
                                      child: Icon(Icons.done,
                                          color: Colors.deepPurple),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        flex: 40,
                      ),
                    ]),
              ),
              constraints: BoxConstraints(
                maxHeight: 420,
              ),
              margin: EdgeInsets.only(left: 40, right: 40, top: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0, // soften the shadow
                    spreadRadius: 5.0, //extend the shadow
                    offset: Offset(
                      0.0, // Move to right 10  horizontally
                      5.0, // Move to bottom 5 Vertically
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void inputTextToField(String str) {
    //Edit first textField
    if (currController == controller1) {
      controller1.text = str;
      currController = controller2;
    }

    //Edit second textField
    else if (currController == controller2) {
      controller2.text = str;
      currController = controller3;
    }

    //Edit third textField
    else if (currController == controller3) {
      controller3.text = str;
      currController = controller4;
    }

    //Edit fourth textField
    else if (currController == controller4) {
      controller4.text = str;
      currController = controller4;
    }
  }

  void deleteText() {
    if (currController.text.length == 0) {
    } else {
      currController.text = "";
      currController = controller4;
      return;
    }

    if (currController == controller1) {
      controller1.text = "";
    } else if (currController == controller2) {
      controller1.text = "";
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = "";
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = "";
      currController = controller3;
    }
  }

  void matchOtp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Successfully"),
            content: Text("Otp matched successfully."),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }
}
