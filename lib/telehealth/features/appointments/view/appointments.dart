import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../colors/fhb_colors.dart' as fhbColors;
import '../../../../common/CommonUtil.dart';
import '../../../../common/SwitchProfile.dart';
import '../../../../common/common_circular_indicator.dart';
import '../../../../common/firestore_services.dart';
import '../../../../constants/variable_constant.dart' as variable;
import '../../../../src/blocs/Category/CategoryListBlock.dart';
import '../../../../src/blocs/Media/MediaTypeBlock.dart';
import '../../../../src/utils/language/language_utils.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../widgets/GradientAppBar.dart';
import '../../chat/viewModel/ChatViewModel.dart';
import '../model/fetchAppointments/appointmentsModel.dart';
import '../model/fetchAppointments/past.dart';
import '../viewModel/appointmentsListViewModel.dart';
import 'DoctorPastAppointments.dart';
import 'DoctorUpcomingAppointments.dart';
import 'appointmentsCommonWidget.dart';

class Appointments extends StatefulWidget {
  Appointments({
    this.isHome = false,
    this.isFromQurday = false,
  });

  final bool isHome;
  final bool isFromQurday;

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  ChatViewModel chatViewModel = ChatViewModel();
  TextEditingController _searchQueryController = TextEditingController();
  late AppointmentsListViewModel appointmentsViewModel;
  AppointmentsCommonWidget commonWidget = AppointmentsCommonWidget();
  List<Past>? upcomingInfo = [];
  List<String> bookingIds = [];
  List<Past>? historyInfo = [];
  bool isSearch = false;
  List<Past> upcomingTimeInfo = [];
  SharedPreferences? prefs;
  Function(String)? closePage;
  final GlobalKey<State> _key = GlobalKey<State>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    try {
      Provider.of<AppointmentsListViewModel>(context, listen: false)
          .fetchAppointments();
      super.initState();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    super.dispose();

    try {
      getCategoryList();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () {
            return refreshPage();
          },
          child: body()),
      appBar: widget.isHome ? null : appBar() as PreferredSizeWidget?,
      floatingActionButton: Visibility(
        visible: CommonUtil.REGION_CODE == 'IN',
        child: commonWidget.floatingButton(
          context,
          isHome: widget.isHome,
        ),
      ),
    );
  }

  getCategoryList() {
    CategoryListBlock _categoryListBlock = CategoryListBlock();
    MediaTypeBlock _mediaTypeBlock = MediaTypeBlock();

    _categoryListBlock.getCategoryLists().then((value) {});

    _mediaTypeBlock.getMediTypesList().then((value) {});
  }

  Widget search() {
    appointmentsViewModel =
        Provider.of<AppointmentsListViewModel>(context, listen: false);
    return Container(
        margin: EdgeInsets.only(
          left: 20.0.w,
          right: 20.0.w,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.0.h,
            right: 10.0.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 40.0.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(fhbColors.cardShadowColor),
                    borderRadius: BorderRadius.circular(
                      5.0.sp,
                    ),
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _searchQueryController,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(
                        2.0.sp,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black54,
                        size: 24.0.sp,
                      ),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 16.0.sp,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0.sp,
                    ),
                    onChanged: (value) {
                      try {
                        if (value.trim().length > 1) {
                          setState(() {
                            isSearch = true;
                            upcomingInfo = appointmentsViewModel
                                .filterSearchResults(value)
                                .upcoming;
                            historyInfo = appointmentsViewModel
                                .filterSearchResults(value)
                                .past;
                          });
                        } else {
                          setState(() {
                            isSearch = false;
                            upcomingInfo!.clear();
                            historyInfo!.clear();
                          });
                        }
                      } catch (e, stackTrace) {
                        //print(e);
                        CommonUtil()
                            .appLogs(message: e, stackTrace: stackTrace);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget body() {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(
            left: 20.0.w,
            right: 20.0.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBoxWidget(
                width: 0.0.w,
                height: 20.0.h,
              ),
              search(),
              getDoctorsAppoinmentsList()
            ],
          )),
    );
  }

  Widget getDoctorsAppoinmentsList() {
    var appointmentData = Provider.of<AppointmentsListViewModel>(context);
    switch (appointmentData.loadingStatus) {
      case LoadingStatus.searching:
        return SafeArea(
          child: SizedBox(
            height: 1.sh / 2.0,
            child: Center(
              child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              ),
            ),
          ),
        );
      case LoadingStatus.completed:
        return Consumer<AppointmentsListViewModel>(
          builder: (context, appointmentsViewModel, child) {
            final AppointmentsModel? appointmentsData =
                appointmentsViewModel.appointments;
            if (appointmentsData != null) {
              return ((appointmentsData.result!.past != null &&
                          appointmentsData.result!.past!.length > 0) ||
                      (appointmentsData.result!.upcoming != null &&
                          appointmentsData.result!.upcoming!.length > 0))
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBoxWidget(
                          width: 0.0.h,
                          height: 10.0.h,
                        ),
                        isSearch
                            ? (upcomingInfo != null &&
                                    upcomingInfo!.length != 0)
                                ? commonWidget.title(TranslationConstants
                                    .upcomingAppointments
                                    .t())
                                : Container()
                            : (appointmentsData.result!.upcoming != null &&
                                    appointmentsData.result!.upcoming!.length !=
                                        0)
                                ? commonWidget.title(TranslationConstants
                                    .upcomingAppointments
                                    .t())
                                : Container(),
                        SizedBoxWidget(
                          width: 0.0.h,
                          height: 10.0.h,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctx, int i) {
                            appointmentsData.result!.upcoming!.sort((a, b) =>
                                a.plannedStartDateTime!.compareTo(
                                    b.plannedStartDateTime!.toLowerCase()));
                            upcomingInfo!.sort((a, b) => a.plannedStartDateTime!
                                .compareTo(
                                    b.plannedStartDateTime!.toLowerCase()));
                            return DoctorUpcomingAppointments(
                                doc: isSearch
                                    ? upcomingInfo![i]
                                    : appointmentsData.result!.upcoming![i],
                                onChanged: (value) {
                                  refreshAppointments();
                                });
                          },
                          itemCount: !isSearch
                              ? appointmentsData.result!.upcoming!.length
                              : upcomingInfo!.length,
                        ),
                        SizedBoxWidget(
                          width: 0.0.h,
                          height: 10.0.h,
                        ),
                        isSearch
                            ? (historyInfo != null && historyInfo!.length != 0)
                                ? commonWidget.title(
                                    TranslationConstants.appointmentHistory.t())
                                : Container()
                            : (appointmentsData.result!.past != null &&
                                    appointmentsData.result!.past!.length != 0)
                                ? commonWidget.title(
                                    TranslationConstants.appointmentHistory.t())
                                : Container(),
                        SizedBoxWidget(
                          width: 0.0.h,
                          height: 10.0.h,
                        ),
                        (appointmentsData.result!.past != null &&
                                appointmentsData.result!.past!.length > 0)
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctx, int i) {
                                  appointmentsData.result!.past!.sort((b, a) =>
                                      a.plannedStartDateTime!.compareTo(b
                                          .plannedStartDateTime!
                                          .toLowerCase()));
                                  historyInfo!.sort((b, a) => a
                                      .plannedStartDateTime!
                                      .compareTo(b.plannedStartDateTime!
                                          .toLowerCase()));
                                  return DoctorPastAppointments(
                                    doc: isSearch
                                        ? historyInfo![i]
                                        : appointmentsData.result!.past![i],
                                    onChanged: (value) {
                                      refreshAppointments();
                                    },
                                    closePage: (value) {
                                      if (!widget.isHome) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                },
                                itemCount: isSearch
                                    ? historyInfo!.length
                                    : appointmentsData.result!.past!.length,
                              )
                            : Container()
                      ],
                    )
                  : refreshIndicatorWithEmptyContainer(
                      variable.strNoAppointments);
            } else {
              return CommonCircularIndicator();
            }
          },
        );
      case LoadingStatus.empty:
        return refreshIndicatorWithEmptyContainer(variable.strNoAppointments);
        break;
      default:
        return refreshIndicatorWithEmptyContainer(variable.strNoAppointments);
    }
  }

  Widget refreshIndicatorWithEmptyContainer(String msg) {
    return RefreshIndicator(
        onRefresh: () {
          return refreshPage();
        },
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 1.sh / 2,
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  variable.strNoAppointments,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(70),
      child: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        // leading: Row(
        //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     // mainAxisSize: MainAxisSize.max,
        //     children: [
        //       SizedBoxWidget(
        //         height: 0.0.h,
        //         width: 30.0.w,
        //       ),
        //       IconWidget(
        //         icon: Icons.arrow_back_ios,
        //         colors: Colors.white,
        //         size: 11.0.sp,
        //         onTap: () {
        //
        //         },
        //       ),
        //     ],
        //   ),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () {
            Navigator.pop(context);
            //PageNavigator.goToPermanent(context, router.rt_Dashboard);
          },
        ),
        title: getTitle(),
      ),
    );
  }

  Widget getTitle() {
    return Row(
      children: [
        Expanded(
          child: TextWidget(
            text: TranslationConstants.appointments.t(),
            colors: Colors.white,
            overflow: TextOverflow.visible,
            fontWeight: FontWeight.w600,
            fontsize: 18.0.sp,
            softwrap: true,
          ),
        ),
        CommonUtil().getNotificationIcon(context),
        if (!widget.isFromQurday)
          SwitchProfile().buildActions(context, _key, callBackToRefresh, false),
        // IconWidget(
        //   icon: Icons.more_vert,
        //   colors: Colors.white,
        //   size: 24,
        //   onTap: () {},
        // ),
      ],
    );
  }

  void callBackToRefresh() {
    FirestoreServices().updateFirestoreListner();
    (context as Element).markNeedsBuild();
    refreshAppointments();
  }

  void refreshAppointments() {
    Provider.of<AppointmentsListViewModel>(context, listen: false)
      ..clearAppointments()
      ..fetchAppointments();
  }

  Future<String> refreshPage() async {
    appointmentsViewModel.clearAppointments();
    await appointmentsViewModel.fetchAppointments();
    return 'success';
  }
}
