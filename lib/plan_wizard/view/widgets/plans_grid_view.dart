import 'package:flutter/material.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

import 'plan_header.dart';

class PlansGridView extends StatelessWidget {
  const PlansGridView({
    @required this.title,
    this.titleColor,
    @required this.planList,
  });

  final String title;
  final Color titleColor;
  final List<MyPlanListResult> planList;

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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(10.0.sp),
              child: Material(
                borderRadius: BorderRadius.circular(
                  20.0.sp,
                ),
                elevation: 5.0.sp,
                color: Colors.white,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        20.0.sp,
                      ),
                    ),
                    child: Center(child: Text('Plan $index')),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
