import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/view/BottomNavigation.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/viewModel/BottomNavigationViewModel.dart';
import 'package:provider/provider.dart';

class BottomNavigationMain extends StatefulWidget {
  final int selectedPageIndex;
  final Function myFunc;

  BottomNavigationMain({this.selectedPageIndex, this.myFunc});
  @override
  _BottomNavigationMainState createState() => _BottomNavigationMainState();
}

class _BottomNavigationMainState extends State<BottomNavigationMain> {
  bool firstTym = false;
  BottomNavigationViewModel bottomNavigationViewModel;
  @override
  Widget build(BuildContext context) {
    getDataForProvider();
    return Scaffold(
//      appBar: AppBar(flexibleSpace: GradientAppBar()),
      body: ChangeNotifierProvider(
        create: (context) => BottomNavigationViewModel(),
        child: BottomNavigationWidget(
          selectedPageIndex: widget.selectedPageIndex,
          myFunc: widget.myFunc(widget.selectedPageIndex),
          bottomNavigationArgumentsList:
              bottomNavigationViewModel.bottomNavigationArgumentsList,
        ),
      ),
    );
  }

  void getDataForProvider() {
    if (firstTym == false) {
      firstTym = true;
      bottomNavigationViewModel =
          Provider.of<BottomNavigationViewModel>(context);
      bottomNavigationViewModel.getAllValuesForBottom();
    }
  }
}
