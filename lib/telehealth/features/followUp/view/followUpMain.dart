import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/followUp/view/followUp.dart';
import 'package:myfhb/telehealth/features/followUp/viewModel/followUpViewModel.dart';
import 'package:provider/provider.dart';

class FollowUpMain extends StatefulWidget {
  @override
  _FollowUpMainState createState() => _FollowUpMainState();
}

class _FollowUpMainState extends State<FollowUpMain> {
  final GlobalKey<State> _key = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => FollowUpViewModel(),
        child: FollowUp(),
      ),
    );
  }
  
}
