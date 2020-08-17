import 'package:flutter/cupertino.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

class Devices extends StatefulWidget {
  @override
  DevicesState createState() => DevicesState();
}

class DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
     return Center(child: Text(variable.strDevices,));

  }
}
