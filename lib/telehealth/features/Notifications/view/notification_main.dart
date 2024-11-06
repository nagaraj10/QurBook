import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../appointments/viewModel/cancelAppointmentViewModel.dart';
import '../viewModel/fetchNotificationViewModel.dart';
import 'notification_screen.dart';

class NotificationMain extends StatefulWidget {
  bool isFromQurday;

  NotificationMain({
    Key? key,
    this.isFromQurday = false,
  }) : super(key: key);

  @override
  _NotificationMainState createState() => _NotificationMainState();
}

class _NotificationMainState extends State<NotificationMain> {
  @override
  Widget build(BuildContext context) => Scaffold(
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
          isFromQurday: widget.isFromQurday,
        ),
      ));
}
