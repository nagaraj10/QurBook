import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

import '../../../main.dart';

class CareDietAppBar extends StatelessWidget implements PreferredSizeWidget {
  TabController? tabController;

  CareDietAppBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: TabBar(
        tabs: [
          Tab(
            child: Text(
              CommonConstants.my_providers_plan,
              style: CommonUtil().getTitleStyle(),
            ),
          ),
          Tab(
            child: Text(
              CommonConstants.all_free_plans,
              style: CommonUtil().getTitleStyle(),
            ),
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
}
