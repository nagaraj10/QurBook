import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/more_menu/screens/more_menu_screen.dart';
import 'package:myfhb/notifications/myfhb_notifications.dart';
import 'package:myfhb/schedules/my_schedules.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
//import 'package:myfhb/src/ui/MyRecords.dart';
import 'package:myfhb/src/ui/MyRecordClone.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  static _HomeScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<State<HomeScreen>>();

  final int bottomindex;
  HomeScreenArguments arguments;

  HomeScreen({this.bottomindex, this.arguments});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex;
  GlobalKey _bottomNavigationKey = GlobalKey();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  var _widgetOptions = [
    MyFhbNotifications(),
    MyRecordsClone(),
    SuperMaya(),
    MySchedule(),
    MoreMenuScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.arguments.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f6f5),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        selectedPageIndex: _selectedIndex,
        myFunc: _myFunc,
      ),
    );
  }

  void _myFunc(int index) {
    if (index == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

class BottomNavigationWidget extends StatefulWidget {
  BottomNavigationWidget({this.selectedPageIndex, this.myFunc});
  final int selectedPageIndex;
  final Function myFunc;

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: 20),
      child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: widget.selectedPageIndex,
          height: 60.0,
          items: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage('assets/navicons/home.png'),
                      size: 20,
                      color: widget.selectedPageIndex == 0
                          ? Colors.white
                          : Colors.black,
                      //size: 22,
                    ),
                    widget.selectedPageIndex == 0
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Text(
                            'Home',
                            style: TextStyle(fontSize: 10),
                          )
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage('assets/navicons/records.png'),
                      color: widget.selectedPageIndex == 1
                          ? Colors.white
                          : Colors.black,
                      //size: 22,
                    ),
                    widget.selectedPageIndex == 1
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Text(
                            'My Records',
                            style: TextStyle(fontSize: 10),
                          )
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      PreferenceUtil.getStringValue('maya_asset') != null
                          ? PreferenceUtil.getStringValue('maya_asset') + '.png'
                          : 'assets/maya/maya_us_main.png',
                      height: 32,
                      width: 32,
                    ),
                    widget.selectedPageIndex == 2
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Text(
                            'Maya',
                            style: TextStyle(fontSize: 10),
                          )
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage('assets/navicons/schedule.png'),
                      color: widget.selectedPageIndex == 3
                          ? Colors.white
                          : Colors.black,
                      size: 22,
                    ),
                    widget.selectedPageIndex == 3
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Text(
                            'Schedules',
                            style: TextStyle(fontSize: 10),
                          )
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage('assets/navicons/more.png'),
                      color: widget.selectedPageIndex == 4
                          ? Colors.white
                          : Colors.black,
                      size: 22,
                    ),
                    widget.selectedPageIndex == 4
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Text(
                            'More',
                            style: TextStyle(fontSize: 10),
                          )
                  ],
                )),
          ],
          color: Colors.white,
          buttonBackgroundColor: widget.selectedPageIndex == 2
              ? Colors.white
              : Color(new CommonUtil().getMyPrimaryColor()),
          backgroundColor: Colors.transparent,
          animationCurve: Curves.linearToEaseOut,
          animationDuration: Duration(milliseconds: 450),
          /* onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        }, */
          onTap: (index) {
            widget.myFunc(index);
          }),
    );
  }
}
