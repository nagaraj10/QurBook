import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../claim/model/members/MemberShipAdditionalInfoBenefitType.dart';
import '../../claim/model/members/MembershipResult.dart';
import '../../common/CommonUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../constants/variable_constant.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class GetMembershipDataWidget extends StatefulWidget {
  GetMembershipDataWidget({
    this.onPressed,
    super.key,
    this.memberShipResult,
    this.iconsUrls,
    this.isShowingBenefits = false,
  });
  MemberShipResult? memberShipResult;
  Function()? onPressed;
  bool? isShowingBenefits;
  Map<String, String?>? iconsUrls;

  @override
  State<GetMembershipDataWidget> createState() =>
      _GetMembershipDataWidgetState();
}

class _GetMembershipDataWidgetState extends State<GetMembershipDataWidget> {
  String _currentCurrency = '';

  final _amountTextStyle = TextStyle(
    fontSize: 18.0.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final planEndDateTime = DateFormat('yyyy-MM-dd').parse(
      widget.memberShipResult?.planEndDate ?? '',
    );

    _currentCurrency =
        CommonUtil.REGION_CODE != 'IN' ? '$strDollar ' : '\u{20B9} ';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                Color(CommonUtil().getMyPrimaryColor()),
                Color(CommonUtil().getMyGredientColor())
              ],
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            border: Border.all(
              color: Color(CommonUtil().getMyPrimaryColor()),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.memberShipResult?.planName ?? '',
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Valid till ${DateFormat("dd-MM-yyyy").format(
                  planEndDateTime,
                )} (${CommonUtil().calculateDifference(
                  planEndDateTime,
                )} days remaining)',
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (!(widget.isShowingBenefits ?? false))
                const Spacer()
              else
                const SizedBox(
                  height: 25,
                ),
              Visibility(
                visible: !(widget.isShowingBenefits ?? false),
                child: TextButton(
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
                  itemCount: widget.memberShipResult?.additionalInfo
                          ?.benefitType?.length ??
                      0,
                  itemBuilder: (context, index) {
                    final currentMembershipType = widget
                        .memberShipResult?.additionalInfo?.benefitType?[index];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Color(CommonUtil().getMyGredientColor())
                          ],
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        border: Border.all(
                          color: Color(CommonUtil().getMyPrimaryColor()),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getIcon(currentMembershipType),
                              Text(
                                getTitle(currentMembershipType),
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: 20.0.sp,
                                  fontWeight: FontWeight.w600,
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
                            children: [
                              Text(
                                strAvailableBalance,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: 15.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              getBalanceAmount(currentMembershipType)
                            ],
                          ),
                        ],
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

  Widget getIcon(MemberShipAdditionalInfoBenefitType? type) {
    final iconsUrl = widget.iconsUrls?[getTitle(type)];
    if (type?.fieldName == strBenefitFamilyMembers) {
      return SvgPicture.asset(
        'assets/icons/Family-member-01.svg',
        height: 30,
        width: 30,
        placeholderBuilder: (context) => CommonCircularIndicator(),
        color: Color(
          CommonUtil().getMyGredientColor(),
        ).withAlpha(200),
      );
    } else if (iconsUrl?.isNotEmpty ?? false) {
      return SvgPicture.network(
        iconsUrl ?? '',
        height: 30,
        width: 30,
        placeholderBuilder: (context) => CommonCircularIndicator(),
        color: Color(
          CommonUtil().getMyGredientColor(),
        ).withAlpha(200),
      );
    } else {
      return Image.asset(
        'assets/icons/10.png',
        width: 30,
        height: 30,
        color: Color(
          CommonUtil().getMyGredientColor(),
        ).withAlpha(200),
      );
    }
  }

  Widget getBalanceAmount(MemberShipAdditionalInfoBenefitType? type) {
    var amount = 0;

    switch (type?.fieldName) {
      case strBenefitDoctorAppointment:
        amount = widget.memberShipResult?.noOfDoctorAppointments ?? 0;
        break;
      case strBenefitCareDietPlans:
        amount = widget.memberShipResult?.noOfCarePlans ?? 0;
        break;
      case strBenefitTransportation:
        amount = widget.memberShipResult?.tranportation ?? 0;
        break;
      case strBenefitFamilyMembers:
        amount = 0;
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
      type?.code == 'BY_COST' ? '$_currentCurrency $amount /-' : '$amount',
      overflow: TextOverflow.visible,
      style: _amountTextStyle,
    );
  }

  String getTitle(MemberShipAdditionalInfoBenefitType? type) {
    var _title = '';
    switch (type?.fieldName) {
      case strBenefitDoctorAppointment:
        _title = type?.fieldName ?? '';
        break;
      case strBenefitLabAppointment:
        _title = type?.fieldName ?? '';
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
      case strBenefitFamilyMembers:
        _title = strBenefitHomecareService;
        break;
      default:
    }
    return _title;
  }
}
