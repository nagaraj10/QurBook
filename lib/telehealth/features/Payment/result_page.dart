import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final bool status;
  ResultPage({Key key, @required this.status}) : super(key: key);
  @override
  _ResultPage createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {

  bool status;

  @override
  void initState() {
    status = widget.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:Container(
        color: Colors.blue[600],
        child: Center(
          child : Container(
            child : SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                          status?'assets/images/success_tick.jpg':'assets/images/failure.png',width:160,height: 160),
                      SizedBox(height: 15),
                      Text(status?'Payment Successful':'Payment Failure',style: TextStyle(fontSize: 22,color:Colors.white,fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(status?'Your appointment is now confirmed':'We unable to reach your process..',style: TextStyle(fontSize: 14,color:Colors.white,fontWeight: FontWeight.bold)),
                      SizedBox(height: 30),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.white)),
                        color: Colors.blue[600],
                        textColor: Colors.white,
                        padding: EdgeInsets.all(12.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Done".toUpperCase(),
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ]
                ),
            ),
          ),
        ),
      ),
    );
  }

}