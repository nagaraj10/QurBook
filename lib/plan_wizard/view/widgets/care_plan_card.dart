import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/view/planDetailsView.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
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
        onCardTapped(context);
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
                      Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => onCardTapped(context),
                              child: Icon(
                                Icons.remove_red_eye_sharp,
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                size: 30.0.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          RoundedCheckBox(
                              isSelected:
                                  Provider.of<PlanWizardViewModel>(context)
                                          .checkItemInCart(
                                              planList.packageid, strCare,
                                              providerId:
                                                  planList.providerid) ||
                                      Provider.of<PlanWizardViewModel>(context)
                                              .currentPackageId ==
                                          planList.packageid,
                              onTap: () async {
                                if (planList.isExtendable == '1') {
                                  var isSelected =
                                      Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          .checkItemInCart(
                                              planList.packageid, strCare,
                                              providerId: planList.providerid);
                                  if (isSelected) {
                                    await Provider.of<PlanWizardViewModel>(
                                            context,
                                            listen: false)
                                        ?.removeCart(
                                            packageId: planList.packageid);
                                  } else {
                                    if (Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            ?.currentPackageId !=
                                        '') {
                                      await Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          ?.removeCart(
                                              packageId: Provider.of<
                                                          PlanWizardViewModel>(
                                                      context,
                                                      listen: false)
                                                  ?.currentPackageId);
                                    }

                                    bool isItemInCart =
                                        Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            .checkAllItems();
                                    if (isItemInCart) {
                                      await Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          ?.removeCart(
                                              packageId: Provider.of<
                                                          PlanWizardViewModel>(
                                                      context,
                                                      listen: false)
                                                  ?.currentCartPackageId);
                                    }

                                    await Provider.of<PlanWizardViewModel>(
                                            context,
                                            listen: false)
                                        ?.addToCartItem(
                                            packageId: planList.packageid,
                                            price: planList.price,
                                            isRenew: planList.isexpired == '1'
                                                ? true
                                                : false,
                                            providerId: planList.providerid,
                                            isFromAdd: strCare);
                                  }
                                } else {
                                  FlutterToast()
                                      .getToast(renewalLimit, Colors.black);
                                }
                              }),
                        ],
                      ),
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

  onCardTapped(BuildContext context) {
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
                packageDuration: planList?.packageDuration,
                providerId: planList?.plinkid,
                isDisable: false,
                hosIcon: planList?.providerMetadata?.icon,
                iconApi: planList?.metadata?.icon,
                catIcon: planList?.catmetadata?.icon,
                metaDataForURL: planList?.metadata,
                isExtendable: planList?.isExtendable == '1' ? true : false,
                isFrom: strCare,
                isRenew: planList?.isexpired == '1' ? true : false,
              )),
    );
  }
}
