import 'package:flutter/material.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;


class HealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: GradientAppBar(),
      ),
      body: Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(variable.apple_health_settings_info),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Container(            
            alignment: Alignment.center,
            padding: EdgeInsets.all(1),
            child: RaisedGradientButton(
              onPressed: () {
                Navigator.pop(context);
              },
              borderRadius: 30,
              child: Container(
                padding: EdgeInsets.all(10),
                //alignment: Alignment.center,
                child: Text(
                  variable.strUnderstood,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(new CommonUtil().getMyPrimaryColor()),
                  Color(new CommonUtil().getMyGredientColor()),
                ],
              ),
            ),
          ),
           ),
        ],
      ),
    );
  }
}
