import 'package:flutter/material.dart';
import 'package:myfhb/schedules/my_appointments.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/more_menu/screens/more_menu_screen.dart';
import 'package:myfhb/notifications/myfhb_notifications.dart';
import 'package:myfhb/schedules/my_schedules.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/ui/bot/ChatScreen.dart';
//import 'package:myfhb/src/ui/MyRecords.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/model/BottomNavigationArguments.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/view/BottomNavigation.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/view/BottomNavigationMain.dart';
import 'package:myfhb/telehealth/features/Devices/view/Devices.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProvidersMain.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsMain.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsViewModel.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:myfhb/telehealth/features/telehealth/view/Telehealth.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import '../../../../src/ui/MyRecord.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';

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
  bool _isCancelDialogShouldShown = false;
  String _bookingId;
  GlobalKey _bottomNavigationKey = GlobalKey();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<BottomNavigationArguments> bottomNavigationArgumentsList = new List();
  var _widgetOptions = [
    AppointmentsMain(),
    MyProvidersMain(),
    SuperMaya(),
    ChatHomeScreen(),
    MyRecords()
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
    if (widget.arguments.isCancelDialogShouldShow != null) {
      _isCancelDialogShouldShown = widget.arguments.isCancelDialogShouldShow;
      _bookingId = widget.arguments.bookingId;
    }

    getAllValuesForBottom();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCancelDialogShouldShown) {
      Future.delayed(Duration(seconds: 5), () {
        showPromptToUser(context);
      });
    }
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

  Future showPromptToUser(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                parameters.warning,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8)),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Text(
                    parameters.cancel_appointment,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.5)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      child: Text(parameters.Yes),
                      onPressed: () async {
                        //call the appointment cancel api
                        FlutterToast toast = new FlutterToast();
                        _isCancelDialogShouldShown = false;
                        Navigator.of(context).pop(true);
                        CancelAppointmentModel cancelAppointment =
                            await AppointmentsViewModel()
                                .fetchCancelAppointment([_bookingId]);

                        if (cancelAppointment.status == 200 &&
                            cancelAppointment.success == true) {
                          toast.getToast(
                              Constants.YOUR_BOOKING_SUCCESS, Colors.green);
                        } else {
                          toast.getToast(Constants.BOOKING_CANCEL, Colors.red);
                        }
                      },
                    ),
                    FlatButton(
                        child: Text(parameters.No),
                        onPressed: () {
                          _isCancelDialogShouldShown = false;
                          Navigator.of(context).pop(false);
                        }),
                  ],
                ),
              ],
            ),
          );
        });
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
      name: 'TeleHealth',
      imageIcon: 'assets/navicons/th.png',
    ));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: 'My Providers', imageIcon: 'assets/navicons/my_providers.png'));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
      name: 'Sheela',
      imageIcon: 'assets/maya/maya_us_main.png',
    ));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: 'Chat', imageIcon: 'assets/navicons/chat.png'));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: 'My Records', imageIcon: 'assets/navicons/records.png'));
  }
}
