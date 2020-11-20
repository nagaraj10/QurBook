import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;

class BottomBarWidget extends StatelessWidget {
  String name;
  String icon;
  int pageIndex;
  int selectedPageIndex;

  BottomBarWidget(
      {this.name, this.icon, this.pageIndex, this.selectedPageIndex});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            name == 'Sheela'
                ? Image.asset(
                    icon,
                    height: 25,
                    width: 25,
                  )
                : ImageIcon(
                    AssetImage(icon),
                    size: 20,
                    color: selectedPageIndex == pageIndex
                        ? Colors.white
                        : Colors.black,
                  ),
            selectedPageIndex == pageIndex
                ? Container(
                    height: 0,
                    width: 0,
                  )
                : Text(
                    name,
                    style: TextStyle(fontSize: 10),
                  )
          ],
        ));
  }
}
