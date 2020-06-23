import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/widgets/GradientAppBar.dart';

class MySettings extends StatefulWidget {
  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  //MyProfile myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
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
                  'false'
              ? false
              : true;
      _isdigitRecognition =
          PreferenceUtil.getStringValue(Constants.allowDigitRecognition) ==
                  'false'
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
          /*   Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  leading: ClipOval(
                    child: FHBBasicWidget().getProfilePicWidget(myProfile
                        .response.data.generalInfo.profilePicThumbnail),

                    /*  Image.memory(
                    Uint8List.fromList(myProfile
                        .response.data.generalInfo.profilePicThumbnail.data),
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ) */
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(myProfile.response.data.generalInfo.name),
                      Text(
                        myProfile.response.data.generalInfo.countryCode +
                            ' ' +
                            myProfile.response.data.generalInfo.phoneNumber,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        myProfile.response.data.generalInfo.email,
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                ),
              )),
          SizedBox(
            height: 20,
          ),
          */
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: ImageIcon(
                      AssetImage('assets/settings/digit_recognition.png'),
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text('Allow digit recognition'),
                    subtitle: Text(
                      'scans for the values from device images',
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
                      AssetImage('assets/settings/device_recognition.png'),
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text('Allow device recognition'),
                    subtitle: Text(
                      'scans and auto-detects devices',
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
                /*   ListTile(
                    leading: ImageIcon(
                      AssetImage('assets/settings/googlefit.png'),
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text('Google fit'),
                    subtitle: Text(
                      'Connect your data from google fit',
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _isGoogleFit,
                        activeColor:
                            Color(new CommonUtil().getMyPrimaryColor()),
                        onChanged: (bool newValue) {
                          setState(() {
                            _isGoogleFit = newValue;
                          });
                        },
                      ),
                    )),
                Container(
                  height: 1,
                  color: Colors.grey[200],
                ), */
                /*    ListTile(
                    leading: ImageIcon(
                      AssetImage('assets/settings/privacy.png'),
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text('Privacy policy'),
                    subtitle: Text(
                      'Manage account security and policy',
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    )),
                Container(
                  height: 1,
                  color: Colors.grey[200],
                ),
                ListTile(
                    leading: ImageIcon(
                      AssetImage('assets/settings/terms.png'),
                      //size: 30,
                      color: Colors.black,
                    ),
                    title: Text('Terms of service'),
                    subtitle: Text(
                      'Manage account terms and conditions',
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    )),
                Container(
                  height: 1,
                  color: Colors.grey[200],
                ),
                ListTile(
                    leading: ImageIcon(
                      AssetImage('assets/settings/help.png'),
                      //ssize: 30,
                      color: Colors.black,
                    ),
                    title: Text('Help and support'),
                    subtitle: Text(
                      'Help and customer support',
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    ))
               */
              ],
            ),
          )
        ],
      ),
    );
  }
}
