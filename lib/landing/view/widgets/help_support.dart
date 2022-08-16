import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/myfhb_weview/myfhb_webview.dart';
import 'package:myfhb/src/utils/language/language_utils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class HelpSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(bgColorContainer),
      appBar: AppBar(
        title: Text(HELP_SUPPORT),
        centerTitle: false,
        flexibleSpace: GradientAppBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          openWebView(FAQ, file_faq, true, context);
                        },
                        child: ListTile(
                            leading: ImageIcon(
                              AssetImage(icon_faq),
                              color: Colors.black,
                            ),
                            title: Text(FAQ)),
                      ),
                      Container(
                        height: 1.0.h,
                        color: Colors.grey[200],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, router.rt_Feedbacks)
                              .then((value) {});
                        },
                        child: ListTile(
                            leading: ImageIcon(
                              AssetImage(icon_feedback),
                              color: Colors.black,
                            ),
                            title: Text(strFeedBack)),
                      ),
                      Container(
                        height: 1.h,
                        color: Colors.grey[200],
                      ),
                      InkWell(
                        onTap: () {
                          openWebView(
                              terms_of_service, file_terms, true, context);
                        },
                        child: ListTile(
                            leading: ImageIcon(
                              AssetImage(icon_term),
                              color: Colors.black,
                            ),
                            title: Text(terms_of_service)),
                      ),
                      Container(
                        height: 1.h,
                        color: Colors.grey[200],
                      ),
                      InkWell(
                        onTap: () {
                          openWebView(
                              privacy_policy, file_privacy, true, context);
                        },
                        child: ListTile(
                            leading: ImageIcon(
                              AssetImage(icon_privacy),
                              color: Colors.black,
                            ),
                            title: Text(strPrivacy)),
                      ),
                      Container(
                        height: 1.h,
                        color: Colors.grey[200],
                      ),
                      InkWell(
                        onTap: () {
                          LaunchReview.launch(
                              androidAppId: strAppPackage, iOSAppId: iOSAppId);
                        },
                        child: ListTile(
                            leading: ImageIcon(
                              AssetImage(icon_record_fav),
                              color: Colors.black,
                            ),
                            title: Text(strRateus)),
                      ),
                      Container(
                        height: 1.h,
                        color: Colors.grey[200],
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     launchWhatsApp(
                      //       context,
                      //         phone: c_qurhealth_helpline,
                      //         message: c_chat_with_whatsapp_begin_conv);
                      //   },
                      //   child: ListTile(
                      //       leading: ImageIcon(
                      //         AssetImage(icon_whatsapp),
                      //         color: Color(0XFF66AB5B),
                      //       ),
                      //       title: Text(TranslationConstants.chatWithUs.t())),
                      // ),
                      // Container(
                      //   height: 1.h,
                      //   color: Colors.grey[200],
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void openWebView(
      String title, String url, bool isLocal, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MyFhbWebView(
            title: title, selectedUrl: url, isLocalAsset: isLocal)));
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return 'whatsapp://wa.me/$phone/?text=${Uri.parse(message)}';
      } else {
        return 'whatsapp://send?phone=$phone&text=${Uri.parse(message)}';
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
}
