import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../authentication/constants/constants.dart';
import '../../common/CommonUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart';
import '../../plan_wizard/view_model/plan_wizard_view_model.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import '../model/MetaDataForURL.dart';
import '../model/PlanListModel.dart';
import '../viewModel/planViewModel.dart';
import 'plan_pdf_viewer.dart';

class MyPlanDetailView extends StatefulWidget {
  final String? packageId;
  final String? isFrom;

  const MyPlanDetailView({
    Key? key,
    this.packageId,
    this.isFrom,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PlanDetail();
}

class PlanDetail extends State<MyPlanDetailView> {
  String? title;
  String? description;
  String? price;
  String? issubscription;
  String? packageId;
  String? providerName;
  String? packageDuration;
  String? docName;
  String? providerId;
  bool? isDisable;
  String? hosIcon = '';
  String? iconApi = '';
  String? catIcon = '';
  bool isExtendable = false;
  bool isRenew = false;
  String? isFrom = '';
  MetaDataForURL? metaDataForURL;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late Future<PlanListModel?> planListModel;
  @override
  void initState() {
    super.initState();

    planListModel = PlanViewModel().getPlanDetail(widget.packageId);
  }

  void setValues(PlanListResult planList) {
    title = planList.title;
    description = planList.description;
    price = planList.price;
    issubscription = planList.issubscription;
    packageId = planList.packageid;
    providerName = planList.providerName;
    packageDuration = planList.packageDuration;
    docName = planList.metadata?.doctorName ?? '';
    providerId = planList.plinkid;
    isDisable = false;
    hosIcon = planList.providerMetadata?.icon;
    iconApi = planList.metadata?.icon;
    catIcon = planList.catmetadata?.icon;
    metaDataForURL = planList.metadata;
    isRenew = planList.isexpired == '1' ? true : false;
    isFrom = widget.isFrom;
    isExtendable = planList.isSubscribed == '1'
        ? planList.isExtendable == '1'
            ? true
            : false
        : true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.isFrom == strDeepLink) {
          Get.offAllNamed(rt_PlanWizard);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: GestureDetector(
            onTap: () {
              if (widget.isFrom == strDeepLink) {
                Get.offAllNamed(rt_PlanWizard);
              } else {
                Get.back();
              }
            },
            child: Icon(
              Icons.arrow_back_ios, // add custom icons also
              size: 24,
            ),
          ),
          title: Text(
            'Plans',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: FutureBuilder<PlanListModel?>(
          future: planListModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SafeArea(
                child: SizedBox(
                  height: 1.sh / 4.5,
                  child: Center(
                    child: SizedBox(
                      width: 30.0.h,
                      height: 30.0.h,
                      child: CommonCircularIndicator(),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return ErrorsWidget();
            } else {
              if (snapshot.hasData &&
                  snapshot.data!.result != null &&
                  snapshot.data!.result!.isNotEmpty) {
                PlanListResult planList =
                    snapshot.data?.result![0] as PlanListResult;
                setValues(planList);
                return Builder(
                  builder: (contxt) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    //alignment: Alignment.center,
                    height: 1.sh - AppBar().preferredSize.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  radius: 30,
                                  child: CommonUtil().customImage(
                                    getImage(),
                                    planInitial: providerName,
                                  )),
                              // child: ClipOval(
                              //   // backgroundColor: Colors.grey[200],
                              //   // radius: 35,
                              //   child: Container(
                              //     alignment: Alignment.center,
                              //     height: 70,
                              //     width: 70,
                              //     decoration: BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       color: Colors.transparent,
                              //     ),
                              //     child: iconApi != null && iconApi != ''
                              //         ? iconApi
                              //                 .toString()
                              //                 .toLowerCase()
                              //                 ?.contains('.svg')
                              //             ? Center(
                              //                 child: SizedBox(
                              //                   height: 50,
                              //                   width: 50,
                              //                   child: SvgPicture.network(
                              //                     iconApi,
                              //                     placeholderBuilder: (BuildContext
                              //                             context) =>
                              //                         CircularProgressIndicator(
                              //                             strokeWidth: 1.5,
                              //                             backgroundColor: Color(
                              //                                 CommonUtil()
                              //                                     .getMyPrimaryColor())),
                              //                   ),
                              //                 ),
                              //               )
                              //             : CachedNetworkImage(
                              //                 imageUrl: iconApi,
                              //                 placeholder: (context, url) =>
                              //                     CircularProgressIndicator(
                              //                         strokeWidth: 1.5,
                              //                         backgroundColor: Color(
                              //                             CommonUtil()
                              //                                 .getMyPrimaryColor())),
                              //                 errorWidget: (context, url, error) =>
                              //                     ClipOval(
                              //                         child: CircleAvatar(
                              //                   backgroundImage:
                              //                       AssetImage(qurHealthLogo),
                              //                   radius: 32,
                              //                   backgroundColor: Colors.transparent,
                              //                 )),
                              //                 imageBuilder: (context, imageProvider) =>
                              //                     Container(
                              //                   width: 80.0,
                              //                   height: 80.0,
                              //                   decoration: BoxDecoration(
                              //                     shape: BoxShape.circle,
                              //                     image: DecorationImage(
                              //                         image: imageProvider,
                              //                         fit: BoxFit.fill),
                              //                   ),
                              //                 ),
                              //               )
                              //         : icon != null && icon != ''
                              //             ? icon
                              //                     .toString()
                              //                     .toLowerCase()
                              //                     ?.contains('.svg')
                              //                 ? SvgPicture.network(
                              //                     icon,
                              //                     placeholderBuilder: (BuildContext
                              //                             context) =>
                              //                         CircularProgressIndicator(
                              //                             strokeWidth: 1.5,
                              //                             backgroundColor: Color(
                              //                                 CommonUtil()
                              //                                     .getMyPrimaryColor())),
                              //                   )
                              //                 : CachedNetworkImage(
                              //                     imageUrl: icon,
                              //                     placeholder: (context, url) =>
                              //                         CircularProgressIndicator(
                              //                             strokeWidth: 1.5,
                              //                             backgroundColor: Color(
                              //                                 CommonUtil()
                              //                                     .getMyPrimaryColor())),
                              //                     errorWidget: (context, url, error) =>
                              //                         ClipOval(
                              //                             child: CircleAvatar(
                              //                       backgroundImage:
                              //                           AssetImage(qurHealthLogo),
                              //                       radius: 32,
                              //                       backgroundColor: Colors.transparent,
                              //                     )),
                              //                     imageBuilder:
                              //                         (context, imageProvider) =>
                              //                             Container(
                              //                       width: 80.0,
                              //                       height: 80.0,
                              //                       decoration: BoxDecoration(
                              //                         shape: BoxShape.circle,
                              //                         image: DecorationImage(
                              //                             image: imageProvider,
                              //                             fit: BoxFit.fill),
                              //                       ),
                              //                     ),
                              //                   )
                              //             : ClipOval(
                              //                 child: CircleAvatar(
                              //                 backgroundImage:
                              //                     AssetImage(qurHealthLogo),
                              //                 radius: 32,
                              //                 backgroundColor: Colors.transparent,
                              //               )),
                              //   ),
                              // ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title != null && title != ''
                                        ? title!.trim()
                                        : '-',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    providerName != null && providerName != ''
                                        ? providerName!
                                        : '-',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600]),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  docName != null && docName != ''
                                      ? Row(
                                          children: [
                                            Text('Plan approved by :',
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.grey[600])),
                                            SizedBox(width: 4.w),
                                            Flexible(
                                              child: Container(
                                                child: Text(
                                                    toBeginningOfSentenceCase(
                                                        docName)!,
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 16.sp)),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Duration: ',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14.sp),
                                          ),
                                          Text(
                                            packageDuration != null &&
                                                    packageDuration != ''
                                                ? '$packageDuration days'
                                                : '-',
                                            style: TextStyle(
                                                color: Color(CommonUtil()
                                                    .getMyPrimaryColor()),
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Price: ',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14.sp),
                                          ),
                                          Text(
                                            price != null && price != ''
                                                ? '${CommonUtil.CURRENCY}$price'
                                                : '-',
                                            style: TextStyle(
                                                color: Color(CommonUtil()
                                                    .getMyPrimaryColor()),
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Visibility(
                          visible: description != null && description != '',
                          child: Container(
                            width: 1.sw,
                            constraints: BoxConstraints(
                              maxHeight: 0.15.sh,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1.0.h,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SingleChildScrollView(
                                child: Text(
                                  description != null && description != ''
                                      ? description!.trim()
                                      : '-',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: metaDataForURL?.descriptionURL != null &&
                                  metaDataForURL?.descriptionURL != ''
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: PlanPdfViewer(
                                    url: metaDataForURL?.descriptionURL,
                                    scaffoldKey: _scaffoldKey,
                                  ),
                                  //),
                                )
                              : Container(),
                        ),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              //hoverColor: Color(getMyPrimaryColor()),
                              onPressed:
                                  */ /*isDisable
                          ? null
                          :*/ /*
                                  () async {
                                if (issubscription == '0') {
                                  if (isFrom == strProviderCare) {
                                    var isSelected =
                                        Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            .checkItemInCart(packageId, isFrom,
                                                providerId: providerId);
                                    if (isSelected) {
                                      await Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          ?.removeCart(
                                              packageId: packageId,
                                              isFrom: isFrom);
                                      Navigator.pop(context);
                                    } else {
                                      if (Provider.of<PlanWizardViewModel>(
                                                  context,
                                                  listen: false)
                                              ?.currentPackageProviderCareId !=
                                          '') {
                                        await Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            ?.removeCart(
                                                packageId: Provider.of<
                                                            PlanWizardViewModel>(
                                                        context,
                                                        listen: false)
                                                    ?.currentPackageProviderCareId,
                                                isFrom: isFrom);
                                        Navigator.pop(context);
                                      }

                                      bool isItemInCart =
                                          Provider.of<PlanWizardViewModel>(
                                                  context,
                                                  listen: false)
                                              .checkAllItemsForProviderCare();
                                      if (isItemInCart) {
                                        await Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            ?.removeCart(
                                                packageId: Provider.of<
                                                            PlanWizardViewModel>(
                                                        context,
                                                        listen: false)
                                                    ?.currentCartProviderCarePackageId,
                                                isFrom: isFrom);
                                        Navigator.pop(context);
                                      }

                                      await Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          ?.addToCartItem(
                                              packageId: packageId,
                                              price: price,
                                              isRenew: isRenew,
                                              providerId: providerId,
                                              isFromAdd: isFrom)
                                          .then((value) {
                                        if (value.isSuccess) {
                                          Navigator.pop(context);
                                        }
                                      });
                                    }
                                  } else if (isFrom == strFreeCare) {
                                    var isSelected =
                                        Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            .checkItemInCart(packageId, isFrom,
                                                providerId: providerId);
                                    if (isSelected) {
                                      await Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          ?.removeCart(
                                              packageId: packageId,
                                              isFrom: isFrom);
                                      Navigator.pop(context);
                                    } else {
                                      if (Provider.of<PlanWizardViewModel>(
                                                  context,
                                                  listen: false)
                                              ?.currentPackageFreeCareId !=
                                          '') {
                                        await Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            ?.removeCart(
                                                packageId: Provider.of<
                                                            PlanWizardViewModel>(
                                                        context,
                                                        listen: false)
                                                    ?.currentPackageFreeCareId,
                                                isFrom: isFrom);
                                        Navigator.pop(context);
                                      }

                                      bool isItemInCart =
                                          Provider.of<PlanWizardViewModel>(
                                                  context,
                                                  listen: false)
                                              .checkAllItemsForFreeCare();
                                      if (isItemInCart) {
                                        await Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            ?.removeCart(
                                                packageId: Provider.of<
                                                            PlanWizardViewModel>(
                                                        context,
                                                        listen: false)
                                                    ?.currentCartFreeCarePackageId,
                                                isFrom: isFrom);
                                        Navigator.pop(context);
                                      }

                                      await Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          ?.addToCartItem(
                                              packageId: packageId,
                                              price: price,
                                              isRenew: isRenew,
                                              providerId: providerId,
                                              isFromAdd: isFrom)
                                          .then((value) {
                                        if (value.isSuccess) {
                                          Navigator.pop(context);
                                        }
                                      });
                                    }
                                  } else if (isFrom == strProviderDiet) {
                                    var isSelected =
                                        Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            .checkItemInCart(packageId, isFrom);
                                    if (isSelected) {
                                      await Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          ?.removeCart(
                                              packageId: packageId,
                                              isFrom: isFrom);
                                      Navigator.pop(context);
                                    } else {
                                      if (Provider.of<PlanWizardViewModel>(
                                                  context,
                                                  listen: false)
                                              ?.currentPackageProviderDietId !=
                                          '') {
                                        await Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            ?.removeCart(
                                                packageId: Provider.of<
                                                            PlanWizardViewModel>(
                                                        context,
                                                        listen: false)
                                                    ?.currentPackageProviderDietId,
                                                isFrom: isFrom);
                                        Navigator.pop(context);
                                      }

                                      bool isItemInCart =
                                          Provider.of<PlanWizardViewModel>(
                                                  context,
                                                  listen: false)
                                              .checkAllItemsForProviderDiet();
                                      if (isItemInCart) {
                                        await Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            ?.removeCart(
                                                packageId: Provider.of<
                                                            PlanWizardViewModel>(
                                                        context,
                                                        listen: false)
                                                    ?.currentCartProviderDietPackageId,
                                                isFrom: isFrom);
                                        Navigator.pop(context);
                                      }

                                      await Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          ?.addToCartItem(
                                              packageId: packageId,
                                              price: price,
                                              isRenew: isRenew,
                                              providerId: providerId,
                                              isFromAdd: isFrom)
                                          .then((value) {
                                        if (value.isSuccess) {
                                          Navigator.pop(context);
                                        }
                                      });
                                    }
                                  } else if (isFrom == strFreeDiet) {
                                    var isSelected =
                                        Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            .checkItemInCart(packageId, isFrom);
                                    if (isSelected) {
                                      await Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          ?.removeCart(
                                              packageId: packageId,
                                              isFrom: isFrom);
                                      Navigator.pop(context);
                                    } else {
                                      if (Provider.of<PlanWizardViewModel>(
                                                  context,
                                                  listen: false)
                                              ?.currentPackageFreeDietId !=
                                          '') {
                                        await Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            ?.removeCart(
                                                packageId: Provider.of<
                                                            PlanWizardViewModel>(
                                                        context,
                                                        listen: false)
                                                    ?.currentPackageFreeDietId,
                                                isFrom: isFrom);
                                        Navigator.pop(context);
                                      }

                                      bool isItemInCart =
                                          Provider.of<PlanWizardViewModel>(
                                                  context,
                                                  listen: false)
                                              .checkAllItemsForFreeDiet();
                                      if (isItemInCart) {
                                        await Provider.of<PlanWizardViewModel>(
                                                context,
                                                listen: false)
                                            ?.removeCart(
                                                packageId: Provider.of<
                                                            PlanWizardViewModel>(
                                                        context,
                                                        listen: false)
                                                    ?.currentCartFreeDietPackageId,
                                                isFrom: isFrom);
                                        Navigator.pop(context);
                                      }

                                      await Provider.of<PlanWizardViewModel>(
                                              context,
                                              listen: false)
                                          ?.addToCartItem(
                                              packageId: packageId,
                                              price: price,
                                              isRenew: isRenew,
                                              providerId: providerId,
                                              isFromAdd: isFrom)
                                          .then((value) {
                                        if (value.isSuccess) {
                                          Navigator.pop(context);
                                        }
                                      });
                                    }
                                  }
                                }
                                */ /*else {
                                CommonUtil().unSubcribeAlertDialog(context,
                                    packageId: packageId, refresh: () {
                                  Navigator.of(context).pop();
                                });
                                }*/ /*
                              },
                              borderSide: BorderSide(
                                color: issubscription == '0'
                                    ? Color(
                                        CommonUtil().getMyPrimaryColor(),
                                      )
                                    : Colors.grey,
                              ),
                              //hoverColor: Color(getMyPrimaryColor()),
                              child: Text(
                                getText(),
                                style: TextStyle(
                                  color:
                                      getTextColor(isDisable, issubscription),
                                  fontSize: 13.sp,
                                ),
                              ),
                              // child: Text(
                              //   issubscription == '0' ? strSubscribe : strSubscribed,
                              //   style: TextStyle(
                              //     color: getTextColor(isDisable, issubscription),
                              //     fontSize: 13.sp,
                              //   ),
                              // ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            OutlinedButton(
                              //hoverColor: Color(getMyPrimaryColor()),
                              onPressed: () async {
                                // open profile page
                                //Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              borderSide: BorderSide(
                                color: Color(
                                  CommonUtil().getMyPrimaryColor(),
                                ),
                              ),
                              //hoverColor: Color(getMyPrimaryColor()),
                              child: Text(
                                'cancel'.toUpperCase(),
                                style: TextStyle(
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor()),
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                );
              } else {
                return SafeArea(
                  child: Center(
                    child: Text('Plan information not available'),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  String getText() {
    String text = '';

    if (isFrom == strDeepLink) {
      if (issubscription == '0') {
        text = strAddToCart;
      } else {
        text = strSubscribed;
      }
    } else if (isFrom == strProviderCare) {
      text = getAddCartText();
    } else if (isFrom == strFreeCare) {
      text = getAddCartTextFreeCare();
    } else if (isFrom == strProviderDiet) {
      text = getAddCartTextProviderDiet();
    } else if (isFrom == strFreeDiet) {
      text = getAddCartTextFreeDiet();
    } else {
      text = '';
    }

    return text;
  }

  String getAddCartText() {
    String text = strAddToCart;

    if (Provider.of<PlanWizardViewModel>(Get.context!)
            .checkItemInCart(packageId, isFrom, providerId: providerId) ||
        Provider.of<PlanWizardViewModel>(Get.context!)
                .currentPackageProviderCareId ==
            packageId) {
      text = strRemoveFromCart;
    } else {
      if (issubscription == '0') {
        text = strAddToCart;
      } else {
        text = strSubscribed;
      }
    }

    return text;
  }

  String getAddCartTextFreeCare() {
    String text = strAddToCart;

    if (Provider.of<PlanWizardViewModel>(Get.context!)
            .checkItemInCart(packageId, isFrom, providerId: providerId) ||
        Provider.of<PlanWizardViewModel>(Get.context!)
                .currentPackageFreeCareId ==
            packageId) {
      text = strRemoveFromCart;
    } else {
      if (issubscription == '0') {
        text = strAddToCart;
      } else {
        text = strSubscribed;
      }
    }

    return text;
  }

  String getAddCartTextProviderDiet() {
    String text = strAddToCart;

    if (Provider.of<PlanWizardViewModel>(Get.context!)
            .checkItemInCart(packageId, isFrom) ||
        Provider.of<PlanWizardViewModel>(Get.context!)
                .currentPackageProviderDietId ==
            packageId) {
      text = strRemoveFromCart;
    } else {
      if (issubscription == '0') {
        text = strAddToCart;
      } else {
        text = strSubscribed;
      }
    }

    return text;
  }

  String getAddCartTextFreeDiet() {
    String text = strAddToCart;

    if (Provider.of<PlanWizardViewModel>(Get.context!)
            .checkItemInCart(packageId, isFrom) ||
        Provider.of<PlanWizardViewModel>(Get.context!)
                .currentPackageFreeDietId ==
            packageId) {
      text = strRemoveFromCart;
    } else {
      if (issubscription == '0') {
        text = strAddToCart;
      } else {
        text = strSubscribed;
      }
    }

    return text;
  }

  String? getImage() {
    String? image;
    if (iconApi != null && iconApi != '') {
      image = iconApi;
    } else {
      if (catIcon != null && catIcon != '') {
        image = catIcon;
      } else {
        if (hosIcon != null && hosIcon != '') {
          image = hosIcon;
        } else {
          image = '';
        }
      }
    }

    return image;
  }

  downloadFileForIos(List<String> updatedData) async {
    var response = await CommonUtil()
        .loadPdf(url: updatedData.first, fileName: updatedData.last);
    CommonUtil().showStatusToUser(response, _scaffoldKey);
  }

  Color getTextColor(bool disable, String isSubscribe) {
    /*if (isDisable) {
      return Colors.grey;
    } else {*/
    if (isSubscribe == '0') {
      return Color(CommonUtil().getMyPrimaryColor());
    } else {
      return Colors.grey;
    }
    //}
  }
}
