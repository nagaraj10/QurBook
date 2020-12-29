import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleAppointments.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsListViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/resheduleAppointmentViewModel.dart';
import 'package:provider/provider.dart';

class ResheduleMain extends StatefulWidget {
  Past doc;
  bool isReshedule;
  String bookId, id;
  Function(String) closePage;
  bool isFromNotification;
  dynamic body;
  ResheduleMain(
      {this.doc, this.isReshedule, this.closePage, this.isFromNotification,this.body});

  @override
  _ResheduleMainState createState() => _ResheduleMainState();
}

class _ResheduleMainState extends State<ResheduleMain> {
  final GlobalKey<State> _key = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppointmentsListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyProviderViewModel(),
        ),
        ChangeNotifierProvider<ResheduleAppointmentViewModel>(
          create: (_) => ResheduleAppointmentViewModel(),
        ),
      ],
      child: ResheduleAppointments(
        doc: widget.doc,
        isReshedule: widget.isReshedule,
        closePage: (value) {
          widget.closePage(value);
        },
        isFromNotification: widget.isFromNotification,
        body: widget.body,
      ),
    ));
  }
}
