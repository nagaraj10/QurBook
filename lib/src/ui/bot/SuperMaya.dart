import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'ChatScreen.dart';

class SuperMaya extends StatefulWidget {
  @override
  _SuperMayaState createState() => _SuperMayaState();
}

class _SuperMayaState extends State<SuperMaya> {
  final GlobalKey _micKey = GlobalKey();
  BuildContext _myContext;

  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 200),
          () => ShowCaseWidget.of(_myContext).startShowCase([_micKey]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
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
                          ? PreferenceUtil.getStringValue('maya_asset') +
                              '_main.png'
                          : 'assets/maya/maya_us_main.png',
                      height: 160,
                      width: 160,
                      //color: Colors.deepPurple,
                    ),
                    //Icon(Icons.people),
                    Text(
                      'Hi, Im Maya your health assistance.',
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    // IconButton(
                    //     icon: Icon(Icons.mic),
                    //     iconSize: 50.0,
                    //     onPressed: () => gettingReposnseFromNative())

                    SizedBox(
                        width: 150,
                        height: 50,
                        child: CommonUtil.customShowCase(
                          _micKey,
                          'Tap to record',
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
                                  Color(new CommonUtil().getMyGredientColor()),
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ChatScreen();
                                    },
                                  ),
                                );
                              }),
                        )),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
