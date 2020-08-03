import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsMain.dart';

class ResultPage extends StatefulWidget {
  final bool status;
  final String refNo;
  ResultPage({Key key, @required this.status,this.refNo}) : super(key: key);
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
      body: Container(
        color: Colors.blue[600],
        child: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                        status
                            ? PAYMENT_SUCCESS_PNG
                            : PAYMENT_FAILURE_PNG,
                        width: 120,
                        height: 120,
                        color: status ? Colors.white : Colors.red),
                    SizedBox(height: 15),
                    Text(status ? PAYMENT_SUCCESS_MSG : PAYMENT_FAILURE_MSG,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(
                        status
                            ? APPOINTMENT_CONFIRM
                            : UNABLE_PROCESS,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    status?Text(
                        widget.refNo!=null?'Ref.no: '+widget.refNo:'',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)):SizedBox(),
                    SizedBox(height: 30),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.white)),
                      color: Colors.blue[600],
                      textColor: Colors.white,
                      padding: EdgeInsets.all(12.0),
                      onPressed: () {
                       status?Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => AppointmentsMain())):Navigator.pop(context);
                      },
                      child: Text(
                        "Done".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
