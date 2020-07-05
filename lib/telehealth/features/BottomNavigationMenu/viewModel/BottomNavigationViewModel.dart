import 'package:flutter/cupertino.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/model/BottomNavigationArguments.dart';

class BottomNavigationViewModel extends ChangeNotifier {
    List<BottomNavigationArguments> bottomNavigationArgumentsList = new List();

  
  Future<void>  getAllValuesForBottom() async {
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

        notifyListeners();
  }
  
}