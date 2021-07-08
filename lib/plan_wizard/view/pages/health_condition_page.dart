import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/plan_wizard/view/widgets/plans_grid_view.dart';
import 'package:myfhb/plan_wizard/view/widgets/plans_list_horizontal.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';

class HealthConditionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          SizedBox(
            height: 5.0.h,
          ),
          PlansListHorizontal(
            title: strTopPlans,
            titleColor: Colors.lightBlue,
            //TODO: Replace with actual plans list
            planList: [],
          ),
          SizedBox(
            height: 5.0.h,
          ),
          PlansGridView(
            title: strAllPlans,
            //TODO: Replace with actual plans list
            planList: [],
          ),
          SizedBox(
            height: 10.0.h,
          ),
        ],
      ),
    );
  }
}
