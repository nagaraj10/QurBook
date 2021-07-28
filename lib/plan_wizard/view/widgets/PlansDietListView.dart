import 'package:flutter/material.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/models/DietPlanModel.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

import 'diet_plan_card.dart';
import 'care_plan_card.dart';
import 'plan_card.dart';
import 'plan_header.dart';

class PlanDietListView extends StatelessWidget {
  const PlanDietListView({
    @required this.title,
    @required this.planList,
  });

  final String title;
  final List<DietPlanResult> planList;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (planList?.length??0)>0,
      child: Column(
        children: [
          SizedBox(
            height: 5.0.h,
          ),
          PlanHeader(
            title: title,
          ),
          /*ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: planList?.length ?? 0,
            itemBuilder: (context, index) {
              return DietPlanCard(planList: planList[index]);
            },
          ),*/
        ],
      ),
    );
  }
}
