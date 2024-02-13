import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';

import '../../claim/model/members/MembershipBenefitListModel.dart';
import '../../claim/model/members/MembershipDetails.dart';
import '../../common/CommonUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../common/errors_widget.dart';
import '../../constants/fhb_constants.dart' as constants;
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import '../controller/create_ticket_controller.dart';
import '../model/ticket_types_model.dart';
import '../view_model/tickets_view_model.dart';
import 'create_ticket_screen.dart';
import 'get_membership_data_widget.dart';

class TicketTypesScreen extends StatefulWidget {
  @override
  State createState() {
    return _TicketTypesScreenState();
  }
}

class _TicketTypesScreenState extends State<TicketTypesScreen> {
  TicketViewModel ticketViewModel = TicketViewModel();
  TicketTypesModel ticketTypesModel = TicketTypesModel();
  Map<String, String?> _iconsurls = Map<String, String?>();

  final _membershipFontSize = CommonUtil().isTablet! ? 25.0.sp : 20.0.sp;
  final _iconHeight = CommonUtil().isTablet! ? 80.0 : 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
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
          constants.strNewServiceRequests,
          style: TextStyle(
              fontSize: (CommonUtil().isTablet ?? false)
                  ? constants.tabFontTitle
                  : constants.mobileFontTitle),
        ),
      ),
      body: Container(
        child: getTicketTypes(),
      ),
    );
  }

  Widget getTicketTypes() {
    return FutureBuilder(
      future: Future.wait([
        ticketViewModel.getTicketTypesList(),
        ticketViewModel.getMemberShip(),
      ]),
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
          final ticketTypesModel = snapshot.data?.first as TicketTypesModel?;
          final memberShipDetails = snapshot.data?.last as MemberShipDetails?;
          //return ticketTypeListTest(context);
          if (snapshot.hasData &&
              ticketTypesModel?.ticketTypeResults != null &&
              (ticketTypesModel?.ticketTypeResults?.isNotEmpty ?? false)) {
            return ListView(
              children: [
                getMembershipDataUI(memberShipDetails),
                ticketTypesList(ticketTypesModel?.ticketTypeResults),
              ],
            );
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 60.w,
                    ),
                    child: Center(
                      child: Text(
                        variable.strNoTicketTypesAvaliable,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            );
          }
        }
      },
    );
  }

  Widget getMembershipDataUI(MemberShipDetails? memberShipDetails) {
    final _memberShipResult = memberShipDetails?.result?.first;
    if (_memberShipResult != null) {
      /// We need to showcase only selected benefitType only.
      _memberShipResult.additionalInfo?.benefitType?.removeWhere(
        (element) => ![
          variable.strBenefitDoctorAppointment,
          variable.strBenefitLabAppointment,
          variable.strBenefitMedicineOrdering,
          variable.strBenefitTransportation,
          variable.strBenefitCareDietPlans,
          variable.strBenefitHomecareServices,
        ].contains(element.fieldName),
      );
      return GetMembershipDataWidget(
        memberShipResult: _memberShipResult,
        onPressed: () {
          /// Navigate to Membership Benefit List Screen.
          Navigator.pushNamed(
            context,
            router.rt_membership_benefits_screen,
            arguments: MembershipBenefitListModel(
              memberShipResult: _memberShipResult,
              iconsUrls: _iconsurls,
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  Widget ticketTypesList(List<TicketTypesResult>? ticketTypesList) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    final double itemWidth = size.width / 2;
    return (ticketTypesList != null && ticketTypesList.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  bottom: 8.0.h,
                ),
                itemBuilder: (ctx, i) {
                  /// this _iconsurls object
                  /// Use later to pass iconsurl to MembershipBenefitsListScreen.
                  _iconsurls[ticketTypesList[i].name ?? ''] =
                      ticketTypesList[i].iconUrl ?? '';
                  return myTicketTypesListItem(ctx, i, ticketTypesList);
                },
                itemCount: ticketTypesList.length,
              ),
            ),
          )
        : SafeArea(
            child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                  child: Center(
                    child: Text(
                      variable.strNoTicketTypesAvaliable,
                    ),
                  ),
                )),
          );
  }

  Widget myTicketTypesListItem(
      BuildContext context, int i, List<TicketTypesResult> ticketList) {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: InkWell(
            onTap: () {
              try {
                var createTicketController = Get.put(CreateTicketController());
                createTicketController.isCTLoading.value = false;

                if (CommonUtil()
                    .validString(ticketList[i].name)
                    .toLowerCase()
                    .contains("lab appointment")) {
                  createTicketController.labBookAppointment.value = true;
                  createTicketController.selPrefLab.value =
                      CommonUtil().validString("Select");
                  createTicketController.selPrefLabId.value =
                      CommonUtil().validString("");
                  createTicketController.getLabList();
                } else {
                  createTicketController.labBookAppointment.value = false;
                  createTicketController.labsList = [];
                }

                if (CommonUtil()
                    .validString(ticketList[i].name)
                    .toLowerCase()
                    .contains("doctor appointment")) {
                  createTicketController.doctorBookAppointment.value = true;
                  createTicketController.selPrefDoctor.value =
                      CommonUtil().validString("Select");
                  createTicketController.selPrefDoctorId.value =
                      CommonUtil().validString("");
                  createTicketController.getDoctorList();
                } else {
                  createTicketController.doctorBookAppointment.value = false;
                  createTicketController.doctorsList = [];
                }

                ticketList[i].additionalInfo != null
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateTicketScreen(ticketList[i])),
                      )
                    : null;
              } catch (e, stackTrace) {
                //print(e);
                CommonUtil().appLogs(message: e, stackTrace: stackTrace);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
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
              padding: EdgeInsets.all(
                15.0.sp,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      getTicketTypeImages(
                        context,
                        ticketList[i],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    (ticketList[i].name!).replaceAll(' ', '\n'),
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: _membershipFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,

                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget getTicketTypeImages(
      BuildContext context, TicketTypesResult ticketListData) {
    if (ticketListData.iconUrl?.isNotEmpty ?? false) {
      return SvgPicture.network(
        ticketListData.iconUrl!,
        height: _iconHeight,
        width: _iconHeight,
        placeholderBuilder: (context) => CommonCircularIndicator(),
        color: Colors.white.withAlpha(200),
      );
    } else {
      return Image.asset(
        'assets/icons/10.png',
        width: _iconHeight,
        height: _iconHeight,
        color: Colors.white.withAlpha(200),
      );
    }
  }
}
