import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/model/BottomNavigationArguments.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/view/BottomBarWidget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/viewModel/BottomNavigationViewModel.dart' as bottomNavigationVModel;

class BottomNavigationWidget extends StatefulWidget {
  BottomNavigationWidget(
      {this.selectedPageIndex,
      this.myFunc,
      this.bottomNavigationArgumentsList});
  final int selectedPageIndex;
  final Function myFunc;
  final List<BottomNavigationArguments> bottomNavigationArgumentsList;

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  bool firstTym = false;
  bottomNavigationVModel.BottomNavigationViewModel bottomNavigationViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: 20),
      child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: widget.selectedPageIndex,
          height: 60.0,
          items: getAllWidgetsInsideBottom(),
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

  List<Widget> getAllWidgetsInsideBottom() {
    List<Widget> widgetsForBottom = new List();
    int i = 0;

    for (BottomNavigationArguments bottomNavigationArguments
        in widget.bottomNavigationArgumentsList) {
      widgetsForBottom.add(new BottomBarWidget(
        name: bottomNavigationArguments.name,
        icon: bottomNavigationArguments.imageIcon,
        selectedPageIndex: widget.selectedPageIndex,
        pageIndex: i,
      ));
      i++;
    }

    return widgetsForBottom;
  }

  void getDataForProvider() {
    if (firstTym == false) {
      firstTym = true;
      bottomNavigationViewModel =Provider.of<bottomNavigationVModel.BottomNavigationViewModel>(context);
      bottomNavigationViewModel.getAllValuesForBottom();
    }
  }
}
