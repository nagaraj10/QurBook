import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';

import 'Rounded_CheckBox.dart';

class CarePlanCard extends StatefulWidget {
  final int i;
  final List<PlanListResult> planList;

  CarePlanCard(this.i, this.planList);

  @override
  _CarePlanCardState createState() => _CarePlanCardState();
}

class _CarePlanCardState extends State<CarePlanCard> {

  List<PlanListResult> planList;
  int i;

  @override
  void initState() {
    super.initState();
    planList = widget.planList;
    i = widget.i;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<PlanWizardViewModel>(context, listen: false)
            .changeCurrentPage(2);
      },
      child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400],
                blurRadius: 5.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.0.w,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 20,
                    child:
                    CommonUtil().customImage(planList[i]?.metadata?.icon),
                  ),
                  SizedBox(
                    width: 20.0.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          planList[i].title != null
                              ? toBeginningOfSentenceCase(planList[i].title)
                              : '',
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          planList[i].providerName != null
                              ? toBeginningOfSentenceCase(
                              planList[i].providerName)
                              : '',
                          style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.lightgraycolor),
                        ),
                        SizedBox(height: 8.h),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Duration: ',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                planList[i].packageDuration != null
                                    ? Text(
                                  planList[i].packageDuration + ' days',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(new CommonUtil()
                                          .getMyPrimaryColor())),
                                )
                                    : Container(),
                                SizedBox(width: 20.w),
                                Text(
                                  'Fee: ',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                planList[i].price != null
                                    ? Visibility(
                                  visible: planList[i].price.isNotEmpty &&
                                      planList[i].price != '0',
                                  child: TextWidget(
                                      text: INR + planList[i].price,
                                      fontsize: 12.0.sp,
                                      fontWeight: FontWeight.w500,
                                      colors: Color(new CommonUtil()
                                          .getMyPrimaryColor())),
                                  replacement: TextWidget(
                                      text: FREE,
                                      fontsize: 12.0.sp,
                                      fontWeight: FontWeight.w500,
                                      colors: Color(new CommonUtil()
                                          .getMyPrimaryColor())),
                                )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      RoundedCheckBox(() {
                        setState(() {
                          planList.forEach((element) {
                            element.isSelected = false;
                          });
                          planList[i].isSelected = true;
                        });
                      },planList[i].isSelected),
                      SizedBox(width: 5.w),
                    ],
                  )
                ],
              ),
              SizedBox(height: 2.h),
            ],
          )),
    );
  }
}
