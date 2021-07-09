import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

import 'plan_card.dart';
import 'plan_header.dart';

class PlansGridView extends StatelessWidget {
  const PlansGridView({
    @required this.title,
    this.titleColor,
    @required this.planList,
  });

  final String title;
  final Color titleColor;
  //TODO: Replace with actual list type
  final List<dynamic> planList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlanHeader(
          title: title,
          titleColor: titleColor,
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 140.0.w,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: planList?.length ?? 0,
          itemBuilder: (context, index) {
            //TODO: Pass actual params
            return PlanCard();
          },
        ),
      ],
    );
  }
}
