import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'ChatScreen.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class SuperMaya extends StatefulWidget {
  @override
  _SuperMayaState createState() => _SuperMayaState();
}

class _SuperMayaState extends State<SuperMaya> {
  final GlobalKey _micKey = GlobalKey();
  BuildContext _myContext;

  PermissionStatus permissionStatus = PermissionStatus.undetermined;
  final Permission _micpermission = Permission.microphone;

  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();

    var isFirstTime = PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_MAYA);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          Duration(milliseconds: 200),
          () => isFirstTime
              ? null
              : ShowCaseWidget.of(_myContext).startShowCase([_micKey]));
    });
  }

  void _listenForPermissionStatus() async {
    final status = await _micpermission.status;
    setState(() => permissionStatus = status);
  }

  Future<PermissionStatus> requestPermission(Permission micPermission) async {
    final status = await micPermission.request();
    setState(() {
      print(status);
      permissionStatus = status;
    });
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {
        PreferenceUtil.saveString(Constants.KEY_SHOWCASE_MAYA, 'true');
      },
      builder: Builder(
        builder: (context) {
          _myContext = context;
          return Scaffold(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: AppBar(
                  flexibleSpace: GradientAppBar(),
                  backgroundColor: Colors.transparent,
                  leading: Container(),
                  elevation: 0,
                  title: Text('Maya'),
                  centerTitle: true,
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      PreferenceUtil.getStringValue('maya_asset') != null
                          ? PreferenceUtil.getStringValue('maya_asset') + '.png'
                          : 'assets/maya/maya_us_main.png',
                      height: 160,
                      width: 160,
                      //color: Colors.deepPurple,
                    ),
                    //Icon(Icons.people),
                    Text(
                      'Hi, I am Maya your voice health assistant.',
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        width: 150,
                        height: 50,
                        child: FHBBasicWidget.customShowCase(
                            _micKey,
                            'Tap me and invoke. Lets converse',
                            RaisedGradientButton(
                                borderRadius: 30,
                                child: Text(
                                  'Start now',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                    Color(
                                        new CommonUtil().getMyGredientColor()),
                                  ],
                                ),
                                onPressed: () {
                                  requestPermission(_micpermission)
                                      .then((status) {
                                    if (status == PermissionStatus.granted) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ChatScreen();
                                          },
                                        ),
                                      );
                                    } else {
                                      print(
                                          'Mic permission has not been given by the user');
                                    }
                                  });
                                }),
                            'Maya')),
                  ],
                ),
              ));
        },
      ),
    );
  }

  /*  void checkForVoicePermission() async {
    try {
      await voice_platform.invokeMethod('speakWithVoiceAssistant');
    } on PlatformException catch (e) {}
  } */
}
