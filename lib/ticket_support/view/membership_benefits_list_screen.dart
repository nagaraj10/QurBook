import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';

import '../../claim/model/members/MembershipBenefitListModel.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart' as constants;
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import 'get_membership_data_widget.dart';

/// This Widget is used for to show Membership Benefit List to patient whose use corporate accounts.
class MembershipBenefitListScreen extends StatefulWidget {
  const MembershipBenefitListScreen({
    super.key,
    this.membershipBenefitListModel,
  });

  /// This object contains two objects
  /// 1.  Map<String, String?>? iconsUrls;
  /// 2. MemberShipResult? memberShipResult;
  /// which use for Full Membership Benefits.
  final MembershipBenefitListModel? membershipBenefitListModel;

  @override
  State<MembershipBenefitListScreen> createState() =>
      _MembershipBenefitListScreenState();
}

class _MembershipBenefitListScreenState
    extends State<MembershipBenefitListScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          backgroundColor: Color(
            CommonUtil().getMyPrimaryColor(),
          ),
          elevation: 0,
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 24.0.sp,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            constants.strMembershipBenefits,
            style: TextStyle(
              fontSize: (CommonUtil().isTablet ?? false)
                  ? constants.tabFontTitle
                  : constants.mobileFontTitle,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: GetMembershipDataWidget(
            memberShipResult:
                widget.membershipBenefitListModel?.memberShipResult,
            isShowingBenefits: true,
            iconsUrls: widget.membershipBenefitListModel?.iconsUrls,
          ),
        ),
      );
}
