import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:showcaseview/showcase_widget.dart';

import 'view/ChatScreen.dart';

class SuperMaya extends StatefulWidget {
  @override
  _SuperMayaState createState() => _SuperMayaState();
}

class _SuperMayaState extends State<SuperMaya> {
  final GlobalKey _micKey = GlobalKey();
  BuildContext _myContext;

  // PermissionStatus permissionStatus = PermissionStatus.undetermined;
  // final Permission _micpermission = Permission.microphone;

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
    // final status = await _micpermission.status;
    //setState(() => permissionStatus = status);
  }

/* Future<PermissionStatus> requestPermission(Permission micPermission) async {
   final status = await micPermission.request();
    setState(() {
      
      permissionStatus = status;
    });
    return status;
  }*/

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {
        PreferenceUtil.saveString(
            Constants.KEY_SHOWCASE_MAYA, variable.strtrue);
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
                  leading: IconWidget(
                    icon: Icons.arrow_back_ios,
                    colors: Colors.white,
                    size: 20,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  elevation: 0,
                  title: Text('Sheela'),
                  centerTitle: true,
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      PreferenceUtil.getStringValue(Constants.keyMayaAsset) !=
                              null
                          ? PreferenceUtil.getStringValue(
                                  Constants.keyMayaAsset) +
                              variable.strExtImg
                          : variable.icon_mayaMain,
                      height: 160,
                      width: 160,
                      //color: Colors.deepPurple,
                    ),
                    //Icon(Icons.people),
                    Text(
                      variable.strIntromaya,
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
                            variable.strTapMaya,
                            RaisedGradientButton(
                                borderRadius: 30,
                                child: Text(
                                  variable.strStartNow,
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
                                  String sheela_lang =
                                      PreferenceUtil.getStringValue(
                                          Constants.SHEELA_LANG);
                                  if (sheela_lang != null &&
                                      sheela_lang != '') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ChatScreen(isSheelaAskForLang: false,langCode: sheela_lang,);
                                        },
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ChatScreen(isSheelaAskForLang: true,);
                                        },
                                      ),
                                    );
                                  }

                                  /* requestPermission(_micpermission)
                                      .then((status) {
                                    if (status == PermissionStatus.granted) {

                                    } 
                                  });*/
                                }),
                            variable.strMaya)),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
