import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:myfhb/widgets/shopping_cart_widget.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';
import 'page_number_widget.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class PlanNavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 2.w),
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
            margin: EdgeInsets.only(
              right: 35.0.sp
            ),
            // or ClipRRect if you need to clip the content
            child: InkWell(
              onTap: (){
                Get.to(CheckoutPage());
              },
              child: BadgeIcon(
                icon: GestureDetector(
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: Color(CommonUtil().getMyPrimaryColor()),
                    size: 38.0.sp,
                  ),
                ),
                badgeColor: ColorUtils.countColor,
                badgeCount: Provider.of<CheckoutPageProvider>(context).currentCartCount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
