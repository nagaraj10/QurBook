import 'package:flutter/material.dart';
import 'package:myfhb/src/model/DrawerItem.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppDrawerState();
  }
}

class AppDrawerState extends State<AppDrawer> {
  //int _selectedIndex;

  final drawerItems = [
    new DrawerItem(Constants.MYFamily, 'assets/icons/my_family.svg'),
    new DrawerItem(Constants.MyProviders, 'assets/icons/providers.svg'),
    new DrawerItem(Constants.Feedback, 'assets/icons/feedback.svg'),
    new DrawerItem(Constants.Settings, 'assets/icons/settings.svg'),
    new DrawerItem(Constants.FAQ, 'assets/icons/faq.svg'),
    new DrawerItem(Constants.RateUs, 'assets/icons/rate_us.svg')
  ];

  _onSelectItem(int index) {
    /* setState(() {
      _selectedIndex = index;
      print(drawerItems[index].title);
      //_getDrawerItemScreen(_selectedIndex);
    }); */
    print(drawerItems[index].title);
    Navigator.of(context).pop(); // close the drawer
//    Navigator.push(
//      context,
//      new MaterialPageRoute(
//        builder: (context) => _getDrawerItemScreen(_selectedIndex),
//      ),
//    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Padding(
            padding: EdgeInsets.only(left: 10),
            child: SvgPicture.asset(
              d.icon,
              width: 20,
              height: 20,
            )

            /* Icon(
            d.icon,
            size: 20,
          ), */
            ),
        title: new Text(
          d.title,
          style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
        //selected: i == _selectedIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 260,
            child: DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Colors.deepPurple,
                Colors.deepPurpleAccent
              ])),
              child: Column(
                children: <Widget>[
                  new Container(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
                        ),
                        //radius: 40,
                      ),
                      width: 90.0,
                      height: 90.0,
                      padding: const EdgeInsets.all(5.0), // borde width
                      decoration: new BoxDecoration(
                        color: Colors.deepPurple[100]
                            .withOpacity(0.5), // border color
                        shape: BoxShape.circle,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Ravindran Perumal',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Poppins'),
                  ),
                  Text('+91 9840972275',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontFamily: 'Poppins')),
                  Text(
                    'ravindran.perumal@globalmantrai.com',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: drawerOptions,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 60, right: 60),
            child: RaisedGradientButton(
                width: 60,
                height: 40,
                borderRadius: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                gradient: LinearGradient(
                  colors: <Color>[Colors.deepPurple[300], Colors.deepPurple],
                ),
                onPressed: () {
                  PageNavigator.goToPermanent(context, '/sign_in_screen');
                }),
          ),
        ],
      ),
    );
  }
}
