import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;


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
