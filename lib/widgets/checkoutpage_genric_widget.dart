import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/plan_dashboard/model/CreateSubscribeModel.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/UserAddressCollection.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/telehealth/features/Payment/PaymentPage.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:myfhb/widgets/payment_gatway.dart';
import 'package:myfhb/widgets/result_page_new.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/constants/router_variable.dart' as router;

class CheckoutPageWidgets {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  MyProfileModel myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();
  CommonUtil commonUtil = CommonUtil();

  Future<dynamic> showPaymentConfirmationDialog(
      {dynamic body,
      dynamic totalCartAmount,
      Function(String) closePage,
      bool isPaymentNotification = false,
      FetchingCartItemsModel fetchingCartItemsModel,
      Function(bool) isSuccess}) {
    return showDialog(
        context: Get.context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: Colors.transparent,
            content: Container(
              width: double.maxFinite,
              height: 250.0,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Container(
                          height: 160,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Center(
                                child: TextWidget(
                                    text: redirectedToPaymentMessage,
                                    fontsize: 16.0.sp,
                                    fontWeight: FontWeight.w500,
                                    colors: Colors.grey[600]),
                              ),
                              SizedBoxWidget(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Color(commonUtil
                                                  .getMyPrimaryColor()))),
                                      color: Colors.transparent,
                                      textColor:
                                          Color(commonUtil.getMyPrimaryColor()),
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Provider.of<CheckoutPageProvider>(
                                                context,
                                                listen: false)
                                            .loader(false, isNeedRelod: true);
                                        Navigator.pop(context);
                                      },
                                      child: TextWidget(
                                        text: 'Cancel',
                                        fontsize: 14.0.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Color(commonUtil
                                                  .getMyPrimaryColor()))),
                                      color: Colors.transparent,
                                      textColor:
                                          Color(commonUtil.getMyPrimaryColor()),
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        CommonUtil.showLoadingDialog(context,
                                            _keyLoader, variable.Please_Wait);
                                        String userId =
                                            PreferenceUtil.getStringValue(
                                                Constants.KEY_USERID);

                                        ApiBaseHelper()
                                            .makePayment(body)
                                            .then((value) {
                                          if (value != null) {
                                            if (value?.isSuccess) {
                                              if (value?.result != null) {
                                                if (value?.result?.payment !=
                                                    null) {
                                                  if (value
                                                          ?.result
                                                          ?.payment
                                                          ?.paymentStatus
                                                          ?.code ==
                                                      'PAYITA') {
                                                    if (value?.result
                                                            ?.paymentGatewayDetail !=
                                                        null) {
                                                      if (value
                                                              ?.result
                                                              ?.paymentGatewayDetail
                                                              ?.responseInfo !=
                                                          null) {
                                                        if (value
                                                                ?.result
                                                                ?.paymentGatewayDetail
                                                                ?.responseInfo
                                                                ?.paymentGateWay ==
                                                            STR_RAZOPAY) {
                                                          if (value
                                                                      ?.result
                                                                      ?.paymentGatewayDetail
                                                                      ?.responseInfo
                                                                      ?.shorturl !=
                                                                  null &&
                                                              value
                                                                      ?.result
                                                                      ?.paymentGatewayDetail
                                                                      ?.responseInfo
                                                                      ?.shorturl !=
                                                                  '') {
                                                            Navigator
                                                                .pushReplacement(
                                                              Get.context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PaymentGatwayPage(
                                                                  redirectUrl: value
                                                                      ?.result
                                                                      ?.paymentGatewayDetail
                                                                      ?.responseInfo
                                                                      ?.shorturl,
                                                                  paymentId: value
                                                                      ?.result
                                                                      ?.payment
                                                                      ?.id
                                                                      ?.toString(),
                                                                  isFromSubscribe:
                                                                      true,
                                                                  isFromRazor:
                                                                      true,
                                                                  closePage:
                                                                      (value) {
                                                                    if (value ==
                                                                        'success') {
                                                                      Get.back();
                                                                    } else {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  isPaymentFromNotification:
                                                                      isPaymentNotification,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        } else {
                                                          if (value
                                                                      ?.result
                                                                      ?.paymentGatewayDetail
                                                                      ?.responseInfo
                                                                      ?.longurl !=
                                                                  null &&
                                                              value
                                                                      ?.result
                                                                      ?.paymentGatewayDetail
                                                                      ?.responseInfo
                                                                      ?.longurl !=
                                                                  '') {
                                                            Navigator
                                                                .pushReplacement(
                                                              Get.context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PaymentGatwayPage(
                                                                  redirectUrl: value
                                                                      ?.result
                                                                      ?.paymentGatewayDetail
                                                                      ?.responseInfo
                                                                      ?.longurl,
                                                                  paymentId: value
                                                                      ?.result
                                                                      ?.payment
                                                                      ?.id
                                                                      ?.toString(),
                                                                  isFromSubscribe:
                                                                      true,
                                                                  isFromRazor:
                                                                      false,
                                                                  closePage:
                                                                      (value) {
                                                                    if (value ==
                                                                        'success') {
                                                                      Get.back();
                                                                    } else {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  isPaymentFromNotification:
                                                                      isPaymentNotification,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        }
                                                      } else {
                                                        Navigator.of(
                                                                _keyLoader
                                                                    .currentContext,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        FlutterToast()
                                                          ..getToast(
                                                              'Subscribe Failed',
                                                              Colors.red);
                                                      }
                                                    }
                                                  } else {
                                                    Navigator.of(
                                                            _keyLoader
                                                                .currentContext,
                                                            rootNavigator: true)
                                                        .pop();
                                                    FlutterToast()
                                                      ..getToast(
                                                          'Subscribe Failed',
                                                          Colors.red);
                                                  }
                                                } else {
                                                  Navigator.of(
                                                          _keyLoader
                                                              .currentContext,
                                                          rootNavigator: true)
                                                      .pop();
                                                  FlutterToast()
                                                    ..getToast(
                                                        'Subscribe Failed',
                                                        Colors.red);
                                                }
                                              } else {
                                                Navigator.of(
                                                        _keyLoader
                                                            .currentContext,
                                                        rootNavigator: true)
                                                    .pop();

                                                Alert.displayConfirmProceed(
                                                    Get.context,
                                                    confirm: "Update Cart",
                                                    title: "Update",
                                                    content:
                                                        value?.message ?? '',
                                                    onPressedConfirm: () {
                                                  ApiBaseHelper()
                                                      .updateCartIcon(
                                                          fetchingCartItemsModel
                                                              ?.result)
                                                      .then((value) {
                                                    Navigator.of(Get.context)
                                                        .pop();
                                                    if (value['isSuccess']) {
                                                      isSuccess(
                                                          value['isSuccess']);
                                                    }
                                                  });
                                                });
                                              }
                                            } else {
                                              Navigator.of(
                                                      _keyLoader.currentContext,
                                                      rootNavigator: true)
                                                  .pop();
                                              FlutterToast()
                                                ..getToast('Subscribe Failed',
                                                    Colors.red);
                                            }
                                          }
                                        });
                                      },
                                      child: TextWidget(
                                        text: ok,
                                        fontsize: 14.0.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<bool> profileValidationCheckOnCart(BuildContext context,
      {String packageId,
      String isSubscribed,
      String providerId,
      String isFrom,
      bool feeZero,
      Function() refresh}) async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);
    await addFamilyUserInfoRepository.getMyProfileInfoNew(userId).then((value) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      myProfile = value;
    });

    if (myProfile != null) {
      return await addressValidation(context,
          packageId: packageId,
          isSubscribed: isSubscribed,
          providerId: providerId,
          isFrom: isFrom,
          feeZero: feeZero,
          refresh: refresh);
    } else {
      FlutterToast().getToast(noGender, Colors.red);
    }
  }

  Future<bool> addressValidation(BuildContext context,
      {String packageId,
      String isSubscribed,
      String providerId,
      String isFrom,
      bool feeZero,
      Function() refresh}) async {
    if (myProfile != null) {
      if (myProfile.isSuccess) {
        if (myProfile.result != null) {
          if (myProfile.result.gender != null &&
              myProfile.result.gender.isNotEmpty) {
            if (myProfile.result.dateOfBirth != null &&
                myProfile.result.dateOfBirth.isNotEmpty) {
              if (myProfile.result.additionalInfo != null) {
                if (myProfile.result.userAddressCollection3 != null) {
                  if (myProfile.result.userAddressCollection3.length > 0) {
                    return await patientAddressCheck(
                        myProfile.result.userAddressCollection3[0], context,
                        packageId: packageId,
                        isSubscribed: isSubscribed,
                        providerId: providerId,
                        feeZero: feeZero,
                        refresh: refresh);
                  } else {
                    return await mCustomAlertDialog(context,
                        content: commonUtil.CONTENT_PROFILE_CHECK,
                        packageId: packageId,
                        isSubscribed: isSubscribed,
                        providerId: providerId,
                        feeZero: feeZero,
                        refresh: refresh);
                  }
                } else {
                  return await mCustomAlertDialog(context,
                      content: commonUtil.CONTENT_PROFILE_CHECK,
                      packageId: packageId,
                      isSubscribed: isSubscribed,
                      providerId: providerId,
                      feeZero: feeZero,
                      refresh: refresh);
                }
              } else {
                return await mCustomAlertDialog(context,
                    content: commonUtil.CONTENT_PROFILE_CHECK,
                    packageId: packageId,
                    providerId: providerId,
                    isSubscribed: isSubscribed,
                    feeZero: feeZero,
                    refresh: refresh);
              }
            } else {
              return await mCustomAlertDialog(context,
                  content: commonUtil.CONTENT_PROFILE_CHECK,
                  packageId: packageId,
                  providerId: providerId,
                  isSubscribed: isSubscribed,
                  feeZero: feeZero,
                  refresh: refresh);
            }
          } else {
            return await mCustomAlertDialog(context,
                content: commonUtil.CONTENT_PROFILE_CHECK,
                packageId: packageId,
                providerId: providerId,
                isSubscribed: isSubscribed,
                feeZero: feeZero,
                refresh: refresh);
          }
        } else {
          return await mCustomAlertDialog(context,
              content: commonUtil.CONTENT_PROFILE_CHECK,
              packageId: packageId,
              providerId: providerId,
              isSubscribed: isSubscribed,
              feeZero: feeZero,
              refresh: refresh);
        }
      } else {
        return await mCustomAlertDialog(context,
            content: commonUtil.CONTENT_PROFILE_CHECK,
            packageId: packageId,
            providerId: providerId,
            isSubscribed: isSubscribed,
            feeZero: feeZero,
            refresh: refresh);
      }
    } else {
      return await mCustomAlertDialog(context,
          content: commonUtil.CONTENT_PROFILE_CHECK,
          packageId: packageId,
          providerId: providerId,
          isSubscribed: isSubscribed,
          feeZero: feeZero,
          refresh: refresh);
    }
  }

  Future<bool> patientAddressCheck(
      UserAddressCollection3 userAddressCollection, BuildContext context,
      {String packageId,
      String isSubscribed,
      String providerId,
      bool feeZero,
      Function() refresh}) async {
    /*String address1 = userAddressCollection.addressLine1 != null
        ? userAddressCollection.addressLine1
        : '';*/
    if (userAddressCollection.city != null) {
      String city = userAddressCollection.city.name != null
          ? userAddressCollection.city.name
          : '';
      String state = userAddressCollection.state.name != null
          ? userAddressCollection.state.name
          : '';

      if (city != '' && state != '') {
        //check if its subcribed we need not to show disclimer alert
        return await mDisclaimerAlertDialog(
            packageId: packageId,
            isSubscribed: isSubscribed,
            providerId: providerId,
            refresh: refresh,
            feeZero: feeZero,
            context: context);
      } else {
        return mCustomAlertDialog(context,
            content: commonUtil.CONTENT_PROFILE_CHECK,
            packageId: packageId,
            isSubscribed: isSubscribed,
            providerId: providerId,
            feeZero: feeZero,
            refresh: refresh);
      }
    } else {
      return mCustomAlertDialog(context,
          content: commonUtil.CONTENT_PROFILE_CHECK,
          packageId: packageId,
          isSubscribed: isSubscribed,
          providerId: providerId,
          feeZero: feeZero,
          refresh: refresh);
    }
  }

  Future<dynamic> mCustomAlertDialog(BuildContext context,
      {String title,
      String content,
      String packageId,
      String isSubscribed,
      bool feeZero,
      Function() refresh,
      String providerId}) async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var isAccepted = false;
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(children: [
                    //CircularProgressIndicator(),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Text(
                      content,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0.sp,
                      ),
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlineButton(
                          child: Text(
                            'cancel'.toUpperCase(),
                            style: TextStyle(
                              color: Color(
                                commonUtil.getMyPrimaryColor(),
                              ),
                              fontSize: 10,
                            ),
                          ),
                          onPressed: () async {
                            // open profile page
                            Navigator.of(context).pop();
                            isAccepted = false;
                          },
                          borderSide: BorderSide(
                            color: Color(
                              commonUtil.getMyPrimaryColor(),
                            ),
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                        SizedBox(
                          width: 10.0.h,
                        ),
                        OutlineButton(
                          //hoverColor: Color(getMyPrimaryColor()),
                          child: Text(
                            'complete profile'.toUpperCase(),
                            style: TextStyle(
                              color: Color(commonUtil.getMyPrimaryColor()),
                              fontSize: 10,
                            ),
                          ),
                          onPressed: () async {
                            // open profile page
                            Navigator.of(context).pop();
                            MyProfileModel myProfile =
                                await commonUtil.fetchUserProfileInfo();
                            Get.toNamed(router.rt_AddFamilyUserInfo,
                                arguments: AddFamilyUserInfoArguments(
                                  myProfileResult: myProfile?.result,
                                  fromClass: CommonConstants.user_update,
                                  isFromCSIR: false,
                                  packageId: packageId,
                                  providerId: providerId,
                                  isSubscribed: isSubscribed,
                                  feeZero: feeZero,
                                  refresh: refresh,
                                  isFromCartPage: true,
                                  isForFamilyAddition: false,
                                  isFromAppointmentOrSlotPage: false,
                                  isForFamily: false,
                                ));
                            isAccepted = true;
                          },
                          borderSide: BorderSide(
                            color: Color(
                              commonUtil.getMyPrimaryColor(),
                            ),
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ]),
          );
        });
    return isAccepted;
  }

  Future<dynamic> mDisclaimerAlertDialog(
      {BuildContext context,
      String title,
      String content,
      String packageId,
      String isSubscribed,
      String providerId,
      bool feeZero,
      Function() refresh}) async {
    bool isAccpted = false;
    await Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Disclaimer',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0.sp,
              ),
            ),
            Expanded(
              child: IconButton(
                  icon: Icon(Icons.close_rounded),
                  onPressed: () {
                    Get.back();
                  }),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  //color: Colors.blue,
                  margin: EdgeInsets.symmetric(horizontal: 1),
                  width: double.infinity,
                  child: Column(children: [
                    Text(
                      commonUtil.CONTENT_DISCALIMER,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                  ]),
                ),
              ]),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OutlineButton(
                  //hoverColor: Color(getMyPrimaryColor()),
                  child: Text(
                    'accept'.toUpperCase(),
                    style: TextStyle(
                      color: Color(commonUtil.getMyPrimaryColor()),
                      fontSize: 13,
                    ),
                  ),
                  onPressed: () async {
                    // CommonUtil.showLoadingDialog(
                    //     context, _keyLoader, variable.Please_Wait);
                    // String userId =
                    //     PreferenceUtil.getStringValue(Constants.KEY_USERID);
                    Get.back();
                    // Provider.of<CheckoutPageProvider>(context, listen: false)
                    //     .updateProfileVaildationStatus(true);

                    isAccpted = true;
                    if (feeZero) {
                      CommonUtil.showLoadingDialog(
                          context, _keyLoader, variable.Please_Wait,
                          isAutoDismiss: true);
                    }
                  },
                  borderSide: BorderSide(
                    color: Color(
                      commonUtil.getMyPrimaryColor(),
                    ),
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                OutlineButton(
                  child: Text(
                    'Reject'.toUpperCase(),
                    style: TextStyle(
                      color: Color(
                        commonUtil.getMyPrimaryColor(),
                      ),
                      fontSize: 13,
                    ),
                  ),
                  onPressed: () async {
                    Get.back();
                    isAccpted = false;
                  },
                  borderSide: BorderSide(
                    color: Color(
                      commonUtil.getMyPrimaryColor(),
                    ),
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      barrierDismissible: false,
    );
    return isAccpted;
  }
}
