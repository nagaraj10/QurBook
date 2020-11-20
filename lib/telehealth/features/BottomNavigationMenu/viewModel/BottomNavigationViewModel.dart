import 'package:flutter/cupertino.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/model/BottomNavigationArguments.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;


class BottomNavigationViewModel extends ChangeNotifier {
    List<BottomNavigationArguments> bottomNavigationArgumentsList = new List();

  
  Future<void>  getAllValuesForBottom() async {
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: variable.strTelehealth, imageIcon: variable.icon_home));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name:variable.strMyRecords , imageIcon: variable.icon_records));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
      name:variable.strMaya,
      imageIcon: variable.icon_mayaMain,
    ));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: variable.strAccounts, imageIcon: variable.icon_schedule));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: variable.strSettings, imageIcon: variable.icon_more));

        notifyListeners();
  }
  
}