import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointments.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleAppointments.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:provider/provider.dart';

class ResheduleMain extends StatefulWidget {
  History doc;
  bool isReshedule;

  ResheduleMain({this.doc,this.isReshedule});
  @override
  _ResheduleMainState createState() => _ResheduleMainState();
}

class _ResheduleMainState extends State<ResheduleMain> {
  final GlobalKey<State> _key = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => MyProviderViewModel(),
        child: ResheduleAppointments(doc: widget.doc,isReshedule: widget.isReshedule,),
      ),
    );
  }

}
