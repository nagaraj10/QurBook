import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuperMaya extends StatefulWidget {
  @override
  _SuperMayaState createState() => _SuperMayaState();
}

class _SuperMayaState extends State<SuperMaya> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          /*   child: Container(
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))), */
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                    const Color(0XFF6717CD),
                    const Color(0XFF0A41A6)
                  ],
                      stops: [
                    0.3,
                    1
                  ])),
            ),
            backgroundColor: Colors.transparent,
            leading: Container(),
            elevation: 0,
            title: Text('Maya'),
            centerTitle: true,
          ),
          //),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/bot/maya_bot.png',
                //color: Colors.deepPurple,
              ),
              //Icon(Icons.people),
              Text(
                'Hi, Im super Maya your health assistance',
                softWrap: true,
              )
            ],
          ),
        ));
  }
}
