import 'package:flutter/material.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class MyProvidersAppBar extends StatelessWidget implements PreferredSizeWidget {
  TabController tabController;

  MyProvidersAppBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,

      elevation: 0,
      flexibleSpace: TabBar(
        tabs: [
          Tab(
            text: CommonConstants.doctors,
          ),
          Tab(
            text: CommonConstants.hospitals,
          ),
          Tab(
            text: CommonConstants.labs,
          ),
        ],
        controller: tabController,
        labelColor: Color(CommonUtil().getMyPrimaryColor()),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Color(CommonUtil().getMyPrimaryColor()),
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
