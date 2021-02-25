import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/more_menu/screens/more_menu_screen.dart';
import 'package:myfhb/notifications/myfhb_notifications.dart';
import 'package:myfhb/schedules/my_schedules.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
//import 'package:myfhb/src/ui/MyRecords.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/ui/user/UserAccountMain.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/src/ui/user/UserAccounts.dart';

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
  int _selectedIndex = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();
  static TextStyle optionStyle =
      TextStyle(fontSize: 30.0.sp, fontWeight: FontWeight.bold);
  var _widgetOptions = [
    MyFhbNotifications(),
    MyRecords(),
    SuperMaya(),
    UserAccounts(arguments: UserAccountsArguments(selectedIndex: 0)),
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
    }
    if (index == 3) {
      Navigator.pushNamed(
        context,
        router.rt_UserAccounts,
        arguments: UserAccountsArguments(selectedIndex: 2),
      ).then((value) {
        _selectedIndex = 1;
        setState(() {});
      });
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
          height: 60.0.h,
          items: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_home),
                      size: 20,
                      color: widget.selectedPageIndex == 0
                          ? Colors.white
                          : Colors.black,
                      //size: 22,
                    ),
                    widget.selectedPageIndex == 0
                        ? Container(
                            height: 0.0.h,
                            width: 0.0.h,
                          )
                        : Text(
                            variable.strhome,
                            style: TextStyle(fontSize: 10.0.sp),
                          )
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_records),
                      color: widget.selectedPageIndex == 1
                          ? Colors.white
                          : Colors.black,
                      //size: 22,
                    ),
                    widget.selectedPageIndex == 1
                        ? Container(
                            height: 0.0.h,
                            width: 0.0.h,
                          )
                        : Text(
                            variable.strMyRecords,
                            style: TextStyle(fontSize: 10.0.sp),
                          )
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      PreferenceUtil.getStringValue(Constants.keyMayaAsset) !=
                              null
                          ? PreferenceUtil.getStringValue(
                                  Constants.keyMayaAsset) +
                              variable.strExtImg
                          : variable.icon_mayaMain,
                      height: 32.0.h,
                      width: 32.0.h,
                    ),
                    widget.selectedPageIndex == 2
                        ? Container(
                            height: 0.0.h,
                            width: 0.0.h,
                          )
                        : Text(
                            variable.strMaya,
                            style: TextStyle(fontSize: 10.0.sp),
                          )
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_provider),
                      color: widget.selectedPageIndex == 3
                          ? Colors.white
                          : Colors.black,
                      size: 24,
                    ),
                    widget.selectedPageIndex == 3
                        ? Container(
                            height: 0.0.h,
                            width: 0.0.h,
                          )
                        : Text(
                            variable.strMyProvider,
                            style: TextStyle(fontSize: 10.0.sp),
                          )
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage(variable.icon_more),
                      color: widget.selectedPageIndex == 4
                          ? Colors.white
                          : Colors.black,
                      size: 22,
                    ),
                    widget.selectedPageIndex == 4
                        ? Container(
                            height: 0.0.h,
                            width: 0.0.h,
                          )
                        : Text(
                            variable.strMore,
                            style: TextStyle(fontSize: 10.0.sp),
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
          onTap: (index) {
            widget.myFunc(index);
          }),
    );
  }
}
