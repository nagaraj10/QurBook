import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:provider/provider.dart';

import 'page_number_widget.dart';

class PlanNavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (ctxt, index) {
              return PageNumberWidget(
                isLastItem: index == 2,
                pageNumber: '${index + 1}',
                isSelected: index <=
                    Provider.of<PlanWizardViewModel>(context).currentPage,
              );
            },
          ),
          Container(
            margin: EdgeInsets.all(
              10.0.sp,
            ),
            height: 50.0.sp,
            width: 50.0.sp,
            // or ClipRRect if you need to clip the content
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(CommonUtil().getMyPrimaryColor()),
              ),
              shape: BoxShape.circle,
              color: Colors.white, // inner circle color
            ),
            child: Icon(
              Icons.add_shopping_cart,
              color: Color(CommonUtil().getMyPrimaryColor()),
              size: 30.0.sp,
            ),
          ),
        ],
      ),
    );
  }
}
