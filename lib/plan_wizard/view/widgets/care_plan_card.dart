import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/view/planDetailsView.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:provider/provider.dart';
import 'Rounded_CheckBox.dart';

class CarePlanCard extends StatelessWidget {
  final PlanListResult planList;
  final Function() onClick;

  CarePlanCard({this.planList, this.onClick});

  PlanWizardViewModel planWizardViewModel = new PlanWizardViewModel();


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyPlanDetailView(
                title: planList?.title,
                providerName: planList?.providerName,
                description: planList?.description,
                issubscription: planList?.isSubscribed,
                packageId: planList?.packageid,
                price: planList?.price,
                packageDuration:
                planList?.packageDuration,
                providerId: planList?.plinkid,
                isDisable: false,
                hosIcon:
                planList?.providerMetadata?.icon,
                iconApi: planList?.metadata?.icon,
                catIcon: planList?.catmetadata?.icon,
                metaDataForURL: planList?.metadata,
              )),
        );
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
                    child: CommonUtil()
                        .customImage(planList?.metadata?.icon ?? ''),
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
                          planList.title != null
                              ? toBeginningOfSentenceCase(planList.title)
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
                          planList.providerName != null
                              ? toBeginningOfSentenceCase(planList.providerName)
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
                                planList.packageDuration != null
                                    ? Text(
                                        planList.packageDuration + ' days',
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
                                planList.price != null
                                    ? Visibility(
                                        visible: planList.price.isNotEmpty &&
                                            planList.price != '0',
                                        child: TextWidget(
                                            text: INR + planList.price,
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
                      RoundedCheckBox(
                          isSelected: Provider.of<PlanWizardViewModel>(context)
                                  .currentPackageId ==
                              planList.packageid,
                          onTap: () {
                            Provider.of<PlanWizardViewModel>(context,
                                    listen: false)
                                .updateSingleSelection(planList.packageid);

                            if (Provider.of<PlanWizardViewModel>(context,
                                        listen: false)
                                    .currentPackageId ==
                                planList.packageid) {
                              planWizardViewModel
                                  .addToCartItem(
                                      packageId: planList.packageid,
                                      price: planList.price,
                                      isRenew: planList.isexpired == '1'
                                          ? true
                                          : false)
                                  .then((value) {
                                if (value?.isSuccess) {
                                  FlutterToast().getToast(
                                      'Plan Added to Cart', Colors.green);
                                } else {
                                  FlutterToast().getToast(
                                      value?.message != null
                                          ? value?.message
                                          : 'Adding Failed! Try again',
                                      Colors.green);
                                }
                              });
                            } else {
                              print('removeItem'); //Mohan delete api
                            }
                          }),
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
