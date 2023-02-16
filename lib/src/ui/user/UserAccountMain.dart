import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';

import 'UserAccounts.dart';

class UserAccountsMain extends StatefulWidget {
  @override
  _UserAccountsMainState createState() => _UserAccountsMainState();
}

class _UserAccountsMainState extends State<UserAccountsMain> {
  @override
  Widget build(BuildContext context) {
    return UserAccounts(arguments: UserAccountsArguments(selectedIndex: 0));
  }
}
