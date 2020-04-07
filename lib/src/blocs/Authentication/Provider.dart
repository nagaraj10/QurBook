import 'package:flutter/material.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';

class Provider extends InheritedWidget {
  final bloc = new LoginBloc();

  Provider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>().bloc);
  }
}
