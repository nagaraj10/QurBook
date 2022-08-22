import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/firebase_analytics_service.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/view/planDetailsView.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:provider/provider.dart';
import 'Rounded_CheckBox.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import 'package:myfhb/styles/styles.dart' as fhbStyles;

class CarePlanCard extends StatelessWidget {
  final PlanListResult planList;
  final Function() onClick;
  final String isFrom;

  CarePlanCard({this.planList, this.onClick, this.isFrom});

  PlanWizardViewModel planWizardViewModel = new PlanWizardViewModel();
  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();
  TextEditingController memoController = TextEditingController();
  bool isCheckbox = false;

  @override
  Widget build(BuildContext context) {
    String orginalPrice = planList.price;
    Provider.of<PlanWizardViewModel>(context, listen: false)?.fetchCartItem();
    return InkWell(
      onTap: () {
        onClick();
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
                    child: CommonUtil().customImage(
                      planList?.metadata?.icon ?? '',
                      planInitial: planList?.providerName,
                    ),
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
                                            text: CommonUtil.CURRENCY +
                                                planList.price,
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
                              isSelected: isFrom == strProviderCare
                                  ? Provider.of<PlanWizardViewModel>(context)
                                          .checkItemInCart(
                                              planList.packageid, isFrom,
                                              providerId:
                                                  planList.providerid) ||
                                      Provider.of<PlanWizardViewModel>(context)
                                              .currentPackageProviderCareId ==
                                          planList.packageid
                                  : Provider.of<PlanWizardViewModel>(context)
                                          .checkItemInCart(
                                              planList.packageid, isFrom,
                                              providerId:
                                                  planList.providerid) ||
                                      Provider.of<PlanWizardViewModel>(context)
                                              .currentPackageFreeCareId ==
                                          planList.packageid,
                              onTap: () async {
                                var firebase = FirebaseAnalyticsService();
                                firebase.trackEvent("on_plan_selected", {
                                  "user_id": PreferenceUtil.getStringValue(
                                      KEY_USERID_MAIN),
                                  "planId": planList.packageid,
                                  "type": "add or remove",
                                  "name": planList.title
                                });
                                if (planList.isSubscribed == '1') {
                                  if (planList.isExtendable == '1') {
                                    var isSelected =
                                        Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            .checkItemInCart(
                                                planList.packageid, isFrom,
                                                providerId:
                                                    planList.providerid);
                                    if (isSelected) {
                                      commonRemoveCartDialog(context, planList,
                                          planList.packageid, orginalPrice);
                                      firebase.trackEvent("on_plan_selected", {
                                        "user_id":
                                            PreferenceUtil.getStringValue(
                                                KEY_USERID_MAIN),
                                        "planId": planList.packageid,
                                        "type": "remove",
                                        "name": planList.title
                                      });
                                    } else {
                                      _alertForSubscribedPlan(
                                          context, orginalPrice);
                                      firebase.trackEvent("on_plan_selected", {
                                        "user_id":
                                            PreferenceUtil.getStringValue(
                                                KEY_USERID_MAIN),
                                        "planId": planList.packageid,
                                        "type": "add",
                                        "name": planList.title
                                      });
                                    }
                                  } else {
                                    FlutterToast()
                                        .getToast(renewalLimit, Colors.black);
                                  }
                                } else {
                                  firebase.trackEvent("on_plan_selected", {
                                    "user_id": PreferenceUtil.getStringValue(
                                        KEY_USERID_MAIN),
                                    "planId": planList.packageid,
                                    "type": "add or remove",
                                    "name": planList.title
                                  });
                                  var isSelected =
                                      Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          .checkItemInCart(
                                              planList.packageid, isFrom,
                                              providerId: planList.providerid);
                                  if (isSelected) {
                                    commonRemoveCartDialog(context, planList,
                                        planList.packageid, orginalPrice);
                                  } else {
                                    bool canProceed =
                                        await Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            .handleBundlePlans();
                                    if (canProceed) {
                                      if (isFrom == strProviderCare) {
                                        if (Provider.of<PlanWizardViewModel>(
                                                    context,
                                                    listen: false)
                                                ?.currentPackageProviderCareId !=
                                            '') {
                                          commonRemoveCartDialog(
                                              context,
                                              planList,
                                              Provider.of<PlanWizardViewModel>(
                                                      context,
                                                      listen: false)
                                                  ?.currentPackageProviderCareId,
                                              orginalPrice);
                                        }

                                        bool isItemInCart =
                                            Provider.of<PlanWizardViewModel>(
                                                    context,
                                                    listen: false)
                                                .checkAllItemsForFreeCare();
                                        if (isItemInCart) {
                                          commonRemoveCartDialog(
                                              context,
                                              planList,
                                              Provider.of<PlanWizardViewModel>(
                                                      context,
                                                      listen: false)
                                                  ?.currentCartProviderCarePackageId,
                                              orginalPrice);
                                        }
                                        checkIfMemberShipIsAvailable(
                                            context, planList, planList.price);
                                      } else if (isFrom == strFreeCare) {
                                        if (Provider.of<PlanWizardViewModel>(
                                                    context,
                                                    listen: false)
                                                ?.currentPackageFreeCareId !=
                                            '') {
                                          commonRemoveCartDialog(
                                              context,
                                              planList,
                                              Provider.of<PlanWizardViewModel>(
                                                      context,
                                                      listen: false)
                                                  ?.currentPackageFreeCareId,
                                              orginalPrice);
                                        }

                                        bool isItemInCart =
                                            Provider.of<PlanWizardViewModel>(
                                                    context,
                                                    listen: false)
                                                .checkAllItemsForFreeCare();
                                        if (isItemInCart) {
                                          commonRemoveCartDialog(
                                              context,
                                              planList,
                                              Provider.of<PlanWizardViewModel>(
                                                      context,
                                                      listen: false)
                                                  ?.currentCartFreeCarePackageId,
                                              orginalPrice);
                                        }
                                        checkIfMemberShipIsAvailable(
                                            context, planList, planList.price);
                                      }
                                    }
                                  }
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
    var firebase = FirebaseAnalyticsService();
    firebase.trackEvent("on_plan_view", {
      "user_id": PreferenceUtil.getStringValue(KEY_USERID_MAIN),
      "planId": planList.packageid,
      "type": "plan view",
      "name": planList.title
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyPlanDetailView(
                // title: planList?.title,
                // providerName: planList?.providerName,
                // description: planList?.description,
                // issubscription: planList?.isSubscribed,
                packageId: planList?.packageid,
                // price: planList?.price,
                // packageDuration: planList?.packageDuration,
                // providerId: planList?.plinkid,
                // isDisable: false,
                // hosIcon: planList?.providerMetadata?.icon,
                // iconApi: planList?.metadata?.icon,
                // catIcon: planList?.catmetadata?.icon,
                // metaDataForURL: planList?.metadata,
                // isExtendable: planList.isSubscribed=='1'?planList?.isExtendable == '1' ? true : false:true,
                isFrom: isFrom,
                // isRenew: planList?.isexpired == '1' ? true : false,
              )),
    );
  }

  Future<bool> _alertForSubscribedPlan(
      BuildContext context, String orginalPrice) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(alreadySubscribed),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);

                  bool canProceed = await Provider.of<PlanWizardViewModel>(
                          Get.context,
                          listen: false)
                      .handleBundlePlans();

                  /// provider care plan
                  if (canProceed) {
                    if (isFrom == strProviderCare) {
                      if (Provider.of<PlanWizardViewModel>(Get.context,
                                  listen: false)
                              ?.currentPackageProviderCareId !=
                          '') {
                        commonRemoveCartDialog(
                            context,
                            planList,
                            Provider.of<PlanWizardViewModel>(context,
                                    listen: false)
                                ?.currentPackageProviderCareId,
                            orginalPrice);
                      }

                      bool isItemInCart = Provider.of<PlanWizardViewModel>(
                              Get.context,
                              listen: false)
                          .checkAllItemsForProviderCare();
                      if (isItemInCart) {
                        commonRemoveCartDialog(
                            context,
                            planList,
                            Provider.of<PlanWizardViewModel>(Get.context,
                                    listen: false)
                                ?.currentCartProviderCarePackageId,
                            orginalPrice);
                      }
                      checkIfMemberShipIsAvailable(
                          context, planList, planList.price);
                    }

                    /// free care plans
                    else {
                      if (Provider.of<PlanWizardViewModel>(Get.context,
                                  listen: false)
                              ?.currentPackageFreeCareId !=
                          '') {
                        commonRemoveCartDialog(
                            context,
                            planList,
                            Provider.of<PlanWizardViewModel>(Get.context,
                                    listen: false)
                                ?.currentPackageFreeCareId,
                            orginalPrice);
                      }

                      bool isItemInCart = Provider.of<PlanWizardViewModel>(
                              Get.context,
                              listen: false)
                          .checkAllItemsForFreeCare();
                      if (isItemInCart) {
                        commonRemoveCartDialog(
                            context,
                            planList,
                            Provider.of<PlanWizardViewModel>(Get.context,
                                    listen: false)
                                ?.currentCartFreeCarePackageId,
                            orginalPrice);
                      }
                      checkIfMemberShipIsAvailable(
                          context, planList, planList.price);
                    }
                  }
                },
                child: Text('Ok'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _alertForMemberShip(
      BuildContext context, PlanListResult planList, bool isMemberShip) {
    String originalPrice = planList.price;
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
                "You can subscribe/renew this plan for free. Do you want to use your membership benefit?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  addToCartCommonMethod(
                      planList, context, originalPrice, "", false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);

                  addToCartCommonMethod(
                      planList, context, originalPrice, "", true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void addToCartCommonMethod(PlanListResult planList, BuildContext context,
      String orginalPrice, String remark, bool isMemberShipAvailable) async {
    await Provider.of<PlanWizardViewModel>(context, listen: false)
        ?.addToCartItem(
            packageId: planList.packageid,
            price: orginalPrice,
            isRenew: planList.isexpired == '1' ? true : false,
            providerId: planList.providerid,
            isFromAdd: isFrom,
            isMemberShipAvail: isMemberShipAvailable ?? false,
            actualFee: orginalPrice,
            remarks: remark,
            planType: isFrom == strProviderCare ? "CARE" : "",
            packageDuration: planList?.packageDuration);
  }

  void checkIfMemberShipIsAvailable(
      BuildContext context, PlanListResult planList, String price) async {
    bool isMemberShip =
        await Provider.of<PlanWizardViewModel>(context, listen: false)
            ?.isMembershipAVailable;
    int careCount =
        await Provider.of<PlanWizardViewModel>(context, listen: false)
            ?.carePlanCount;
    int priceValue = int.parse(price);
    if (isMemberShip && priceValue > 0 && careCount > 0) {
      _alertForMemberShip(context, planList, isMemberShip);
    } else {
      addToCartCommonMethod(planList, context, planList.price, "", false);
    }
  }

  Future<Widget> _alertBoxforCheckMemberShip(
      BuildContext context, PlanListResult planList, bool showCheckBox) {
    String originalPrice = planList.price;
    String priceSet = planList.price;
    var dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              fhbBasicWidget.getTextTextTitleWithPurpleColor("Plan Review"),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 24.0.sp,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          content: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0.h,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextWidget(
                          text: "Price",
                          colors: Color(CommonUtil().getMyPrimaryColor()),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        new Container(
                          width: 1.sw - 20,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: new Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: TextWidget(
                            text: priceSet,
                            colors: Color(CommonUtil().getMyPrimaryColor()),
                          ),
                        ),
                        SizedBox(
                          height: 5.0.h,
                        ),
                        showCheckBox
                            ? Row(
                                children: [
                                  Checkbox(
                                    checkColor:
                                        Color(CommonUtil().getMyPrimaryColor()),
                                    activeColor:
                                        Color(CommonUtil().getThemeColor()),
                                    value: isCheckbox,
                                    onChanged: (bool value) {
                                      setState(() {
                                        if (value) {
                                          priceSet = 0.toString();
                                        } else {
                                          priceSet = originalPrice;
                                        }
                                        isCheckbox = value;
                                      });
                                    },
                                  ),
                                  Text(
                                    "AVAIL MEMBERSHIP BENEFIT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: fhbStyles.fnt_doc_name,
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              )
                            : SizedBox(),
                        fhbBasicWidget.getRichTextFieldWithNoCallbacks(
                            context,
                            memoController,
                            Constants.Rmarks_HINT,
                            500,
                            "",
                            (value) {},
                            false),
                        SizedBox(
                          height: 15.0.h,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            height: 1.sw - 80,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () async {
                Navigator.pop(context);

                addToCartCommonMethod(planList, context, originalPrice,
                    memoController.text, isCheckbox ?? false);
              },
              child: Text('Yes'),
            ),
          ]);
    });

    return showDialog(
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
  }

  void commonRemoveCartDialog(BuildContext context, PlanListResult planList,
      String packageId, String orginalPrice) async {
    await Provider.of<PlanWizardViewModel>(context, listen: false)
        ?.fetchCartItem();

    ProductList productList =
        Provider.of<PlanWizardViewModel>(context, listen: false)
            ?.getProductListUsingPackageId(packageId);
    await Provider.of<PlanWizardViewModel>(context, listen: false)?.removeCart(
        packageId: packageId, isFrom: isFrom, productList: productList);
  }
}
