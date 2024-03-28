import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../claim/model/members/MemberShipAdditionalInfoBenefitType.dart';
import '../../claim/model/members/MembershipResult.dart';
import '../../common/CommonUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../constants/variable_constant.dart';
import '../../main.dart';
import '../../src/utils/screenutils/size_extensions.dart';

/// This Commonly use on New Service Request And Membership Benefits
class GetMembershipDataWidget extends StatefulWidget {
  GetMembershipDataWidget({
    this.onPressed,
    super.key,
    this.memberShipResult,
    this.iconsUrls,
    this.isShowingBenefits = false,
  });

  /// Object contains All require Membership details which we need to showcase to patients. Object is Optional type.
  MemberShipResult? memberShipResult;

  /// Function contains on Show Benefits button action. Function is Optional type.
  Function()? onPressed;

  /// bool Contains wheather Membership Benefits is showing to patients or not. bool is Optional type.
  bool? isShowingBenefits;

  /// Map Contains benefits name with iconsurl to show icons. Map is Optional type.
  Map<String, String?>? iconsUrls;

  @override
  State<GetMembershipDataWidget> createState() =>
      _GetMembershipDataWidgetState();
}

class _GetMembershipDataWidgetState extends State<GetMembershipDataWidget> {
  /// Curreant Currency symbol as per current region
  String _currentCurrency = '';

  /// common TextStyle for amount text widget
  final _amountTextStyle = TextStyle(
    fontSize: 21.0.sp,
    fontWeight: FontWeight.bold,
    color: mAppThemeProvider.primaryColor,
  );

  TextStyle _getmemberhipTitleTextStyle({Color color = Colors.white}) {
    return TextStyle(
      fontSize: CommonUtil().isTablet! ? 25.0.sp : 20.0.sp,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// From String to DateTime conversion.
    final planEndDateTime = DateFormat('yyyy-MM-dd').parse(
      widget.memberShipResult?.planEndDate ?? '',
    );

    final planStartDateTime = DateFormat('yyyy-MM-dd').parse(
      widget.memberShipResult?.planStartDate ?? '',
    );

    /// Curreant Currency symbol as per current region
    _currentCurrency =
        CommonUtil.REGION_CODE != 'IN' ? '$strDollar ' : '\u{20B9} ';
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          height: !(widget.isShowingBenefits ?? false) ? 150.h : null,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                mAppThemeProvider.primaryColor,
                Color(CommonUtil().getMyGredientColor())
              ],
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            border: Border.all(
              color: mAppThemeProvider.primaryColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.memberShipResult?.planName ?? '',
                overflow: TextOverflow.visible,
                style: _getmemberhipTitleTextStyle(),
              ),
              const SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                        text: 'Valid till',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: ' ${DateFormat("MMM-dd-yyyy").format(
                        planEndDateTime,
                      )} (${CommonUtil().calculateDifference(
                        planEndDateTime,
                      )} days remaining)',
                    ),
                  ],
                ),
              ),
              if (!(widget.isShowingBenefits ?? false))
                const Spacer()
              else
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Subscribed on',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: ' - '),
                      TextSpan(
                        text: DateFormat('MMM-dd-yyyy').format(
                          planStartDateTime,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              Visibility(
                visible: !(widget.isShowingBenefits ?? false),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 0),
                  ),
                  onPressed: widget.onPressed,
                  child: Text(
                    strShowAvailableBenefits,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.isShowingBenefits ?? false,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.memberShipResult?.additionalInfo
                          ?.benefitType?.length ??
                      0,
                  itemBuilder: (context, index) {
                    final currentMembershipType = widget
                        .memberShipResult?.additionalInfo?.benefitType?[index];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        border: Border.all(
                          color: mAppThemeProvider.primaryColor,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              mAppThemeProvider.primaryColor
                                  .withOpacity(0.01),
                              Color(CommonUtil().getMyGredientColor())
                                  .withAlpha(80)//.withOpacity(0.37)
                            ],
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTitle(currentMembershipType),
                                  overflow: TextOverflow.visible,
                                  style: _getmemberhipTitleTextStyle(
                                    color: Color(
                                      CommonUtil().getMyGredientColor(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                getIcon(currentMembershipType),
                                const SizedBox(height: 4),
                                Text(
                                  strAvailableBalance,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        mAppThemeProvider.primaryColor,
                                  ),
                                ),
                                getBalanceAmount(currentMembershipType)
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: !(widget.isShowingBenefits ?? false),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 6, 15, 0),
            child: Text(
              strAvailableServices,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 18.0.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Widget Return icon
  /// Based on which MemberShipAdditionalInfoBenefitType is passed
  /// if type is 'Family Members'
  ///    then we set local icons
  /// else
  ///    then fetch from API or set default icon
  Widget getIcon(MemberShipAdditionalInfoBenefitType? type) {
    final iconsUrl = widget.iconsUrls?[getIconsTitle(type)];
    if (type?.fieldName == strBenefitHomecareServices) {
      return SvgPicture.asset(
        'assets/icons/Family-member-01.svg',
        height: 40,
        width: 40,
        placeholderBuilder: (context) => CommonCircularIndicator(),
        color: Color(CommonUtil().getMyGredientColor()).withOpacity(0.3),
      );
    } else if (iconsUrl?.isNotEmpty ?? false) {
      return SvgPicture.network(
        iconsUrl ?? '',
        height: 40,
        width: 40,
        placeholderBuilder: (context) => CommonCircularIndicator(),
        color: Color(CommonUtil().getMyGredientColor()).withOpacity(0.3),
      );
    } else {
      return Image.asset(
        'assets/icons/10.png',
        width: 40,
        height: 40,
        color: Color(CommonUtil().getMyGredientColor()).withOpacity(0.3),
      );
    }
  }

  /// Widget Return Text
  /// Based on which MemberShipAdditionalInfoBenefitType is passed
  Widget getBalanceAmount(MemberShipAdditionalInfoBenefitType? type) {
    num amount = 0;

    switch (type?.fieldName) {
      case strBenefitDoctorAppointment:
        amount = widget.memberShipResult?.noOfDoctorAppointments?.toInt() ?? 0;
        break;
      case strBenefitCareDietPlans:
        amount = widget.memberShipResult?.noOfCarePlans ?? 0;
        break;
      case strBenefitTransportation:
        amount = widget.memberShipResult?.tranportation ?? 0;
        break;
      case strBenefitHomecareServices:
        amount = widget.memberShipResult?.homecareServices ?? 0;
        break;
      case strBenefitMedicineOrdering:
        amount = widget.memberShipResult?.medicineOrdering ?? 0;
        break;
      case strBenefitLabAppointment:
        amount = widget.memberShipResult?.labAppointment ?? 0;
      default:
        break;
    }

    return Text(
      type?.code == 'BY_COST'
          ? '$_currentCurrency${CommonUtil.formatAmount(amount)} /-'
          : '$amount',
      overflow: TextOverflow.visible,
      style: _amountTextStyle,
    );
  }

  /// Method Return String for Title for icon
  /// Based on which MemberShipAdditionalInfoBenefitType is passed
  String getIconsTitle(MemberShipAdditionalInfoBenefitType? type) {
    var _title = '';
    switch (type?.fieldName) {
      case strBenefitDoctorAppointment:
        _title = strBenefitDoctorAppointment;
        break;
      case strBenefitLabAppointment:
        _title = strBenefitLabAppointment;
        break;
      case strBenefitMedicineOrdering:
        _title = strBenefitOrderMedicine;
        break;
      case strBenefitTransportation:
        _title = strBenefitAmbulanceService;
        break;
      case strBenefitCareDietPlans:
        _title = strBenefitHealthPlan;
        break;
      case strBenefitHomecareServices:
        _title = strBenefitHomecareService;
        break;
      default:
    }
    return _title;
  }

  /// Method Return String for Title
  /// Based on which MemberShipAdditionalInfoBenefitType is passed
  String getTitle(MemberShipAdditionalInfoBenefitType? type) {
    var _title = '';
    switch (type?.fieldName) {
      case strBenefitDoctorAppointment:
        _title = strBenefitDoctorAppointments;
        break;
      case strBenefitLabAppointment:
        _title = strBenefitLabAppointments;
        break;
      case strBenefitMedicineOrdering:
        _title = strBenefitOrderMedicines;
        break;
      case strBenefitTransportation:
        _title = strBenefitAmbulanceServices;
        break;
      case strBenefitCareDietPlans:
        _title = strBenefitHealthPlans;
        break;
      case strBenefitHomecareServices:
        _title = strBenefitHomecareServices;
        break;
      default:
    }
    return _title;
  }
}
