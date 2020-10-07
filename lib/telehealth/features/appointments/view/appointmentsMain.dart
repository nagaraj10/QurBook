import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/view/DoctorUpcomingAppointments.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointments.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleAppointments.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsListViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/cancelAppointmentViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/resheduleAppointmentViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;
import 'package:provider/provider.dart';

class AppointmentsMain extends StatefulWidget {
  @override
  _AppointmentsMainState createState() => _AppointmentsMainState();
}

class _AppointmentsMainState extends State<AppointmentsMain> {
  final GlobalKey<State> _key = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
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
          ],child: Appointments(),
        ));
  }

  Widget appBar() {
    return AppBar(
        flexibleSpace: GradientAppBar(),
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBoxWidget(
              height: 0,
              width: 30,
            ),
            IconWidget(
              icon: Icons.arrow_back_ios,
              colors: Colors.white,
              size: 20,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        title: getTitle());
  }

  Widget getTitle() {
    return Row(
      children: [
        Expanded(
          child: TextWidget(
            text: Constants.Appointments_Title,
            colors: Colors.white,
            overflow: TextOverflow.visible,
            fontWeight: FontWeight.w600,
            fontsize: 18,
            softwrap: true,
          ),
        ),
        IconWidget(
          icon: Icons.notifications,
          colors: Colors.white,
          size: 22,
          onTap: () {},
        ),
        SwitchProfile().buildActions(context, _key, callBackToRefresh),
        // IconWidget(
        //   icon: Icons.more_vert,
        //   colors: Colors.white,
        //   size: 24,
        //   onTap: () {},
        // ),
      ],
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }
}
