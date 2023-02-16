import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_screen.dart';
import 'package:myfhb/telehealth/features/Notifications/viewModel/fetchNotificationViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/cancelAppointmentViewModel.dart';
import 'package:provider/provider.dart';


class NotificationMain extends StatefulWidget {
  @override
  _NotificationMainState createState() => _NotificationMainState();
}

class _NotificationMainState extends State<NotificationMain> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => FetchNotificationViewModel(),
            ),
            ChangeNotifierProvider<CancelAppointmentViewModel>(
              create: (_) => CancelAppointmentViewModel(),
            ),
          ],
          child: NotificationScreen(


          ),
        )
    );
  }
}
