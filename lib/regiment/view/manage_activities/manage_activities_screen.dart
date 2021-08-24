import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/regiment/view/widgets/regiment_activities_card.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import '../../../common/CommonUtil.dart';
import '../../../reminders/QurPlanReminders.dart';
import '../../../constants/fhb_constants.dart';
import '../../models/regiment_data_model.dart';
import '../../view_model/regiment_view_model.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

class ManageActivitiesScreen extends StatefulWidget {
  @override
  _ManageActivitiesScreenState createState() => _ManageActivitiesScreenState();
}

class _ManageActivitiesScreenState extends State<ManageActivitiesScreen> {
  RegimentViewModel _regimentViewModel;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    FocusManager.instance.primaryFocus.unfocus();
    super.initState();
    Provider.of<RegimentViewModel>(context, listen: false).getActivityDate(
      dateTime: DateTime.now(),
      isInitial: true,
    );
    Provider.of<RegimentViewModel>(context, listen: false)
        .fetchScheduledActivities(
      isInitial: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color getColor(
      Activityname activityname, Uformname uformName, Metadata metadata) {
    Color cardColor;
    try {
      if ((metadata?.color?.length ?? 0) == 7) {
        cardColor = Color(int.parse(metadata?.color.replaceFirst('#', '0xFF')));
      } else {
        switch (activityname) {
          case Activityname.DIET:
            cardColor = Colors.green;
            break;
          case Activityname.VITALS:
            if (uformName == Uformname.BLOODPRESSURE) {
              cardColor = Color(0xFF059192);
            } else if (uformName == Uformname.BLOODSUGAR) {
              cardColor = Color(0xFFb70a80);
            } else if (uformName == Uformname.PULSE) {
              cardColor = Color(0xFF8600bd);
            } else {
              cardColor = Colors.lightBlueAccent;
            }
            break;
          case Activityname.MEDICATION:
            cardColor = Colors.blue;
            break;
          case Activityname.SCREENING:
            cardColor = Colors.teal;
            break;
          default:
            cardColor = Color(CommonUtil().getMyPrimaryColor());
        }
      }
    } catch (e) {
      cardColor = Color(CommonUtil().getMyPrimaryColor());
    }
    return cardColor;
  }

  @override
  Widget build(BuildContext context) {
    _regimentViewModel = Provider.of<RegimentViewModel>(context);
    _regimentViewModel.handleSearchField(
      controller: searchController,
      focusNode: searchFocus,
    );
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 0,
        title: const Text(strManageActivities),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () => onBackPressed(context),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          onBackPressed(context);
          return Future<bool>.value(false);
        },
        child: Column(
          children: [
            // Container(
            //   width: 1.sw,
            //   padding: EdgeInsets.all(10.0.sp),
            //   color: Colors.white,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           Material(
            //             color: Colors.transparent,
            //             child: InkWell(
            //               onTap: () {
            //                 _regimentViewModel.getActivityDate(
            //                     isPrevious: true);
            //               },
            //               child: Icon(
            //                 Icons.chevron_left_rounded,
            //                 size: 24.0.sp,
            //                 color: Color(CommonUtil().getMyPrimaryColor()),
            //               ),
            //             ),
            //           ),
            //           SizedBox(
            //             width: 5.0.w,
            //           ),
            //           Material(
            //             color: Colors.transparent,
            //             child: InkWell(
            //               onTap: () async {
            //                 final selectedDate = await showDatePicker(
            //                   context: context,
            //                   firstDate: DateTime(2015, 8),
            //                   lastDate: DateTime(2101),
            //                   initialDate:
            //                       _regimentViewModel.selectedActivityDate,
            //                 );
            //                 if (selectedDate != null) {
            //                   _regimentViewModel.getActivityDate(
            //                     dateTime: selectedDate,
            //                   );
            //                 }
            //               },
            //               child: Text(
            //                 _regimentViewModel.activitiesDate,
            //                 style: TextStyle(
            //                   fontSize: 14.0.sp,
            //                   color: Color(CommonUtil().getMyPrimaryColor()),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           SizedBox(
            //             width: 5.0.w,
            //           ),
            //           Material(
            //             color: Colors.transparent,
            //             child: InkWell(
            //               onTap: () {
            //                 _regimentViewModel.getActivityDate(isNext: true);
            //               },
            //               child: Icon(
            //                 Icons.chevron_right_rounded,
            //                 size: 24.0.sp,
            //                 color: Color(CommonUtil().getMyPrimaryColor()),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(
                10.0.sp,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SearchWidget(
                      searchController: searchController,
                      searchFocus: searchFocus,
                      onChanged: _regimentViewModel.onSearchActivities,
                      padding: 0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<RegimentViewModel>(
                builder: (context, regimentViewModel, child) {
                  if (regimentViewModel.activityStatus ==
                      ActivityStatus.Loading) {
                    return CommonCircularIndicator();
                  } else if ((regimentViewModel.activitiesList?.length ?? 0) >
                      0) {
                    final regimentsList = regimentViewModel.activitiesList;
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        bottom: 10.0.h,
                      ),
                      itemCount: regimentsList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final regimentData = (index < regimentsList.length)
                            ? regimentsList[index]
                            : RegimentDataModel();
                        return RegimentActivitiesCard(
                          index: index,
                          title: regimentData.title,
                          time: regimentData?.estart != null
                              ? DateFormat('hh:mm\na')
                                  .format(regimentData?.estart)
                              : '',
                          color: getColor(regimentData.activityname,
                              regimentData.uformname, regimentData.metadata),
                          eid: regimentData.eid,
                          startTime: regimentData.estart,
                          regimentData: regimentData,
                        );
                      },
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                            10.0.sp,
                          ),
                          child: Text(
                            noRegimentScheduleData,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onBackPressed(BuildContext context) {
    if (Navigator.canPop(context)) {
      _regimentViewModel.fetchRegimentData();
      QurPlanReminders.getTheRemindersFromAPI();
      Get.back();
    } else {
      Get.offAllNamed(
        rt_Landing,
        arguments: const LandingArguments(
          needFreshLoad: false,
        ),
      );
    }
  }
}
