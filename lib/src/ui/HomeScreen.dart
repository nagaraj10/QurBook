import 'package:flutter/material.dart';
import 'package:myfhb/src/ui/MyRecords.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/src/ui/user/UserAccount.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final _widgetOptions = [
    Text(
      'Schedule',
      style: optionStyle,
    ),
    SuperMaya(),
    MyRecords(),
    UserAccount(),
    Text(
      'Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black45,
        selectedItemColor: Colors.black,
        selectedFontSize: 14,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        unselectedLabelStyle: TextStyle(color: Colors.black45),
        //showSelectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/navicons/calendar.png'),
              //color: Colors.red,
              size: 22,
            ),

            //Icon(Icons.schedule),
            title: Text('Schedule'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/navicons/robot.png'),
              //color: Colors.red,
              size: 22,
            ),
            title: Text('Maya'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/navicons/home.png'),
              //color: Colors.red,
              size: 22,
            ),
            title: Text('My records'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/navicons/user.png'),
              //color: Colors.red,
              size: 22,
            ),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/navicons/settings.png'),
              //color: Colors.red,
              size: 22,
            ),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
