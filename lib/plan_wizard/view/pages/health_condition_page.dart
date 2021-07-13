import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/plan_wizard/view/widgets/plans_grid_view.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';

class HealthConditionPage extends StatefulWidget {
  @override
  _HealthConditionPageState createState() => _HealthConditionPageState();
}

class _HealthConditionPageState extends State<HealthConditionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWidget(onChanged: (value){

        },hintText: strSearchHealth),
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
