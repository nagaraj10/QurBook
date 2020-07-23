import 'package:flutter/cupertino.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

class Telehealth extends StatefulWidget{
  @override
  TelehealthState createState() => TelehealthState();

  

}
class TelehealthState extends State<Telehealth>{
  @override
  Widget build(BuildContext context) {
  return Center(child: Text(variable.strTelehealth),);
  }

}