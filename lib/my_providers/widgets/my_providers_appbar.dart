import 'package:flutter/material.dart';

class MyProvidersAppBar extends StatelessWidget implements PreferredSizeWidget {
  TabController tabController;

  MyProvidersAppBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
              const Color(0XFF6717CD),
              const Color(0XFF0A41A6)
            ],
                stops: [
              0.3,
              1
            ])),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 20,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: TabBar(
        tabs: [
          Tab(
            text: 'Doctors',
          ),
          Tab(
            text: 'Hospitals',
          ),
          Tab(
            text: 'Laboratories',
          ),
        ],
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.white,
        indicatorWeight: 4,
      ),
      title: Text('My Providers'),
      centerTitle: false,
    );
  }

  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
