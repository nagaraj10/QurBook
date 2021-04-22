import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProviderHospitals.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProviders.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

class MyProvidersMain extends StatefulWidget {
  final int mTabIndex;

  MyProvidersMain({this.mTabIndex});
  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<MyProvidersMain>
    with SingleTickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TabController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = new TabController(
      length: 2,
      vsync: this,
    );

    _controller.index = widget.mTabIndex != null ? widget.mTabIndex : 0;

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: TabBar(
            onTap: (index) {
              // Should not used it as it only called when tab options are clicked,
              // not when user swapped
            },
            controller: _controller,
            tabs: const <Tab>[
              const Tab(text: 'Doctors'),
              const Tab(text: 'Hospitals')
            ],
          ),
          flexibleSpace: GradientAppBar(),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios, // add custom icons also
              size: 24.0.sp,
            ),
          ),
          // you can put Icon as well, it accepts any widget.
          title: getTitle()),
      body: TabBarView(
        controller: _controller,
        children: [
          Scaffold(
            body: ChangeNotifierProvider(
              create: (context) => MyProviderViewModel(),
              child: MyProviders(
                closePage: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Scaffold(
            body: ChangeNotifierProvider(
              create: (context) => MyProviderViewModel(),
              child: MyProvidersHospitals(
                closePage: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'My Providers',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        new CommonUtil().getNotificationIcon(context),
        new SwitchProfile()
            .buildActions(context, _keyLoader, callBackToRefresh, false),
        // Icon(Icons.more_vert),
      ],
    );
  }

  void callBackToRefresh() {
    //myProvidersResponseList = null;
    (context as Element).markNeedsBuild();
  }
}

/*class MyProvidersMain extends StatefulWidget {
  @override
  _MyProvidersMainState createState() => _MyProvidersMainState();
}

class _MyProvidersMainState extends State<MyProvidersMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => MyProviderViewModel(),
        child: MyProviders(
          closePage: (value) {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}*/
