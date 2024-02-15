import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewModel/appointmentsListViewModel.dart';
import '../viewModel/cancelAppointmentViewModel.dart';
import '../viewModel/resheduleAppointmentViewModel.dart';
import 'appointments.dart';

class AppointmentsMain extends StatefulWidget {
  AppointmentsMain({
    super.key,
    this.isHome = false,
    this.onBackPressed,
    this.isFromQurday = false,
  });

  final bool isHome;
  final bool isFromQurday;
  final Function? onBackPressed;

  @override
  _AppointmentsMainState createState() => _AppointmentsMainState();
}

class _AppointmentsMainState extends State<AppointmentsMain> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () {
          if (widget.isHome) {
            widget.onBackPressed!();
          }
          return Future.value(!widget.isHome);
        },
        child: Scaffold(
            body: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => AppointmentsListViewModel(),
            ),
            ChangeNotifierProvider<CancelAppointmentViewModel>(
              create: (_) => CancelAppointmentViewModel(),
            ),
            ChangeNotifierProvider<ResheduleAppointmentViewModel>(
              create: (_) => ResheduleAppointmentViewModel(),
            ),
          ],
          child: Appointments(
            isHome: widget.isHome,
            isFromQurday: widget.isFromQurday,
          ),
        )),
      );
}
