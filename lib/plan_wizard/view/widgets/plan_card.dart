import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:provider/provider.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    @required this.healthCondition,
  });

  final MenuItem healthCondition;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(10.0.sp),
        child: Material(
          borderRadius: BorderRadius.circular(
            10.0.sp,
          ),
          elevation: 5.0.sp,
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Provider.of<PlanWizardViewModel>(context, listen: false)
                  .selectedTag = healthCondition?.tags ?? '';
              Provider.of<PlanWizardViewModel>(context, listen: false)
                  .changeCurrentPage(1);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 10.0.h,
                horizontal: 10.0.w,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: (constraints?.maxHeight ?? 97.0.h) / 2,
                        ),
                        margin: EdgeInsets.only(
                          bottom: 3.0.h,
                        ),
                        child: CommonUtil().customImage(
                          healthCondition?.metadata?.icon ?? '',
                          defaultWidget: ClipOval(
                              child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey[200],
                            child: Text(
                              healthCondition?.title
                                      ?.substring(0, 1)
                                      ?.toUpperCase() ??
                                  '',
                              style: TextStyle(
                                fontSize: 25.0.sp,
                                color: Color(CommonUtil().getMyPrimaryColor()),
                              ),
                            ),
                          )),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          healthCondition.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0.sp,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
}
