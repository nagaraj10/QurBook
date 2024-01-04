import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import '../../../../common/firestore_services.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/telehealth/features/MyProvider/view/MyProviderHospitals.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProviders.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

class MyProvidersMain extends StatefulWidget {
  final int? mTabIndex;

  MyProvidersMain({this.mTabIndex});
  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<MyProvidersMain>
    with SingleTickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  TabController? _controller;
  int _selectedIndex = 0;
  bool isRefresh = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(
      length: 2,
      vsync: this,
    );

    _controller!.index = widget.mTabIndex != null ? widget.mTabIndex! : 0;

    _controller!.addListener(() {
      FocusManager.instance.primaryFocus!.unfocus();
      setState(() {
        _selectedIndex = _controller!.index;
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
            tabs: <Tab>[
              Tab(
                  child: Text(CommonConstants.doctors,
                      style: CommonUtil().getTitleStyle())),
              Tab(
                  child: Text(CommonConstants.hospitals,
                      style: CommonUtil().getTitleStyle()))
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
          Container(
            child: ChangeNotifierProvider(
              create: (context) => MyProviderViewModel(),
              child: MyProviders(
                isRefresh: isRefresh,
                closePage: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Container(
            child: ChangeNotifierProvider(
              create: (context) => MyProviderViewModel(),
              child: MyProvidersHospitals(
                isRefresh: isRefresh,
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
                fontSize: CommonUtil().isTablet!
                    ? Constants.tabFontTitle
                    : Constants.mobileFontTitle),
          ),
        ),
        CommonUtil().getNotificationIcon(context),
        SwitchProfile()
            .buildActions(context, _keyLoader, callBackToRefresh, false),
        // Icon(Icons.more_vert),
      ],
    );
  }

  void callBackToRefresh() {
    //myProvidersResponseList = null;
    FirestoreServices().updateFirestoreListner();
    setState(() {
      isRefresh = false;
    });
    print('Came hereee');
    (context as Element).markNeedsBuild();
  }
}
