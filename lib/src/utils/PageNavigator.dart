import 'package:flutter/material.dart';

class PageNavigator {
  static void goTo(BuildContext context, route) {
    Navigator.pushNamed(context, route);
  }

  static void goToPermanent(BuildContext context, route,{dynamic arguments}) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false,arguments: arguments);
  }
}
