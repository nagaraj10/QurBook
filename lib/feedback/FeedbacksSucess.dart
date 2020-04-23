import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/utils/PageNavigator.dart';

class FeedbackSuccess extends StatefulWidget {
  @override
  _FeedbackSuccessState createState() => _FeedbackSuccessState();
}

class _FeedbackSuccessState extends State<FeedbackSuccess> {
  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    Future.delayed(const Duration(seconds: 4), () {
              PageNavigator.goToPermanent(context, '/feedbacks');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Icon(
          Icons.check,
          size: 40,
          color: Colors.black,
        )),
        Text(
          'Suceess',
          style: TextStyle(fontSize: 30),
        ),
        Text(
          'Thank  you for your feedback',
          style: TextStyle(fontSize: 30),
        ),
      ],
    ));
  }
}
