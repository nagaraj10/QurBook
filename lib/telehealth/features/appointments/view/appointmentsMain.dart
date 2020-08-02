import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointments.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

class AppointmentsMain extends StatefulWidget {
  @override
  _AppointmentsMainState createState() => _AppointmentsMainState();
}

class _AppointmentsMainState extends State<AppointmentsMain> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(flexibleSpace: GradientAppBar()),
      body: ChangeNotifierProvider(
        create: (context) => AppointmentsViewModel(),
        child: Appointments(),
      ),
    );
  }
}