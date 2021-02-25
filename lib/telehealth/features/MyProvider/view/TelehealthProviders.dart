import 'package:flutter/material.dart';
import 'package:myfhb/authentication/service/authservice.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
//import 'package:myfhb/src/ui/MyRecords.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/model/BottomNavigationArguments.dart';
import 'package:myfhb/telehealth/features/BottomNavigationMenu/view/BottomNavigation.dart';
import 'package:myfhb/telehealth/features/Notifications/services/notification_services.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as AppConstants;
import 'package:myfhb/telehealth/features/MyProvider/view/MyProvidersMain.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsMain.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/cancelAppointmentViewModel.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import '../../../../src/ui/MyRecord.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'dart:convert' as convert;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;

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
  String date;
  GlobalKey _bottomNavigationKey = GlobalKey();
  static TextStyle optionStyle =
      TextStyle(fontSize: 30.0.sp, fontWeight: FontWeight.bold);
  List<BottomNavigationArguments> bottomNavigationArgumentsList = new List();
  var _widgetOptions = [
    AppointmentsMain(),
    MyProvidersMain(),
    SuperMaya(),
    ChatHomeScreen(),
    MyRecords(
      argument: MyRecordsArgument(),
    ),
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
      date = widget.arguments.date;
    }

    getAllValuesForBottom();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 0 && _isCancelDialogShouldShown) {
      Future.delayed(Duration(seconds: 5), () {
        //* show cancel app. dialog
        showCanelAppointmentPromptToUser(context);
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

  Future showCanelAppointmentPromptToUser(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Confirmation',
                style: TextStyle(
                    fontSize: 20.0.sp,
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
                        fontSize: 20.0.sp,
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
                            await CancelAppointmentViewModel()
                                .fetchCancelAppointment([_bookingId], [date]);

                        if (cancelAppointment.isSuccess == true) {
                          toast.getToast(
                              AppConstants.YOUR_BOOKING_SUCCESS, Colors.green);
                          var body = {};
                          body['templateName'] =
                              widget?.arguments?.templateName;
                          body['contextId'] = _bookingId;
                          FetchNotificationService()
                              .updateNsActionStatus(body)
                              .then((data) {
                            if (data != null && data['isSuccess']) {
                            } else {}
                          });
                        } else {
                          toast.getToast(
                              AppConstants.BOOKING_CANCEL, Colors.red);
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
      name: variable.strMaya,
      imageIcon: 'assets/maya/maya_us_main.png',
    ));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: 'Chats', imageIcon: 'assets/navicons/chat.png'));
    bottomNavigationArgumentsList.add(new BottomNavigationArguments(
        name: 'My Records', imageIcon: 'assets/navicons/records.png'));
  }
}
