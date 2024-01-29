import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/ticket_support/view/ticket_types_screen.dart';
import 'package:myfhb/ticket_support/view/tickets_list_view.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../widgets/GradientAppBar.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:get/get.dart';

class MyTicketsListScreen extends StatefulWidget {
  @override
  _MyTicketsListScreenState createState() => _MyTicketsListScreenState();
}

class _MyTicketsListScreenState extends State<MyTicketsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(CommonUtil().getMyPrimaryColor()),
                  Color(CommonUtil().getMyGredientColor())
                ]),
          boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],),

        child: FloatingActionButton(
          autofocus: false,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicketTypesScreen()),
            ).then((value) {
              print('intent working');
              setState(() {});
            });
          },
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          child: Image.asset('assets/icons/09.png', height: 40, width: 40),
        ),
      ),
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
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
      arguments: LandingArguments(
        needFreshLoad: true,
      ),
    );

    /*if (Navigator.canPop(context)) {
      Get.back();
    } else {

    }*/
  }
}
