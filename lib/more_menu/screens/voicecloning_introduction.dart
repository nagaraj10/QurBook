import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/more_menu/screens/terms_and_conditon.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class VoiceCloningIntroducuton extends StatefulWidget {
  const VoiceCloningIntroducuton();

  @override
  _MyFhbWebViewState createState() => _MyFhbWebViewState();
}

class _MyFhbWebViewState extends State<VoiceCloningIntroducuton> {
  bool isLoading = true;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Terms And Condition Voice Cloning',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: AppBarForVoiceCloning().getVoiceCloningAppBar(),
          centerTitle: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    strVoiceCloneIntro,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[600], fontSize: mobileFontTitle),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(CommonUtil().getMyPrimaryColor()),
                ),
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 30.sp, right: 30.sp, top: 10, bottom: 10),
                    child: Text(
                      'Start',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }
}
