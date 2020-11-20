import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProviders.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

class MyProvidersMain extends StatefulWidget {
  @override
  _MyProvidersMainState createState() => _MyProvidersMainState();
}

class _MyProvidersMainState extends State<MyProvidersMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => MyProviderViewModel(),
        child: MyProviders(closePage: (value){
          Navigator.pop(context);
        },),
      ),
    );
  }
}
