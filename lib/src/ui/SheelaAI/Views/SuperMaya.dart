import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../colors/fhb_colors.dart' as fhbColors;
import '../../../../common/CommonUtil.dart';
import '../../../../common/FHBBasicWidget.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../constants/fhb_constants.dart' as Constants;
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/router_variable.dart';
import '../../../../constants/variable_constant.dart' as variable;
import '../../../../widgets/GradientAppBar.dart';
import '../../../../widgets/RaisedGradientButton.dart';
import '../../../utils/screenutils/size_extensions.dart';
import '../Models/sheela_arguments.dart';

class SuperMaya extends StatefulWidget {
  SuperMaya({
    this.isHome = false,
    this.onBackPressed,
  });

  final bool isHome;
  final Function onBackPressed;

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
    mInitialTime = DateTime.now();
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

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Sheela Start Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
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
          return WillPopScope(
            onWillPop: () {
              if (widget.isHome) {
                widget.onBackPressed();
              }
              Future.value(widget.isHome ? false : true);
            },
            child: Scaffold(
                backgroundColor: const Color(fhbColors.bgColorContainer),
                appBar: widget.isHome
                    ? null
                    : PreferredSize(
                        preferredSize: Size.fromHeight(60),
                        child: AppBar(
                          flexibleSpace: GradientAppBar(),
                          backgroundColor: Colors.transparent,
                          leading: IconWidget(
                            icon: Icons.arrow_back_ios,
                            colors: Colors.white,
                            size: 24.0.sp,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          elevation: 0,
                          title: Text(strSheelaG),
                          actions: [
                            Center(
                                child:
                                    CommonUtil().getNotificationIcon(context)),
                            SizedBoxWidget(
                              width: 10.0.w,
                            ),
                          ],
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
                        height: 160.0.h,
                        width: 160.0.h,
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
                          width: 150.0.w,
                          height: 50.0.h,
                          child: FHBBasicWidget.customShowCase(
                              _micKey,
                              variable.strTapMaya,
                              RaisedGradientButton(
                                  borderRadius: 30,
                                  child: Text(
                                    variable.strStartNow,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0.sp),
                                  ),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(CommonUtil().getMyPrimaryColor()),
                                      Color(CommonUtil().getMyGredientColor()),
                                    ],
                                  ),
                                  onPressed: () {
                                    String sheela_lang =
                                        PreferenceUtil.getStringValue(
                                            Constants.SHEELA_LANG);
                                    if (sheela_lang != null &&
                                        sheela_lang != '') {
                                      Get.toNamed(
                                        rt_Sheela,
                                        arguments: SheelaArgument(
                                          isSheelaAskForLang: false,
                                          langCode: sheela_lang,
                                        ),
                                      );
                                      /*  Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ChatScreen(
                                              arguments: SheelaArgument(
                                                isSheelaAskForLang: false,
                                                langCode: sheela_lang,
                                              ),
                                            );
                                          },
                                        ),
                                      ); */
                                    } else {
                                      Get.toNamed(
                                        rt_Sheela,
                                        arguments: SheelaArgument(
                                          isSheelaAskForLang: true,
                                        ),
                                      );

                                      /* Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ChatScreen(
                                              arguments: SheelaArgument(
                                                isSheelaAskForLang: true,
                                              ),
                                            );
                                          },
                                        ),
                                      ); */
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
                )),
          );
        },
      ),
    );
  }
}