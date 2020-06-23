import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

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
          title: Text('Notifications'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('No notifications'),
        )

        /*  ListView(
        children: <Widget>[
          ListTile(
            //leading: Icon(Icons.notifications, color: Colors.deepPurple[400]),
            title: Text(
              'Apollo hospital',
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'your records of recent visit is added',
              style: TextStyle(color: Colors.black54),
            ),
            trailing: Text(
              FHBUtils().getFormattedDateString(DateTime.now().toString()),
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          Divider(),
          ListTile(
            //leading: Icon(Icons.notifications, color: Colors.deepPurple[400]),
            title: Text(
              'Kauvery hospital',
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'your records of recent visit is added',
              style: TextStyle(color: Colors.black54),
            ),
            trailing: Text(
              FHBUtils().getFormattedDateString(DateTime.now().toString()),
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          Divider(),
          ListTile(
            //leading: Icon(Icons.notifications, color: Colors.deepPurple[400]),
            title: Text('Apollo hospital'),
            subtitle: Text(
              'your records of recent visit is added',
              style: TextStyle(color: Colors.black54),
            ),
            trailing: Text(
              FHBUtils().getFormattedDateString(DateTime.now().toString()),
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          Divider(),
          ListTile(
            //leading: Icon(Icons.notifications, color: Colors.deepPurple[400]),
            title: Text('Apollo hospital'),
            subtitle: Text(
              'your records of recent visit is added',
              style: TextStyle(color: Colors.black54),
            ),
            trailing: Text(
              FHBUtils().getFormattedDateString(DateTime.now().toString()),
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          Divider(),
        ],
      ), */
        );
  }
}
