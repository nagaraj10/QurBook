import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/widgets/GradientAppBar.dart';


import 'package:myfhb/constants/variable_constant.dart' as variable;

class MySettings extends StatefulWidget {
  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  bool _isdigitRecognition = true;
  bool _isdeviceRecognition = true;
  bool _isGoogleFit = true;

  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    setState(() {
      _isdeviceRecognition =
          PreferenceUtil.getStringValue(Constants.allowDeviceRecognition) ==
                  variable.strFalse
              ? false
              : true;
      _isdigitRecognition =
          PreferenceUtil.getStringValue(Constants.allowDigitRecognition) ==
                  variable.strFalse
              ? false
              : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(fhbColors.bgColorContainer),
      appBar: AppBar(
        title: Text(Constants.Settings),
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
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: ImageIcon(
                      AssetImage(variable.icon_digit_reco),
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text(variable.strAllowDigit),
                    subtitle: Text(
                      variable.strScanDevices,
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _isdigitRecognition,
                        activeColor:
                            Color(new CommonUtil().getMyPrimaryColor()),
                        onChanged: (bool newValue) {
                          setState(() {
                            _isdigitRecognition = newValue;

                            PreferenceUtil.saveString(
                                Constants.allowDigitRecognition,
                                _isdigitRecognition.toString());
                          });
                        },
                      ),
                    )),
                Container(
                  height: 1,
                  color: Colors.grey[200],
                ),
                ListTile(
                    leading: ImageIcon(
                      AssetImage(variable.icon_device_recon),
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text(variable.strAllowDevice),
                    subtitle: Text(
                      variable.strScanAuto,
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _isdeviceRecognition,
                        activeColor:
                            Color(new CommonUtil().getMyPrimaryColor()),
                        onChanged: (bool newValue) {
                          setState(() {
                            _isdeviceRecognition = newValue;

                            PreferenceUtil.saveString(
                                Constants.allowDeviceRecognition,
                                _isdeviceRecognition.toString());
                          });
                        },
                      ),
                    )),
                Container(
                  height: 1,
                  color: Colors.grey[200],
                ),
                            ],
            ),
          )
        ],
      ),
    );
  }
}
