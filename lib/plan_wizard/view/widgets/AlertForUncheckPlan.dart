import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';

class AlertForUncheckPlan extends StatelessWidget {
  final Function(String) onClicked;

  AlertForUncheckPlan(this.onClicked);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Do you want to un check the plans'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            onClicked(STR_NO);
          },
          child: Text('No'),
        ),
        FlatButton(
          onPressed: () {
            onClicked(STR_YES);
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}
