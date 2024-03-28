import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';

import '../../common/CommonUtil.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../../landing/view/landing_arguments.dart';
import '../../main.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import 'ticket_types_screen.dart';
import 'tickets_list_view.dart';

class MyTicketsListScreen extends StatefulWidget {
  @override
  _MyTicketsListScreenState createState() => _MyTicketsListScreenState();
}

class _MyTicketsListScreenState extends State<MyTicketsListScreen> {
  @override
  Widget build(BuildContext context) {
    FABService.trackCurrentScreen(FBAServiceRequestScreen);

    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [
            mAppThemeProvider.primaryColor,
            Color(CommonUtil().getMyGredientColor())
          ]),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicketTypesScreen()),
            ).then((value) {
              setState(() {});
            });
          },
          backgroundColor: mAppThemeProvider.primaryColor,
          child: Image.asset('assets/icons/09.png', height: 40, width: 40),
        ),
      ),
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: mAppThemeProvider.primaryColor,
        elevation: 0,
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () {
            onBackPressed(context);
          },
        ),
        title: Text(strServiceRequests,
            style: TextStyle(
                fontSize: (CommonUtil().isTablet ?? false)
                    ? tabFontTitle
                    : mobileFontTitle)),
      ),
      body: TicketsList(),
    );
  }

  Future<bool>? onBackPressed(BuildContext context) {
    Get.offAllNamed(
      router.rt_Landing,
      arguments: const LandingArguments(),
    );
  }
}
