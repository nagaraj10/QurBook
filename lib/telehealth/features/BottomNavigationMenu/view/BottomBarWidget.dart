import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBarWidget extends StatelessWidget {
  String name;
  String icon;
  int pageIndex;
  int selectedPageIndex;

  BottomBarWidget(
      {this.name, this.icon, this.pageIndex, this.selectedPageIndex});
  @override
  Widget build(BuildContext context) {
    print(icon);
    return Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            name == 'Maya'
                ? Image.asset(
                    icon,
                    height: 32,
                    width: 32,
                  )
                : ImageIcon(
                    AssetImage(icon),
                    size: 20,
                    color: selectedPageIndex == pageIndex
                        ? Colors.white
                        : Colors.black,
                    //size: 22,
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
