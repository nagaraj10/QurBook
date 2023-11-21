
import 'package:flutter/cupertino.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/model/BottomNavigationArguments.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;


class BottomNavigationViewModel extends ChangeNotifier {
    List<BottomNavigationArguments> bottomNavigationArgumentsList = [];

  
  Future<void>  getAllValuesForBottom() async {
    bottomNavigationArgumentsList.add(BottomNavigationArguments(
        name: variable.strTelehealth, imageIcon: variable.icon_home));
    bottomNavigationArgumentsList.add(BottomNavigationArguments(
        name:variable.strMyRecords , imageIcon: variable.icon_records));
    bottomNavigationArgumentsList.add(BottomNavigationArguments(
      name:variable.strMaya,
      imageIcon: variable.icon_mayaMain,
    ));
    bottomNavigationArgumentsList.add(BottomNavigationArguments(
        name: variable.strAccounts, imageIcon: variable.icon_schedule));
    bottomNavigationArgumentsList.add(BottomNavigationArguments(
        name: variable.strSettings, imageIcon: variable.icon_more));

        notifyListeners();
  }
  
}