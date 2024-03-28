import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class MyProvidersAppBar extends StatelessWidget implements PreferredSizeWidget {
  TabController? tabController;

  MyProvidersAppBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,

      elevation: 0,
      flexibleSpace: TabBar(
        tabs: [
          Tab(
            child: Text(CommonConstants.doctors, style: getTitleStyle()),
          ),
          Tab(
            child: Text(CommonConstants.hospitals, style: getTitleStyle()),
          ),
          Tab(
            child: Text(CommonConstants.labs, style: getTitleStyle()),
          ),
        ],
        controller: tabController,
        labelColor: mAppThemeProvider.primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: mAppThemeProvider.primaryColor,
      ),
      /*   title: Container(
        height: 0,
      ), */
      leading: Container(
        height: 0.0.h,
        width: 0.0.h,
      ),
      //title: Text('My Providers'),
      //centerTitle: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(30.0.h);

  getTitleStyle() {
    return TextStyle(
      fontSize: CommonUtil().isTablet! ? tabHeader2 : mobileHeader2,
      fontWeight: FontWeight.w600,
    );
  }
}
