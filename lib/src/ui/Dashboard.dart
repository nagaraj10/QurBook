import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/src/utils/ShapesPainter.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: new AssetImage('assets/bg/family_bg.png'),
                    fit: BoxFit.cover)),
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                CustomPaint(
                    painter: ShapesPainter(),
                    child: Container(
                        child: Stack(
                      children: <Widget>[
                        Positioned(
                          bottom: 10,
                          right: 20,
                          child: Image.asset(
                            'assets/bot/maya_bot.png',
                            height: 100,
                            width: 100,
                            //color: Colors.deepPurple,
                          ),
                        ),
                        Positioned(
                            bottom: 30,
                            right: 170,
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  child: Image.asset(
                                    'assets/navicons/my_providers.png',
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    PageNavigator.goTo(
                                        context, '/my_providers');
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'My Providers',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                )
                              ],
                            )),
                        Positioned(
                            bottom: 120,
                            right: 120,
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  child: Image.asset(
                                    'assets/navicons/my_records.png',
                                    color: Colors.white,
                                    height: 25,
                                    width: 25,
                                  ),
                                  onTap: () {
                                    //print('My records clicked');
                                    PageNavigator.goTo(context, '/home_screen');
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'My Records',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                )
                              ],
                            )),
                        Positioned(
                            bottom: 180,
                            right: 30,
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  child: Image.asset(
                                    'assets/navicons/my_family.png',
                                    height: 30,
                                    width: 30,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    PageNavigator.goTo(context, '/my_family');
                                    //print('My family clicked');
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'My Family',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                )
                              ],
                            ))
                      ],
                    ))),
                /*  Positioned(
                  left: 0,
                  top: 260,
                  child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.transparent,
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: Colors.white70,
                              size: 44,
                            ),
                            onTap: () {},
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Tip of the day',
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  )),
                              Text(
                                'Track your food intake every now and then :)',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          )
                        ],
                      )),
                ) */
              ],
            )),
      ],
    ));
  }
}
