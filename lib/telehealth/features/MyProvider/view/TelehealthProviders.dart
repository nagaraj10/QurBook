import 'package:flutter/material.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/more_menu/screens/more_menu_screen.dart';
import 'package:myfhb/notifications/myfhb_notifications.dart';
import 'package:myfhb/schedules/my_schedules.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
//import 'package:myfhb/src/ui/MyRecords.dart';
import 'package:myfhb/src/ui/MyRecordClone.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/model/BottomNavigationArguments.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/view/BottomNavigation.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/view/BottomNavigationMain.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProvidersMain.dart';

class TelehealthProviders extends StatefulWidget {
  static _TelehealthProvidersState of(BuildContext context) =>
      context.findAncestorStateOfType<State<TelehealthProviders>>();

  final int bottomindex;
  HomeScreenArguments arguments;

  TelehealthProviders({this.bottomindex, this.arguments});

  @override
  _TelehealthProvidersState createState() => _TelehealthProvidersState();
}

class _TelehealthProvidersState extends State<TelehealthProviders> {
  int _selectedIndex;
  GlobalKey _bottomNavigationKey = GlobalKey();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<BottomNavigationArguments> bottomNavigationArgumentsList = new List();
  var _widgetOptions = [
    MyProvidersMain(),
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
    getAllValuesForBottom();
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
        bottomNavigationArgumentsList: bottomNavigationArgumentsList,
      ),
      //bottomNavigationBar: BottomNavigationMain(),
    );
  }

  void _myFunc(int index) {
      setState(() {
        _selectedIndex = index;
      });
    /*if (index == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }*/
  }

  void getAllValuesForBottom() {
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: 'TeleHealth', imageIcon: 'assets/navicons/home.png'));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: 'My Records', imageIcon: 'assets/navicons/records.png'));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
      name: 'Maya',
      imageIcon: 'assets/maya/maya_us_main.png',
    ));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: 'Accounts', imageIcon: 'assets/navicons/schedule.png'));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: 'Settings', imageIcon: 'assets/navicons/more.png'));
  }
}
