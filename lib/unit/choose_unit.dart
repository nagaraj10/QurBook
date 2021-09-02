import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class ChooseUnit extends StatefulWidget{
  @override
  _ChooseUnitState createState() => _ChooseUnitState();


}

class _ChooseUnitState extends State<ChooseUnit> {
  bool isTouched = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isTouched) {
          _onWillPop();
        } else {
          Navigator.pop(context, false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(fhbColors.bgColorContainer),
        appBar: AppBar(
          title: Text(Constants.UnitPreference),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {
              isTouched ? _onWillPop() : Navigator.of(context).pop();
            },
          ),
          flexibleSpace: GradientAppBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[

                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to update the changes'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => closeDialog(),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () => applyUnitSelection(),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  closeDialog() {
    Navigator.of(context).pop();
    Navigator.of(context).pop(true);
  }

  applyUnitSelection() {}

}