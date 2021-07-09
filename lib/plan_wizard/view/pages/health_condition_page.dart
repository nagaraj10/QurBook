import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/plan_wizard/view/widgets/plans_grid_view.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';

class HealthConditionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWidget(
          hintText: strSearchHealth,
          onChanged: (providerName) {
            // if (providerName != '' && providerName.length > 2) {
            //   isSearch = true;
            //   onSearchedNew(providerName);
            // } else {
            //   setState(() {
            //     isSearch = false;
            //   });
            // }
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 5.0.h,
                ),
                PlansGridView(
                  title: strTopPlans,
                  //TODO: Replace with actual plans list
                  planList: List.generate(5, (index) => null),
                ),
                SizedBox(
                  height: 5.0.h,
                ),
                PlansGridView(
                  title: strAllPlans,
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
