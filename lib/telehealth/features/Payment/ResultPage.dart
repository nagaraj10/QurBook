import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class ResultPage extends StatefulWidget {
  final bool status;
  final String refNo;
  Function(String) closePage;
  ResultPage({Key key, @required this.status, this.refNo, this.closePage})
      : super(key: key);
  @override
  _ResultPage createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  bool status;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    status = widget.status;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Payment Done Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: Color(new CommonUtil().getMyPrimaryColor()),
        child: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                        status ? PAYMENT_SUCCESS_PNG : PAYMENT_FAILURE_PNG,
                        width: 120.0.h,
                        height: 120.0.h,
                        color: status ? Colors.white : Colors.red),
                    SizedBox(height: 15.0.h),
                    Text(status ? PAYMENT_SUCCESS_MSG : PAYMENT_FAILURE_MSG,
                        style: TextStyle(
                            fontSize: 22.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0.h),
                    Text(status ? APPOINTMENT_CONFIRM : UNABLE_PROCESS,
                        style: TextStyle(
                            fontSize: 16.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    status
                        ? Text(
                            widget.refNo != null
                                ? 'Ref.no: ' + widget.refNo
                                : '',
                            style: TextStyle(
                                fontSize: 16.0.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                        : SizedBox(),
                    SizedBox(height: 30.0.h),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.white)),
                      color: Color(new CommonUtil().getMyPrimaryColor()),
                      textColor: Colors.white,
                      padding: EdgeInsets.all(12.0),
                      onPressed: () {
                        status
                            ? widget.closePage(STR_SUCCESS)
                            : widget.closePage(STR_FAILED);
                        status
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TelehealthProviders(
                                          arguments: HomeScreenArguments(
                                              selectedIndex: 0),
                                        )))
                            : Navigator.pop(context);
                      },
                      child: Text(
                        STR_DONE.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0.sp,
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
