import 'package:flutter/material.dart';
import '../src/utils/FHBUtils.dart';
import '../widgets/GradientAppBar.dart';

import '../constants/variable_constant.dart' as variable;


class MyFhbNotifications extends StatefulWidget {
  @override
  _MyFhbNotificationsState createState() => _MyFhbNotificationsState();
}

class _MyFhbNotificationsState extends State<MyFhbNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: Container(),
          title: Text(variable.strNotifications),
          centerTitle: true,
        ),
        body: Center(
          child: Text(variable.strNoNotification),
        )

        );
  }
}
