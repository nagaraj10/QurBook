import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

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
        labelColor: Color(new CommonUtil().getMyPrimaryColor()),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Color(new CommonUtil().getMyPrimaryColor()),
        indicatorWeight: 2,
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

  Size get preferredSize => new Size.fromHeight(30.0.h);
}
