import 'package:flutter/material.dart';

class VitalsList extends StatefulWidget {
  const VitalsList({Key key}) : super(key: key);

  @override
  _VitalsListState createState() => _VitalsListState();
}

class _VitalsListState extends State<VitalsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("This is Vitals Screen", style: TextStyle(fontSize: 24),),
        )
      ],
    );
  }
}