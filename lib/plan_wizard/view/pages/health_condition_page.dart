import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/plan_wizard/view/widgets/plans_grid_view.dart';
import 'package:myfhb/plan_wizard/view/widgets/search_widget.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';

class HealthConditionPage extends StatefulWidget {
  @override
  _HealthConditionPageState createState() => _HealthConditionPageState();
}

class _HealthConditionPageState extends State<HealthConditionPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PlanWizardViewModel>(context).currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWidgetWizard((value) {}, strSearchHealth),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 5.0.h,
                ),
                PlansGridView(
                  title: strTopHealth,
                  //TODO: Replace with actual plans list
                  planList: List.generate(5, (index) => null),
                ),
                SizedBox(
                  height: 5.0.h,
                ),
                PlansGridView(
                  title: strAllHealth,
                  //TODO: Replace with actual plans list
                  planList: List.generate(10, (index) => null),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
