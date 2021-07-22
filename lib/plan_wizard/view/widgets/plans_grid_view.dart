import 'package:flutter/material.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

import 'plan_card.dart';
import 'plan_header.dart';

class PlansGridView extends StatelessWidget {
  const PlansGridView({
    @required this.title,
    @required this.planList,
  });

  final String title;
  final List<MenuItem> planList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5.0.h,
        ),
        PlanHeader(
          title: title,
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 140.0.w,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: planList?.length ?? 0,
          itemBuilder: (context, index) {
            return PlanCard(
              healthCondition: planList[index],
            );
          },
        ),
      ],
    );
  }
}
